-- สร้างตารางเก็บ PlaceId และลิงก์ของสคริปต์
local allowedMaps = {
    [16993432698] = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/main/ThunderZhub-Impossible-Squid-Game-Glass-Bridge-2.lua",
    [16732694052] = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/refs/heads/main/ThunderZhub-Fisch.lua",
    [6243699076]  = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/main/ThunderZhub-TheMimic.lua",
    [87854376962069] = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/main/ThunderZhub-The1.000.000GlassBridge.lua",
    [13827198708] = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/main/ThunderZhub-Pull-a-Sword.lua",
    [2753915549]  = "https://raw.githubusercontent.com/ThundarZ/Welcome/main/Main/Loader/AllGame.lua"

local currentPlaceId = game.PlaceId

if allowedMaps[currentPlaceId] then
    loadstring(game:HttpGet(allowedMaps[currentPlaceId]))()
else
    warn("Map not found")
end
