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
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local InterfaceSection = Tabs.Main:AddSection("Meun Farm")

-- ✅ Auto Tap Function
local AutoTapToggle = Tabs.Main:AddToggle("AutoWin", {
    Title = "Auto Win",
    Default = false
})

local AutoTapRunning = false

AutoTapToggle:OnChanged(function(Value)
    AutoTapRunning = Value
    if Value then
        task.spawn(function()
            while AutoTapRunning do
                pcall(function()
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Finish.Chest, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Finish.Chest, 1)
                end)
                task.wait(5) -- สามารถปรับความถี่ได้
            end
        end)
    end
end)


local AutoTapToggle = Tabs.Main:AddToggle("Free OP ltem", {
    Title = "Free OP ltem(conjure things)",
    Default = false
})

AutoTapToggle:OnChanged(function(Value)
    AutoTapRunning = Value
    if Value then
        task.spawn(function()
            while AutoTapRunning do
                pcall(function()
                    local args = {
                        [1] = "processClaim"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("blockRemote"):FireServer(unpack(args))
                end)
                task.wait(0.1) -- สามารถปรับความถี่ได้
            end
        end)
    end
end)


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
