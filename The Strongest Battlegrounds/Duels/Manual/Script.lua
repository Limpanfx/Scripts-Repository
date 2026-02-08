local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hide chat on execution
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0, 20, 0.4, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = frame

local buttonHolder = Instance.new("Frame")
buttonHolder.Size = UDim2.new(1, 0, 1, 0)
buttonHolder.BackgroundTransparency = 1
buttonHolder.Parent = frame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Parent = buttonHolder

local function createButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 40)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(240, 240, 255)

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1.5
    btnStroke.Color = Color3.fromRGB(30, 30, 45)
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = btn

    btn.Parent = buttonHolder
    return btn
end

local minPos = Vector3.new(165, 439, -1085)
local maxPos = Vector3.new(199, 439, -1075)

local tpButton = createButton("Queue Teleport (E)", Color3.fromRGB(60, 140, 90))
local resetButton = createButton("Limpan's Tiny Reset (R)", Color3.fromRGB(170, 60, 70))
local lobbyButton = createButton("Teleport to Lobby (T)", Color3.fromRGB(80, 100, 160))

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function randomPosition()
    return Vector3.new(
        math.random(minPos.X, maxPos.X),
        minPos.Y,
        math.random(minPos.Z, maxPos.Z)
    )
end

tpButton.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local pos = randomPosition()
    hrp.CFrame = CFrame.new(pos)
end)

resetButton.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Health = 0
end)

lobbyButton.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:Teleport(12360882630, player)
    end)
end)

-- R keybind for tiny reset (chat-safe)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    elseif input.KeyCode == Enum.KeyCode.E then
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = randomPosition()
                hrp.CFrame = CFrame.new(pos)
            end
        end
    elseif input.KeyCode == Enum.KeyCode.T then
        pcall(function()
            TeleportService:Teleport(12360882630, player)
        end)
    end
end)
