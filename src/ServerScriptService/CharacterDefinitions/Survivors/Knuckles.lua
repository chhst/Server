return {
	Id = "Knuckles",
	Role = "Survivor",
	DisplayName = "KNUCKLES",
	ModelPath = "Knuckles",
	Stats = {
		HP = 110,
		Speed = 17,
	},
	Abilities = {
		Ability1 = {
			Name = "Punch",
			Type = "Stun",
			Cooldown = 15,
			Damage = 0,
			Range = 10,
			Duration = 3,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = 0
					task.delay(3, function()
						if humanoid.Parent then
							humanoid.WalkSpeed = 16
						end
					end)
				end
			end,
		},
		Ability2 = {
			Name = "Ground Slam",
			Type = "Utility",
			Cooldown = 20,
			Damage = 0,
			Range = 14,
			Duration = 1,
			ServerLogic = function() end,
		},
		Passive = {
			Name = "Tough",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
