return {
	Id = "Blaze",
	Role = "Survivor",
	DisplayName = "BLAZE",
	ModelPath = "Blaze",
	Stats = {
		HP = 100,
		Speed = 21,
	},
	Abilities = {
		Ability1 = {
			Name = "Fire Dash",
			Type = "Dash",
			Cooldown = 12,
			Damage = 0,
			Range = 0,
			Duration = 0.5,
			ServerLogic = function(player)
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed += 14
					task.delay(0.5, function()
						if humanoid.Parent then
							humanoid.WalkSpeed -= 14
						end
					end)
				end
			end,
		},
		Ability2 = {
			Name = "Burn",
			Type = "Attack",
			Cooldown = 20,
			Damage = 12,
			Range = 10,
			Duration = 4,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					for i = 1, 4 do
						task.delay(i, function()
							if humanoid.Parent then
								humanoid:TakeDamage(3)
							end
						end)
					end
				end
			end,
		},
		Passive = {
			Name = "Heat Escape",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
