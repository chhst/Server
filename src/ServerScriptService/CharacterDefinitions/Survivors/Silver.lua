return {
	Id = "Silver",
	Role = "Survivor",
	DisplayName = "SILVER",
	ModelPath = "Silver",
	Stats = {
		HP = 100,
		Speed = 19,
	},
	Abilities = {
		Ability1 = {
			Name = "Telekinesis",
			Type = "Utility",
			Cooldown = 20,
			Damage = 0,
			Range = 12,
			Duration = 1,
			ServerLogic = function(_, target)
				local root = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
				if root then
					root.AssemblyLinearVelocity = Vector3.new(0, 35, 0)
				end
			end,
		},
		Ability2 = {
			Name = "Psychic Hold",
			Type = "Stun",
			Cooldown = 28,
			Damage = 0,
			Range = 14,
			Duration = 5,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = math.max(8, humanoid.WalkSpeed - 10)
					task.delay(5, function()
						if humanoid.Parent then
							humanoid.WalkSpeed += 10
						end
					end)
				end
			end,
		},
		Passive = {
			Name = "Psychic Focus",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
