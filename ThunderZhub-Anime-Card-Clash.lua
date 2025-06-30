local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
if not Fluent then
    warn("Unable to load Fluent library")
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "THUNDER Z HUB V2",
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
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local InterfaceSection = Tabs.Main:AddSection("Farm")

Tabs.Main:AddToggle("Auto Roll", {
    Title = "Auto Roll",
    Default = false,
    Callback = function(state)
        local args = {
            "auto_roll",
            state
        }

        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("shared/network@eventDefinitions")
                :WaitForChild("setSetting")
                :FireServer(unpack(args))
        end)
    end
})

local skipRollValue = 0 -- ค่าเริ่มต้น

Tabs.Main:AddInput("SkipRollInput", {
    Title = "Set Skip Roll Value",
    Default = tostring(skipRollValue),
    Placeholder = "Check the number such as 1-1000",
    Numeric = true,
    Callback = function(value)
        skipRollValue = tonumber(value) or skipRollValue
        print("ตั้งค่า Skip Roll เป็น:", skipRollValue)
    end
})

Tabs.Main:AddButton({
    Title = "Skip Roll Animation",
    Description = "",
    Callback = function()
        local args = {
            "skip_roll_denom",
            skipRollValue
        }
        game:GetService("ReplicatedStorage"):WaitForChild("shared/network@eventDefinitions"):WaitForChild("setSetting"):FireServer(unpack(args))
        print("ยิงค่าที่ตั้งไป:", skipRollValue)
    end
})


local InterfaceSection = Tabs.Main:AddSection("Farm Boss")

local AutoTutorialBoss = false

Tabs.Main:AddToggle("Tutorial Boss", {
    Title = "Auto Tutorial Boss",
    Default = false,
    Callback = function(state)
        AutoTutorialBoss = state
        if state then
            task.spawn(function()
                while AutoTutorialBoss do
                    pcall(function()
                        local args = { 379 }
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("shared/network@eventDefinitions")
                            :WaitForChild("fightStoryBoss")
                            :FireServer(unpack(args))
                    end)
                    task.wait(1) -- ปรับความถี่ตามต้องการ
                end
            end)
        end
    end
})


local InterfaceSection = Tabs.Main:AddSection("Upgrades")

local AutoUpgradeRunning = false

Tabs.Main:AddToggle("Auto Upgrades", {
    Title = "Auto Upgrades Luck",
    Default = false,
    Callback = function(state)
        AutoUpgradeRunning = state
        if state then
            task.spawn(function()
                while AutoUpgradeRunning do
                    pcall(function()
                        local args = { "luck" }
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("shared/network@eventDefinitions")
                            :WaitForChild("allocateUpgradePoint")
                            :FireServer(unpack(args))
                    end)
                    task.wait(0.5) -- ปรับเวลาได้ตามต้องการ
                end
            end)
        end
    end
})

--Teleport

local InterfaceSection = Tabs.Teleport:AddSection("Teleport area Lobby")

Tabs.Teleport:AddButton({
    Title = "Teleport Lobby",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(173.540649, 7.45765829, -281.699127, 0.999999881, -2.75049961e-09, -0.000448356324, 2.75127854e-09, 1, 1.7367997e-09, 0.000448356324, -1.73803305e-09, 0.999999881)
    end
})


Tabs.Teleport:AddButton({
    Title = "Teleport Card Index",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(65.8842773, 22.7632446, -470.53537, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport card Deconstruct",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(24.2931976, 17.5937805, -322.221222, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport card Merge",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(-19.4662933, 18.2859802, -322.211182, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport potions",
    Description = "",
    Callback = function()
        local potions = workspace:FindFirstChild("lobby")
        if potions then
            potions = potions:FindFirstChild("potions")
        end

        if potions then
            local cframe = nil
            if potions:IsA("BasePart") then
                cframe = potions.CFrame
            elseif potions:IsA("Model") then
                cframe = potions:GetModelCFrame()
            end

            if cframe then
                game.Players.LocalPlayer.Character:PivotTo(cframe)
            else
                warn("potions ไม่ใช่ BasePart หรือ Model ที่มี CFrame")
            end
        else
            warn("ไม่พบ lobby.potions ใน workspace")
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport card Packs",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(120.159286, 18.4754028, -406.270691, -0.886880994, 0.000885124551, -0.4619973, 0.00531935692, 0.999951422, -0.00829562172, 0.461967498, -0.00981475785, -0.886842608)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport trait shop",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(125.438278, 7.33677053, -95.1099167, -0.898439646, 1.77817174e-08, 0.439096987, 1.49342831e-08, 1, -9.93895544e-09, -0.439096987, -2.37195241e-09, -0.898439646)
    end
})

local InterfaceSection = Tabs.Teleport:AddSection("Teleport area Raids")

Tabs.Teleport:AddButton({
    Title = "Teleport Raids",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(439.598999, 21.0201607, -15.0789337, -0.66741246, -1.84471591e-10, -0.744688272, -3.90772286e-08, 1, 3.47744944e-08, 0.744688272, 5.23092858e-08, -0.66741246)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport Raids Shop",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(407.734558, 37.5252686, -23.9795685, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247)
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
