local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "THUNDER Z HUB" .. " | " .. "King Legacy",
    Icon = "door-open",
    Author = "https://discord.gg/f6Mge5f2w2",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = false,
    KeySystem = { 
        Key = { "1234", "5678" },
        Note = "The Key is '1234' or '5678",
        URL = "https://github.com/Footagesus/WindUI",
        SaveKey = true,
    },
})

Window:EditOpenButton({
    Title = "Open Example UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,10),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
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

local autoSkill = false
local player = game:GetService("Players").LocalPlayer
local killCount = 0
local hasTakenQuest = false
local angle = 0
local rotationSpeed = 1.5
local spinAnimation

-- ฟังก์ชันหามอนสเตอร์ที่ใกล้ที่สุด (ไม่เปลี่ยนแปลง)
local function findNearestMonster()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart
    local playerLevel = player.PlayerStats and player.PlayerStats.lvl and player.PlayerStats.lvl.Value or 0

    local monsterParent = game:GetService("Workspace"):WaitForChild("Monster")
    if playerLevel >= 725 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local kingOfSand = bossParent:FindFirstChild("King of Sand [Lv. 725]")
        if kingOfSand and kingOfSand:IsA("Model") and kingOfSand:FindFirstChild("Humanoid") and kingOfSand:FindFirstChild("HumanoidRootPart") and kingOfSand.Humanoid.Health > 0 then
            print("[DEBUG] Targeting King of Sand: " .. kingOfSand.Name)
            return kingOfSand
        end
    -- ส่วนที่เหลือของฟังก์ชันนี้เหมือนเดิม ไม่เปลี่ยนแปลง
    elseif playerLevel >= 675 and playerLevel < 725 then
        local monParent = monsterParent:WaitForChild("Mon")
        local desertMarauder = monParent:FindFirstChild("Desert Marauder [Lv. 675]")
        if desertMarauder and desertMarauder:IsA("Model") and desertMarauder:FindFirstChild("Humanoid") and desertMarauder:FindFirstChild("HumanoidRootPart") and desertMarauder.Humanoid.Health > 0 then
            print("[DEBUG] Targeting Desert Marauder: " .. desertMarauder.Name)
            return desertMarauder
        end
    -- ... (ส่วนอื่น ๆ คงเดิม)
    end
    print("[DEBUG] No valid monster found for level: " .. playerLevel)
    return nil
end

-- กำหนดตัวแปรพื้นฐาน
local player = game.Players.LocalPlayer
local autoSkill = false
local hasTakenQuest = false
local killCount = 0
local spinAnimation = nil

-- รายการทักษะหมัดที่รองรับใน King Legacy (สามารถเพิ่มได้ตามต้องการ)
local fightingStyles = {
    "FS_None_M1",        -- หมัดพื้นฐาน
    "FS_BlackLeg_M1",    -- Black Leg
    "FS_Dragon_M1",      -- Dragon Claw
    "FS_Electro_M1",     -- Electro
    "FS_Fishman_M1"      -- Fishman Karate
    -- เพิ่มทักษะอื่น ๆ ที่คุณต้องการ เช่น "FS_Rokushiki_M1" ถ้ามี
}

-- ฟังก์ชันเลือกทักษะหมัดที่ใช้งานได้
local function getAvailableFightingStyle()
    for _, style in pairs(fightingStyles) do
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SkillAction"):InvokeServer(style)
        end)
        if success and result then
            print("[DEBUG] Found usable fighting style: " .. style)
            return style
        end
    end
    print("[DEBUG] No usable fighting style found, defaulting to FS_None_M1")
    return "FS_None_M1" -- ค่าเริ่มต้นถ้าไม่มีทักษะอื่นใช้งานได้
end

-- จำลอง Tabs.Main:Toggle (ไม่เปลี่ยนแปลง)
local Tabs = Tabs or { Main = {} }
Tabs.Main.Toggle = Tabs.Main.Toggle or function(options)
    local title = options.Title
    local default = options.Default
    local callback = options.Callback
    print("[DEBUG] Toggle created: " .. title .. " with default state: " .. tostring(default))
    callback(default)
end

-- Auto Farm Toggle
Tabs.Main:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        autoSkill = state

        if autoSkill then
            task.spawn(function()
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                
                if humanoid and not spinAnimation then
                    local animation = Instance.new("Animation")
                    animation.AnimationId = "rbxassetid://507771019"
                    spinAnimation = humanoid:LoadAnimation(animation)
                end

                local teleportFlags = {
                    hasTeleported50 = false,
                    hasTeleported100 = false,
                    hasTeleported180 = false,
                    hasTeleported250 = false,
                    hasTeleported400 = false,
                    hasTeleported575 = false,
                    hasTeleported625 = false,
                    hasTeleported675 = false,
                    hasTeleported725 = false
                }

                local function resetOnDeath()
                    hasTakenQuest = false
                    killCount = 0
                    if spinAnimation and spinAnimation.IsPlaying then
                        spinAnimation:Stop()
                    end
                    for key in pairs(teleportFlags) do
                        teleportFlags[key] = false
                    end
                end

                local function teleportToLevelPosition(hrp, playerLevel)
                    if not hrp then return end
                    if playerLevel >= 725 and not teleportFlags.hasTeleported725 then
                        hrp.CFrame = CFrame.new(-2780.8396, 41.3035355, -690.016052, -0.688813686, -5.83267123e-08, 0.724938452, 8.44549319e-09, 1, 8.84821105e-08, -0.724938452, 6.70701539e-08, -0.688813686)
                        teleportFlags.hasTeleported725 = true
                        print("[DEBUG] Teleported to 725 position")
                    -- ... (ส่วนอื่น ๆ คงเดิม)
                    end
                end

                humanoid.Died:Connect(function()
                    if autoSkill then
                        resetOnDeath()
                        character = player.CharacterAdded:Wait()
                        humanoid = character:WaitForChild("Humanoid")
                        local hrp = character:WaitForChild("HumanoidRootPart")
                        if humanoid and not spinAnimation then
                            local animation = Instance.new("Animation")
                            animation.AnimationId = "rbxassetid://507771019"
                            spinAnimation = humanoid:LoadAnimation(animation)
                        end
                        task.spawn(function()
                            task.wait(1)
                            local playerLevel = player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("lvl") and player.PlayerStats.lvl.Value or 0
                            print("[DEBUG] Player level after respawn: " .. playerLevel)
                            teleportToLevelPosition(hrp, playerLevel)
                            if typeof(findNearestMonster) == "function" then
                                findNearestMonster()
                            else
                                print("[ERROR] findNearestMonster function not defined")
                            end
                        end)
                    end
                end)

                -- ลูปสำหรับการเคลื่อนที่และหมุน (ไม่เปลี่ยนแปลง)
                task.spawn(function()
                    local targetMonster = typeof(findNearestMonster) == "function" and findNearestMonster() or nil
                    while autoSkill do
                        local hrp = character:WaitForChild("HumanoidRootPart", 1)
                        if hrp then
                            if humanoid then
                                humanoid.WalkSpeed = 0
                                humanoid.JumpPower = 0
                            end

                            local playerLevel = player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("lvl") and player.PlayerStats.lvl.Value or 0
                            print("[DEBUG] Current player level: " .. playerLevel)
                            
                            teleportToLevelPosition(hrp, playerLevel)

                            if typeof(findNearestMonster) == "function" then
                                if not targetMonster or not targetMonster.Parent or not targetMonster:FindFirstChild("Humanoid") or targetMonster.Humanoid.Health <= 0 then
                                    targetMonster = findNearestMonster()
                                    if targetMonster then
                                        print("[DEBUG] New target acquired: " .. targetMonster.Name)
                                    else
                                        print("[DEBUG] No new target found")
                                    end
                                end
                            end

                            if targetMonster then
                                if not hasTakenQuest then
                                    local questName
                                    if playerLevel >= 725 then questName = "Kill 1 King of Sand"
                                    -- ... (ส่วนอื่น ๆ คงเดิม)
                                    end

                                    local args = { [1] = "take", [2] = questName }
                                    local success, result = pcall(function()
                                        return game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))
                                    end)
                                    if success and result then
                                        hasTakenQuest = true
                                        print("[DEBUG] Quest taken: " .. questName)
                                    else
                                        warn("[DEBUG] Error invoking Quest remote: " .. tostring(result))
                                    end
                                end

                                local targetHumanoid = targetMonster:FindFirstChild("Humanoid")
                                if targetHumanoid and targetHumanoid.Health > 0 then
                                    local targetHrp = targetMonster:FindFirstChild("HumanoidRootPart")
                                    if targetHrp then
                                        local targetCFrame = targetHrp.CFrame
                                        local backOffset = -targetCFrame.LookVector * 7
                                        local heightOffset = Vector3.new(0, 5, 0)
                                        local newPosition = targetCFrame.Position + backOffset + heightOffset
                                        hrp.CFrame = CFrame.new(newPosition, targetHrp.Position)
                                        hrp.Velocity = Vector3.new(0, 0, 0)

                                        if spinAnimation and not spinAnimation.IsPlaying then
                                            spinAnimation:Play()
                                        end
                                    end
                                end

                                if targetHumanoid and targetHumanoid.Health <= 0 then
                                    killCount = killCount + 1
                                    print("[DEBUG] Monster killed, killCount: " .. killCount)
                                    targetMonster = typeof(findNearestMonster) == "function" and findNearestMonster() or nil
                                    if playerLevel >= 10 then
                                        hasTakenQuest = false
                                        killCount = 0
                                        print("[DEBUG] Quest reset for level: " .. playerLevel)
                                    end
                                end
                            end
                        end
                        task.wait(0.05)
                    end
                end)

                -- ลูปสำหรับการโจมตี (ปรับปรุงให้ใช้หมัดอื่นได้)
                task.spawn(function()
                    local targetMonster = typeof(findNearestMonster) == "function" and findNearestMonster() or nil
                    local currentFightingStyle = getAvailableFightingStyle() -- เลือกทักษะหมัดเริ่มต้น
                    while autoSkill do
                        local hrp = character:WaitForChild("HumanoidRootPart", 1)
                        if hrp then
                            if not targetMonster or not targetMonster.Parent or not targetMonster:FindFirstChild("Humanoid") or targetMonster.Humanoid.Health <= 0 then
                                targetMonster = typeof(findNearestMonster) == "function" and findNearestMonster() or nil
                            end

                            if targetMonster and targetMonster:FindFirstChild("Humanoid") then
                                local targetHumanoid = targetMonster.Humanoid
                                if targetHumanoid.Health > 0 then
                                    -- ใช้ทักษะหมัดที่เลือกไว้
                                    local args = { [1] = currentFightingStyle }
                                    local success, result = pcall(function()
                                        return game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SkillAction"):InvokeServer(unpack(args))
                                    end)
                                    if not success or not result then
                                        print("[DEBUG] Failed to use " .. currentFightingStyle .. ", switching style")
                                        currentFightingStyle = getAvailableFightingStyle() -- ถ้าทักษะใช้ไม่ได้ ให้เปลี่ยน
                                    end
                                end
                            end
                        end
                        task.wait(0.01) -- ความถี่การโจมตี
                    end
                end)
            end)
        else
            autoSkill = false
            hasTakenQuest = false
            killCount = 0
            if spinAnimation and spinAnimation.IsPlaying then
                spinAnimation:Stop()
            end
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Anchored = false
                if character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = 16
                    character.Humanoid.JumpPower = 50
                end
            end
        end
    end
})

-- ส่วน Configuration เดิม (ไม่มีการแก้ไข)
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
