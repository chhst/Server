local Players = game:GetService("Players")

local AbilityCatalog = {}

local function basicAttack(player)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local otherCharacter = otherPlayer.Character
			local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
			local otherHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
			if otherRoot and otherHumanoid and (otherRoot.Position - root.Position).Magnitude <= 7 then
				otherHumanoid:TakeDamage(30)
			end
		end
	end
end

local function rageSlash(player)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local otherCharacter = otherPlayer.Character
			local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
			local otherHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
			if otherRoot and otherHumanoid and (otherRoot.Position - root.Position).Magnitude <= 10 then
				otherHumanoid:TakeDamage(45)
			end
		end
	end
end

local function hunterRush(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	local baseSpeed = humanoid.WalkSpeed
	humanoid.WalkSpeed = baseSpeed + 12
	task.delay(3, function()
		if humanoid.Parent then
			humanoid.WalkSpeed = baseSpeed
		end
	end)
end

local function sprintBurst(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	local baseSpeed = humanoid.WalkSpeed
	humanoid.WalkSpeed = baseSpeed + 8
	task.delay(3.5, function()
		if humanoid.Parent then
			humanoid.WalkSpeed = baseSpeed
		end
	end)
end

local abilities = {
	BasicAttack = {
		Id = "BasicAttack",
		Name = "Basic Attack",
		Cooldown = 1.1,
		Execute = basicAttack,
	},
	RageSlash = {
		Id = "RageSlash",
		Name = "Rage Slash",
		Cooldown = 10,
		Execute = rageSlash,
	},
	HunterRush = {
		Id = "HunterRush",
		Name = "Hunter Rush",
		Cooldown = 16,
		Execute = hunterRush,
	},
	SprintBurst = {
		Id = "SprintBurst",
		Name = "Sprint",
		Cooldown = 8,
		Execute = sprintBurst,
	},
}

function AbilityCatalog:Get(abilityId)
	return abilities[abilityId]
end

return AbilityCatalog
