local ServerStorage = game:GetService("ServerStorage")

local MorphService = {}

local function getRoleFolder(role)
	if role == "Killer" then
		return ServerStorage:FindFirstChild("Killers")
	elseif role == "Survivor" then
		return ServerStorage:FindFirstChild("Survivors")
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

function MorphService:ApplyMorph(player, characterData)
	if not characterData then
		warn("[MorphService] characterData is nil for", player.Name)
		return
	end

	local roleFolder = getRoleFolder(characterData.Role)
	if not roleFolder then
		warn("[MorphService] Missing ServerStorage role folder for role", characterData.Role)
		return
	end

	local sourceModel = roleFolder:FindFirstChild(characterData.ModelName)
	if not sourceModel or not sourceModel:IsA("Model") then
		warn("[MorphService] Missing model in ServerStorage:", characterData.ModelName)
		return
	end

	local newCharacter = sourceModel:Clone()
	newCharacter.Name = player.Name
	newCharacter.Parent = workspace

	local humanoid = newCharacter:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("[MorphService] Cloned model has no Humanoid:", characterData.ModelName)
		newCharacter:Destroy()
		return
	end

	local root = newCharacter:FindFirstChild("HumanoidRootPart") or newCharacter.PrimaryPart
	if not root then
		warn("[MorphService] Cloned model has no HumanoidRootPart/PrimaryPart:", characterData.ModelName)
		newCharacter:Destroy()
		return
	end

	local oldCharacter = player.Character
	player.Character = newCharacter

	if oldCharacter and oldCharacter.Parent then
		oldCharacter:Destroy()
	end

	applyCharacterStats(newCharacter, characterData.Stats)

	local roleValue = Instance.new("StringValue")
	roleValue.Name = "Role"
	roleValue.Value = characterData.Role
	roleValue.Parent = newCharacter
end

return MorphService
