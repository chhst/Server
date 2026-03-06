return {
	Id = "Tails",
	Role = "Survivor",
	DisplayName = "TAILS",
	ModelPath = "Tails",
	Stats = {
		HP = 100,
		Speed = 18,
	},
	Abilities = {
		Ability1 = {
			Name = "Flight",
			Type = "Utility",
			Cooldown = 20,
			Damage = 0,
			Range = 0,
			Duration = 5,
			ServerLogic = function(player)
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if root then
					root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 65, root.AssemblyLinearVelocity.Z)
				end
			end,
		},
		Ability2 = {
			Name = "Drone Scan",
			Type = "Utility",
			Cooldown = 25,
			Damage = 0,
			Range = 0,
			Duration = 4,
			ServerLogic = function() end,
		},
		Passive = {
			Name = "Mechanic",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
