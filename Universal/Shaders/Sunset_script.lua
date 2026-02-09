local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace

local EffectSettings = {
    SunRaySettings = {
        enabled = true,
        intensity = 0.4,
        spread = 1.1
    },
    BloomSettings = {
        enabled = true,
        intensity = 0.8,
        size = 28,
        threshold = 0.9
    },
    ColorSettings = {
        enabled = true,
        brightness = 0.05,
        contrast = -0.05,
        saturation = 0.2,
        tintcolor = Color3.fromRGB(255, 190, 140)
    },
    BlurSettings = {
        enabled = false,
        size = 6
    },
    Liquid = {
        minX = 25,
        minZ = 25,
        maxY = 10,
        sizePadding = 4,
        heightOffset = 0.05,
        transparency = 0.2,
        reflectance = 1
    }
}

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
ScreenGui.Name = "ShadersDisplay"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(1,1,1)
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.new(1, -160, 1, -80)
Frame.Size = UDim2.new(0, 160, 0, 80)
TextLabel.Parent = Frame
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Shaders Active\nSunset + Liquid Ground Reflections"
TextLabel.TextColor3 = Color3.new(1, 0.85, 0.5)
TextLabel.TextSize = 12

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent and LocalPlayer then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

Lighting.ClockTime = 17
Lighting.Brightness = 2.2
Lighting.OutdoorAmbient = Color3.fromRGB(140, 110, 90)
Lighting.Ambient = Color3.fromRGB(90, 70, 60)
Lighting.EnvironmentSpecularScale = 1
Lighting.EnvironmentDiffuseScale = 1
Lighting.Technology = Enum.Technology.ShadowMap

local SunRays = Instance.new("SunRaysEffect")
SunRays.Parent = Lighting
SunRays.Enabled = EffectSettings.SunRaySettings.enabled
SunRays.Intensity = EffectSettings.SunRaySettings.intensity
SunRays.Spread = EffectSettings.SunRaySettings.spread

local Bloom = Instance.new("BloomEffect")
Bloom.Parent = Lighting
Bloom.Enabled = EffectSettings.BloomSettings.enabled
Bloom.Intensity = EffectSettings.BloomSettings.intensity
Bloom.Size = EffectSettings.BloomSettings.size
Bloom.Threshold = EffectSettings.BloomSettings.threshold

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Parent = Lighting
ColorCorrection.Enabled = EffectSettings.ColorSettings.enabled
ColorCorrection.Brightness = EffectSettings.ColorSettings.brightness
ColorCorrection.Contrast = EffectSettings.ColorSettings.contrast
ColorCorrection.Saturation = EffectSettings.ColorSettings.saturation
ColorCorrection.TintColor = EffectSettings.ColorSettings.tintcolor

local Blur = Instance.new("BlurEffect")
Blur.Parent = Lighting
Blur.Enabled = EffectSettings.BlurSettings.enabled
Blur.Size = EffectSettings.BlurSettings.size

local liquidFolder = Instance.new("Folder")
liquidFolder.Name = "LiquidGroundReflections"
liquidFolder.Parent = Workspace

local MIN_X = EffectSettings.Liquid.minX
local MIN_Z = EffectSettings.Liquid.minZ
local MAX_Y = EffectSettings.Liquid.maxY
local SIZE_PADDING = EffectSettings.Liquid.sizePadding
local HEIGHT_OFFSET = EffectSettings.Liquid.heightOffset
local LIQUID_TRANSPARENCY = EffectSettings.Liquid.transparency
local LIQUID_REFLECTANCE = EffectSettings.Liquid.reflectance

local function isLargeFloor(part)
    if not part:IsA("BasePart") then
        return false
    end
    local size = part.Size
    return size.X >= MIN_X and size.Z >= MIN_Z and size.Y <= MAX_Y
end

local function makeLiquidLayer(basePart)
    if not isLargeFloor(basePart) then
        return nil
    end

    local size = basePart.Size

    local liquid = Instance.new("Part")
    liquid.Name = "LiquidReflectionLayer"
    liquid.Anchored = true
    liquid.CanCollide = false
    liquid.CanQuery = false
    liquid.CanTouch = false
    liquid.Material = Enum.Material.Glass
    liquid.Color = Color3.fromRGB(255, 210, 170)
    liquid.Transparency = LIQUID_TRANSPARENCY
    liquid.Reflectance = LIQUID_REFLECTANCE
    liquid.Size = Vector3.new(size.X + SIZE_PADDING, 0.1, size.Z + SIZE_PADDING)
    liquid.CFrame = basePart.CFrame * CFrame.new(0, size.Y/2 + HEIGHT_OFFSET, 0)
    liquid.TopSurface = Enum.SurfaceType.Smooth
    liquid.BottomSurface = Enum.SurfaceType.Smooth
    liquid.Parent = liquidFolder

    return liquid
end

local liquidLayers = {}

for _, obj in ipairs(Workspace:GetDescendants()) do
    local liquid = makeLiquidLayer(obj)
    if liquid then
        table.insert(liquidLayers, liquid)
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if #liquidLayers > 200 then
        return
    end
    local liquid = makeLiquidLayer(obj)
    if liquid then
        table.insert(liquidLayers, liquid)
    end
end)

task.spawn(function()
    local t = 0
    local sin = math.sin
    while task.wait(0.08) do
        t = t + 0.08
        local colorOffset = math.floor(20 * sin(t * 0.5))
        local yOffset = 0.02 * sin(t * 0.7)
        local baseColorR = 255
        local baseColorG = 190
        local baseColorB = 150

        local color = Color3.fromRGB(
            baseColorR,
            math.clamp(baseColorG + colorOffset, 160, 210),
            baseColorB
        )

        for i = 1, #liquidLayers do
            local liquid = liquidLayers[i]
            if liquid and liquid.Parent then
                local cf = liquid.CFrame
                liquid.CFrame = CFrame.new(cf.Position.X, cf.Position.Y + yOffset, cf.Position.Z) * CFrame.Angles(0, cf:ToEulerAnglesYXZ())
                liquid.Color = color
            else
                liquidLayers[i] = nil
            end
        end
    end
end)
