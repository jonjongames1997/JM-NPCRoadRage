-- Client Utilities Module - Helper functions

ClientUtils = {}

--- Get filtered weapon list (excludes blacklisted weapons)
---@return table
function ClientUtils.GetAllowedWeapons()
    local allowedWeapons = {}
    
    for _, weapon in pairs(Config.RageWeapons) do
        local isBlacklisted = false
        
        if Config.BlacklistedWeapons then
            for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
                if weapon == blacklistedWeapon then
                    isBlacklisted = true
                    break
                end
            end
        end
        
        if not isBlacklisted then
            table.insert(allowedWeapons, weapon)
        end
    end
    
    return allowedWeapons
end

--- Get nearby vehicles within radius
---@param coords vector3 Center coordinates
---@param radius number Search radius
---@return table
function ClientUtils.GetNearbyVehicles(coords, radius)
    local vehicles = {}
    local handle, vehicle = FindFirstVehicle()
    local success
    
    repeat
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehicleCoords)
        
        if distance <= radius then
            table.insert(vehicles, vehicle)
        end
        
        success, vehicle = FindNextVehicle(handle)
    until not success
    
    EndFindVehicle(handle)
    return vehicles
end

--- Check if vehicle has collided
---@param vehicle number Vehicle entity
---@param playerVehicle number Player's vehicle entity
---@return boolean
function ClientUtils.HasVehicleCollided(vehicle, playerVehicle)
    return HasEntityCollidedWithAnything(vehicle) or HasEntityCollidedWithAnything(playerVehicle)
end

--- Check if player is driving aggressively
---@param playerVehicle number Player's vehicle entity
---@return boolean
function ClientUtils.IsPlayerDrivingAggressively(playerVehicle)
    local speed = GetEntitySpeed(playerVehicle) * 2.237 -- Convert to mph
    local maxSpeed = GetVehicleModelMaxSpeed(GetEntityModel(playerVehicle)) * 2.237
    
    return speed > (maxSpeed * 0.8) or HasEntityCollidedWithAnything(playerVehicle)
end

--- Check if position is in blacklisted area
---@param coords vector3 Position to check
---@return boolean
function ClientUtils.IsInBlacklistedArea(coords)
    for _, area in pairs(Config.BlacklistedAreas) do
        local distance = #(coords - vector3(area.x, area.y, area.z))
        if distance <= area.radius then
            return true
        end
    end
    return false
end

--- Play rage sound for NPC
---@param npcPed number NPC ped entity
function ClientUtils.PlayRageSound(npcPed)
    if Config.UseCustomSounds and #Config.RageSounds > 0 then
        local sound = Config.RageSounds[math.random(1, #Config.RageSounds)]
        PlayPedAmbientSpeechNative(npcPed, sound, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 0)
    end
end

--- Play rage animation for NPC
---@param npcPed number NPC ped entity
function ClientUtils.PlayRageAnimation(npcPed)
    RequestAnimDict("gestures@m@standing@casual")
    
    while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Wait(100)
    end
    
    TaskPlayAnim(npcPed, "gestures@m@standing@casual", "gesture_point", 8.0, -8.0, 3000, 0, 0, false, false, false)
end

--- Load model with timeout
---@param modelHash number Model hash
---@param timeout number Timeout in ms (default: 5000)
---@return boolean
function ClientUtils.LoadModel(modelHash, timeout)
    timeout = timeout or 5000
    local startTime = GetGameTimer()
    
    RequestModel(modelHash)
    
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() - startTime > timeout then
            print('^1[JM-NPCRoadRage] Model load timeout: ' .. modelHash .. '^7')
            return false
        end
        Wait(100)
    end
    
    return true
end

--- Log weapon information to console
---@param allowedWeapons table List of allowed weapons
function ClientUtils.LogWeaponInfo(allowedWeapons)
    local totalWeapons = #Config.RageWeapons
    local allowedCount = #allowedWeapons
    local blacklistedCount = Config.BlacklistedWeapons and #Config.BlacklistedWeapons or 0
    
    print(string.format('^3[JM-NPCRoadRage] Weapon filtering: %d/%d weapons allowed (%d blacklisted)^7', 
          allowedCount, totalWeapons, blacklistedCount))
    
    if allowedCount == 0 then
        print('^1[JM-NPCRoadRage] WARNING: No weapons available! NPCs will only use fists.^7')
    end
end

return ClientUtils
