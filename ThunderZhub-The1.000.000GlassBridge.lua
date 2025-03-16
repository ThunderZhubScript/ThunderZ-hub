local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "THUNDER Z HUB" .. " | ".."The $1,000,000 Glass Bridge",
    Icon = "door-open",
    Author = "https://discord.gg/f6Mge5f2w2",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    --Background = "rbxassetid://13511292247", -- rbxassetid only
    HasOutline = false,
    -- remove it below if you don't want to use the key system in your script.
})


Window:EditOpenButton({
    Title = "Open Example UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,10),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    --Enabled = false,
    Draggable = true,
})


local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "list", Desc = "Contains interactive buttons for various actions." }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart", Desc = "Contains interactive buttons for various actions." }),
    b = Window:Divider(),
    WindowTab = Window:Tab({ Title = "Window and File Configuration", Icon = "settings", Desc = "Manage window settings and file configurations." }),
    CreateThemeTab = Window:Tab({ Title = "Create Theme", Icon = "palette", Desc = "Design and apply custom themes." }),
    be = Window:Divider(),
}

Window:SelectTab(1)

local connection

Tabs.Main:Toggle({
    Title = "Auto Farm money",
    Default = false,
    Callback = function(state)
        if state then
            connection = game:GetService("RunService").Stepped:Connect(function()
                local player = game:GetService("Players").LocalPlayer
                if player then
                    local replicatedStorage = game:GetService("ReplicatedStorage")
                    local spinEvent = replicatedStorage:FindFirstChild("SpinEvents")
                    if spinEvent then
                        local quintoPremio = spinEvent:FindFirstChild("QuintoPremio")
                        if quintoPremio then
                            quintoPremio:FireServer(player)
                        else
                            warn("QuintoPremio event not found")
                        end
                    else
                        warn("SpinEvents not found in ReplicatedStorage")
                    end
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})


Tabs.Main:Button({
    Title = "TP Complete",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(882.424805, 36.5105095, -0.380279958, 0.156183496, 3.5054029e-08, -0.987728059, -2.20540013e-08, 1, 3.2002287e-08, 0.987728059, 1.67851262e-08, 0.156183496)
    end
})

Tabs.Main:Button({
    Title = "Conjure a gift (Free)",
    Callback = function()
        local args = {
        [1] = game:GetService("Players").LocalPlayer
            }

        game:GetService("ReplicatedStorage"):WaitForChild("FreeGearEvent"):FireServer(unpack(args))
    end,
    Locked = false
})

Tabs.Main:Button({
    Title = "Free Admin",
    Locked = true,
})

-- Shop

Tabs.Shop:Button({
      Title = "Buy Helicopter",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
                                
        game:GetService("ReplicatedStorage"):WaitForChild("HeliEvents"):WaitForChild("remote1"):FireServer(unpack(args))
    end
})

Tabs.Shop:Button({
      Title = "Buy Super Car",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
            
        game:GetService("ReplicatedStorage"):WaitForChild("Car_Prompt"):FireServer(unpack(args))
    end
})

Tabs.Shop:Button({
      Title = "Buy Diamond Carpet",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
            
        game:GetService("ReplicatedStorage"):WaitForChild("CarpetsEvents"):WaitForChild("DiamondPrompt"):FireServer(unpack(args))
    end
})

Tabs.Shop:Button({
      Title = "Buy Gold Carpet",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }

        game:GetService("ReplicatedStorage"):WaitForChild("CarpetsEvents"):WaitForChild("GoldenPrompt"):FireServer(unpack(args))
    end
})

Tabs.Shop:Button({
      Title = "Buy Fire Coil",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
            
        game:GetService("ReplicatedStorage"):WaitForChild("Money_Coil_Remotes"):WaitForChild("Fire"):FireServer(unpack(args))
    end
})

Tabs.Shop:Button({
      Title = "Buy Gold Coil",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
    
        game:GetService("ReplicatedStorage"):WaitForChild("Money_Coil_Remotes"):WaitForChild("CoilGold"):FireServer(unpack(args)) 
    end
})

Tabs.Shop:Button({
      Title = "Buy Void Coil",
    Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
            
        game:GetService("ReplicatedStorage"):WaitForChild("Money_Coil_Remotes"):WaitForChild("Void"):FireServer(unpack(args))  
    end
})

-- Configuration


local HttpService = game:GetService("HttpService")

local folderPath = "WindUI"
makefolder(folderPath)

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

Tabs.WindowTab:Section({ Title = "Window" })

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

local themeDropdown = Tabs.WindowTab:Dropdown({
    Title = "Select Theme",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})
themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = Tabs.WindowTab:Toggle({
    Title = "Toggle Window Transparency",
    Callback = function(e)
        Window:ToggleTransparency(e)
    end,
    Value = WindUI:GetTransparency()
})

Tabs.WindowTab:Section({ Title = "Save" })

local fileNameInput = ""
Tabs.WindowTab:Input({
    Title = "Write File Name",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        fileNameInput = text
    end
})

Tabs.WindowTab:Button({
    Title = "Save File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.WindowTab:Section({ Title = "Load" })

local filesDropdown
local files = ListFiles()

filesDropdown = Tabs.WindowTab:Dropdown({
    Title = "Select File",
    Multi = false,
    AllowNone = true,
    Values = files,
    Callback = function(selectedFile)
        fileNameInput = selectedFile
    end
})

Tabs.WindowTab:Button({
    Title = "Load File",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                WindUI:Notify({
                    Title = "File Loaded",
                    Content = "Loaded data: " .. HttpService:JSONEncode(data),
                    Duration = 5,
                })
                if data.Transparent then 
                    Window:ToggleTransparency(data.Transparent)
                    ToggleTransparency:SetValue(data.Transparent)
                end
                if data.Theme then WindUI:SetTheme(data.Theme) end
            end
        end
    end
})

Tabs.WindowTab:Button({
    Title = "Overwrite File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.WindowTab:Button({
    Title = "Refresh List",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

local currentThemeName = WindUI:GetCurrentTheme()
local themes = WindUI:GetThemes()

local ThemeAccent = themes[currentThemeName].Accent
local ThemeOutline = themes[currentThemeName].Outline
local ThemeText = themes[currentThemeName].Text
local ThemePlaceholderText = themes[currentThemeName].PlaceholderText

function updateTheme()
    WindUI:AddTheme({
        Name = currentThemeName,
        Accent = ThemeAccent,
        Outline = ThemeOutline,
        Text = ThemeText,
        PlaceholderText = ThemePlaceholderText
    })
    WindUI:SetTheme(currentThemeName)
end

local CreateInput = Tabs.CreateThemeTab:Input({
    Title = "Theme Name",
    Value = currentThemeName,
    Callback = function(name)
        currentThemeName = name
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Background Color",
    Default = Color3.fromHex(ThemeAccent),
    Callback = function(color)
        ThemeAccent = color:ToHex()
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Outline Color",
    Default = Color3.fromHex(ThemeOutline),
    Callback = function(color)
        ThemeOutline = color:ToHex()
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Text Color",
    Default = Color3.fromHex(ThemeText),
    Callback = function(color)
        ThemeText = color:ToHex()
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Placeholder Text Color",
    Default = Color3.fromHex(ThemePlaceholderText),
    Callback = function(color)
        ThemePlaceholderText = color:ToHex()
    end
})

Tabs.CreateThemeTab:Button({
    Title = "Update Theme",
    Callback = function()
        updateTheme()
    end
})
