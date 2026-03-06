local TeamService = {}

TeamService.PlayerRoles = {}
TeamService.RoundCharacters = {}

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

function TeamService:SetRoundCharacter(player, characterData)
	self.RoundCharacters[player.UserId] = characterData
end

function TeamService:GetRoundCharacter(player)
	return self.RoundCharacters[player.UserId]
end

function TeamService:ClearRoundData()
	self.PlayerRoles = {}
	self.RoundCharacters = {}
end

return TeamService
