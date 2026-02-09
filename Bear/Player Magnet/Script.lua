local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LimpanUtilityUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 340, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

local topBarFix = Instance.new("Frame")
topBarFix.Position = UDim2.new(0, 0, 1, -12)
topBarFix.Size = UDim2.new(1, 0, 0, 12)
topBarFix.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
topBarFix.BorderSizePixel = 0
topBarFix.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Player Magnet"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 40, 0, 18)
versionLabel.Position = UDim2.new(0, 160, 0.5, -9)
versionLabel.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
versionLabel.Font = Enum.Font.GothamBold
versionLabel.Text = "v2.0"
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.TextSize = 11
versionLabel.Parent = topBar

local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(0, 4)
versionCorner.Parent = versionLabel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -44, 0.5, -18)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(185, 187, 190)
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(237, 66, 69)})
    tween(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)})
end)

closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(47, 49, 54)})
    tween(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(185, 187, 190)})
end)

local uiHardClosed = false

closeBtn.MouseButton1Click:Connect(function()
    uiHardClosed = true
    tween(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    wait(0.2)
    screenGui:Destroy()
end)

local contentFrame = Instance.new("Frame")
contentFrame.Position = UDim2.new(0, 0, 0, 48)
contentFrame.Size = UDim2.new(1, 0, 1, -48)
contentFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local contentFix = Instance.new("Frame")
contentFix.Position = UDim2.new(0, 0, 0, 0)
contentFix.Size = UDim2.new(1, 0, 0, 12)
contentFix.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
contentFix.BorderSizePixel = 0
contentFix.Parent = contentFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -32, 0, 40)
infoLabel.Position = UDim2.new(0, 16, 0, 16)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.Text = "Continuously bring all players to your location.\nNo collision enabled when active."
infoLabel.TextColor3 = Color3.fromRGB(142, 146, 151)
infoLabel.TextSize = 13
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.Parent = contentFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -32, 0, 24)
statusLabel.Position = UDim2.new(0, 16, 0, 64)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "Status: INACTIVE"
statusLabel.TextColor3 = Color3.fromRGB(185, 187, 190)
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

local magnetBtn = Instance.new("TextButton")
magnetBtn.Size = UDim2.new(1, -32, 0, 44)
magnetBtn.Position = UDim2.new(0, 16, 1, -60)
magnetBtn.Text = "ACTIVATE"
magnetBtn.Font = Enum.Font.GothamBold
magnetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
magnetBtn.TextSize = 15
magnetBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
magnetBtn.BorderSizePixel = 0
magnetBtn.AutoButtonColor = false
magnetBtn.Parent = contentFrame

local magnetBtnCorner = Instance.new("UICorner")
magnetBtnCorner.CornerRadius = UDim.new(0, 8)
magnetBtnCorner.Parent = magnetBtn

magnetBtn.MouseEnter:Connect(function()
    tween(magnetBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(71, 82, 196)
    })
end)

magnetBtn.MouseLeave:Connect(function()
    local isActive = magnetBtn.Text == "DEACTIVATE"
    tween(magnetBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundColor3 = isActive and Color3.fromRGB(237, 66, 69) or Color3.fromRGB(88, 101, 242)
    })
end)

local magnetEnabled = false
local magnetConn

local function setCollision(player, enabled)
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = enabled
            end
        end
    end
end

local function bringPlayers()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local myPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = myPosition
            if magnetEnabled then
                setCollision(player, false)
            end
        end
    end
end

local function restoreAllCollisions()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            setCollision(player, true)
        end
    end
end

magnetBtn.MouseButton1Click:Connect(function()
    magnetEnabled = not magnetEnabled
    
    if magnetEnabled then
        magnetBtn.Text = "DEACTIVATE"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        statusLabel.Text = "Status: ACTIVE ✓"
        statusLabel.TextColor3 = Color3.fromRGB(87, 242, 135)
        
        bringPlayers()
        
        magnetConn = RunService.Heartbeat:Connect(function()
            bringPlayers()
        end)
        
        spawn(function()
            while magnetEnabled do
                for i = 1, 10 do
                    if not magnetEnabled then break end
                    magnetBtn.BackgroundColor3 = Color3.fromRGB(237 + i*1, 66 + i*2, 69 + i*3)
                    wait(0.05)
                end
                for i = 1, 10 do
                    if not magnetEnabled then break end
                    magnetBtn.BackgroundColor3 = Color3.fromRGB(247 - i*1, 86 - i*2, 99 - i*3)
                    wait(0.05)
                end
            end
        end)
    else
        magnetBtn.Text = "ACTIVATE"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        statusLabel.Text = "Status: INACTIVE"
        statusLabel.TextColor3 = Color3.fromRGB(185, 187, 190)
        
        if magnetConn then
            magnetConn:Disconnect()
            magnetConn = nil
        end
        restoreAllCollisions()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if magnetEnabled then
            wait(0.1)
            setCollision(player, false)
        end
    end)
end)

local currentToggleKey = Enum.KeyCode.RightControl

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if uiHardClosed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentToggleKey then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

makeDraggable(mainFrame, topBar)
