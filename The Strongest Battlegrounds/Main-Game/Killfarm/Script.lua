local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local spawnpos = nil
local antiAfkStarted = false
local antiMoveEnabled = false
local afkScreenEnabled = false
local mainButtonPressed = false
local targetPlayerName = "giveherpeasure"
local lastPosition = nil
local movementThreshold = 10
local resetCooldown = 0.1
local startingKills = 0
local currentKills = 0
local screenGuiEnabled = true

local function resetPlayer(plr)
    local char = plr.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

local function hasPlayerMovedUpward(targetPlr)
    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
        local currentPosition = targetPlr.Character.HumanoidRootPart.Position
        if lastPosition then
            local yDiff = currentPosition.Y - lastPosition.Y
            lastPosition = currentPosition
            if yDiff >= movementThreshold then
                return true
            end
        else
            lastPosition = currentPosition
        end
    end
    return false
end

local function startAntiMove()
    if antiMoveEnabled then return end
    antiMoveEnabled = true
    task.spawn(function()
        lastPosition = nil
        while antiMoveEnabled do
            task.wait(resetCooldown)
            if not targetPlayerName or targetPlayerName == "" then
                lastPosition = nil
            else
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer and targetPlayer.Character then
                    if hasPlayerMovedUpward(targetPlayer) then
                        resetPlayer(player)
                    end
                else
                    lastPosition = nil
                end
            end
        end
    end)
end

local function potatoLighting()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentSpecularScale = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 0
        Lighting.ExposureCompensation = 0
        Lighting.ShadowSoftness = 0
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(1, 1, 1)
    end)
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("BloomEffect")
        or obj:IsA("BlurEffect")
        or obj:IsA("ColorCorrectionEffect")
        or obj:IsA("SunRaysEffect")
        or obj:IsA("DepthOfFieldEffect") then
            obj.Enabled = false
        end
    end
end

local foldersToDelete = {"Built", "Map", "Ambience", "Preload", "Thrown", "Sound"}

local function deleteMapFolders()
    for _, folderName in ipairs(foldersToDelete) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            folder:Destroy()
        end
    end
end

local function potatoTerrain()
    pcall(function()
        local Terrain = Workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false
        end
    end)
end

local function potatoEffects()
    local function strip(obj)
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("Fire")
        or obj:IsA("Smoke")
        or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        strip(obj)
    end
    Workspace.DescendantAdded:Connect(strip)
end

local function startAntiAfk()
    if antiAfkStarted then return end
    antiAfkStarted = true
    task.spawn(function()
        while true do
            task.wait(600)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end
    end)
end

local function setSpawn(pos)
    spawnpos = CFrame.new(pos)
end

player.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    if spawnpos then
        task.wait(0.1)
        hrp.CFrame = spawnpos
    end
end)

local altSpawnCFrames = {
    Alt1 = Vector3.new(-36, 29, 20314),
    Alt2 = Vector3.new(-36, 29, 20316),
    Alt3 = Vector3.new(-36, 29, 20318),
    Alt4 = Vector3.new(-36, 29, 20320)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AltMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local background = Instance.new("Frame")
background.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
background.BackgroundTransparency = 0.2
background.BorderSizePixel = 0
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Size = UDim2.new(0.36, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = background

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(60, 60, 60)
uiStroke.Thickness = 1.5
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = mainFrame

local titleDragFrame = Instance.new("Frame")
titleDragFrame.Name = "TitleDrag"
titleDragFrame.BackgroundTransparency = 1
titleDragFrame.Size = UDim2.new(1, 0, 0, 70)
titleDragFrame.Position = UDim2.new(0, 0, 0, 0)
titleDragFrame.ZIndex = 10
titleDragFrame.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 20)
uiPadding.PaddingBottom = UDim.new(0, 20)
uiPadding.PaddingLeft = UDim.new(0, 20)
uiPadding.PaddingRight = UDim.new(0, 20)
uiPadding.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "×"
closeButton.Font = Enum.Font.GothamBlack
closeButton.TextSize = 22
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextXAlignment = Enum.TextXAlignment.Center
closeButton.TextYAlignment = Enum.TextYAlignment.Center
closeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
closeButton.AutoButtonColor = false
closeButton.BorderSizePixel = 0
closeButton.Size = UDim2.new(0, 34, 0, 34)
closeButton.Position = UDim2.new(1, -30, 0, 18)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.ZIndex = 11
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(70, 70, 70)
closeStroke.Thickness = 1
closeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
closeStroke.Parent = closeButton

local closeGradient = Instance.new("UIGradient")
closeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
closeGradient.Rotation = 90
closeGradient.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)

closeButton.MouseButton1Click:Connect(function()
    screenGuiEnabled = false
    screenGui.Enabled = false
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 48)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "Limpan's Kill Farm"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 44
titleLabel.TextWrapped = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 10
titleLabel.Parent = titleDragFrame

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Size = UDim2.new(1, 0, 0, 22)
subtitleLabel.Position = UDim2.new(0, 0, 0, 44)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "v3.0 downgraded ver"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitleLabel.TextSize = 16
subtitleLabel.TextWrapped = true
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
subtitleLabel.TextYAlignment = Enum.TextYAlignment.Center
subtitleLabel.ZIndex = 10
subtitleLabel.Parent = titleDragFrame

local killStatsFrame = Instance.new("Frame")
killStatsFrame.Name = "KillStats"
killStatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
killStatsFrame.BackgroundTransparency = 0.1
killStatsFrame.BorderSizePixel = 0
killStatsFrame.Size = UDim2.new(0, 220, 0, 90)
killStatsFrame.Position = UDim2.new(0, 15, 1, -105)
killStatsFrame.Visible = false
killStatsFrame.Parent = background

local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 12)
killCorner.Parent = killStatsFrame

local killStroke = Instance.new("UIStroke")
killStroke.Color = Color3.fromRGB(60, 60, 60)
killStroke.Thickness = 1.5
killStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
killStroke.Parent = killStatsFrame

local killPadding = Instance.new("UIPadding")
killPadding.PaddingTop = UDim.new(0, 12)
killPadding.PaddingBottom = UDim.new(0, 12)
killPadding.PaddingLeft = UDim.new(0, 15)
killPadding.PaddingRight = UDim.new(0, 15)
killPadding.Parent = killStatsFrame

local killListLayout = Instance.new("UIListLayout")
killListLayout.FillDirection = Enum.FillDirection.Vertical
killListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
killListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
killListLayout.Padding = UDim.new(0, 8)
killListLayout.Parent = killStatsFrame

local startingKillsLabel = Instance.new("TextLabel")
startingKillsLabel.Name = "StartingKills"
startingKillsLabel.BackgroundTransparency = 1
startingKillsLabel.Size = UDim2.new(1, 0, 0, 20)
startingKillsLabel.Font = Enum.Font.GothamSemibold
startingKillsLabel.Text = "Starting kills: --"
startingKillsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
startingKillsLabel.TextSize = 14
startingKillsLabel.TextXAlignment = Enum.TextXAlignment.Left
startingKillsLabel.TextYAlignment = Enum.TextYAlignment.Center
startingKillsLabel.Parent = killStatsFrame

local killsLabel = Instance.new("TextLabel")
killsLabel.Name = "Kills"
killsLabel.BackgroundTransparency = 1
killsLabel.Size = UDim2.new(1, 0, 0, 20)
killsLabel.Font = Enum.Font.GothamSemibold
killsLabel.Text = "Kills: --"
killsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
killsLabel.TextSize = 16
killsLabel.TextXAlignment = Enum.TextXAlignment.Left
killsLabel.TextYAlignment = Enum.TextYAlignment.Center
killsLabel.Parent = killStatsFrame

local killGainLabel = Instance.new("TextLabel")
killGainLabel.Name = "KillGain"
killGainLabel.BackgroundTransparency = 1
killGainLabel.Size = UDim2.new(1, 0, 0, 20)
killGainLabel.Font = Enum.Font.GothamBold
killGainLabel.Text = "Kill gain: --"
killGainLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
killGainLabel.TextSize = 16
killGainLabel.TextXAlignment = Enum.TextXAlignment.Left
killGainLabel.TextYAlignment = Enum.TextYAlignment.Center
killGainLabel.Parent = killStatsFrame

local function updateKillStats()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local killsStat = leaderstats:FindFirstChild("Kills")
        if killsStat then
            currentKills = killsStat.Value
            startingKillsLabel.Text = "Starting kills: " .. startingKills
            killsLabel.Text = "Kills: " .. currentKills
            killGainLabel.Text = "Kill gain: " .. (currentKills - startingKills)
        end
    end
end

local leaderstats = player:FindFirstChild("leaderstats")
if leaderstats then
    local killsStat = leaderstats:FindFirstChild("Kills")
    if killsStat then
        startingKills = killsStat.Value
    end
end

task.spawn(function()
    while true do
        updateKillStats()
        task.wait(1)
    end
end)

local function createButton(name, text, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(235, 235, 235)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 70)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)

    return btn
end

local contentHolder = Instance.new("Frame")
contentHolder.BackgroundTransparency = 1
contentHolder.Size = UDim2.new(1, 0, 0, 220)
contentHolder.Position = UDim2.new(0, 0, 0, 76)
contentHolder.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = contentHolder

local mainButton = createButton("Main", "Main", contentHolder)

local altRow = Instance.new("Frame")
altRow.BackgroundTransparency = 1
altRow.Size = UDim2.new(1, 0, 0, 38)
altRow.Parent = contentHolder

local altLayout = Instance.new("UIListLayout")
altLayout.FillDirection = Enum.FillDirection.Horizontal
altLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
altLayout.VerticalAlignment = Enum.VerticalAlignment.Center
altLayout.Padding = UDim.new(0, 6)
altLayout.Parent = altRow

local function runPotatoStuffForAlt(altName)
    potatoLighting()
    deleteMapFolders()
    potatoTerrain()
    potatoEffects()
    startAntiAfk()
    startAntiMove()
    local pos = altSpawnCFrames[altName]
    if pos then
        setSpawn(pos)
        resetPlayer(player)
    end
end

local afkGui = Instance.new("ScreenGui")
afkGui.Name = "AFKScreen"
afkGui.ResetOnSpawn = false
afkGui.IgnoreGuiInset = true
afkGui.Parent = playerGui
afkGui.Enabled = false

local afkBackground = Instance.new("Frame")
afkBackground.Name = "AFKBackground"
afkBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
afkBackground.BackgroundTransparency = 0
afkBackground.BorderSizePixel = 0
afkBackground.Size = UDim2.new(1, 0, 1, 0)
afkBackground.Position = UDim2.new(0, 0, 0, 0)
afkBackground.ZIndex = 100
afkBackground.Parent = afkGui

local afkText = Instance.new("TextLabel")
afkText.Name = "AFKText"
afkText.BackgroundTransparency = 1
afkText.Size = UDim2.new(1, 0, 1, 0)
afkText.Position = UDim2.new(0, 0, 0, 0)
afkText.Font = Enum.Font.GothamBlack
afkText.Text = "AFK ENABLED"
afkText.TextColor3 = Color3.fromRGB(255, 255, 255)
afkText.TextSize = 72
afkText.TextWrapped = true
afkText.TextXAlignment = Enum.TextXAlignment.Center
afkText.TextYAlignment = Enum.TextYAlignment.Center
afkText.ZIndex = 101
afkText.Parent = afkGui

local function createAltButton(name, text, parent)
    local btn = createButton(name, text, parent)
    btn.Size = UDim2.new(0.23, 0, 1, 0)
    btn.MouseButton1Click:Connect(function()
        runPotatoStuffForAlt(name)
        screenGui.Enabled = false
        afkScreenEnabled = true
        afkGui.Enabled = true
    end)
    return btn
end

createAltButton("Alt1", "Alt 1", altRow)
createAltButton("Alt2", "Alt 2", altRow)
createAltButton("Alt3", "Alt 3", altRow)
createAltButton("Alt4", "Alt 4", altRow)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        if not mainButtonPressed then
            afkScreenEnabled = true
            afkGui.Enabled = true
            screenGui.Enabled = false
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Escape and afkScreenEnabled then
        afkScreenEnabled = false
        afkGui.Enabled = false
    end
end)

local creditsHolder = Instance.new("Frame")
creditsHolder.BackgroundTransparency = 1
creditsHolder.Size = UDim2.new(1, 0, 0, 90)
creditsHolder.Position = UDim2.new(0, 0, 1, 0)
creditsHolder.AnchorPoint = Vector2.new(0, 1)
creditsHolder.Parent = mainFrame

local creditsLayout = Instance.new("UIListLayout")
creditsLayout.FillDirection = Enum.FillDirection.Vertical
creditsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
creditsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
creditsLayout.Padding = UDim.new(0, 6)
creditsLayout.Parent = creditsHolder

local function createCopyRow(labelText, valueText)
    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 26)
    row.Parent = creditsHolder

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rowLayout.Padding = UDim.new(0, 6)
    rowLayout.Parent = row

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.2, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(170, 170, 170)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = row

    local box = Instance.new("TextBox")
    box.Text = valueText
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.Size = UDim2.new(0.47, 0, 1, 0)
    box.ClearTextOnFocus = false
    box.TextEditable = false
    box.Parent = row

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(70, 70, 70)
    boxStroke.Thickness = 1
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    boxStroke.Parent = box

    local copyBtn = Instance.new("TextButton")
    copyBtn.Name = "Copy_" .. labelText:gsub("%s+", "")
    copyBtn.Text = "Copy"
    copyBtn.Font = Enum.Font.GothamSemibold
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
    copyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    copyBtn.AutoButtonColor = true
    copyBtn.BorderSizePixel = 0
    copyBtn.Size = UDim2.new(0.18, 0, 1, 0)
    copyBtn.Parent = row

    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 8)
    copyCorner.Parent = copyBtn

    local copyStroke = Instance.new("UIStroke")
    copyStroke.Color = Color3.fromRGB(90, 90, 90)
    copyStroke.Thickness = 1
    copyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    copyStroke.Parent = copyBtn

    copyBtn.MouseEnter:Connect(function()
        copyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end)

    copyBtn.MouseLeave:Connect(function()
        copyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)

    copyBtn.MouseButton1Click:Connect(function()
        local text = box.Text or valueText
        if setclipboard then
            setclipboard(text)
        else
            box:CaptureFocus()
            box.CursorPosition = #box.Text + 1
            box.SelectionStart = 1
        end
    end)
end

createCopyRow("Discord", "Limpan002s")
createCopyRow("About me", "guns.lol/Limpan")

local autoExecEnabled = false
local autoExecThread

local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleDragFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        updateInput(input)
    end
end)

mainButton.MouseButton1Click:Connect(function()
    mainButtonPressed = true
    autoExecEnabled = not autoExecEnabled
    if autoExecEnabled then
        killStatsFrame.Parent = screenGui
        killStatsFrame.Visible = true
        background.Visible = false
        autoExecThread = task.spawn(function()
            while autoExecEnabled do
                local p,vi = game:GetService("Players"),game:GetService("VirtualInputManager")
                local plr = p.LocalPlayer
                if plr then
                    local hrp = (plr.Character or plr.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
                    hrp.CFrame = CFrame.new(-41,49,20315) * CFrame.Angles(0,math.rad(270),0)
                    task.wait(.3)
                    hrp.CFrame = CFrame.new(-41,29,20315) * CFrame.Angles(0,math.rad(270),0)
                    task.wait(1/5)
                    vi:SendKeyEvent(true,Enum.KeyCode.Three,false,game)
                    task.wait(.1)
                    vi:SendKeyEvent(false,Enum.KeyCode.Three,false,game)
                end
                task.wait(10)
            end
        end)
    else
        killStatsFrame.Visible = false
        autoExecThread = nil
    end
end)
