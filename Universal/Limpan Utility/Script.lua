local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")


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


local function styleButton(btn)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(235, 235, 235)
    btn.TextSize = 13
    btn.TextWrapped = true
    btn.ClipsDescendants = true


    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn


    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn


    local hover = false
    btn.MouseEnter:Connect(function()
        hover = true
        tween(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        })
    end)
    btn.MouseLeave:Connect(function()
        hover = false
        tween(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset, 0, 30)
        })
    end)


    btn.MouseButton1Click:Connect(function()
        if not hover then return end
        tween(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
            Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset, 0, 26)
        })
    end)
end


local function createButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = text
    btn.Parent = parent
    styleButton(btn)
    return btn
end


local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 460, 0, 320)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui


local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame


local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 1
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame


local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame


local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar


local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Limpan Utilities"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextWrapped = true
title.ClipsDescendants = true
title.Parent = topBar


local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -80, 1, 0)
subtitle.Position = UDim2.new(0, 10, 0, 0)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Player • World • Tools • Utility • Settings • Credits"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 120)
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Right
subtitle.TextWrapped = true
subtitle.ClipsDescendants = true
subtitle.Parent = topBar


local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 24)
closeBtn.Position = UDim2.new(1, -36, 0.5, -12)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar
styleButton(closeBtn)


local uiHardClosed = false


closeBtn.MouseButton1Click:Connect(function()
    uiHardClosed = true
    screenGui:Destroy()
end)


local contentFrame = Instance.new("Frame")
contentFrame.Position = UDim2.new(0, 0, 0, 32)
contentFrame.Size = UDim2.new(1, 0, 1, -32)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame


local leftTabs = Instance.new("Frame")
leftTabs.Position = UDim2.new(0, 10, 0, 10)
leftTabs.Size = UDim2.new(0, 110, 1, -20)
leftTabs.BackgroundTransparency = 1
leftTabs.Parent = contentFrame


local leftList = Instance.new("UIListLayout")
leftList.Padding = UDim.new(0, 6)
leftList.FillDirection = Enum.FillDirection.Vertical
leftList.SortOrder = Enum.SortOrder.LayoutOrder
leftList.Parent = leftTabs


local rightPanel = Instance.new("Frame")
rightPanel.Position = UDim2.new(0, 130, 0, 10)
rightPanel.Size = UDim2.new(1, -140, 1, -20)
rightPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = contentFrame


local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightPanel


local rightStroke = Instance.new("UIStroke")
rightStroke.Color = Color3.fromRGB(50, 50, 50)
rightStroke.Thickness = 1
rightStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
rightStroke.Parent = rightPanel


local tabs = {}
local pages = {}


local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 28)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    tabBtn.TextSize = 13
    tabBtn.AutoButtonColor = false
    tabBtn.TextWrapped = true
    tabBtn.ClipsDescendants = true
    tabBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    tabBtn.BorderSizePixel = 0


    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn


    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 55)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = tabBtn


    tabBtn.Parent = leftTabs
    return tabBtn
end


local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = rightPanel


    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.FillDirection = Enum.FillDirection.Vertical
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    list.VerticalAlignment = Enum.VerticalAlignment.Top
    list.Parent = page


    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 6)
    end)


    return page
end


local function selectTab(key)
    for k, btn in pairs(tabs) do
        local active = (k == key)
        btn.TextColor3 = active and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(160, 160, 160)
        btn.BackgroundColor3 = active and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(10, 10, 10)
    end
    for k, pg in pairs(pages) do
        pg.Visible = (k == key)
    end
end


tabs["Player"]   = createTab("Player")
tabs["World"]    = createTab("World")
tabs["Tools"]    = createTab("Tools")
tabs["Utility"]  = createTab("Utility")
tabs["Settings"] = createTab("Settings")
tabs["Credits"]  = createTab("Credits")


pages["Player"]   = createPage()
pages["World"]    = createPage()
pages["Tools"]    = createPage()
pages["Utility"]  = createPage()
pages["Settings"] = createPage()
pages["Credits"]  = createPage()


for key, btn in pairs(tabs) do
    btn.MouseButton1Click:Connect(function()
        selectTab(key)
    end)
end


selectTab("Player")


local function createSectionHeader(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ClipsDescendants = true
    lbl.Parent = parent
    return lbl
end


local function createSubtext(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ClipsDescendants = true
    lbl.Parent = parent
    return lbl
end


local function createCopyRow(parent, labelText, initial)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent


    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(190, 190, 190)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ClipsDescendants = true
    lbl.Parent = row


    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.4, -6, 1, 0)
    box.Position = UDim2.new(0.4, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.Code
    box.Text = initial or ""
    box.TextColor3 = Color3.fromRGB(210, 210, 210)
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.TextEditable = false
    box.TextWrapped = false
    box.ClipsDescendants = true
    box.Parent = row


    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box


    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(55, 55, 55)
    boxStroke.Thickness = 1
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    boxStroke.Parent = box


    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.2, 0, 1, 0)
    copyBtn.Position = UDim2.new(0.8, 0, 0, 0)
    copyBtn.Text = "Copy"
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = row
    styleButton(copyBtn)


    copyBtn.MouseButton1Click:Connect(function()
        local text = box.Text or ""
        if text ~= "" and setclipboard then
            setclipboard(text)
        end
    end)


    return box
end


createSectionHeader(pages["Player"], "Movement")


local noclipEnabled = false
local noclipConn


local noclipBtn = createButton(pages["Player"], "Toggle noclip (OFF)")
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = noclipEnabled and "Toggle noclip (ON)" or "Toggle noclip (OFF)"
    if noclipEnabled then
        if not noclipConn then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end)


local infJumpEnabled = false
local infJumpConn

local infJumpBtn = createButton(pages["Player"], "Toggle Infinite Jump (OFF)")
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = infJumpEnabled and "Toggle Infinite Jump (ON)" or "Toggle Infinite Jump (OFF)"
    if infJumpEnabled then
        if not infJumpConn then
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    else
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
    end
end)


createSectionHeader(pages["Player"], "Stats")


local function createSlider(rowParent, labelText, minVal, maxVal, defaultVal, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundTransparency = 1
    row.Parent = rowParent


    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.35, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(190, 190, 190)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ClipsDescendants = true
    lbl.Parent = row


    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.55, 0, 0, 6)
    bar.Position = UDim2.new(0.35, 0, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bar.BorderSizePixel = 0
    bar.Parent = row


    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = bar


    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(55, 55, 55)
    barStroke.Thickness = 1
    barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    barStroke.Parent = bar


    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    fill.BorderSizePixel = 0
    fill.Parent = bar


    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill


    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 12, 0, 14)
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.new(0, 0, 0.5, 0)
    handle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    handle.BorderSizePixel = 0
    handle.Parent = bar


    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle


    local handleStroke = Instance.new("UIStroke")
    handleStroke.Color = Color3.fromRGB(40, 40, 40)
    handleStroke.Thickness = 1
    handleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    handleStroke.Parent = handle


    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.1, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.9, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row


    local dragging = false


    local function setAlpha(alpha)
        alpha = math.clamp(alpha, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * alpha + 0.5)
        valueLabel.Text = tostring(value)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        handle.Position = UDim2.new(alpha, 0, 0.5, 0)
        onChange(value)
    end


    local function alphaFromMouse()
        local mousePos = UserInputService:GetMouseLocation().X
        local absPos = bar.AbsolutePosition.X
        local absSize = bar.AbsoluteSize.X
        return (mousePos - absPos) / absSize
    end


    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setAlpha(alphaFromMouse())
        end
    end)


    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)


    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setAlpha(alphaFromMouse())
        end
    end)


    local defaultAlpha = (defaultVal - minVal) / (maxVal - minVal)
    setAlpha(defaultAlpha)


    return {
        setAlpha = setAlpha,
        bar = bar
    }
end


createSlider(
    pages["Player"],
    "WalkSpeed",
    16,
    60,
    16,
    function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
        end
    end
)


createSlider(
    pages["Player"],
    "JumpPower",
    50,
    150,
    50,
    function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = v
        end
    end
)


createSectionHeader(pages["Player"], "Flight")


local flySpeed = 80


createSlider(
    pages["Player"],
    "Fly Speed",
    30,
    250,
    flySpeed,
    function(v)
        flySpeed = v
    end
)


local flying = false
local flyConn
local bodyGyro, bodyVel


local flyBtn = createButton(pages["Player"], "Toggle Fly (OFF)")
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "Toggle Fly (ON)" or "Toggle Fly (OFF)"


    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end


    local char = LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")


    if flying then
        if not hrp or not hum then return end


        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp


        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new()
        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Parent = hrp


        hum.PlatformStand = true


        if not flyConn then
            flyConn = RunService.RenderStepped:Connect(function()
                if flying and hrp and bodyGyro and bodyVel then
                    local cam = Workspace.CurrentCamera
                    local moveDir = Vector3.new()


                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir += cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir -= cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir -= cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir += cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDir += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDir -= Vector3.new(0, 1, 0)
                    end


                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit
                    end


                    bodyVel.Velocity = moveDir * flySpeed
                    bodyGyro.CFrame = cam.CFrame
                end
            end)
        end
    else
        if flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if hum then
            hum.PlatformStand = false
        end
    end
end)


createSectionHeader(pages["World"], "Visual")


local espEnabled = false
local espConnections = {}


local function clearESP()
    for _, conn in pairs(espConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    espConnections = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") and part:FindFirstChild("LimpanESP") then
                    part.LimpanESP:Destroy()
                end
                if part:IsA("Head") and part:FindFirstChild("LimpanESPNametag") then
                    part.LimpanESPNametag:Destroy()
                end
            end
        end
    end
end


local function createNameTag(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    if not head then return end


    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LimpanESPNametag"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = head


    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = plr.Name
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextScaled = true
    label.Parent = billboard
end


local function applyESP()
    clearESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Name = "LimpanESP"
                    adorn.Adornee = part
                    adorn.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
                    adorn.Color3 = Color3.fromRGB(0, 255, 0)
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 10
                    adorn.Transparency = 0.3
                    adorn.Parent = part
                end
            end
            createNameTag(plr)
            local conn = plr.CharacterAdded:Connect(function(newChar)
                task.wait(0.5)
                if not espEnabled then return end
                for _, part in ipairs(newChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local adorn = Instance.new("BoxHandleAdornment")
                        adorn.Name = "LimpanESP"
                        adorn.Adornee = part
                        adorn.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
                        adorn.Color3 = Color3.fromRGB(0, 255, 0)
                        adorn.AlwaysOnTop = true
                        adorn.ZIndex = 10
                        adorn.Transparency = 0.3
                        adorn.Parent = part
                    end
                end
                createNameTag(plr)
            end)
            espConnections[plr] = conn
        end
    end


    local connPlayers = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled then return end
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if not espEnabled then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Name = "LimpanESP"
                    adorn.Adornee = part
                    adorn.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
                    adorn.Color3 = Color3.fromRGB(0, 255, 0)
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 10
                    adorn.Transparency = 0.3
                    adorn.Parent = part
                end
            end
            createNameTag(plr)
        end)
    end)
    espConnections["_Players"] = connPlayers
end


local espBtn = createButton(pages["World"], "Toggle player ESP (OFF)")
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "Toggle player ESP (ON)" or "Toggle player ESP (OFF)"
    if espEnabled then
        applyESP()
    else
        clearESP()
    end
end)


local fullbrightEnabled = false
local savedLighting = {}


local function applyFullbright()
    savedLighting.Brightness = Lighting.Brightness
    savedLighting.ClockTime = Lighting.ClockTime
    savedLighting.FogEnd = Lighting.FogEnd
    savedLighting.Ambient = Lighting.Ambient
    savedLighting.OutdoorAmbient = Lighting.OutdoorAmbient


    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1e5
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end


local function restoreLighting()
    if next(savedLighting) == nil then return end
    Lighting.Brightness = savedLighting.Brightness
    Lighting.ClockTime = savedLighting.ClockTime
    Lighting.FogEnd = savedLighting.FogEnd
    Lighting.Ambient = savedLighting.Ambient
    Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
end


local fullbrightBtn = createButton(pages["World"], "Toggle Fullbright (OFF)")
fullbrightBtn.MouseButton1Click:Connect(function()
    fullbrightEnabled = not fullbrightEnabled
    fullbrightBtn.Text = fullbrightEnabled and "Toggle Fullbright (ON)" or "Toggle Fullbright (OFF)"
    if fullbrightEnabled then
        applyFullbright()
    else
        restoreLighting()
    end
end)


local xrayEnabled = false
local xrayParts = {}

local function applyXRay()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Parent:FindFirstChildOfClass("Humanoid") then
            if obj.Transparency < 1 then
                xrayParts[obj] = obj.Transparency
                obj.Transparency = 0.7
            end
        end
    end
end

local function removeXRay()
    for obj, originalTransparency in pairs(xrayParts) do
        if obj and obj.Parent then
            obj.Transparency = originalTransparency
        end
    end
    xrayParts = {}
end

local xrayBtn = createButton(pages["World"], "Toggle X-Ray (OFF)")
xrayBtn.MouseButton1Click:Connect(function()
    xrayEnabled = not xrayEnabled
    xrayBtn.Text = xrayEnabled and "Toggle X-Ray (ON)" or "Toggle X-Ray (OFF)"
    if xrayEnabled then
        applyXRay()
    else
        removeXRay()
    end
end)


createSectionHeader(pages["World"], "Time")

createSlider(
    pages["World"],
    "Time of Day",
    0,
    24,
    Lighting.ClockTime,
    function(v)
        Lighting.ClockTime = v
    end
)


createSectionHeader(pages["Tools"], "Teleportation")


local function giveTPTool()
    local player = LocalPlayer
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "TP Tool"
    tool.Parent = player.Backpack


    local mouse
    tool.Equipped:Connect(function()
        mouse = player:GetMouse()
    end)


    tool.Activated:Connect(function()
        if not mouse then return end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = player.Character.HumanoidRootPart
        local hit = mouse.Hit
        if hit then
            local pos = hit.Position + Vector3.new(0, 3, 0)
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end


local tpBtn = createButton(pages["Tools"], "Give TP Tool (click to teleport)")
tpBtn.MouseButton1Click:Connect(function()
    giveTPTool()
end)


createSectionHeader(pages["Tools"], "Building Tools")


local function giveDeleteBTool()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Delete"
    tool.Parent = LocalPlayer.Backpack


    local mouse
    tool.Equipped:Connect(function()
        mouse = LocalPlayer:GetMouse()
    end)


    tool.Activated:Connect(function()
        if not mouse or not mouse.Target then return end
        pcall(function()
            mouse.Target:Destroy()
        end)
    end)
end


local delBtn = createButton(pages["Tools"], "Give BTools: Delete")
delBtn.MouseButton1Click:Connect(function()
    giveDeleteBTool()
end)


createSectionHeader(pages["Utility"], "Game Info")
createSubtext(pages["Utility"], "Copy PlaceId, JobId, and live CFrame.")


local placeBox  = createCopyRow(pages["Utility"], "PlaceId", tostring(game.PlaceId))
local jobBox    = createCopyRow(pages["Utility"], "JobId", tostring(game.JobId))
local cframeBox = createCopyRow(pages["Utility"], "CFrame", "Updating...")


RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        cframeBox.Text = string.format("CFrame.new(%.2f, %.2f, %.2f)", cf.X, cf.Y, cf.Z)
    else
        cframeBox.Text = "N/A"
    end
end)


createSectionHeader(pages["Utility"], "Server")


local rejoinBtn = createButton(pages["Utility"], "Rejoin current server")
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)


local hopBtn = createButton(pages["Utility"], "Server hop (new server)")
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)


local copyAllBtn = createButton(pages["Utility"], "Copy PlaceId | JobId | CFrame")
copyAllBtn.MouseButton1Click:Connect(function()
    if not setclipboard then return end
    local char = LocalPlayer.Character
    local cfs = "N/A"
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        cfs = string.format("CFrame.new(%.2f, %.2f, %.2f)", cf.X, cf.Y, cf.Z)
    end
    local text = "PlaceId: " .. tostring(game.PlaceId) ..
        " | JobId: " .. tostring(game.JobId) ..
        " | CFrame: " .. cfs
    setclipboard(text)
end)


createSectionHeader(pages["Settings"], "UI Settings")
createSubtext(pages["Settings"], "Toggle the menu with a keybind.")


local keyRow = Instance.new("Frame")
keyRow.Size = UDim2.new(1, 0, 0, 32)
keyRow.BackgroundTransparency = 1
keyRow.Parent = pages["Settings"]


local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.5, 0, 1, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Font = Enum.Font.Gotham
keyLabel.Text = "Toggle key"
keyLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
keyLabel.TextSize = 13
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = keyRow


local keyButton = Instance.new("TextButton")
keyButton.Size = UDim2.new(0.5, -10, 1, 0)
keyButton.Position = UDim2.new(0.5, 10, 0, 0)
keyButton.Text = "RightControl"
keyButton.AutoButtonColor = false
keyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyButton.BorderSizePixel = 0
keyButton.Font = Enum.Font.Gotham
keyButton.TextColor3 = Color3.fromRGB(230, 230, 230)
keyButton.TextSize = 13
keyButton.Parent = keyRow
styleButton(keyButton)


local currentToggleKey = Enum.KeyCode.RightControl
local waitingForKey = false


keyButton.MouseButton1Click:Connect(function()
    if waitingForKey then return end
    waitingForKey = true
    keyButton.Text = "Press a key..."
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentToggleKey = input.KeyCode
            keyButton.Text = tostring(currentToggleKey):gsub("Enum.KeyCode.", "")
            waitingForKey = false
            conn:Disconnect()
        end
    end)
end)


UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if uiHardClosed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentToggleKey then
        screenGui.Enabled = not screenGui.Enabled
    end
end)


createSectionHeader(pages["World"], "Freecam (Keybind: P)")


local freecamEnabled = false
local freecamConn
local savedCamType
local savedCamSubject
local savedHRPCFrame
local savedHRPAnchored
local savedHumPlatformStand


local function enableFreecam()
    if freecamEnabled then return end
    freecamEnabled = true


    local cam = Workspace.CurrentCamera
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")


    if hrp and hum then
        savedHRPCFrame = hrp.CFrame
        savedHRPAnchored = hrp.Anchored
        savedHumPlatformStand = hum.PlatformStand
        hrp.Anchored = true
        hum.PlatformStand = true
    end


    savedCamType = cam.CameraType
    savedCamSubject = cam.CameraSubject
    cam.CameraType = Enum.CameraType.Scriptable


    local camCFrame = cam.CFrame
    local yaw, pitch = 0, 0


    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter


    freecamConn = RunService.RenderStepped:Connect(function(dt)
        local delta = UserInputService:GetMouseDelta()
        yaw = yaw - delta.X * 0.002
        pitch = math.clamp(pitch - delta.Y * 0.002, -1.55, 1.55)


        local rot = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)


        local moveDir = Vector3.new()
        local speed = 80


        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir += rot.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir -= rot.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir -= rot.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir += rot.RightVector
        end


        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            camCFrame = camCFrame + moveDir * speed * dt
        end


        cam.CFrame = CFrame.new(camCFrame.Position) * rot
    end)
end


local function disableFreecam()
    if not freecamEnabled then return end
    freecamEnabled = false


    if freecamConn then
        freecamConn:Disconnect()
        freecamConn = nil
    end


    UserInputService.MouseBehavior = Enum.MouseBehavior.Default


    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")


    if hrp then
        if savedHRPCFrame then
            hrp.CFrame = savedHRPCFrame
        end
        if savedHRPAnchored ~= nil then
            hrp.Anchored = savedHRPAnchored
        else
            hrp.Anchored = false
        end
    end


    if hum then
        if savedHumPlatformStand ~= nil then
            hum.PlatformStand = savedHumPlatformStand
        else
            hum.PlatformStand = false
        end
    end


    local cam = Workspace.CurrentCamera
    cam.CameraType = savedCamType or Enum.CameraType.Custom
    cam.CameraSubject = savedCamSubject or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
end


local freecamBtn = createButton(pages["World"], "Toggle Freecam (OFF)")
freecamBtn.MouseButton1Click:Connect(function()
    if freecamEnabled then
        freecamBtn.Text = "Toggle Freecam (OFF)"
        disableFreecam()
    else
        freecamBtn.Text = "Toggle Freecam (ON)"
        enableFreecam()
    end
end)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == Enum.KeyCode.P then
        if freecamEnabled then
            freecamBtn.Text = "Toggle Freecam (OFF)"
            disableFreecam()
        else
            freecamBtn.Text = "Toggle Freecam (ON)"
            enableFreecam()
        end
    end
end)


createSectionHeader(pages["Credits"], "Credits")


local creditLinkBox = createCopyRow(pages["Credits"], "About me", "https://guns.lol/Limpan")
local creditDiscBox = createCopyRow(pages["Credits"], "Discord", "Limpan002s")


makeDraggable(mainFrame, topBar)
