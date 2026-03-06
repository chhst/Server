local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateRemote = remotes:WaitForChild("RoundState")
local castAbilityRemote = remotes:WaitForChild("CastAbility")

local playerGui = player:WaitForChild("PlayerGui")
local lobbyGui = playerGui:WaitForChild("LobbyGui")
local timerLabel = lobbyGui:WaitForChild("Timer"):WaitForChild("Label")

local roundGui = playerGui:WaitForChild("RoundGui")
local number1Button = roundGui:WaitForChild("Number1")
local number2Button = roundGui:WaitForChild("Number2")
local number3Button = roundGui:WaitForChild("Number3")
local sprintButton = roundGui:WaitForChild("Sprint")

local currentRole = nil

local chaseSound = Instance.new("Sound")
chaseSound.Name = "ChaseTheme"
chaseSound.Looped = true
chaseSound.Volume = 0
chaseSound.Parent = SoundService

local lmsSound = Instance.new("Sound")
lmsSound.Name = "LMSTheme"
lmsSound.Looped = true
lmsSound.Volume = 0
lmsSound.Parent = SoundService

local function fadeSound(sound, targetVolume, duration)
	TweenService:Create(sound, TweenInfo.new(duration), { Volume = targetVolume }):Play()
end

local function setButtonState(role)
	if role == "Killer" then
		number1Button.Visible = true
		number2Button.Visible = true
		number3Button.Visible = true
		sprintButton.Visible = false
	elseif role == "Survivor" then
		number1Button.Visible = false
		number2Button.Visible = false
		number3Button.Visible = false
		sprintButton.Visible = true
	else
		number1Button.Visible = false
		number2Button.Visible = false
		number3Button.Visible = false
		sprintButton.Visible = false
	end
end

number1Button.MouseButton1Click:Connect(function()
	if currentRole == "Killer" then
		castAbilityRemote:FireServer("Number1")
	end
end)

number2Button.MouseButton1Click:Connect(function()
	if currentRole == "Killer" then
		castAbilityRemote:FireServer("Number2")
	end
end)

number3Button.MouseButton1Click:Connect(function()
	if currentRole == "Killer" then
		castAbilityRemote:FireServer("Number3")
	end
end)

sprintButton.MouseButton1Click:Connect(function()
	if currentRole == "Survivor" then
		castAbilityRemote:FireServer("Sprint")
	end
end)

roundStateRemote.OnClientEvent:Connect(function(payload)
	if payload.state == "ROLE_ASSIGNED" and payload.player == player.Name then
		currentRole = payload.role
		setButtonState(currentRole)
		return
	end

	if payload.state == "POST_ROUND" or payload.state == "WAITING_FOR_PLAYERS" then
		currentRole = nil
		setButtonState(nil)
	end

	if payload.state == "CHASE_THEME" then
		if payload.soundId and payload.soundId ~= "" then
			chaseSound.SoundId = payload.soundId
		end
		if payload.enabled then
			if not chaseSound.IsPlaying then
				chaseSound:Play()
			end
			fadeSound(chaseSound, payload.volume or 0.7, 0.35)
		else
			fadeSound(chaseSound, 0, 0.5)
			task.delay(0.55, function()
				if chaseSound.Volume <= 0.01 then
					chaseSound:Stop()
				end
			end)
		end
	end

	if payload.state == "LMS_THEME" then
		if payload.soundId and payload.soundId ~= "" then
			lmsSound.SoundId = payload.soundId
		end
		if payload.enabled then
			if not lmsSound.IsPlaying then
				lmsSound:Play()
			end
			fadeSound(lmsSound, payload.volume or 0.8, 0.35)
		else
			fadeSound(lmsSound, 0, 0.5)
			task.delay(0.55, function()
				if lmsSound.Volume <= 0.01 then
					lmsSound:Stop()
				end
			end)
		end
	end

	if payload.timerLabel then
		timerLabel.Text = payload.timerLabel
	end
end)

setButtonState(nil)
