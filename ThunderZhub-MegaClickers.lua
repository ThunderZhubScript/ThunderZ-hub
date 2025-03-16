local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
if not Fluent then
    warn("Unable to load Fluent library")
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "THUNDER Z HUB " .. Fluent.Version,
    SubTitle = "by ThunderNorlis",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "list" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "Teleport" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddParagraph({
    Title = "Join our Discord",
    Content = "https://discord.gg/f6Mge5f2w2"
})

-- ✅ Auto Tap Function
local AutoTapToggle = Tabs.Main:AddToggle("AutoTap", { Title = "Auto Tap", Default = false })
AutoTapToggle:OnChanged(function(state)
    _G.AutoTap = state
    if state then
        spawn(function()
            while _G.AutoTap do
                wait(0.001)
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Tap"):InvokeServer(true)
                end)
            end
        end)
    end
end)

-- ✅ Auto TP Gems Function
local AutoTPGemsToggle = Tabs.Main:AddToggle("AutoTPGems", { Title = "Auto TP Gems", Default = false })
AutoTPGemsToggle:OnChanged(function(state)
    _G.AutoTPGems = state
    if state then
        spawn(function()
            while _G.AutoTPGems do
                local player = game.Players.LocalPlayer
                local gems = workspace:FindFirstChild("Gems")

                if gems then
                    for _, gem in ipairs(gems:GetChildren()) do
                        if not _G.AutoTPGems then break end
                        if gem:IsA("BasePart") then
                            pcall(function()
                                player.Character.HumanoidRootPart.CFrame = gem.CFrame
                            end)
                            wait(0.1)
                        end
                    end
                else
                    warn("Gems folder not found in workspace.")
                end
                wait(1.5)
            end
        end)
    end
end)

-- ✅ Teleport Function
local function teleportToPosition(position)
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
        else
            warn("Failed to teleport: HumanoidRootPart not found.")
        end
    end)
end

-- ✅ Teleport Buttons
Tabs.Teleport:AddButton({
    Title = "Teleport to Lobby",
    Description = "Instantly teleport to the Lobby.",
    Callback = function()
        teleportToPosition(Vector3.new(-302.568, 6.192, 714.537))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Wheel Loot",
    Description = "Instantly teleport to the Wheel Loot.",
    Callback = function()
        teleportToPosition(Vector3.new(-241.307175, 4.72485638, 714.628418, -0.302300662, 6.80838355e-08, -0.953212619, -3.62116248e-09, 1, 7.25740676e-08, 0.953212619, 2.53909249e-08, -0.302300662))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 15K",
    Description = "Instantly teleport to the 15K door.",
    Callback = function()
        teleportToPosition(Vector3.new(-43.438, 7.963, 840.802))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 5M",
    Description = "Instantly teleport to the 5M door.",
    Callback = function()
        teleportToPosition(Vector3.new(108.810, 7.657, 753.916))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 1B",
    Description = "Instantly teleport to the 10B door.",
    Callback = function()
        teleportToPosition(Vector3.new(54.7824249, 7.91474104, 811.184509, -0.864480197, 0.000181875279, -0.502666831, 9.56207659e-05, 1, 0.000197373316, 0.502666891, 0.000122559926, -0.864480197))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 10T",
    Description = "Instantly teleport to the 10T door.",
    Callback = function()
        teleportToPosition(Vector3.new(-94.2942963, 8.15314674, 524.767883, 0.912118733, 3.88470681e-07, 0.409926116, -1.55083012e-06, 1, 2.50306221e-06, -0.409926116, -2.91881565e-06, 0.912118733))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 50Qa",
    Description = "Instantly teleport to the 50Qa door.",
    Callback = function()
        teleportToPosition(Vector3.new(9.06841373, 8.31605721, 534.610291, 0.934296489, 5.3086378e-08, -0.35649693, -5.64562868e-08, 1, 9.52234291e-10, 0.35649693, 1.92368237e-08, 0.934296489))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 1Qi",
    Description = "Instantly teleport to the 1Qi door.",
    Callback = function()
        teleportToPosition(Vector3.new(116.963142, 22.2672043, 506.146088, 0.999558806, -9.21591621e-08, -0.0297007989, 9.37220435e-08, 1, 5.12286142e-08, 0.0297007989, -5.39896341e-08, 0.999558806))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 5Qi",
    Description = "Instantly teleport to the 5Qi door.",
    Callback = function()
        teleportToPosition(Vector3.new(201.647644, 9.96162224, 698.543884, -0.753585637, -5.12591569e-08, -0.657349765, -3.10581143e-08, 1, -4.23734967e-08, 0.657349765, -1.15160148e-08, -0.753585637))
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Door 100Qi",
    Description = "Instantly teleport to the 5Qi door.",
    Callback = function()
        teleportToPosition(Vector3.new(219.437897, 60.9986382, 568.075134, 0.704654753, -4.96537673e-08, -0.709550321, 9.35707192e-08, 1, 2.29459189e-08, 0.709550321, -8.25620887e-08, 0.704654753))
    end
})


-- ✅ Save & Load Configuration
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
