local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateRemote = remotes:WaitForChild("RoundState")
local castAbilityRemote = remotes:WaitForChild("CastAbility")

local abilities = {}

roundStateRemote.OnClientEvent:Connect(function(payload)
	if payload.state == "ABILITY_CAST" then
		abilities[payload.abilityId] = os.clock() + payload.cooldown
		return
	end

	print("Round state update:", payload.state, payload.remaining)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.Q then
		castAbilityRemote:FireServer("SprintBurst")
	elseif input.KeyCode == Enum.KeyCode.E then
		castAbilityRemote:FireServer("MedicPulse")
	elseif input.KeyCode == Enum.KeyCode.R then
		castAbilityRemote:FireServer("RageSlash")
	end
end)
