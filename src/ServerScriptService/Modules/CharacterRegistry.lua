local ServerScriptService = game:GetService("ServerScriptService")

local Killers = {
	require(ServerScriptService.CharacterDefinitions.Killers.AKTEP),
	require(ServerScriptService.CharacterDefinitions.Killers.FleetwaySuperSonic),
	require(ServerScriptService.CharacterDefinitions.Killers.ManiacSuperSonic),
	require(ServerScriptService.CharacterDefinitions.Killers.Kolossos),
}

local Survivors = {
	require(ServerScriptService.CharacterDefinitions.Survivors.Sonic),
	require(ServerScriptService.CharacterDefinitions.Survivors.Tails),
	require(ServerScriptService.CharacterDefinitions.Survivors.Knuckles),
	require(ServerScriptService.CharacterDefinitions.Survivors.Amy),
	require(ServerScriptService.CharacterDefinitions.Survivors.Silver),
	require(ServerScriptService.CharacterDefinitions.Survivors.Blaze),
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

function CharacterRegistry:GetRandomSurvivor()
	local all = self:GetAll("Survivor")
	if #all == 0 then
		return nil
	end
	return all[math.random(1, #all)]
end

function CharacterRegistry:GetAKTEP()
	return byRoleAndId.Killer.AKTEP
end

return CharacterRegistry
