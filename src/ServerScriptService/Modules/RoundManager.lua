local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeamService = require(script.Parent.TeamService)
local MorphService = require(script.Parent.MorphService)
local AbilityService = require(script.Parent.AbilityService)

local CharacterCatalog = require(ReplicatedStorage.Config.Characters.CharacterCatalog)

local RoundManager = {}
RoundManager.__index = RoundManager

function RoundManager:Init(config)
	self.Config = config
	self.State = "BOOT"
	self.RoundActive = false
	self.CurrentKiller = nil
	self.RoundStartedAt = 0

	AbilityService:Init(config.RoundStateRemote)

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

function RoundManager:ApplyMorphs(players)
	for _, player in ipairs(players) do
		local role = TeamService:GetRole(player)
		local chosenCharacterId = TeamService:GetSelectedCharacter(player, role)
		local characterData = CharacterCatalog:Get(role, chosenCharacterId)
		MorphService:ApplyMorph(player, characterData)
		AbilityService:RegisterPlayerLoadout(player, characterData)
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
			killer = self.CurrentKiller and self.CurrentKiller.Name,
		})

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
	self:ApplyMorphs(players)
end

function RoundManager:EndRound(reason)
	if not self.RoundActive then
		return
	end

	self.RoundActive = false
	AbilityService:ClearAllLoadouts()
	TeamService:ClearRoundData()

	self:BroadcastState({
		state = "POST_ROUND",
		reason = reason,
	})

	for _, player in ipairs(Players:GetPlayers()) do
		player:LoadCharacter()
	end

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
					minimumPlayers = self.Config.MinimumPlayers,
					currentPlayers = #Players:GetPlayers(),
				})
				task.wait(5)
			end
		end
	end)
end

return setmetatable({}, RoundManager)
