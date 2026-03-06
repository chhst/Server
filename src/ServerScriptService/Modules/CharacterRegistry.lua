local ServerScriptService = game:GetService("ServerScriptService")

local Killers = {

}

local byRoleAndId = {
	Killer = {},
	Survivor = {},
}

for _, character in ipairs(Killers) do
	byRoleAndId.Killer[character.Id] = character
end

for _, character in ipairs(Survivors) do
	byRoleAndId.Survivor[character.Id] = character
end

local CharacterRegistry = {}

function CharacterRegistry:Get(role, id)
	local roleCatalog = byRoleAndId[role]
	if not roleCatalog then
		return nil
	end
	return roleCatalog[id]
end

function CharacterRegistry:GetAll(role)
	if role == "Killer" then
		return Killers
	elseif role == "Survivor" then
		return Survivors
	end
	return {}
end

function CharacterRegistry:GetDefault(role)
	local all = self:GetAll(role)
	return all[1]
end


return CharacterRegistry
