local Players = game:GetService("Players")

local MusicSystem = {}
MusicSystem.RoundStateRemote = nil
MusicSystem.Killer = nil
MusicSystem.KillerConfig = nil
MusicSystem.ChaseActive = {}
MusicSystem.LMSActive = false

function MusicSystem:Init(roundStateRemote)
	self.RoundStateRemote = roundStateRemote
end

function MusicSystem:StartRound(killerPlayer, killerCharacterData)
	self.Killer = killerPlayer
	self.KillerConfig = killerCharacterData and killerCharacterData.KillerConfig or {}
	self.ChaseActive = {}
	self.LMSActive = false
end

function MusicSystem:StopRound()
	for _, player in ipairs(Players:GetPlayers()) do
		self:SendChaseState(player, false)
	end
	self:SendLMSState(false)
	self.Killer = nil
	self.KillerConfig = nil
	self.ChaseActive = {}
	self.LMSActive = false
end

function MusicSystem:SendChaseState(player, isActive)
	if not self.RoundStateRemote then
		return
	end

	self.RoundStateRemote:FireClient(player, {
		state = "CHASE_THEME",
		enabled = isActive,
		soundId = self.KillerConfig and self.KillerConfig.ChaseMusic or "rbxassetid://0",
		volume = self.KillerConfig and self.KillerConfig.Volume or 0.7,
	})
end

function MusicSystem:SendLMSState(isActive)
	if not self.RoundStateRemote then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		self.RoundStateRemote:FireClient(player, {
			state = "LMS_THEME",
			enabled = isActive,
			soundId = self.KillerConfig and self.KillerConfig.LMSMusic or "rbxassetid://0",
			volume = 0.8,
		})
	end
end

function MusicSystem:Update(alivePlayers, getRole)
	if not self.Killer or not self.Killer.Character then
		return
	end

	local killerRoot = self.Killer.Character:FindFirstChild("HumanoidRootPart")
	if not killerRoot then
		return
	end

	local survivorAliveCount = 0

	for _, player in ipairs(alivePlayers) do
		if player ~= self.Killer and getRole(player) == "Survivor" then
			survivorAliveCount += 1
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local distance = (root.Position - killerRoot.Position).Magnitude
				local currentlyActive = self.ChaseActive[player.UserId] == true
				if distance < 60 and not currentlyActive then
					self.ChaseActive[player.UserId] = true
					self:SendChaseState(player, true)
				elseif distance > 80 and currentlyActive then
					self.ChaseActive[player.UserId] = false
					self:SendChaseState(player, false)
				end
			end
		end
	end

	local shouldEnableLMS = survivorAliveCount == 1
	if shouldEnableLMS ~= self.LMSActive then
		self.LMSActive = shouldEnableLMS
		self:SendLMSState(self.LMSActive)
	end
end

return MusicSystem
