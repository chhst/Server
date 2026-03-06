local ReplicatedStorage = game:GetService("ReplicatedStorage")

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


	local loadout = self.Loadouts[player.UserId]
	if not loadout then
		return
	end



	if self.RoundStateRemote then
		self.RoundStateRemote:FireClient(player, {
			state = "ABILITY_CAST",

		})
	end
end

function AbilityService:ClearAllLoadouts()
	table.clear(self.Loadouts)
end

return AbilityService
