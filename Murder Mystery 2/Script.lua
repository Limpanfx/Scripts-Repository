local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local themes = {
    SchemeColor  = Color3.fromRGB(255, 105, 180),
    Background   = Color3.fromRGB(0, 0, 0),
    Header       = Color3.fromRGB(0, 0, 0),
    TextColor    = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}

local Window = Library.CreateLib("Limpans GUI", themes)

local MainTab         = Window:NewTab("Main")
local VisualSection   = MainTab:NewSection("Visual")
local LocalSection    = MainTab:NewSection("Local Character")
local SpectateSection = MainTab:NewSection("Spectation")

local EspTab          = Window:NewTab("ESP")
local EspSection      = EspTab:NewSection("Player ESP")

local AimbotTab       = Window:NewTab("Aimbot")
local AimbotSection   = AimbotTab:NewSection("Aimbot")

local HitboxesTab     = Window:NewTab("Hitboxes")
local HitboxesSection = HitboxesTab:NewSection("Hitboxes")

local ObviousTab      = Window:NewTab("Obvious")
local ObviousSection  = ObviousTab:NewSection("Obvious")

local SettingsTab     = Window:NewTab("Settings")
local ThemeSection    = SettingsTab:NewSection("UI Colors")
local KeybindSection  = SettingsTab:NewSection("Keybinds")

local noAnimationsEnabled = false

local function noAnims(char)
    if not char then return end
    local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 2)
    if animate then
        animate:Destroy()
    end
end

ObviousSection:NewButton("No Animations", "Disable character animations", function()
    noAnimationsEnabled = not noAnimationsEnabled
    if noAnimationsEnabled and LocalPlayer.Character then
        noAnims(LocalPlayer.Character)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if noAnimationsEnabled then
        task.wait(0.1)
        noAnims(char)
    end
end)

ObviousSection:NewButton("Teleport to Spawn", "Teleports the player to spawn", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-5045, 284, 83)
end)

local walkSpeedEnabled = false
local originalWalkSpeed = 16
local jumpPowerEnabled = false
local originalJumpPower = 50
local currentWalkSpeed = originalWalkSpeed
local currentJumpPower = originalJumpPower

local function updateWalkSpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = walkSpeedEnabled and currentWalkSpeed or originalWalkSpeed
    end
end

local function updateJumpPower()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = jumpPowerEnabled and currentJumpPower or originalJumpPower
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        originalWalkSpeed = hum.WalkSpeed
        originalJumpPower = hum.JumpPower
    end
    updateWalkSpeed()
    updateJumpPower()
end)

RunService.Heartbeat:Connect(function()
    updateWalkSpeed()
    updateJumpPower()
end)

local fullbrightEnabled = false
local _fb_oldLighting = {}

local function enableFullbright()
    if fullbrightEnabled then return end
    local Lighting = game:GetService("Lighting")

    _fb_oldLighting.Brightness = Lighting.Brightness
    _fb_oldLighting.ClockTime = Lighting.ClockTime
    _fb_oldLighting.FogEnd = Lighting.FogEnd
    _fb_oldLighting.Ambient = Lighting.Ambient

    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1e10
    Lighting.Ambient = Color3.new(1, 1, 1)

    fullbrightEnabled = true
end

local function disableFullbright()
    if not fullbrightEnabled then return end
    local Lighting = game:GetService("Lighting")

    if _fb_oldLighting.Brightness ~= nil then Lighting.Brightness = _fb_oldLighting.Brightness end
    if _fb_oldLighting.ClockTime ~= nil then Lighting.ClockTime = _fb_oldLighting.ClockTime end
    if _fb_oldLighting.FogEnd ~= nil then Lighting.FogEnd = _fb_oldLighting.FogEnd end
    if _fb_oldLighting.Ambient ~= nil then Lighting.Ambient = _fb_oldLighting.Ambient end

    fullbrightEnabled = false
end

VisualSection:NewToggle("Fullbright", "Better visibility", function(state)
    if state then
        enableFullbright()
    else
        disableFullbright()
    end
end)

local xrayEnabled = false
local originalTransparency = {}
local trackedParts = {}
local XRayTransparency = 0.7

local function shouldAffectPart(part)
    if not part:IsA("BasePart") then return false end
    if part:IsDescendantOf(LocalPlayer.Character) then return false end
    return true
end

local function enableXRay()
    if xrayEnabled then return end

    for _, part in ipairs(Workspace:GetDescendants()) do
        if shouldAffectPart(part) then
            originalTransparency[part] = part.LocalTransparencyModifier
            part.LocalTransparencyModifier = XRayTransparency
            trackedParts[part] = true
        end
    end

    xrayEnabled = true
end

local function disableXRay()
    if not xrayEnabled then return end

    for part in pairs(trackedParts) do
        if part.Parent then
            part.LocalTransparencyModifier = originalTransparency[part] or 0
        end
    end

    originalTransparency = {}
    trackedParts = {}
    xrayEnabled = false
end

VisualSection:NewToggle("XRay", "See through walls", function(state)
    if state then
        enableXRay()
    else
        disableXRay()
    end
end)

local infiniteJumpEnabled = false

LocalSection:NewToggle("Infinite Jump", "Always jump (hold space)", function(state)
    infiniteJumpEnabled = state
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local noclipEnabled = false

LocalSection:NewToggle("Noclip", "Walk through walls", function(state)
    noclipEnabled = state
end)

RunService.Stepped:Connect(function()
    if not noclipEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end)

LocalSection:NewSlider("Walkspeed", "Change walkspeed", 500, 16, function(val)
    currentWalkSpeed = val
    walkSpeedEnabled = true
    updateWalkSpeed()
end)

LocalSection:NewSlider("Jumppower", "Change jumppower", 500, 50, function(val)
    currentJumpPower = val
    jumpPowerEnabled = true
    updateJumpPower()
end)

local InnocentESP_Enabled = false
local SheriffESP_Enabled  = false
local MurdererESP_Enabled = false

local playerHighlights = {}

local function clearAllESP()
    for plr, h in pairs(playerHighlights) do
        if h and h.Destroy then
            pcall(function() h:Destroy() end)
        end
    end
    table.clear(playerHighlights)
end

local function getPlayerRole(plr)
    local char = plr.Character
    if not char then return "Unknown" end

    local hasGun = char:FindFirstChild("Gun", true)
    local hasKnife = char:FindFirstChild("Knife", true)

    if not hasGun then
        local bp = plr:FindFirstChildOfClass("Backpack")
        if bp then
            if bp:FindFirstChild("Gun") then hasGun = true end
            if bp:FindFirstChild("Knife") then hasKnife = true end
        end
    end

    if hasGun then
        return "Sheriff"
    elseif hasKnife then
        return "Murderer"
    else
        return "Innocent"
    end
end

local function roleAllowed(role)
    if role == "Innocent" and InnocentESP_Enabled then return true end
    if role == "Sheriff"  and SheriffESP_Enabled  then return true end
    if role == "Murderer" and MurdererESP_Enabled then return true end
    return false
end

local function roleColor(role)
    if role == "Innocent" then
        return Color3.fromRGB(0, 255, 255)
    elseif role == "Sheriff" then
        return Color3.fromRGB(0, 255, 0)
    elseif role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)
    end
    return Color3.fromRGB(255, 255, 255)
end

task.spawn(function()
    while true do
        task.wait(1)

        if not (InnocentESP_Enabled or SheriffESP_Enabled or MurdererESP_Enabled) then
            clearAllESP()
            continue
        end

        clearAllESP()

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local role = getPlayerRole(plr)
                    if roleAllowed(role) then
                        local h = Instance.new("Highlight")
                        h.Adornee = char
                        h.FillColor = roleColor(role)
                        h.FillTransparency = 0.5
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.OutlineTransparency = 0
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = char
                        playerHighlights[plr] = h
                    end
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function() end)
end

EspSection:NewToggle("Innocent ESP", "Show innocents", function(state)
    InnocentESP_Enabled = state
    clearAllESP()
end)

EspSection:NewToggle("Sheriff ESP", "Show sheriff", function(state)
    SheriffESP_Enabled = state
    clearAllESP()
end)

EspSection:NewToggle("Murderer ESP", "Show murderer", function(state)
    MurdererESP_Enabled = state
    clearAllESP()
end)

local aimbotEnabled   = false
local holdingRMB      = false
local stickTarget     = nil

local fovEnabled      = false
local fovRadius       = 20
local fovColor        = Color3.fromRGB(255, 255, 255)

local predictionEnabled = false
local basePredictionTime = 0.12
local maxPredictionTime  = 0.35

local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = fovRadius
FOVCircle.Filled = false
FOVCircle.Color = fovColor
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Transparency = 1
FOVCircle.NumSides = 64

RunService.RenderStepped:Connect(function()
    if Camera then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    FOVCircle.Visible = fovEnabled
    FOVCircle.Radius = fovRadius
    FOVCircle.Color  = fovColor
end)

local function worldToScreen(pos)
    if not Camera then return nil end
    local vec, onScreen = Camera:WorldToViewportPoint(pos)
    if not onScreen then return nil end
    return Vector2.new(vec.X, vec.Y)
end

local function getChestPart(char)
    return char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function getClosestInFOV()
    if not Camera then return nil end

    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestPlayer = nil
    local closestDist = fovRadius

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local chest = getChestPart(char)
                if chest then
                    local screenPos = worldToScreen(chest.Position)
                    if screenPos then
                        local dist = (screenPos - center).Magnitude
                        if dist <= fovRadius and dist < closestDist then
                            closestDist = dist
                            closestPlayer = plr
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function getPredictionTime(part)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return basePredictionTime
    end

    local distance = (part.Position - root.Position).Magnitude
    local scaled = basePredictionTime + (distance / 100) * 0.03
    if scaled > maxPredictionTime then
        scaled = maxPredictionTime
    end
    if scaled < 0 then
        scaled = 0
    end
    return scaled
end

local function getPredictedPosition(part)
    if not predictionEnabled then
        return part.Position
    end

    local vel = part.AssemblyLinearVelocity or Vector3.zero
    local t = getPredictionTime(part)
    return part.Position + vel * t
end

local function aimAtPlayer(plr)
    local char = plr and plr.Character
    if not (char and Camera) then return end

    local chest = getChestPart(char)
    if not chest then return end

    local targetPos = getPredictedPosition(chest)
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
end

task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()

        if not aimbotEnabled then
            stickTarget = nil
            continue
        end

        if holdingRMB then
            if not stickTarget or not stickTarget.Character then
                stickTarget = getClosestInFOV()
            end

            if stickTarget and stickTarget.Character then
                aimAtPlayer(stickTarget)
            end
        else
            stickTarget = nil
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRMB = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRMB = false
    end
end)

AimbotSection:NewToggle("Aimbot", "Hold RMB to lock within FOV", function(state)
    aimbotEnabled = state
    if not state then
        stickTarget = nil
    end
end)

AimbotSection:NewToggle("FOV Circle", "Show aimbot FOV", function(state)
    fovEnabled = state
end)

AimbotSection:NewSlider("FOV Radius", "Change aimbot FOV size", 500, 20, function(val)
    fovRadius = val
end)

AimbotSection:NewToggle("Prediction", "Enable movement prediction", function(state)
    predictionEnabled = state
end)

AimbotSection:NewColorPicker("FOV Color", "Change FOV circle color", fovColor, function(col)
    fovColor = col
end)

local hitboxesEnabled = false
local hitboxSize = 5
local originalSizes = {}

local function setHitboxes(state)
    hitboxesEnabled = state

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if state then
                        if not originalSizes[hrp] then
                            originalSizes[hrp] = hrp.Size
                        end
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Transparency = 0.5
                        hrp.BrickColor = BrickColor.new("Really red")
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    else
                        if originalSizes[hrp] then
                            hrp.Size = originalSizes[hrp]
                        end
                        hrp.Transparency = 1
                        hrp.BrickColor = BrickColor.new("Medium stone grey")
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
end

HitboxesSection:NewToggle("Hitbox Visible", "Show / hide expanded hitboxes", function(state)
    setHitboxes(state)
end)

HitboxesSection:NewSlider("Hitbox Size", "Change hitbox size", 20, 2, function(val)
    hitboxSize = val
    if hitboxesEnabled then
        setHitboxes(true)
    end
end)

local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local roleGui = Instance.new("ScreenGui")
roleGui.Name = "RoleAvatarsGui"
roleGui.ResetOnSpawn = false
roleGui.IgnoreGuiInset = true
roleGui.Parent = playerGui

local murdererImage = Instance.new("ImageLabel")
murdererImage.Name = "MurdererImage"
murdererImage.Size = UDim2.new(0, 80, 0, 80)
murdererImage.AnchorPoint = Vector2.new(0.5, 1)
murdererImage.Position = UDim2.new(0.5, -50, 1, -10)
murdererImage.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
murdererImage.BorderSizePixel = 0
murdererImage.ScaleType = Enum.ScaleType.Fit
murdererImage.Parent = roleGui

local sheriffImage = Instance.new("ImageLabel")
sheriffImage.Name = "SheriffImage"
sheriffImage.Size = UDim2.new(0, 80, 0, 80)
sheriffImage.AnchorPoint = Vector2.new(0.5, 1)
sheriffImage.Position = UDim2.new(0.5, 50, 1, -10)
sheriffImage.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
sheriffImage.BorderSizePixel = 0
sheriffImage.ScaleType = Enum.ScaleType.Fit
sheriffImage.Parent = roleGui

local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size100x100

local function getHeadshotThumb(userId)
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    return content
end

local function updateRoleImages()
    local currentMurderer = nil
    local currentSheriff = nil

    for _, plr in ipairs(Players:GetPlayers()) do
        local role = getPlayerRole(plr)
        if role == "Murderer" then
            currentMurderer = plr
        elseif role == "Sheriff" then
            currentSheriff = plr
        end
    end

    if currentMurderer then
        murdererImage.Image = getHeadshotThumb(currentMurderer.UserId)
    else
        murdererImage.Image = ""
    end

    if currentSheriff then
        sheriffImage.Image = getHeadshotThumb(currentSheriff.UserId)
    else
        sheriffImage.Image = ""
    end
end

task.spawn(function()
    while true do
        task.wait(1.5)
        updateRoleImages()
    end
end)

ThemeSection:NewColorPicker("SchemeColor", "Change SchemeColor", themes.SchemeColor, function(color3)
    themes.SchemeColor = color3
    Library:ChangeColor("SchemeColor", color3)
end)

ThemeSection:NewColorPicker("TextColor", "Change TextColor", themes.TextColor, function(color3)
    themes.TextColor = color3
    Library:ChangeColor("TextColor", color3)
end)

KeybindSection:NewKeybind("Toggle UI", "Toggle UI with R", Enum.KeyCode.R, function()
    Library:ToggleUI()
end)

local swimming = false
local swimConn
local gravReset
local oldGravity = workspace.Gravity

local function getRoot(char)
    if char and char:FindFirstChildOfClass("Humanoid") then
        return char:FindFirstChildOfClass("Humanoid").RootPart
    end
end

local function toggleSwim(state)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid")

    if state and not swimming and humanoid then
        swimming = true
        oldGravity = workspace.Gravity
        workspace.Gravity = 0

        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for _, v in pairs(enums) do
            humanoid:SetStateEnabled(v, false)
        end
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

        gravReset = humanoid.Died:Connect(function()
            workspace.Gravity = oldGravity
            swimming = false
            if swimConn then
                swimConn:Disconnect()
                swimConn = nil
            end
            if gravReset then
                gravReset:Disconnect()
                gravReset = nil
            end
        end)

        swimConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local root = getRoot(character)
                if not root then return end

                if humanoid.MoveDirection ~= Vector3.new() or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    root.Velocity = root.Velocity
                else
                    root.Velocity = Vector3.new()
                end
            end)
        end)
    elseif not state and swimming then
        swimming = false
        workspace.Gravity = oldGravity
        local player = Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                local enums = Enum.HumanoidStateType:GetEnumItems()
                table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
                for _, v in pairs(enums) do
                    humanoid:SetStateEnabled(v, true)
                end
            end
        end
        if swimConn then
            swimConn:Disconnect()
            swimConn = nil
        end
        if gravReset then
            gravReset:Disconnect()
            gravReset = nil
        end
    end
end

ObviousSection:NewToggle("Swim", "Toggle fly-like swimming", function(state)
    toggleSwim(state)
end)

-- SPECTATE SYSTEM (replaced)

local murderer = nil
local sheriff = nil
local spectateConnection = nil
local spectatingTarget = nil

local function findMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character
            if backpack and backpack:FindFirstChild("Knife") then
                return player
            elseif character and character:FindFirstChild("Knife") then
                return player
            end
        end
    end
    return nil
end

local function findSheriff()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character
            if backpack and backpack:FindFirstChild("Gun") then
                return player
            elseif character and character:FindFirstChild("Gun") then
                return player
            end
        end
    end
    return nil
end

local function stopSpectate()
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
    spectatingTarget = nil
    Camera.CameraType = Enum.CameraType.Custom
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        Camera.CameraSubject = hum
    end
end

local function startSpectate(target)
    if not (target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
        return
    end
    spectatingTarget = target
    Camera.CameraType = Enum.CameraType.Scriptable

    if spectateConnection then
        spectateConnection:Disconnect()
    end

    spectateConnection = RunService.Heartbeat:Connect(function()
        if not (spectatingTarget and spectatingTarget.Character and spectatingTarget.Character:FindFirstChild("HumanoidRootPart")) then
            return
        end
        local hrp = spectatingTarget.Character.HumanoidRootPart
        local offset = hrp.CFrame:VectorToWorldSpace(Vector3.new(5, 3, 8))
        Camera.CFrame = CFrame.lookAt(hrp.Position + offset, hrp.Position)
    end)

    target.CharacterAdded:Connect(function()
        task.wait(1)
        if spectatingTarget == target then
            startSpectate(target)
        end
    end)
end

SpectateSection:NewToggle("Spectate Murderer", "Toggle spectating murderer", function(state)
    if state then
        murderer = findMurderer()
        if murderer then
            startSpectate(murderer)
        end
    else
        stopSpectate()
    end
end)

SpectateSection:NewToggle("Spectate Sheriff", "Toggle spectating sheriff", function(state)
    if state then
        sheriff = findSheriff()
        if sheriff then
            startSpectate(sheriff)
        end
    else
        stopSpectate()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        if Camera.CameraType == Enum.CameraType.Scriptable then
            stopSpectate()
        end
    end
end)
