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

    if playerLevel >= 145 then
        local bossParent = game:GetService("Workspace"):WaitForChild("Monster"):WaitForChild("Boss")
        local theBarbaric = bossParent:FindFirstChild("The Barbaric [Lv. 145]")
        if theBarbaric and theBarbaric:IsA("Model") and theBarbaric:FindFirstChild("Humanoid") and theBarbaric:FindFirstChild("HumanoidRootPart") and theBarbaric.Humanoid.Health > 0 then
            return theBarbaric
        end
        return nil
    elseif playerLevel >= 120 then
        local bossParent = game:GetService("Workspace"):WaitForChild("Monster"):WaitForChild("Boss")
        local captain = bossParent:FindFirstChild("Captain [Lv. 120]")
        if captain and captain:IsA("Model") and captain:FindFirstChild("Humanoid") and captain:FindFirstChild("HumanoidRootPart") and captain.Humanoid.Health > 0 then
            return captain
        end
        return nil
    elseif playerLevel >= 100 then
        local monsterParent = game:GetService("Workspace"):WaitForChild("Monster"):WaitForChild("Mon")
        local monsters = monsterParent:GetChildren()
        local targetMonster = monsters[3]
        if targetMonster and targetMonster:IsA("Model") and targetMonster:FindFirstChild("Humanoid") and targetMonster:FindFirstChild("HumanoidRootPart") and targetMonster.Humanoid.Health > 0 then
            return targetMonster
        end
        return nil
    elseif playerLevel >= 75 then
        local bossParent = game:GetService("Workspace"):WaitForChild("Monster"):WaitForChild("Boss")
        local theClown = bossParent:FindFirstChild("The Clown [Lv. 75]")
        if theClown and theClown:IsA("Model") and theClown:FindFirstChild("Humanoid") and theClown:FindFirstChild("HumanoidRootPart") and theClown.Humanoid.Health > 0 then
            return theClown
        end
        return nil
    elseif playerLevel >= 50 then
        local monsterParent = game:GetService("Workspace"):WaitForChild("Monster"):WaitForChild("Mon")
        local closestMonster = nil
        local shortestDistance = math.huge

        for _, monster in pairs(monsterParent:GetChildren()) do
            if monster:IsA("Model") and monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") then
                local humanoid = monster.Humanoid
                if humanoid.Health > 0 then
                    local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestMonster = monster
                    end
                end
            end
        end
        return closestMonster
    elseif playerLevel >= 20 then
        local bossParent = game:GetService("Workspace"):WaitForChild("Monster"):WaitForChild("Boss")
        local smoky = bossParent:FindFirstChild("Smoky [Lv. 20]")
        if smoky and smoky:IsA("Model") and smoky:FindFirstChild("Humanoid") and smoky:FindFirstChild("HumanoidRootPart") and smoky.Humanoid.Health > 0 then
            return smoky
        end
        return nil
    else
        local monsterParent = game:GetService("Workspace"):WaitForChild("Monster")
        if not monsterParent:FindFirstChild("Mon") then return nil end
        local targetName = playerLevel >= 10 and "Clown Pirate [Lv. 10]" or "Soldier [Lv. 1]"
        local closestMonster = nil
        local shortestDistance = math.huge

        for _, monster in pairs(monsterParent.Mon:GetChildren()) do
            if monster.Name == targetName and monster:IsA("Model") and monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") then
                local humanoid = monster.Humanoid
                if humanoid.Health > 0 then
                    local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestMonster = monster
                    end
                end
            end
        end
        return closestMonster
    end
end

-- Auto Farm Toggle (ปรับใหม่)
-- ฟังก์ชันหามอนสเตอร์ที่ใกล้ที่สุด (ปรับใหม่)
local function findNearestMonster()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart
    local playerLevel = player.PlayerStats and player.PlayerStats.lvl and player.PlayerStats.lvl.Value or 0

    local monsterParent = game:GetService("Workspace"):WaitForChild("Monster")
    if playerLevel >= 725 then -- เพิ่มเงื่อนไขสำหรับเลเวล 725
        local bossParent = monsterParent:WaitForChild("Boss")
        local kingOfSand = bossParent:FindFirstChild("King of Sand [Lv. 725]")
        if kingOfSand and kingOfSand:IsA("Model") and kingOfSand:FindFirstChild("Humanoid") and kingOfSand:FindFirstChild("HumanoidRootPart") and kingOfSand.Humanoid.Health > 0 then
            print("[DEBUG] Targeting King of Sand: " .. kingOfSand.Name)
            return kingOfSand
        end
    elseif playerLevel >= 675 and playerLevel < 725 then -- จำกัดช่วง 675-724
        local monParent = monsterParent:WaitForChild("Mon")
        local desertMarauder = monParent:FindFirstChild("Desert Marauder [Lv. 675]")
        if desertMarauder and desertMarauder:IsA("Model") and desertMarauder:FindFirstChild("Humanoid") and desertMarauder:FindFirstChild("HumanoidRootPart") and desertMarauder.Humanoid.Health > 0 then
            print("[DEBUG] Targeting Desert Marauder: " .. desertMarauder.Name)
            return desertMarauder
        end
    elseif playerLevel >= 625 and playerLevel < 675 then -- จำกัดช่วง 625-674
        local bossParent = monsterParent:WaitForChild("Boss")
        local bombMan = bossParent:FindFirstChild("Bomb Man [Lv. 625]")
        if bombMan and bombMan:IsA("Model") and bombMan:FindFirstChild("Humanoid") and bombMan:FindFirstChild("HumanoidRootPart") and bombMan.Humanoid.Health > 0 then
            print("[DEBUG] Targeting Bomb Man: " .. bombMan.Name)
            return bombMan
        end
    elseif playerLevel >= 575 and playerLevel < 625 then -- จำกัดช่วง 575-624
        local monParent = monsterParent:WaitForChild("Mon")
        local monsters = monParent:GetChildren()
        print("[DEBUG] Level 575 - Number of monsters in Mon: " .. #monsters)
        local sandBandit = monParent:FindFirstChild("Sand Bandit [Lv. 575]") or monParent:GetChildren()[2]
        if sandBandit and sandBandit:IsA("Model") and sandBandit:FindFirstChild("Humanoid") and sandBandit:FindFirstChild("HumanoidRootPart") and sandBandit.Humanoid.Health > 0 then
            print("[DEBUG] Targeting Sand Bandit: " .. sandBandit.Name)
            return sandBandit
        else
            print("[DEBUG] Sand Bandit not found or dead, searching for alive monster in Mon")
            for _, monster in pairs(monsters) do
                if monster:IsA("Model") and monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") and monster.Humanoid.Health > 0 then
                    print("[DEBUG] Fallback targeting: " .. monster.Name)
                    return monster
                end
            end
        end
    elseif playerLevel >= 500 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local littleDear = bossParent:FindFirstChild("Little Dear [Lv. 500]")
        if littleDear and littleDear:IsA("Model") and littleDear:FindFirstChild("Humanoid") and littleDear:FindFirstChild("HumanoidRootPart") and littleDear.Humanoid.Health > 0 then
            return littleDear
        end
    elseif playerLevel >= 450 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local kingSnow = bossParent:FindFirstChild("King Snow [Lv. 450]")
        if kingSnow and kingSnow:IsA("Model") and kingSnow:FindFirstChild("Humanoid") and kingSnow:FindFirstChild("HumanoidRootPart") and kingSnow.Humanoid.Health > 0 then
            return kingSnow
        end
    elseif playerLevel >= 400 then
        local monParent = monsterParent:WaitForChild("Mon")
        local monsters = monParent:GetChildren()
        if #monsters >= 4 then
            local targetMonster = monsters[4]
            if targetMonster and targetMonster:IsA("Model") and targetMonster:FindFirstChild("Humanoid") and targetMonster:FindFirstChild("HumanoidRootPart") and targetMonster.Humanoid.Health > 0 then
                return targetMonster
            end
        end
    elseif playerLevel >= 350 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local dory = bossParent:FindFirstChild("Dory [Lv. 350]")
        if dory and dory:IsA("Model") and dory:FindFirstChild("Humanoid") and dory:FindFirstChild("HumanoidRootPart") and dory.Humanoid.Health > 0 then
            return dory
        end
    elseif playerLevel >= 300 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local darkLeg = bossParent:FindFirstChild("Dark Leg [Lv. 300]")
        if darkLeg and darkLeg:IsA("Model") and darkLeg:FindFirstChild("Humanoid") and darkLeg:FindFirstChild("HumanoidRootPart") and darkLeg.Humanoid.Health > 0 then
            return darkLeg
        end
    elseif playerLevel >= 250 then
        local monParent = monsterParent:WaitForChild("Mon")
        local trainerChef = monParent:FindFirstChild("Trainer Chef [Lv. 250]")
        if trainerChef and trainerChef:IsA("Model") and trainerChef:FindFirstChild("Humanoid") and trainerChef:FindFirstChild("HumanoidRootPart") and trainerChef.Humanoid.Health > 0 then
            return trainerChef
        end
    elseif playerLevel >= 230 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local sharkMan = bossParent:FindFirstChild("Shark Man [Lv. 230]")
        if sharkMan and sharkMan:IsA("Model") and sharkMan:FindFirstChild("Humanoid") and sharkMan:FindFirstChild("HumanoidRootPart") and sharkMan.Humanoid.Health > 0 then
            return sharkMan
        end
    elseif playerLevel >= 200 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local karateFishman = bossParent:FindFirstChild("Karate Fishman [Lv. 200]")
        if karateFishman and karateFishman:IsA("Model") and karateFishman:FindFirstChild("Humanoid") and karateFishman:FindFirstChild("HumanoidRootPart") and karateFishman.Humanoid.Health > 0 then
            return karateFishman
        end
    elseif playerLevel >= 180 then
        local monParent = monsterParent:WaitForChild("Mon")
        local fighterFishman = monParent:FindFirstChild("Fighter Fishman [Lv. 180]")
        if fighterFishman and fighterFishman:IsA("Model") and fighterFishman:FindFirstChild("Humanoid") and fighterFishman:FindFirstChild("HumanoidRootPart") and fighterFishman.Humanoid.Health > 0 then
            return fighterFishman
        end
    elseif playerLevel >= 145 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local theBarbaric = bossParent:FindFirstChild("The Barbaric [Lv. 145]")
        if theBarbaric and theBarbaric:IsA("Model") and theBarbaric:FindFirstChild("Humanoid") and theBarbaric:FindFirstChild("HumanoidRootPart") and theBarbaric.Humanoid.Health > 0 then
            return theBarbaric
        end
    elseif playerLevel >= 120 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local captain = bossParent:FindFirstChild("Captain [Lv. 120]")
        if captain and captain:IsA("Model") and captain:FindFirstChild("Humanoid") and captain:FindFirstChild("HumanoidRootPart") and captain.Humanoid.Health > 0 then
            return captain
        end
    elseif playerLevel >= 100 then
        local monParent = monsterParent:WaitForChild("Mon")
        local monsters = monParent:GetChildren()
        if #monsters >= 3 then
            local targetMonster = monsters[3]
            if targetMonster and targetMonster:IsA("Model") and targetMonster:FindFirstChild("Humanoid") and targetMonster:FindFirstChild("HumanoidRootPart") and targetMonster.Humanoid.Health > 0 then
                return targetMonster
            end
        end
    elseif playerLevel >= 75 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local theClown = bossParent:FindFirstChild("The Clown [Lv. 75]")
        if theClown and theClown:IsA("Model") and theClown:FindFirstChild("Humanoid") and theClown:FindFirstChild("HumanoidRootPart") and theClown.Humanoid.Health > 0 then
            return theClown
        end
    elseif playerLevel >= 50 then
        local monParent = monsterParent:WaitForChild("Mon")
        local closestMonster = nil
        local shortestDistance = math.huge
        for _, monster in pairs(monParent:GetChildren()) do
            if monster:IsA("Model") and monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") then
                local humanoid = monster.Humanoid
                if humanoid.Health > 0 then
                    local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestMonster = monster
                    end
                end
            end
        end
        return closestMonster
    elseif playerLevel >= 20 then
        local bossParent = monsterParent:WaitForChild("Boss")
        local smoky = bossParent:WaitForChild("Smoky [Lv. 20]")
        if smoky and smoky:IsA("Model") and smoky:FindFirstChild("Humanoid") and smoky:FindFirstChild("HumanoidRootPart") and smoky.Humanoid.Health > 0 then
            return smoky
        end
    else
        local monParent = monsterParent:WaitForChild("Mon")
        local targetName = playerLevel >= 10 and "Clown Pirate [Lv. 10]" or "Soldier [Lv. 1]"
        local closestMonster = nil
        local shortestDistance = math.huge
        for _, monster in pairs(monParent:GetChildren()) do
            if monster.Name == targetName and monster:IsA("Model") and monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") then
                local humanoid = monster.Humanoid
                if humanoid.Health > 0 then
                    local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestMonster = monster
                    end
                end
            end
        end
        return closestMonster
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

-- จำลอง Tabs.Main:Toggle ถ้าไม่มี UI library (สำหรับทดสอบ)
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

                -- ตัวแปรสถานะสำหรับการเทเลพอร์ต
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

                -- ฟังก์ชันรีเซ็ตสถานะเมื่อตาย
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

                -- ฟังก์ชันเทเลพอร์ตตามเลเวล
                local function teleportToLevelPosition(hrp, playerLevel)
                    if not hrp then return end
                    if playerLevel >= 725 and not teleportFlags.hasTeleported725 then
                        hrp.CFrame = CFrame.new(-2780.8396, 41.3035355, -690.016052, -0.688813686, -5.83267123e-08, 0.724938452, 8.44549319e-09, 1, 8.84821105e-08, -0.724938452, 6.70701539e-08, -0.688813686)
                        teleportFlags.hasTeleported725 = true
                        print("[DEBUG] Teleported to 725 position")
                    elseif playerLevel >= 675 and playerLevel < 725 and not teleportFlags.hasTeleported675 then
                        hrp.CFrame = CFrame.new(-2780.8396, 41.3035355, -690.016052, -0.688813686, -5.83267123e-08, 0.724938452, 8.44549319e-09, 1, 8.84821105e-08, -0.724938452, 6.70701539e-08, -0.688813686)
                        teleportFlags.hasTeleported675 = true
                        print("[DEBUG] Teleported to 675 position")
                    elseif playerLevel >= 625 and playerLevel < 675 and not teleportFlags.hasTeleported625 then
                        hrp.CFrame = CFrame.new(-2780.8396, 41.3035355, -690.016052, -0.688813686, -5.83267123e-08, 0.724938452, 8.44549319e-09, 1, 8.84821105e-08, -0.724938452, 6.70701539e-08, -0.688813686)
                        teleportFlags.hasTeleported625 = true
                        print("[DEBUG] Teleported to 625 position")
                    elseif playerLevel >= 575 and playerLevel < 625 and not teleportFlags.hasTeleported575 then
                        hrp.CFrame = CFrame.new(-2780.8396, 41.3035355, -690.016052, -0.688813686, -5.83267123e-08, 0.724938452, 8.44549319e-09, 1, 8.84821105e-08, -0.724938452, 6.70701539e-08, -0.688813686)
                        teleportFlags.hasTeleported575 = true
                        print("[DEBUG] Teleported to 575 position")
                    elseif playerLevel >= 400 and playerLevel < 575 and not teleportFlags.hasTeleported400 then
                        hrp.CFrame = CFrame.new(-5342.396, 28.921236, -1360.87329, -0.470811516, 3.72533009e-08, 0.882233799, 5.7678097e-08, 1, -1.14457066e-08, -0.882233799, 4.54967974e-08, -0.470811516)
                        teleportFlags.hasTeleported400 = true
                        print("[DEBUG] Teleported to 400 position")
                    elseif playerLevel >= 250 and playerLevel < 400 and not teleportFlags.hasTeleported250 then
                        hrp.CFrame = CFrame.new(-4121.94287, 17.1786251, -3079.13184, 0.946295142, 6.657109e-08, -0.323304027, -7.02158403e-08, 1, 3.90299598e-10, 0.323304027, 2.2331724e-08, 0.946295142)
                        teleportFlags.hasTeleported250 = true
                        print("[DEBUG] Teleported to 250 position")
                    elseif playerLevel >= 180 and playerLevel < 250 and not teleportFlags.hasTeleported180 then
                        hrp.CFrame = CFrame.new(-776.85199, 23.0631371, -1367.97144, 0.960952818, -2.775149e-08, -0.276712209, 2.63510067e-08, 1, -8.77957351e-09, 0.276712209, 1.14511034e-09, 0.960952818)
                        teleportFlags.hasTeleported180 = true
                        print("[DEBUG] Teleported to 180 position")
                    elseif playerLevel >= 100 and playerLevel < 180 and not teleportFlags.hasTeleported100 then
                        hrp.CFrame = CFrame.new(-2407.68555, 76.4155045, -2692.56274, -0.902790844, 8.81547368e-09, -0.430079877, 5.32680922e-08, 1, -9.13190163e-08, 0.430079877, -1.05351504e-07, -0.902790844)
                        teleportFlags.hasTeleported100 = true
                        print("[DEBUG] Teleported to 100 position")
                    elseif playerLevel >= 50 and playerLevel < 100 and not teleportFlags.hasTeleported50 then
                        hrp.CFrame = CFrame.new(-708.370667, 51.3790741, -3416.86328, 0.89880532, -2.37368933e-08, -0.438347995, 5.97499072e-09, 1, -4.18994475e-08, 0.438347995, 3.50403226e-08, 0.89880532)
                        teleportFlags.hasTeleported50 = true
                        print("[DEBUG] Teleported to 50 position")
                    end
                end

                -- ตรวจจับเมื่อตัวละครตายและเกิดใหม่
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

                -- ลูปสำหรับการเคลื่อนที่และหมุน (ปรับให้อยู่ข้างหลังมอนสเตอร์)
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
                                    elseif playerLevel >= 675 then questName = "Kill 4 Desert Marauder"
                                    elseif playerLevel >= 625 then questName = "Kill 1 Bomb Man"
                                    elseif playerLevel >= 575 then questName = "Kill 4 Sand Bandit"
                                    elseif playerLevel >= 500 then questName = "Kill 1 Little Dear"
                                    elseif playerLevel >= 450 then questName = "Kill 1 King Snow"
                                    elseif playerLevel >= 400 then questName = "Kill 5 Snow Soldier"
                                    elseif playerLevel >= 350 then questName = "Kill 1 Dory"
                                    elseif playerLevel >= 300 then questName = "Kill 1 Dark Leg"
                                    elseif playerLevel >= 250 then questName = "Kill 4 Trainer Chef"
                                    elseif playerLevel >= 230 then questName = "Kill 1 Shark Man"
                                    elseif playerLevel >= 200 then questName = "Kill 1 Karate Fishman"
                                    elseif playerLevel >= 180 then questName = "Kill 4 Fighter Fishmans"
                                    elseif playerLevel >= 145 then questName = "Kill 1 The Barbaric"
                                    elseif playerLevel >= 120 then questName = "Kill 1 Captain"
                                    elseif playerLevel >= 100 then questName = "Kill 4 Commander"
                                    elseif playerLevel >= 75 then questName = "Kill 1 The Clown"
                                    elseif playerLevel >= 50 then questName = "Kill 6 Clown Swordman"
                                    elseif playerLevel >= 20 then questName = "Kill 1 Smoky"
                                    elseif playerLevel >= 10 then questName = "Kill 5 Clown Pirates"
                                    else questName = "Kill 4 Soldiers" end

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
                                        -- คำนวณตำแหน่งด้านหลังมอนสเตอร์
                                        local targetCFrame = targetHrp.CFrame
                                        local backOffset = -targetCFrame.LookVector * 7 -- ระยะ 7 หน่วยด้านหลัง
                                        local heightOffset = Vector3.new(0, 5, 0) -- ความสูง +5
                                        local newPosition = targetCFrame.Position + backOffset + heightOffset

                                        -- วางตัวละครด้านหลังและหันหน้าไปทางมอนสเตอร์
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

                -- ลูปสำหรับการโจมตี
                task.spawn(function()
                    local targetMonster = typeof(findNearestMonster) == "function" and findNearestMonster() or nil
                    while autoSkill do
                        local hrp = character:WaitForChild("HumanoidRootPart", 1)
                        if hrp then
                            if not targetMonster or not targetMonster.Parent or not targetMonster:FindFirstChild("Humanoid") or targetMonster.Humanoid.Health <= 0 then
                                targetMonster = typeof(findNearestMonster) == "function" and findNearestMonster() or nil
                            end

                            if targetMonster and targetMonster:FindFirstChild("Humanoid") then
                                local targetHumanoid = targetMonster.Humanoid
                                if targetHumanoid.Health > 0 then
                                    local args = { [1] = "FS_None_M1" }
                                    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SkillAction"):InvokeServer(unpack(args))
                                end
                            end
                        end
                        task.wait(0.01)
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
