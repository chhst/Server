local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AbilityCatalog = require(ReplicatedStorage.Config.Abilities.AbilityCatalog)

local AbilityService = {}
AbilityService.Loadouts = {}
AbilityService.RoundStateRemote = nil

function AbilityService:Init(roundStateRemote)
	self.RoundStateRemote = roundStateRemote

	local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
	local castRemote = remotesFolder and remotesFolder:FindFirstChild("CastAbility")
	if not castRemote then
		castRemote = Instance.new("RemoteEvent")
		castRemote.Name = "CastAbility"
		castRemote.Parent = remotesFolder
	end

	castRemote.OnServerEvent:Connect(function(player, abilityId, payload)
		self:CastAbility(player, abilityId, payload)
	end)
end

function AbilityService:RegisterPlayerLoadout(player, characterData)
	local loadout = {}
	for _, abilityId in ipairs(characterData.Abilities or {}) do
		local ability = AbilityCatalog:Get(abilityId)
		if ability then
			loadout[abilityId] = {
				Definition = ability,
				LastUsedAt = 0,
			}
		end
	end
	self.Loadouts[player.UserId] = loadout
end

function AbilityService:IsOnCooldown(loadoutItem)
	local now = os.clock()
	return now - loadoutItem.LastUsedAt < loadoutItem.Definition.Cooldown
end

function AbilityService:CastAbility(player, abilityId, payload)
	local loadout = self.Loadouts[player.UserId]
	if not loadout then
		return
	end

	local loadoutItem = loadout[abilityId]
	if not loadoutItem then
		return
	end

	if self:IsOnCooldown(loadoutItem) then
		return
	end

	loadoutItem.LastUsedAt = os.clock()
	loadoutItem.Definition.Execute(player, payload)

	if self.RoundStateRemote then
		self.RoundStateRemote:FireClient(player, {
			state = "ABILITY_CAST",
			abilityId = abilityId,
			cooldown = loadoutItem.Definition.Cooldown,
		})
	end
end

function AbilityService:ClearAllLoadouts()
	table.clear(self.Loadouts)
end

return AbilityService
