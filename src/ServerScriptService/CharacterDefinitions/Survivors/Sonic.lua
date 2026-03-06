return {
	Id = "Sonic",
	Role = "Survivor",
	DisplayName = "SONIC",
	ModelPath = "Sonic",
	Stats = {
		HP = 100,
		Speed = 24,
	},
	Abilities = {
		Ability1 = {
			Name = "Drop Dash",
			Type = "Dash",
			Cooldown = 10,
			Damage = 0,
			Range = 0,
			Duration = 0.45,
			ServerLogic = function(player)
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed += 18
					task.delay(0.45, function()
						if humanoid.Parent then
							humanoid.WalkSpeed -= 18
						end
					end)
				end
			end,
		},
		Ability2 = {
			Name = "Speed Boost",
			Type = "Utility",
			Cooldown = 18,
			Damage = 0,
			Range = 0,
			Duration = 6,
			ServerLogic = function(player)
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local delta = humanoid.WalkSpeed * 0.4
					humanoid.WalkSpeed += delta
					task.delay(6, function()
						if humanoid.Parent then
							humanoid.WalkSpeed -= delta
						end
					end)
				end
			end,
		},
		Passive = {
			Name = "Momentum",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
