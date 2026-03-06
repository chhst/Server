return {
	Id = "Amy",
	Role = "Survivor",
	DisplayName = "AMY",
	ModelPath = "Amy",
	Stats = {
		HP = 100,
		Speed = 18,
	},
	Abilities = {
		Ability1 = {
			Name = "Hammer Strike",
			Type = "Stun",
			Cooldown = 18,
			Damage = 0,
			Range = 11,
			Duration = 4,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = 0
					task.delay(4, function()
						if humanoid.Parent then
							humanoid.WalkSpeed = 16
						end
					end)
				end
			end,
		},
		Ability2 = {
			Name = "Tarot Cards",
			Type = "Utility",
			Cooldown = 25,
			Damage = 0,
			Range = 0,
			Duration = 5,
			ServerLogic = function(player)
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed += 4
					task.delay(5, function()
						if humanoid.Parent then
							humanoid.WalkSpeed -= 4
						end
					end)
				end
			end,
		},
		Passive = {
			Name = "Lucky",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
