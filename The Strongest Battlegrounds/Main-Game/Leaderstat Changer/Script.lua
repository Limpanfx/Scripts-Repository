local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LeaderstatsEditorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 210)
Frame.Position = UDim2.new(0.5, -160, 0.5, -105)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(120, 80, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Leaderstats Editor"
Title.TextColor3 = Color3.fromRGB(230, 230, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -20, 0, 18)
Subtitle.Position = UDim2.new(0, 10, 0, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Total Kills & Kills"
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 200)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Frame

local function createInputBlock(labelText, yOffset)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, -20, 0, 60)
    Holder.Position = UDim2.new(0, 10, 0, yOffset)
    Holder.BackgroundTransparency = 1
    Holder.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, -5, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(210, 210, 235)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Holder

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.5, -5, 0, 26)
    TextBox.Position = UDim2.new(0, 0, 0, 26)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TextBox.BorderSizePixel = 0
    TextBox.Text = ""
    TextBox.PlaceholderText = "Enter number"
    TextBox.TextColor3 = Color3.fromRGB(230, 230, 255)
    TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = Holder

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 6)
    TBCorner.Parent = TextBox

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.5, -5, 0, 26)
    Button.Position = UDim2.new(0.5, 5, 0, 26)
    Button.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    Button.BorderSizePixel = 0
    Button.Text = "Set"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 15
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Holder

    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = Button

    return TextBox, Button
end

local totalKillsBox, totalKillsButton = createInputBlock("Total Kills", 70)
local killsBox, killsButton = createInputBlock("Kills", 140)

local dragToggle = false
local dragStart
local startPos

local function updateInputPos(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInputPos(input)
        end
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInputPos(input)
        end
    end
end)

local function parseNumber(str)
    local n = tonumber(str)
    if not n then
        return nil
    end
    n = math.floor(n)
    if n < 0 then n = 0 end
    if n > 1000000 then n = 1000000 end
    return n
end

local function getLeaderstats()
    return LocalPlayer:FindFirstChild("leaderstats")
end

local function setLeaderstat(statName, value)
    local leaderstats = getLeaderstats()
    if not leaderstats then return end
    local stat = leaderstats:FindFirstChild(statName)
    if not stat then return end
    stat.Value = value
end

local lockedTotalKills
local lockedKills

local function getStat(name)
    local leaderstats = getLeaderstats()
    if not leaderstats then return nil end
    return leaderstats:FindFirstChild(name)
end

local totalKillsStat = getStat("Total Kills")
local killsStat = getStat("Kills")

if totalKillsStat then
    lockedTotalKills = totalKillsStat.Value
    totalKillsStat.Changed:Connect(function(newValue)
        if lockedTotalKills ~= nil and newValue ~= lockedTotalKills then
            totalKillsStat.Value = lockedTotalKills
        end
    end)
end

if killsStat then
    lockedKills = killsStat.Value
    killsStat.Changed:Connect(function(newValue)
        if lockedKills ~= nil and newValue ~= lockedKills then
            killsStat.Value = lockedKills
        end
    end)
end

totalKillsButton.MouseButton1Click:Connect(function()
    local n = parseNumber(totalKillsBox.Text)
    if n then
        setLeaderstat("Total Kills", n)
        lockedTotalKills = n
        totalKillsBox.Text = tostring(n)
    else
        totalKillsBox.Text = ""
        totalKillsBox.PlaceholderText = "Invalid number"
    end
end)

killsButton.MouseButton1Click:Connect(function()
    local n = parseNumber(killsBox.Text)
    if n then
        setLeaderstat("Kills", n)
        lockedKills = n
        killsBox.Text = tostring(n)
    else
        killsBox.Text = ""
        killsBox.PlaceholderText = "Invalid number"
    end
end)

ScreenGui.Enabled = true

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
