
local function hunterRush(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end


		end
	end)
end


	},
	RageSlash = {
		Id = "RageSlash",
		Name = "Rage Slash",

}

function AbilityCatalog:Get(abilityId)
	return abilities[abilityId]
end

return AbilityCatalog
