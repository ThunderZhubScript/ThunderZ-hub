local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HR = Char:WaitForChild("HumanoidRootPart")

-- Initialize global variables
_G.AutoFisch = false
_G.IsFrozen = false
_G.Shop = false

-- Equip item function
local function equipitem(v)
    if LocalPlayer.Backpack:FindFirstChild(v) then
        local Eq = LocalPlayer.Backpack:FindFirstChild(v)
        LocalPlayer.Character.Humanoid:EquipTool(Eq)
    end
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
if not Fluent then
    warn("Unable to load Fluent library")
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Fluent:CreateWindow({
    Title = "THUNDER Z HUB" .. Fluent.Version,
    SubTitle = "by ThunderNorlis",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "list" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "Shop" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local InterfaceSection = Tabs.Main:AddSection("Discord THUNDER Z HUB")

InterfaceSection:AddButton({
    Title = "Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/f6Mge5f2w2")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Copied!",
            Text = "Discord link copied to clipboard.",
            Duration = 3
        })
    end
})

local InterfaceSection = Tabs.Main:AddSection("Auto Farm")

--freeze
local AutoCastToggle = Tabs.Main:AddToggle("AutoCast", { Title = "Freeze", Default = false })
AutoCastToggle:OnChanged(function(value)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart then return end  -- ตรวจสอบว่ามี HumanoidRootPart จริงๆ

    if value then
        -- เปิด Freeze: บันทึกตำแหน่งเดิมและล็อกตัวละครไว้
        local oldPos = humanoidRootPart.CFrame

        task.spawn(function()
            while AutoCastToggle.Value do
                task.wait()
                if humanoidRootPart then
                    humanoidRootPart.CFrame = oldPos
                else
                    break
                end
            end
        end)
    else
        -- ปิด Freeze: ให้ตัวละครเคลื่อนที่ได้ปกติ
        humanoidRootPart.Anchored = false
    end
end)


-- Farm Money
local AutoCastToggle = Tabs.Main:AddToggle("AutoCast", { Title = "Farm for money", Default = false })
AutoCastToggle:OnChanged(function(state)
    _G.AutoCast = state
    if state then
        spawn(function()
            while _G.AutoCast do
                wait(0.1)
                game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-3840.46777, 133.065857, 342.404236, 0.835021675, 6.93383129e-08, -0.550217032, -1.12085978e-07, 1, -4.40842634e-08, 0.550217032, 9.84829356e-08, 0.835021675)
            end
        end)
    end
end)

-- Auto Fisch Toggle
local AutoFischToggle = Tabs.Main:AddToggle("AutoFisch", { Title = "Auto Fisch", Default = false })
AutoFischToggle:OnChanged(function(state)
    _G.AutoFisch = state
    spawn(function()
        while _G.AutoFisch do
            wait(0.01)
            pcall(function()
                -- Ensure that the character is not frozen before proceeding with Auto Fisch actions
                if not _G.IsFrozen then
                    -- Loop through the tools in the backpack and equip the fishing rod
                    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name:lower():find("rod") then
                            equipitem(v.Name)
                        end
                    end
                    
                    local Rod = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if Rod and Rod:FindFirstChild("events") then
                        Rod.events.cast:FireServer(100, 1)
                    end
                    
                    local GUI = LocalPlayer:WaitForChild("PlayerGui")
                    local shakeui = GUI:FindFirstChild("shakeui")
                    if shakeui and shakeui.Enabled then
                        local safezone = shakeui:FindFirstChild("safezone")
                        if safezone then
                            local button = safezone:FindFirstChild("button")
                            if button and button:IsA("ImageButton") and button.Visible then
                                GuiService.SelectedCoreObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end
                    end
                    
                    
                    local eventsFolder = ReplicatedStorage:FindFirstChild("events")
                    if eventsFolder then
                        local reelfinished = eventsFolder:FindFirstChild("reelfinished")
                        if reelfinished then
                            for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
                                if v:IsA("ScreenGui") and v.Name == "reel" and v:FindFirstChild("bar") then
                                    wait(0.01)
                                    reelfinished:FireServer(100, true)
                                end
                            end
                        end
                    end
                else
                    -- If the character is frozen, pause Auto Fisch
                    wait(0.01) -- Delay to avoid constant checks
                end
            end)
        end
    end)
end)

local InterfaceSection = Tabs.Main:AddSection("Auto Sell")

Tabs.Main:AddButton({
    Title = "Auto Sell",
    Description = "",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
    end
})


-- TP

Tabs.Teleport:AddButton({
    Title = "TP Roslit Bay Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-1469.44092, 132.525513, 692.787537, -0.965977013, -8.95565044e-09, 0.258628041, 1.74973191e-08, 1, 9.9980106e-08, -0.258628041, 1.0110378e-07, -0.965977013)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Grand Reef Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-3568.62207, 150.474365, 542.644287, -0.846319437, -8.96525432e-09, -0.532675743, -6.35419823e-08, 1, 8.41253964e-08, 0.532675743, 1.05044229e-07, -0.846319437)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Northern Expedition Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-1696.30701, 186.913864, 3955.62256, 0.742073715, -6.63090631e-08, 0.670318246, 4.31906173e-08, 1, 5.11077225e-08, -0.670318246, -8.97424002e-09, 0.742073715)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Snowcap Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(2643.83154, 150.778595, 2372.62183, 0.312208146, 3.00397818e-09, 0.950013697, -3.33724977e-08, 1, 7.80534837e-09, -0.950013697, -3.41412232e-08, 0.312208146)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Terrapin Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-162.935699, 145.057587, 1939.40271, 0.120352507, -1.3822351e-09, 0.992731214, -2.19435692e-09, 1, 1.65838587e-09, -0.992731214, -2.37799735e-09, 0.120352507)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Forsaken Shores Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-2498.06665, 132.750015, 1542.3927, 0.211525366, 6.73177709e-08, -0.977372527, -7.09824866e-09, 1, 6.73400535e-08, 0.977372527, -7.30649541e-09, 0.211525366)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Moosewood Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(474.26004, 150.693405, 263.867371, 0.384041905, -5.64242075e-09, 0.923315644, -1.42076448e-10, 1, 6.17013729e-09, -0.923315644, -2.5007727e-09, 0.384041905)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Ancient lsle Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(5944.97217, 154.931061, 478.758392, -0.912173629, -2.2557952e-08, -0.409803957, -1.87255491e-08, 1, -1.33649287e-08, 0.409803957, -4.51733229e-09, -0.912173629)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Mushgrove Swamp Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(2479.79199, 131.000015, -644.66333, 0.791070521, -9.39594091e-09, -0.611724973, -2.62746305e-08, 1, -4.93375758e-08, 0.611724973, 5.51023476e-08, 0.791070521)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Statue Of Sovereignty Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(26.0937996, 159.014709, -1038.23096, 0.846611261, -3.56529419e-08, 0.532211721, 9.21532362e-08, 1, -7.96018327e-08, -0.532211721, 1.16436844e-07, 0.846611261)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Keepers Altar (Upgrade fishing rod)",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(1310.36511, -805.292236, -116.92115, -0.998537302, -1.08100508e-07, -0.054067336, -1.05696543e-07, 1, -4.73218122e-08, 0.054067336, -4.15378629e-08, -0.998537302)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Sunstone Island",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-917.761719, 137.0327, -1130.1427, -0.788481414, -2.47171084e-09, 0.615058541, -5.36813305e-09, 1, -2.86308088e-09, -0.615058541, -5.55920199e-09, -0.788481414)
    end
})

Tabs.Teleport:AddButton({
    Title = "TP Vertigo Island underwater",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-111.160294, -515.299316, 1142.05505, -0.991547108, 9.14033507e-08, 0.129747272, 9.16893939e-08, 1, -3.76886966e-09, -0.129747272, 8.15943668e-09, -0.991547108)
    end
})

-- Shop
local InterfaceSection = Tabs.Shop:AddSection("Power&Luck")

Tabs.Shop:AddButton({
    Title = "Buy Power - 11,000 (TP Sunstone Island!!!) ",
    Description = "",
    Callback = function()
        workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("power"):InvokeServer()
    end
})

Tabs.Shop:AddButton({
    Title = "Buy Luck - 5,000 (TP Sunstone Island!!!) ",
    Description = "",
    Callback = function()
        workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("luck"):InvokeServer()
    end
})

local InterfaceSection = Tabs.Shop:AddSection("Crates")

Tabs.Shop:AddButton({
    Title = "Buy Moosewood 25,000 ",
    Description = "",
    Callback = function()
        local args = {
            [1] = "Moosewood"
        }
            
        game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RF/SkinCrates/Purchase"):InvokeServer(unpack(args))
    end
})

Tabs.Shop:AddButton({
    Title = "Buy Ancient 175,000 ",
    Description = "",
    Callback = function()
        local args = {
            [1] = "Ancient"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RF/SkinCrates/Purchase"):InvokeServer(unpack(args))
    end
})

Tabs.Shop:AddButton({
    Title = "Buy Atlantis 250,000 ",
    Description = "",
    Callback = function()
        local args = {
            [1] = "Atlantis"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RF/SkinCrates/Purchase"):InvokeServer(unpack(args))
    end
})



-- ออโต้รีจอย  
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(status)
    if status == Enum.TeleportState.Failed then
        wait(2) -- รอ 2 วินาทีก่อนลองใหม่
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
end)


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
