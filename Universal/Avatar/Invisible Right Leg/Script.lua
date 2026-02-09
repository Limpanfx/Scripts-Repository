local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function hideRightLeg(char)
    local parts = {
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot"
    }

    for _, name in ipairs(parts) do
        local part = char:FindFirstChild(name)
        if part then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

local function onCharacter(char)
    hideRightLeg(char)
end

if player.Character then
    onCharacter(player.Character)
end

player.CharacterAdded:Connect(onCharacter)
