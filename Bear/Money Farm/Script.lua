local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

game.ReplicatedStorage._Remotes["RE/AFK_Toggle"]:FireServer(true)

local player = Players.LocalPlayer
if not player then
    repeat task.wait() player = Players.LocalPlayer until player
end

local targetPos = Vector3.new(407, 28, -28)
local tweenHeight = 10
local tweenTime = 0.1

local function startTween(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
    local upCFrame = CFrame.new(targetPos + Vector3.new(0, tweenHeight, 0))
    local tweenInfo = TweenInfo.new(
        tweenTime,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    )
    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = upCFrame })
    tween:Play()
end

player.CharacterAdded:Connect(startTween)
if player.Character then
    startTween(player.Character)
end

local playerGui = player:WaitForChild("PlayerGui")
local gameUI = playerGui:WaitForChild("GameUI")
local leftHandButtons = gameUI:WaitForChild("LeftHandButtons")
local moneyDisplay = leftHandButtons:WaitForChild("MoneyDisplay")
local label = moneyDisplay:WaitForChild("Label")

local function getMoney()
    local text = tostring(label.Text or label.Value or "0")
    text = text:gsub("[^0-9%-%.]", "")
    return tonumber(text) or 0
end

local startingMoney = getMoney()

local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "MoneyTrackerNotification"
notificationGui.ResetOnSpawn = false
notificationGui.IgnoreGuiInset = true
notificationGui.Parent = playerGui

local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 300, 0, 80)
notificationFrame.Position = UDim2.new(1, -320, 1, -100)
notificationFrame.BackgroundColor3 = Color3.new(0, 0, 0)
notificationFrame.BackgroundTransparency = 0.2
notificationFrame.BorderSizePixel = 0
notificationFrame.Parent = notificationGui

local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 8)
notificationCorner.Parent = notificationFrame

local notificationText = Instance.new("TextLabel")
notificationText.Size = UDim2.new(1, -20, 1, 0)
notificationText.Position = UDim2.new(0, 10, 0, 0)
notificationText.BackgroundTransparency = 1
notificationText.Text = "Money Tracker Active!\n(R) Toggle GUI | (Right Shift) Exit"
notificationText.TextColor3 = Color3.new(0, 1, 0)
notificationText.TextScaled = true
notificationText.Font = Enum.Font.SourceSansBold
notificationText.TextWrapped = true
notificationText.Parent = notificationFrame

notificationFrame:TweenPosition(UDim2.new(1, -320, 1, -100), "Out", "Quad", 0.5, true)
task.wait(4)
notificationFrame:TweenPosition(UDim2.new(1, 0, 1, -100), "Out", "Quad", 0.5, true)
task.wait(0.5)
notificationGui:Destroy()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyTrackerOverlay"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local overlay = Instance.new("Frame")
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 0
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.BorderSizePixel = 0
overlay.Parent = screenGui
overlay.Visible = false

local madeBy = Instance.new("TextLabel")
madeBy.Size = UDim2.new(0.6, 0, 0.08, 0)
madeBy.Position = UDim2.new(0.2, 0, 0.02, 0)
madeBy.BackgroundTransparency = 1
madeBy.Text = "Made by Limpan"
madeBy.TextColor3 = Color3.new(1, 1, 1)
madeBy.TextScaled = true
madeBy.Font = Enum.Font.SourceSansBold
madeBy.Parent = overlay

local function makeLabel(text, yScale, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 0.08, 0)
    lbl.Position = UDim2.new(0.15, 0, yScale, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.new(1, 1, 1)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = text
    lbl.Parent = overlay
    return lbl
end

local startText = makeLabel("Starting money: " .. startingMoney, 0.12, Color3.new(1, 1, 1))
local currentText = makeLabel("Money now: " .. startingMoney, 0.22, Color3.new(1, 1, 1))
local timerText = makeLabel("Time active: 0s", 0.32, Color3.new(1, 1, 1))

local profitFrame = Instance.new("Frame")
profitFrame.Size = UDim2.new(0.8, 0, 0.45, 0)
profitFrame.Position = UDim2.new(0.1, 0, 0.42, 0)
profitFrame.BackgroundColor3 = Color3.new(0, 0, 0)
profitFrame.BackgroundTransparency = 0.3
profitFrame.BorderSizePixel = 0
profitFrame.Parent = overlay

local profitCorner = Instance.new("UICorner")
profitCorner.CornerRadius = UDim.new(0, 12)
profitCorner.Parent = profitFrame

local profitTitle = Instance.new("TextLabel")
profitTitle.Size = UDim2.new(1, 0, 0.2, 0)
profitTitle.Position = UDim2.new(0, 0, 0, 0)
profitTitle.BackgroundTransparency = 1
profitTitle.Text = "PROFITS"
profitTitle.TextColor3 = Color3.new(0, 1, 0)
profitTitle.TextScaled = true
profitTitle.Font = Enum.Font.SourceSansBold
profitTitle.Parent = profitFrame

local ppsText = makeLabel("Profit/sec: 0", 0.52, Color3.new(0, 1, 0))
local ppmText = makeLabel("Profit/min: 0", 0.62, Color3.new(0, 1, 0))
local pphText = makeLabel("Profit/hour: 0", 0.72, Color3.new(0, 1, 0))
local profitText = makeLabel("Profit: 0", 0.82, Color3.new(0, 1, 0))

local guiVisible = false

local scriptStartTime = tick()
local hbConn
hbConn = RunService.Heartbeat:Connect(function()
    if not label or not label.Parent then return end
    local currentMoney = getMoney()
    local elapsedSeconds = tick() - scriptStartTime
    local profit = currentMoney - startingMoney
    local profitPerSec = elapsedSeconds > 0 and (profit / elapsedSeconds) or 0
    local profitPerMin = profitPerSec * 60
    local profitPerHour = profitPerSec * 3600
    
    currentText.Text = "Money now: " .. currentMoney
    timerText.Text = "Time active: " .. math.floor(elapsedSeconds) .. "s"
    ppsText.Text = "Profit/sec: " .. math.floor(profitPerSec * 10) / 10
    ppmText.Text = "Profit/min: " .. math.floor(profitPerMin * 10) / 10
    pphText.Text = "Profit/hour: " .. math.floor(profitPerHour)
    profitText.Text = "Profit: " .. profit
    
    local isPositive = profit >= 0
    profitText.TextColor3 = isPositive and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    ppsText.TextColor3 = isPositive and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    ppmText.TextColor3 = isPositive and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    pphText.TextColor3 = isPositive and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    profitTitle.TextColor3 = isPositive and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        guiVisible = not guiVisible
        overlay.Visible = guiVisible
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        if hbConn then hbConn:Disconnect() end
        screenGui:Destroy()
    end
end)
