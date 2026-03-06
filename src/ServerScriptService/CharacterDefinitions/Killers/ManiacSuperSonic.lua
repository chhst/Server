return {
	Id = "ManiacSuperSonic",
	Role = "Killer",
	DisplayName = "MANIAC SUPER SONIC",
	ModelPath = "ManiacSuperSonic",
	Stats = {
		HP = 1600,
		Speed = 54,
		BaseDamage = 30,
		CritDamage = 37,
	},
	KillerConfig = {
		ChaseMusic = "rbxassetid://0",
		Volume = 0.7,
	},
	Abilities = {
		Ability1 = {
			Name = "Insane Slash",
			Type = "Attack",
			Cooldown = 3,
			Damage = 30,
			Range = 9,
			Duration = 0,
			ServerLogic = function(_, target)
				local humanoid = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:TakeDamage(30)
				end
			end,
		},
		Ability2 = {
			Name = "Terror Aura",
			Type = "Stun",
			Cooldown = 20,
			Damage = 0,
			Range = 25,
			Duration = 4,
			ServerLogic = function() end,
		},
		Passive = {
			Name = "Unstable Crit",
			Type = "Passive",
			Cooldown = 0,
			Damage = 0,
			Range = 0,
			Duration = 0,
			ServerLogic = function() end,
		},
	},
}
