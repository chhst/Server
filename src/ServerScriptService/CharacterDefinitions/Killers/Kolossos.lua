return {
	Id = "Kolossos",
	Role = "Killer",
	DisplayName = "KOLOSSOS",
	ModelPath = "Kolossos",
	Stats = {
		HP = 2000,
		Speed = 52,
		BaseDamage = 55,
	},
	KillerConfig = {
		ChaseMusic = "rbxassetid://0",
		Volume = 0.7,
	},
	Abilities = {
		Ability1 = {
			Name = "Heavy Smash",
			Type = "Attack",
			Cooldown = 6,
			Damage = 55,
			Range = 10,
			Duration = 0,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:TakeDamage(55)
				end
			end,
		},
		Ability2 = {
			Name = "Shockwave",
			Type = "Utility",
			Cooldown = 18,
			Damage = 20,
			Range = 20,
			Duration = 0,
			ServerLogic = function() end,
		},
		Passive = {
			Name = "Tank Armor",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
