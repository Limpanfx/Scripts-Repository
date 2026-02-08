local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LeaderstatsEditorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 280)
Frame.Position = UDim2.new(0.5, -160, 0.5, -140)
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
Subtitle.Text = "Streak, Solo Rank, Duo Rank"
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

local streakBox, streakButton = createInputBlock("Streak", 70)
local soloRankBox, soloRankButton = createInputBlock("Solo Rank", 140)
local duoRankBox, duoRankButton = createInputBlock("Duo Rank", 210)

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

local lockedStreak
local lockedSoloRank
local lockedDuoRank

local function getStat(name)
    local leaderstats = getLeaderstats()
    if not leaderstats then return nil end
    return leaderstats:FindFirstChild(name)
end

local streakStat = getStat("Streak")
local soloRankStat = getStat("Solo Rank")
local duoRankStat = getStat("Duo Rank")

if streakStat then
    lockedStreak = streakStat.Value
    streakStat.Changed:Connect(function(newValue)
        if lockedStreak ~= nil and newValue ~= lockedStreak then
            streakStat.Value = lockedStreak
        end
    end)
end

if soloRankStat then
    lockedSoloRank = soloRankStat.Value
    soloRankStat.Changed:Connect(function(newValue)
        if lockedSoloRank ~= nil and newValue ~= lockedSoloRank then
            soloRankStat.Value = lockedSoloRank
        end
    end)
end

if duoRankStat then
    lockedDuoRank = duoRankStat.Value
    duoRankStat.Changed:Connect(function(newValue)
        if lockedDuoRank ~= nil and newValue ~= lockedDuoRank then
            duoRankStat.Value = lockedDuoRank
        end
    end)
end

streakButton.MouseButton1Click:Connect(function()
    local n = parseNumber(streakBox.Text)
    if n then
        setLeaderstat("Streak", n)
        lockedStreak = n
        streakBox.Text = tostring(n)
    else
        streakBox.Text = ""
        streakBox.PlaceholderText = "Invalid number"
    end
end)

soloRankButton.MouseButton1Click:Connect(function()
    local n = parseNumber(soloRankBox.Text)
    if n then
        setLeaderstat("Solo Rank", n)
        lockedSoloRank = n
        soloRankBox.Text = tostring(n)
    else
        soloRankBox.Text = ""
        soloRankBox.PlaceholderText = "Invalid number"
    end
end)

duoRankButton.MouseButton1Click:Connect(function()
    local n = parseNumber(duoRankBox.Text)
    if n then
        setLeaderstat("Duo Rank", n)
        lockedDuoRank = n
        duoRankBox.Text = tostring(n)
    else
        duoRankBox.Text = ""
        duoRankBox.PlaceholderText = "Invalid number"
    end
end)

ScreenGui.Enabled = true

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
