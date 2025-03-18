local sneakDetectionArea = workspace.IADUMMY:WaitForChild("sneakDetection")
local isPlayerDetected = false

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharChangeEvent = ReplicatedStorage.DataUpdates:FindFirstChild("CharSelect")

local npc = workspace:WaitForChild("IADUMMY")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function isPlayerBehindWall(npcHead, playerHead)
	local ray = Ray.new(npcHead.Position, (playerHead.Position - npcHead.Position).Unit * (playerHead.Position - npcHead.Position).Magnitude)

	local ignoreList = {npc, character}

	local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

	if hit then
		return true
	else
		return false
	end
end

sneakDetectionArea.Touched:Connect(function(hit)
	if isPlayerDetected == false then
		if hit.Parent == character then
			print("Player touched the sneakDetection Area")
			isPlayerDetected = true
		end
	end
end)

sneakDetectionArea.TouchEnded:Connect(function(hit)
	if hit.Parent == character then
		print("Player isn't touching the sneakDetection area anymore")
		isPlayerDetected = false
	end
end)

RunService.PreRender:Connect(function()
	character = player.Character or player.CharacterAdded:Wait()
	if character and character:FindFirstChild("Head") and npc and npc:FindFirstChild("Head") then
		if isPlayerDetected == false then
			local npcToCharacter = (character.Head.Position - npc.Head.Position).Unit
			local differenceBetweenPosition = character.Head.Position.Z - npc.Head.Position.Z

			local cframe = CFrame.new(npc.Head.Position, npc.Head.Position + npcToCharacter)
			local npcLook = npc.Head.CFrame.LookVector

			local maxview = 0.7001 -- 45° View in front of the NPC

			local dotProduct = npcToCharacter:Dot(npcLook)

			if dotProduct > maxview then
				if not isPlayerBehindWall(npc.Head, character.Head) then
					print("Player Detected by the view of the NPC")
				else
					print("Player is behind a wall and cannot be seen")
				end
			else
				print("Player isn't detected")
			end
		end
	end
end)

CharChangeEvent.OnClientEvent:Connect(function()
	character = player.Character or player.CharacterAdded:Wait()
end)
