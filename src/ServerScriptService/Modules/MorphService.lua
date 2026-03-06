local ServerStorage = game:GetService("ServerStorage")

local MorphService = {}

local function getModelByPath(role, modelPath)
	if role == "Killer" then
		local killers = ServerStorage:FindFirstChild("Killers")
		if not killers then
			return nil
		end

		local current = killers
		for segment in string.gmatch(modelPath, "[^/]+") do
			current = current:FindFirstChild(segment)
			if not current then
				return nil
			end
		end
		return current
	elseif role == "Survivor" then
		local survivors = ServerStorage:FindFirstChild("Survivors")
		if not survivors then
			return nil
		end
		return survivors:FindFirstChild(modelPath)
	end

	return nil
end

local function applyCharacterStats(character, stats)
	if not stats then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	humanoid.WalkSpeed = stats.WalkSpeed or humanoid.WalkSpeed
	humanoid.MaxHealth = stats.MaxHealth or humanoid.MaxHealth
	humanoid.Health = humanoid.MaxHealth
end

function MorphService:ApplyMorphByModel(player, role, modelPath, stats)
	if not modelPath then
		warn("[MorphService] modelPath is nil for", player.Name)
		return nil
	end

	local sourceModel = getModelByPath(role, modelPath)
	if not sourceModel or not sourceModel:IsA("Model") then
		warn("[MorphService] Missing source model:", role, modelPath)
		return nil
	end

	local newCharacter = sourceModel:Clone()
	newCharacter.Name = player.Name
	newCharacter.Parent = workspace

	local humanoid = newCharacter:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("[MorphService] Cloned model has no Humanoid:", modelPath)
		newCharacter:Destroy()
		return nil
	end

	local root = newCharacter:FindFirstChild("HumanoidRootPart") or newCharacter.PrimaryPart
	if not root then
		warn("[MorphService] Cloned model has no HumanoidRootPart/PrimaryPart:", modelPath)
		newCharacter:Destroy()
		return nil
	end

	local oldCharacter = player.Character
	player.Character = newCharacter

	if oldCharacter and oldCharacter.Parent then
		oldCharacter:Destroy()
	end

	applyCharacterStats(newCharacter, stats)

	local roleValue = Instance.new("StringValue")
	roleValue.Name = "Role"
	roleValue.Value = role
	roleValue.Parent = newCharacter

	return newCharacter
end

function MorphService:GetRandomSurvivorModelName()
	local survivors = ServerStorage:FindFirstChild("Survivors")
	if not survivors then
		return nil
	end

	local models = {}
	for _, child in ipairs(survivors:GetChildren()) do
		if child:IsA("Model") then
			table.insert(models, child.Name)
		end
	end

	if #models == 0 then
		return nil
	end

	return models[math.random(1, #models)]
end

return MorphService
