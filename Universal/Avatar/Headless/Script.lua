local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function makeHeadless(char)
    local head = char:WaitForChild("Head")
    head.Transparency = 1
    local face = head:FindFirstChild("face")
    if face then
        face.Transparency = 1
    end
end

if player.Character then
    makeHeadless(player.Character)
end

player.CharacterAdded:Connect(makeHeadless)
