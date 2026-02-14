if game.PlaceId == 12360882630 then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local function getCharacter()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            return char
        end
        char = player.CharacterAdded:Wait()
        char:WaitForChild("HumanoidRootPart")
        return char
    end

    local minPos = Vector3.new(166.38, 437.88, -1085.53)
    local maxPos = Vector3.new(199.66, 440.21, -1074.37)

    local character = getCharacter()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local randX = math.random()
        local randY = math.random()
        local randZ = math.random()
        local randomPos = Vector3.new(
            minPos.X + (maxPos.X - minPos.X) * randX,
            minPos.Y + (maxPos.Y - minPos.Y) * randY,
            minPos.Z + (maxPos.Z - minPos.Z) * randZ
        )
        hrp.CFrame = CFrame.new(randomPos)
    end
end
