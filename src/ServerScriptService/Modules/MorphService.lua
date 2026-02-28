local MorphService = {}

local function clearCosmetics(character)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") then
			child:Destroy()
		end
	end
end

local function applyBodyColors(character, colors)
	if not colors then
		return
	end

	local bodyColors = character:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
	for property, value in pairs(colors) do
		bodyColors[property] = BrickColor.new(value)
	end
	bodyColors.Parent = character
end

function MorphService:ApplyMorph(player, characterData)
	if not characterData then
		return
	end

	player:LoadCharacter()
	local character = player.Character or player.CharacterAdded:Wait()
	clearCosmetics(character)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and characterData.Appearance then
		if characterData.Appearance.DescriptionId then
			local ok, description = pcall(function()
				return game:GetService("Players"):GetHumanoidDescriptionFromUserId(characterData.Appearance.DescriptionId)
			end)
			if ok and description then
				humanoid:ApplyDescription(description)
			end
		end

		applyBodyColors(character, characterData.Appearance.BodyColors)
	end

	if humanoid and characterData.Stats then
		humanoid.WalkSpeed = characterData.Stats.WalkSpeed or humanoid.WalkSpeed
		humanoid.MaxHealth = characterData.Stats.MaxHealth or humanoid.MaxHealth
		humanoid.Health = humanoid.MaxHealth
	end

	local roleValue = Instance.new("StringValue")
	roleValue.Name = "Role"
	roleValue.Value = characterData.Role
	roleValue.Parent = character
end

return MorphService
