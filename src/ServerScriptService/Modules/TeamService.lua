

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


end

function TeamService:ClearRoundData()
	self.PlayerRoles = {}

end

return TeamService
