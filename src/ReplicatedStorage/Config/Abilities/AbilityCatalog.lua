local AbilityCatalog = {}

local function healPulse(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + 35)
	end
end

local function sprintBurst(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	local previousSpeed = humanoid.WalkSpeed
	humanoid.WalkSpeed = previousSpeed + 10
	task.delay(4, function()
		if humanoid.Parent then
			humanoid.WalkSpeed = previousSpeed
		end
	end)
end

local function rageSlash(player)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local radius = 8
	for _, model in ipairs(workspace:GetChildren()) do
		if model:IsA("Model") and model ~= character then
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			local otherRoot = model:FindFirstChild("HumanoidRootPart")
			if humanoid and otherRoot and (otherRoot.Position - root.Position).Magnitude <= radius then
				humanoid:TakeDamage(40)
			end
		end
	end
end

local abilities = {
	MedicPulse = {
		Id = "MedicPulse",
		Name = "Medic Pulse",
		Cooldown = 24,
		Execute = healPulse,
	},
	SprintBurst = {
		Id = "SprintBurst",
		Name = "Sprint Burst",
		Cooldown = 16,
		Execute = sprintBurst,
	},
	RageSlash = {
		Id = "RageSlash",
		Name = "Rage Slash",
		Cooldown = 12,
		Execute = rageSlash,
	},
}

function AbilityCatalog:Get(abilityId)
	return abilities[abilityId]
end

return AbilityCatalog
