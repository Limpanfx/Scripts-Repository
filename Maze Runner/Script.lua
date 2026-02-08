local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Limpan´s GUI", "Sentinel")

--tabs
local Tab = Window:NewTab("Main")
local RemovalTab = Window:NewTab("Remove")
local AutofarmTab = Window:NewTab("Autofarms")
local TeleportTab = Window:NewTab("Teleports")
local ESPTab = Window:NewTab("ESP")
local TimeTab = Window:NewTab("Times")
local OutfitTab = Window:NewTab("Outfit")
local SettingsTab= Window:NewTab("UI Settings")

--sections
local Section = Tab:NewSection("Functions") 
local RemovalSection = RemovalTab:NewSection("Options") 
local AutofarmSection = AutofarmTab:NewSection("Options") 
local TeleportBSection = TeleportTab:NewSection("Badges")
local TeleportSSection = TeleportTab:NewSection("Sectors (random sector from 1 to 8, teleport from spawn)") 
local TeleportSSSection = TeleportTab:NewSection("Regular Teleports") 
local ESPSection = ESPTab:NewSection("Functions") 
local TimeSection = TimeTab:NewSection("Time (Morning - 6:00 to 17:59, Night - 18:00 to 5:59):") 
local ShirtSection = OutfitTab:NewSection("Shirt Color:")
local SettingsSection = SettingsTab:NewSection("Options")


--general functionalities
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

getgenv().ChestESPEnabled = false
getgenv().GrieverESPEnabled = false
getgenv().PlayerESPEnabled = false
local ESP = nil

local teleporting = false
local teleportThread

local Lighting = game:GetService("Lighting")

--Main functions
Section:NewSlider("Walkspeed", "Bypassed walkspeed script", 200, 16, function(s)
    local speed = s
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local rs = game:GetService("RunService")

    if getgenv().SpeedConnection then
        getgenv().SpeedConnection:Disconnect()
    end
    
    getgenv().SpeedConnection = rs.RenderStepped:Connect(function()
        if char and hrp and char:FindFirstChild("Humanoid") then
            local dir = char.Humanoid.MoveDirection
            if dir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (dir * (speed / 100))
            end
        end
    end)
end)

Section:NewToggle("Infinite Jump", "Allows you to jump indefintely", function(state)
    getgenv().InfiniteJumpEnabled = state
end)

Section:NewToggle("FullBright", "Toggle FullBright on/off", function(state)
    local lighting = game:GetService("Lighting")
    getgenv().FullBrightEnabled = state

    if state then
        getgenv().OriginalLightingSettings = {
            Brightness = lighting.Brightness,
            ClockTime = lighting.ClockTime,
            FogEnd = lighting.FogEnd,
            GlobalShadows = lighting.GlobalShadows,
            OutdoorAmbient = lighting.OutdoorAmbient
        }
        lighting.Brightness = 5
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        local settings = getgenv().OriginalLightingSettings
        if settings then
            lighting.Brightness = settings.Brightness or 2
            lighting.ClockTime = settings.ClockTime or 14
            lighting.FogEnd = settings.FogEnd or 1000
            lighting.GlobalShadows = settings.GlobalShadows ~= false
            lighting.OutdoorAmbient = settings.OutdoorAmbient or Color3.new(0.5, 0.5, 0.5)
        end
    end
end)

--removal functions
RemovalSection:NewButton("Remove Maze Walls", "This includes the invisible roof", function()
    workspace._MAZE.InnerMaze.GladeWalls:Destroy()
    wait(0.1)
    workspace._MAZE.InnerMaze.InnerWalls:Destroy()
    wait(0.1)
    workspace._MAZE.OuterMaze.Walls:Destroy()
    wait(0.1)
    workspace.AntiNoclip:Destroy()
    wait(0.1)
    local animatedFolder = workspace:FindFirstChild("Animated")
    if animatedFolder then
        animatedFolder:Destroy()
    end
end)

RemovalSection:NewButton("Remove Kill Parts", "Removes killparts, generally within the walls", function()
    workspace.KillParts:Destroy()
end)

RemovalSection:NewButton("Remove Traps", "Removes in-maze traps", function()
    workspace._MAZE.InnerMaze.Traps:Destroy()
end) 

RemovalSection:NewButton("Remove Annoying Gamepasses", "Removes the step rings for all the gamepasses", function()
    workspace.StarterPack.PromptArea:Destroy()
    wait(0.1)
    workspace.Special.Destinations.GrieverPedistal:Destroy()
end) 

RemovalSection:NewButton("Remove Tutorial", "Removes the tutorial guy's ring", function()
    workspace.Special.Destinations.Tutorial:Destroy()
end) 

--autofarm functions
AutofarmSection:NewButton("Autofarm Pumpkins", "Once per server", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local pumpkinsFolder = workspace:WaitForChild("Pumpkins")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local function getClosestPumpkin()
        local closest, minDist = nil, math.huge
        for _, pumpkin in ipairs(pumpkinsFolder:GetChildren()) do
            if pumpkin:IsA("BasePart") then
                local dist = (humanoidRootPart.Position - pumpkin.Position).Magnitude
                if dist < minDist then
                    closest = pumpkin
                    minDist = dist
                end
            end
        end
        return closest
    end

    while #pumpkinsFolder:GetChildren() > 0 do
        local pumpkin = getClosestPumpkin()
        if not pumpkin then break end

        humanoidRootPart.CFrame = pumpkin.CFrame + Vector3.new(0, 3, 0)

        local spamDuration = 0.2
        local spamInterval = 0.05  

        local startTime = tick()
        while tick() - startTime < spamDuration do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(spamInterval)
        end
        pumpkin:Destroy()
        task.wait(0.2) 
    end
end) 

--teleport functions
TeleportBSection:NewButton("Mushroom Cave Badge", "Gives you the badge", function()
    local tpPart = workspace.Badges["Mushroom Cave"]
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if tpPart and character then
        character:MoveTo(tpPart.Position)
    end
end)

TeleportSSection:NewButton("One of the sectors", "The sector numbers are randomized every server", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local goal = Vector3.new(-605, 753, -456)
    local steps = 50
    local totalTime = 5
    local delayBetween = totalTime / steps

    if HumanoidRootPart then
        local startPos = HumanoidRootPart.Position
        for i = 1, steps do
            local alpha = i / steps
            local nextPos = startPos:Lerp(goal, alpha)
            HumanoidRootPart.CFrame = CFrame.new(nextPos)
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            task.wait(delayBetween)
        end
    else
        print("HumanoidRootPart not found")
    end
end)

TeleportSSection:NewButton("One of the sectors", "The sector numbers are randomized every server", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local goal = Vector3.new(461, 753, -605)
    local steps = 50
    local totalTime = 5
    local delayBetween = totalTime / steps

    if HumanoidRootPart then
        local startPos = HumanoidRootPart.Position
        for i = 1, steps do
            local alpha = i / steps
            local nextPos = startPos:Lerp(goal, alpha)
            HumanoidRootPart.CFrame = CFrame.new(nextPos)
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            task.wait(delayBetween)
        end
    else
        print("HumanoidRootPart not found")
    end
end)

TeleportSSection:NewButton("One of the sectors", "The sector numbers are randomized every server", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local goal = Vector3.new(-458, 753, 610)
    local steps = 50
    local totalTime = 5
    local delayBetween = totalTime / steps

    if HumanoidRootPart then
        local startPos = HumanoidRootPart.Position
        for i = 1, steps do
            local alpha = i / steps
            local nextPos = startPos:Lerp(goal, alpha)
            HumanoidRootPart.CFrame = CFrame.new(nextPos)
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            task.wait(delayBetween)
        end
    else
        print("HumanoidRootPart not found")
    end
end)

TeleportSSection:NewButton("One of the sectors", "The sector numbers are randomized every server", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local goal = Vector3.new(609, 753, 462)
    local steps = 50
    local totalTime = 5
    local delayBetween = totalTime / steps

    if HumanoidRootPart then
        local startPos = HumanoidRootPart.Position
        for i = 1, steps do
            local alpha = i / steps
            local nextPos = startPos:Lerp(goal, alpha)
            HumanoidRootPart.CFrame = CFrame.new(nextPos)
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            task.wait(delayBetween)
        end
    else
        print("HumanoidRootPart not found")
    end
end)

TeleportSSSection:NewToggle("Night Obby (Toggle)", "", function(state)
    teleporting = state
    if teleporting then
        teleportThread = task.spawn(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local goal = Vector3.new(-173, 600, 243)
            local steps = 50
            local totalTime = 5
            local delayBetween = totalTime / steps
            while teleporting do
                local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if HumanoidRootPart and Humanoid then
                    local startPos = HumanoidRootPart.Position
                    for i = 1, steps do
                        if not teleporting then return end
                        local alpha = i / steps
                        local nextPos = startPos:Lerp(goal, alpha)
                        HumanoidRootPart.CFrame = CFrame.new(nextPos)
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        Humanoid:Move(Vector3.new(0,0,-1), true)
                        task.wait(delayBetween)
                    end
                else
                    print("HumanoidRootPart not found")
                    break
                end
            end
        end)
    end
end)


--ESP functions
ESPSection:NewToggle("Chest ESP", "Toggle Chest ESP on/off.", function(state)
    getgenv().ChestESPEnabled = state
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local Chest_Folder = Workspace:WaitForChild("Chests")

    if state then
        ESP = ESP or loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
        ESP:Toggle(true)
        ESP.Players = false

        ESP:AddObjectListener(Chest_Folder, {
            Recursive = true,
            Validator = function(obj)
                return obj.ClassName == "Model" and obj:FindFirstChild("Tier")
            end,
            Color = Color3.new(0.3, 1, 0.3),
            IsEnabled = function()
                return getgenv().ChestESPEnabled
            end
        })
    else
        if ESP then
            ESP:Toggle(false)
        end
    end
end)

ESPSection:NewToggle("Griever ESP", "Toggle Griever ESP on/off.", function(state)
    getgenv().GrieverESPEnabled = state
    local Workspace = game:GetService("Workspace")
    local Griever_Folder = Workspace:WaitForChild("AIGrievers")

    if state then
        ESP = ESP or loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
        ESP:Toggle(true)
        
        ESP:AddObjectListener(Griever_Folder, {
            Recursive = true,
            Validator = function(obj)
                return obj.ClassName == "Model" and obj:FindFirstChild("HumanoidRootPart")
            end,
            Color = Color3.new(1, 0.3, 0.3),
            IsEnabled = function()
                return getgenv().GrieverESPEnabled
            end
        })
    else
        if ESP then
            ESP:Toggle(false)
        end
    end
end)

ESPSection:NewToggle("Player ESP", "Toggle Player ESP on/off.", function(state)
    getgenv().PlayerESPEnabled = state

    if ESP then
        ESP.Players = state and true or false
    else
        if state then
            ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
            ESP:Toggle(true)
            ESP.Players = true
        end
    end
end)

ESPSection:NewToggle("DigSite ESP", "Toggle ESP for all DigSites in OpenDigSites folder.", function(state)
    getgenv().DigSiteESPEnabled = state
    local Workspace = game:GetService("Workspace")
    local DigSite_Folder = Workspace.Special:WaitForChild("OpenDigSites")

    if state then
        ESP = ESP or loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
        ESP:Toggle(true)
        ESP.Players = false

        ESP:AddObjectListener(DigSite_Folder, {
            Recursive = true,
            Validator = function(obj)
                return obj:IsA("Model") and obj.Name == "Digging_Treasure"
            end,
            Color = Color3.new(0.5, 0.8, 1),
            IsEnabled = function()
                return getgenv().DigSiteESPEnabled
            end
        })
    else
        if ESP then
            ESP:Toggle(false)
        end
    end
end)

ESPSection:NewToggle("Interactables ESP", "Toggle ESP for all models in Interactables folder.", function(state)
    getgenv().InteractablesESPEnabled = state
    local Workspace = game:GetService("Workspace")
    local Interactables_Folder = Workspace.Special:WaitForChild("Interactables")

    if state then
        ESP = ESP or loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
        ESP:Toggle(true)
        ESP.Players = false

        ESP:AddObjectListener(Interactables_Folder, {
            Recursive = true,
            Validator = function(obj)
                return obj:IsA("Model")
            end,
            Color = Color3.new(1, 0.85, 0.25), 
            IsEnabled = function()
                return getgenv().InteractablesESPEnabled
            end
        })
    else
        if ESP then
            ESP:Toggle(false)
        end
    end
end)

--time functions
local function getTimePeriod(clock)
    if clock >= 6 and clock < 18 then
        return "Morning"
    else
        return "Night"
    end
end

local TimeLabel = TimeSection:NewLabel("Time: Initializing...")

coroutine.wrap(function()
    while true do
        local clock = Lighting.ClockTime
        local hour = math.floor(clock)
        local minute = math.floor((clock - hour) * 60)
        local period = getTimePeriod(clock)
        local timeString = string.format("%s - %02d:%02d", period, hour, minute)
        TimeLabel:UpdateLabel(timeString)
        wait(1)
    end
end)()

--outfit functions
local colorAssets = {
    Green = "295320232",
    Blue = "295320223",
    Yellow = "295320208",
    Orange = "295320191",
    Red = "295320158",
    Gray = "295320139"
}

ShirtSection:NewDropdown("Choose Color", "Select an outfit color.", {"Green", "Blue", "Yellow", "Orange", "Red", "Gray"}, function(selectedColor)
    local assetId = colorAssets[selectedColor]
    if assetId then
        local args = {
            "http://www.roblox.com/asset/?id=" .. assetId,
            "Outfit"
        }
        game:GetService("ReplicatedStorage").Events.OutfitChange:FireServer(unpack(args))
    end
end)

ShirtSection:NewToggle("Fake Headless (client-sided)", "To other people you look normal", function(state)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if state then
        character.Head.Transparency = 1
        for _, v in pairs(character.Head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    else
        character.Head.Transparency = 0
        for _, v in pairs(character.Head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 0
            end
        end
    end
end)

--settings functions
SettingsSection:NewKeybind("UI Toggle Key", "", Enum.KeyCode.Q, function()
	Library:ToggleUI()
end)
