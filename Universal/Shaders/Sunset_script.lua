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
    }
}

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
