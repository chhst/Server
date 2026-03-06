return {
	Id = "FleetwaySuperSonic",
	Role = "Killer",
	DisplayName = "FLEETWAY SUPER SONIC",
	ModelPath = "FleetwaySuperSonic",
	Stats = {
		HP = 1500,
		Speed = 30,
		BaseDamage = 35,
	},
	KillerConfig = {
		ChaseMusic = "rbxassetid://0",
		Volume = 0.7,
	},
	Abilities = {
		Ability1 = {
			Name = "Chaos Dash",
			Type = "Dash",
			Cooldown = 10,
			Damage = 35,
			Range = 16,
			Duration = 0.8,
			ServerLogic = function(player, target)
				if target and target.Character then
					local hum = target.Character:FindFirstChildOfClass("Humanoid")
					if hum then
						hum:TakeDamage(35)
					end
				end
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed += 10
					task.delay(0.8, function()
						if humanoid.Parent then
							humanoid.WalkSpeed -= 10
						end
					end)
				end
			end,
		},
		Ability2 = {
			Name = "Madness",
			Type = "Utility",
			Cooldown = 22,
			Damage = 0,
			Range = 0,
			Duration = 6,
			ServerLogic = function(player)
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed += 12
					task.delay(6, function()
						if humanoid.Parent then
							humanoid.WalkSpeed -= 12
						end
					end)
				end
			end,
		},
		Passive = {
			Name = "Rage Mode",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
