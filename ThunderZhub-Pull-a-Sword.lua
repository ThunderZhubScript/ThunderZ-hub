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
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


local InterfaceSection: any = Tabs.Main:AddSection("Farm")

-- ✅ Auto Click
local AutoClickToggle = Tabs.Main:AddToggle("AutoClick", {
    Title = "Auto Click",
    Default = false
})

task.spawn(function()
    while true do
        task.wait(0.01)
        if AutoClickToggle.Value then
            pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("Events")
                    :WaitForChild("ClickEvent")
                    :FireServer()
            end)
        end
    end
end)

-- ✅ Auto Rebirth
local AutoRebirthToggle = Tabs.Main:AddToggle("AutoRebirth", {
    Title = "Auto Rebirth",
    Default = false
})

task.spawn(function()
    while true do
        task.wait(1)
        if AutoRebirthToggle.Value then
            pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("GameClient")
                    :WaitForChild("Events")
                    :WaitForChild("RemoteEvent")
                    :WaitForChild("RebirthEvent")
                    :FireServer()
            end)
        end
    end
end)

local InterfaceSection: any = Tabs.Main:AddSection("Receive a gift")

local AutoReceivegiftToggle = Tabs.Main:AddToggle("AutoReceiveGift", {
    Title = "Auto Receive a gift",
    Default = false
})

task.spawn(function()
    while true do
        task.wait(5) -- ความถี่ของการรับรางวัลทั้งหมดต่อรอบ (ปรับได้)
        if AutoReceivegiftToggle.Value then
            pcall(function()
                for i = 1, 12 do
                    local args = {
                        [1] = "Reward" .. i
                    }

                    game:GetService("ReplicatedStorage")
                        :WaitForChild("GameClient")
                        :WaitForChild("Events")
                        :WaitForChild("RemoteEvent")
                        :WaitForChild("ClaimGift")
                        :FireServer(unpack(args))

                    task.wait(0.1) -- หน่วงระหว่างแต่ละรางวัล (กันล่ม)
                end
            end)
        end
    end
end)

local InterfaceSection: any = Tabs.Main:AddSection("Redeem Code")

Tabs.Main:AddButton({
    Title = "Redeem Code All",
    Description = "",
    Callback = function()
        local args = {
            [1] = "sorrydelayraid",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "ARISE2",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "TIMERBUG23",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "ARISE",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "MASTERCODE",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "REBIRTHFIX",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "LUNACODE33",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "WHEELFIX3",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "BESTCODE333",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "SORRYPAW",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "PAWSEVENT5",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "PAWSEVENT4",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "PAWSGO",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "SEASONXI",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))
        local args = {
            [1] = "SEASONFIXI",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "WORLD10",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "LAST1ME",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "XMASEVENT",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "bugfixes2",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "SUPERFLUFFY",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "ELLIE",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "FIXED1412",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "COUNTOZERO",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "GIFTFROMUS888",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "EXTRAMEGA89",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "SEASONX",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "HALLOWEENPART2",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "HAUNTED2",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "usecodemagia1",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "classiccode12",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "newcode4891",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "i2perfectcode1",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "Newi2code12",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

        local args = {
            [1] = "RELEASE",
            [2] = "X_Arawrd"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("OnCodeRequest"):InvokeServer(unpack(args))

    end
})


-- Tp
Tabs.Teleport:AddButton({
    Title = "TP word1",
    Description = "",
    Callback = function()
        local args = {
            [1] = "2",
            [2] = false
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("PortalC"):FireServer(unpack(args))
    end
})

Tabs.Teleport:AddButton({
    Title = "TP word2",
    Description = "",
    Callback = function()
        local args = {
            [1] = "1",
            [2] = false
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("PortalC"):FireServer(unpack(args))
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
