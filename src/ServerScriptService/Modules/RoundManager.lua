local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local TeamService = require(script.Parent.TeamService)
local MorphService = require(script.Parent.MorphService)
local AbilityService = require(script.Parent.AbilityService)
local CharacterRegistry = require(ServerScriptService.Modules.CharacterRegistry)
local MusicSystem = require(script.Parent.MusicSystem)

local RoundManager = {}
RoundManager.__index = RoundManager

local function teleportCharacterToPart(player, part)
	if not part then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = part.CFrame + Vector3.new(0, 4, 0)
	end
end

function RoundManager:Init(config)
	self.Config = config
	self.State = "BOOT"
	self.RoundActive = false
	self.CurrentKiller = nil
	self.RoundStartedAt = 0
	self.RoundPart = Workspace:FindFirstChild("RoundPart")
	self.SpawnLocation = Workspace:FindFirstChildOfClass("SpawnLocation")

	AbilityService:Init(config.RoundStateRemote)
	MusicSystem:Init(config.RoundStateRemote)

	Players.PlayerRemoving:Connect(function(leavingPlayer)
		if leavingPlayer == self.CurrentKiller then
			self:EndRound("KillerLeft")
		end
	end)
end

function RoundManager:BroadcastState(payload)
	if self.Config.RoundStateRemote then
		self.Config.RoundStateRemote:FireAllClients(payload)
	end
end

function RoundManager:GetAlivePlayers()
	local alive = {}
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			table.insert(alive, player)
		end
	end
	return alive
end

function RoundManager:ChooseKiller(players)
	if #players == 0 then
		return nil
	end
	return players[math.random(1, #players)]
end

function RoundManager:AssignRoles(players)
	self.CurrentKiller = self:ChooseKiller(players)
	TeamService:AssignRoles(players, self.CurrentKiller)
end

function RoundManager:ApplyRoundCharacters(players)
	local aktep = CharacterRegistry:GetAKTEP()

	for _, player in ipairs(players) do
		local role = TeamService:GetRole(player)
		local characterData

		if role == "Killer" then
			characterData = aktep
		elseif role == "Survivor" then
			characterData = CharacterRegistry:GetRandomSurvivor()
		end

		if characterData then
			MorphService:ApplyMorphByModel(player, characterData.Role, characterData.ModelPath, {
				MaxHealth = characterData.Stats.HP,
				WalkSpeed = characterData.Stats.Speed,
			})
			TeamService:SetRoundCharacter(player, characterData)
			AbilityService:RegisterPlayerLoadout(player, role, characterData)
		end

		self:BroadcastState({
			state = "ROLE_ASSIGNED",
			player = player.Name,
			role = role,
			characterId = characterData and characterData.Id or nil,
		})
	end

	MusicSystem:StartRound(self.CurrentKiller, aktep)
end

function RoundManager:TeleportAllToRoundPart()
	for _, player in ipairs(Players:GetPlayers()) do
		teleportCharacterToPart(player, self.RoundPart)
	end
end

function RoundManager:CanStartRound()
	return #Players:GetPlayers() >= self.Config.MinimumPlayers
end

function RoundManager:IntermissionTick()
	self.State = "INTERMISSION"
	for remaining = self.Config.IntermissionDuration, 0, -1 do
		self:BroadcastState({
			state = self.State,
			remaining = remaining,
			timerLabel = string.format("Intermission: %d", remaining),
			minimumPlayers = self.Config.MinimumPlayers,
			currentPlayers = #Players:GetPlayers(),
		})
		task.wait(1)
	end
end

function RoundManager:RunRoundTimer()
	self.State = "ROUND"
	self.RoundStartedAt = os.time()
	self.RoundActive = true

	for remaining = self.Config.RoundDuration, 0, -1 do
		if not self.RoundActive then
			break
		end

		self:BroadcastState({
			state = self.State,
			remaining = remaining,
			timerLabel = string.format("Round: %d", remaining),
			killer = self.CurrentKiller and self.CurrentKiller.Name,
		})

		local alive = self:GetAlivePlayers()
		MusicSystem:Update(alive, function(player)
			return TeamService:GetRole(player)
		end)

		if self:IsRoundOver() then
			break
		end

		task.wait(1)
	end

	if self.RoundActive then
		self:EndRound("TimeUp")
	end
end

function RoundManager:IsRoundOver()
	local alive = self:GetAlivePlayers()
	local survivorAliveCount = 0
	local killerAlive = false

	for _, player in ipairs(alive) do
		local role = TeamService:GetRole(player)
		if role == "Killer" then
			killerAlive = true
		elseif role == "Survivor" then
			survivorAliveCount += 1
		end
	end

	if not killerAlive then
		self:EndRound("SurvivorsWin")
		return true
	end

	if survivorAliveCount <= 0 then
		self:EndRound("KillerWin")
		return true
	end

	return false
end

function RoundManager:PrepareRound()
	local players = Players:GetPlayers()
	self:AssignRoles(players)
	self:ApplyRoundCharacters(players)
	self:TeleportAllToRoundPart()
end

function RoundManager:ReturnPlayersToLobby()
	for _, player in ipairs(Players:GetPlayers()) do
		player:LoadCharacter()
		local character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")
		if root and self.SpawnLocation then
			root.CFrame = self.SpawnLocation.CFrame + Vector3.new(0, 4, 0)
		end
	end
end

function RoundManager:EndRound(reason)
	if not self.RoundActive then
		return
	end

	self.RoundActive = false
	MusicSystem:StopRound()
	AbilityService:ClearAllLoadouts()
	TeamService:ClearRoundData()

	self:BroadcastState({
		state = "POST_ROUND",
		reason = reason,
		timerLabel = "Intermission: 0",
	})

	self:ReturnPlayersToLobby()
	task.wait(5)
end

function RoundManager:StartLoop()
	task.spawn(function()
		while true do
			self:IntermissionTick()

			if self:CanStartRound() then
				self:PrepareRound()
				self:RunRoundTimer()
			else
				self:BroadcastState({
					state = "WAITING_FOR_PLAYERS",
					timerLabel = "Waiting for players...",
					minimumPlayers = self.Config.MinimumPlayers,
					currentPlayers = #Players:GetPlayers(),
				})
				task.wait(5)
			end
		end
	end)
end

return setmetatable({}, RoundManager)
