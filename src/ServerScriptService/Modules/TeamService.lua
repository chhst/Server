local TeamService = {}

TeamService.PlayerRoles = {}
TeamService.SelectedCharacters = {}

function TeamService:AssignRoles(players, killer)
	self.PlayerRoles = {}
	for _, player in ipairs(players) do
		if player == killer then
			self.PlayerRoles[player.UserId] = "Killer"
		else
			self.PlayerRoles[player.UserId] = "Survivor"
		end
	end
end

function TeamService:GetRole(player)
	return self.PlayerRoles[player.UserId]
end

function TeamService:SetSelectedCharacter(player, role, characterId)
	self.SelectedCharacters[player.UserId] = self.SelectedCharacters[player.UserId] or {}
	self.SelectedCharacters[player.UserId][role] = characterId
end

function TeamService:GetSelectedCharacter(player, role)
	local playerData = self.SelectedCharacters[player.UserId]
	if playerData and playerData[role] then
		return playerData[role]
	end

	if role == "Killer" then
		return "Slasher"
	end

	return "Scout"
end

function TeamService:ClearRoundData()
	self.PlayerRoles = {}
end

return TeamService
