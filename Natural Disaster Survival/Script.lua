local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end

local lastPos = hrp.Position
local TARGET_POS = Vector3.new(-233.82, 179.68, 305.99)
local TELEPORT_THRESHOLD = 50

local connection
connection = RunService.Heartbeat:Connect(function()
    local currentPos = hrp.Position
    local distance = (currentPos - lastPos).Magnitude
    
    if distance > TELEPORT_THRESHOLD then
        hrp.CFrame = CFrame.new(TARGET_POS)
    end
    
    lastPos = currentPos
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    lastPos = hrp.Position
end)
