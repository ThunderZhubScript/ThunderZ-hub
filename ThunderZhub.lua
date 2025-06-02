local allowedMaps = {
    [16732694052] = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/refs/heads/main/ThunderZhub-Fisch.lua",
    [6243699076]  = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/main/ThunderZhub-TheMimic.lua",
    [13827198708] = "https://raw.githubusercontent.com/ThunderZhubScript/ThunderZ-hub/main/ThunderZhub-Pull-a-Sword.lua"

local currentPlaceId = game.PlaceId

if allowedMaps[currentPlaceId] then
    loadstring(game:HttpGet(allowedMaps[currentPlaceId]))()
else
    warn("Map not found")
end
