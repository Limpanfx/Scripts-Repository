local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local locations = {
    CFrame.new(-59.29, 49.37, 867.98),
    CFrame.new(-75.20, 49.39, 8691.31),
    CFrame.new(-75.36, -253.51, 8794.47),
    CFrame.new(-58.42, -340.38, 9493.82)
}

local collisionConn
local function setCollisions(char, enabled)
    collisionConn = RunService.Heartbeat:Connect(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = enabled
                part.AssemblyLinearVelocity = Vector3.new()
            end
        end
    end)
end

local function stopCollisions()
    if collisionConn then
        collisionConn:Disconnect()
        collisionConn = nil
    end
end

local function getHRP()
    local char = player.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
end

local function tweenTo(hrp, targetCFrame, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

local function runPath()
    local char = player.Character
    if not char or not getHRP() then return end
    
    setCollisions(char, false)
    local hrp = getHRP()
    
    tweenTo(hrp, locations[1], 2)
    tweenTo(hrp, locations[2], 20)
    tweenTo(hrp, locations[3], 2)
    tweenTo(hrp, locations[4], 2)
    
    stopCollisions()
end

local charConn
local function onChar(char)
    if charConn then charConn:Disconnect() end
    local hrp = char:WaitForChild("HumanoidRootPart")
    spawn(runPath)
end

if player.Character then
    onChar(player.Character)
end
player.CharacterAdded:Connect(onChar)
