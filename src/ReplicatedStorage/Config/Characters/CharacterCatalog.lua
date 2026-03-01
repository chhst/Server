local CharacterCatalog = {}

local characters = {
	Survivor = {
		Scout = {
			Id = "Scout",
			Role = "Survivor",
			DisplayName = "Scout",
			Stats = {
				WalkSpeed = 18,
				MaxHealth = 100,
			},
			Appearance = {
				BodyColors = {
					HeadColor = "Light orange",
					TorsoColor = "Bright blue",
					LeftArmColor = "Light orange",
					RightArmColor = "Light orange",
					LeftLegColor = "Black",
					RightLegColor = "Black",
				},
			},
			Abilities = { "SprintBurst" },
		},
		Medic = {
			Id = "Medic",
			Role = "Survivor",
			DisplayName = "Medic",
			Stats = {
				WalkSpeed = 16,
				MaxHealth = 110,
			},
			Appearance = {
				BodyColors = {
					HeadColor = "Pastel brown",
					TorsoColor = "Institutional white",
					LeftArmColor = "Pastel brown",
					RightArmColor = "Pastel brown",
					LeftLegColor = "Dark green",
					RightLegColor = "Dark green",
				},
			},
			Abilities = { "MedicPulse" },
		},
	},
	Killer = {
		Slasher = {
			Id = "Slasher",
			Role = "Killer",
			DisplayName = "Slasher",
			Stats = {
				WalkSpeed = 20,
				MaxHealth = 220,
			},
			Appearance = {
				BodyColors = {
					HeadColor = "Really black",
					TorsoColor = "Crimson",
					LeftArmColor = "Really black",
					RightArmColor = "Really black",
					LeftLegColor = "Really black",
					RightLegColor = "Really black",
				},
			},
			Abilities = { "RageSlash" },
		},
	},
}

function CharacterCatalog:Get(role, id)
	local roleCatalog = characters[role]
	if not roleCatalog then
		return nil
	end

	return roleCatalog[id]
end

function CharacterCatalog:GetAll(role)
	return characters[role]
end

return CharacterCatalog
