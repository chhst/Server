local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoundManager = require(ServerScriptService.Modules.RoundManager)

local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = ReplicatedStorage
end

local roundStateRemote = remotesFolder:FindFirstChild("RoundState")
if not roundStateRemote then
	roundStateRemote = Instance.new("RemoteEvent")
	roundStateRemote.Name = "RoundState"
	roundStateRemote.Parent = remotesFolder
end

RoundManager:Init({
	IntermissionDuration = 20,
	RoundDuration = 240,
	MinimumPlayers = 2,
	RoundStateRemote = roundStateRemote,
})

RoundManager:StartLoop()
