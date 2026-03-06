return {
	Id = "AKTEP",
	Role = "Killer",
	DisplayName = "AKTEP",
	ModelPath = "DEV/AKTEP",
	Stats = {
		HP = 1100,
		Speed = 28,
		BaseDamage = 50,
		CritDamage = 65,
	},
	KillerConfig = {
		ChaseMusic = "rbxassetid://0",
		Volume = 0.7,
		LMSMusic = "rbxassetid://0",
	},
	Abilities = {
		Ability1 = {
			Name = "Slash",
			Type = "Attack",
			Cooldown = 2,
			Damage = 50,
			Range = 9,
			Duration = 0,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:TakeDamage(50)
				end
			end,
		},
		Ability2 = {
			Name = "Money! Money! Money!",
			Type = "Utility",
			Cooldown = 35,
			Damage = 0,
			Range = 999,
			Duration = 8,
			ServerLogic = function(player)
				for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
					if other ~= player then
						local roleValue = other.Character and other.Character:FindFirstChild("Role")
						if roleValue and roleValue.Value == "Survivor" then
							for i = 1, 8 do
								task.delay(i, function()
									local hum = other.Character and other.Character:FindFirstChildOfClass("Humanoid")
									if hum and hum.Health > 0 then
										hum:TakeDamage(2)
									end
								end)
							end
						end
					end
				end
			end,
		},
		Ability3 = {
			Name = "You Are Mine",
			Type = "Utility",
			Cooldown = 45,
			Damage = 20,
			Range = 12,
			Duration = 5,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local old = humanoid.WalkSpeed
					humanoid.WalkSpeed = 0
					task.delay(5, function()
						if humanoid.Parent then
							humanoid.WalkSpeed = old
							humanoid:TakeDamage(20)
						end
					end)
				end
			end,
		},
		Passive = {
			Name = "Greed",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
