local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local originalCFrame = hrp.CFrame
local finishesFolder = game.Workspace:WaitForChild("tower"):WaitForChild("finishes")

local safeY = 10 

for _, finish in ipairs(finishesFolder:GetChildren()) do
    if finish:IsA("BasePart") then
        local target = finish.Position + Vector3.new(0, safeY, 0)
        hrp.CFrame = CFrame.new(target)
        task.wait(0.1)
    end
end

hrp.CFrame = originalCFrame
