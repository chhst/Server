local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local TeamService = require(ServerScriptService.Modules.TeamService)

local AbilityService = {}
AbilityService.Loadouts = {}
AbilityService.RoundStateRemote = nil

local function getNearestOpponent(player, role, maxRange)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end

	local nearest = nil
	local nearestDistance = math.huge

	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			local otherRole = TeamService:GetRole(other)
			if otherRole and otherRole ~= role then
				local otherRoot = other.Character and other.Character:FindFirstChild("HumanoidRootPart")
				local otherHumanoid = other.Character and other.Character:FindFirstChildOfClass("Humanoid")
				if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
					local distance = (otherRoot.Position - root.Position).Magnitude
					if distance <= maxRange and distance < nearestDistance then
						nearest = other
						nearestDistance = distance
					end
				end
			end
		end
	end

	return nearest
end

function AbilityService:Init(roundStateRemote)
	self.RoundStateRemote = roundStateRemote

	local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
	local castRemote = remotesFolder and remotesFolder:FindFirstChild("CastAbility")
	if not castRemote then
		castRemote = Instance.new("RemoteEvent")
		castRemote.Name = "CastAbility"
		castRemote.Parent = remotesFolder
	end

	castRemote.OnServerEvent:Connect(function(player, slot)
		self:CastAbilityBySlot(player, slot)
	end)
end

function AbilityService:RegisterPlayerLoadout(player, role, characterData)
	local loadout = {
		Slots = {},
		Cooldowns = {},
	}

	if not characterData or not characterData.Abilities then
		self.Loadouts[player.UserId] = loadout
		return
	end

	if role == "Killer" then
		loadout.Slots.Number1 = characterData.Abilities.Ability1
		loadout.Slots.Number2 = characterData.Abilities.Ability2
		loadout.Slots.Number3 = characterData.Abilities.Ability3 or characterData.Abilities.Ability2
	elseif role == "Survivor" then
		loadout.Slots.Sprint = characterData.Abilities.Ability1
	end

	for slot, ability in pairs(loadout.Slots) do
		if ability then
			loadout.Cooldowns[slot] = 0
		end
	end

	self.Loadouts[player.UserId] = loadout
end

function AbilityService:IsOnCooldown(loadout, slot)
	local ability = loadout.Slots[slot]
	if not ability then
		return true
	end
	local lastUsedAt = loadout.Cooldowns[slot] or 0
	return os.clock() - lastUsedAt < (ability.Cooldown or 0)
end

function AbilityService:CastAbilityBySlot(player, slot)
	local loadout = self.Loadouts[player.UserId]
	if not loadout then
		return
	end

	local ability = loadout.Slots[slot]
	if not ability then
		return
	end

	if self:IsOnCooldown(loadout, slot) then
		return
	end

	local role = TeamService:GetRole(player)
	local range = ability.Range or 12
	local target = getNearestOpponent(player, role, range)

	loadout.Cooldowns[slot] = os.clock()
	if ability.ServerLogic then
		ability.ServerLogic(player, target)
	end

	if self.RoundStateRemote then
		self.RoundStateRemote:FireClient(player, {
			state = "ABILITY_CAST",
			slot = slot,
			abilityName = ability.Name,
			cooldown = ability.Cooldown,
		})
	end
end

function AbilityService:ClearAllLoadouts()
	table.clear(self.Loadouts)
end

return AbilityService
