local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local rageNPCs = {}
local playerVehicle = nil
local isInVehicle = false

-- Troll cop tracking variables
local trollCops = {}
local lastTrollCopTime = 0
local trollCopSessionCount = 0

-- Filter out blacklisted weapons from the available weapon list
local function GetAllowedWeapons()
    local allowedWeapons = {}
    
    for _, weapon in pairs(Config.RageWeapons) do
        local isBlacklisted = false
        
        -- Check if weapon is in the blacklist
        if Config.BlacklistedWeapons then
            for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
                if weapon == blacklistedWeapon then
                    isBlacklisted = true
                    break
                end
            end
        end
        
        -- Add to allowed list if not blacklisted
        if not isBlacklisted then
            table.insert(allowedWeapons, weapon)
        end
    end
    
    return allowedWeapons
end

-- Get filtered weapon list on resource start
local allowedWeapons = GetAllowedWeapons()

-- Troll cop functions
local function IsPlayerInJurisdiction()
    if not Config.TrollCops.enabled then return false end
    
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    
    for _, jurisdiction in pairs(Config.TrollCops.jurisdictions) do
        if jurisdiction.enabled then
            local distance = #(playerPos - vector3(jurisdiction.coords.x, jurisdiction.coords.y, jurisdiction.coords.z))
            if distance <= jurisdiction.radius then
                return jurisdiction
            end
        end
    end
    
    return false
end

local function CanTriggerTrollCops()
    if not Config.TrollCops.enabled then return false end
    
    local currentTime = GetGameTimer()
    
    -- Check cooldown
    if (currentTime - lastTrollCopTime) < Config.TrollCops.cooldown then
        return false
    end
    
    -- Check session limit
    if trollCopSessionCount >= Config.TrollCops.maxPerSession then
        return false
    end
    
    return true
end

local function SpawnTrollCop(spawnPos, targetPed)
    local copHash = GetHashKey("s_m_y_cop_01")
    RequestModel(copHash)
    
    while not HasModelLoaded(copHash) do
        Wait(100)
    end
    
    local cop = CreatePed(4, copHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)
    
    -- Configure cop
    SetPedAsEnemy(cop, true)
    SetPedCombatAttributes(cop, 5, true)
    SetPedCombatAttributes(cop, 46, true)
    SetPedAccuracy(cop, 75)
    SetPedArmour(cop, 100)
    
    -- Give weapon
    local weaponHash = Config.TrollCops.weapons[math.random(1, #Config.TrollCops.weapons)]
    GiveWeaponToPed(cop, GetHashKey(weaponHash), 250, false, true)
    
    -- Create blip if enabled
    local blip = nil
    if Config.TrollCops.useBlips then
        blip = AddBlipForEntity(cop)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1) -- Red
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Troll Cop")
        EndTextCommandSetBlipName(blip)
    end
    
    -- Make cop attack player
    TaskCombatPed(cop, targetPed, 0, 16)
    
    return {ped = cop, blip = blip, spawnTime = GetGameTimer()}
end

local function TriggerTrollCops(jurisdiction)
    if not CanTriggerTrollCops() then return end
    
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    
    -- Show warning message
    if Config.TrollCops.warningMessage and Config.TrollCops.warningMessage ~= "" then
        QBCore.Functions.Notify(Config.TrollCops.warningMessage, 'error', 5000)
    end
    
    -- Play sirens if enabled
    if Config.TrollCops.useSirens then
        PlaySoundFrontend(-1, "POLICE_HELICOPTER_SPOTLIGHT_MOVEMENT", "HUD_FRONTEND_SOUNDSET", 1)
    end
    
    -- Spawn cops
    local copCount = math.random(Config.TrollCops.copCount.min, Config.TrollCops.copCount.max)
    
    for i = 1, copCount do
        -- Calculate spawn position around player
        local angle = (i / copCount) * 360
        local rad = math.rad(angle)
        local spawnPos = vector3(
            playerPos.x + math.cos(rad) * Config.TrollCops.spawnDistance,
            playerPos.y + math.sin(rad) * Config.TrollCops.spawnDistance,
            playerPos.z
        )
        
        -- Ensure spawn position is on ground
        local groundZ = spawnPos.z
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 10.0, false)
        if foundGround then
            spawnPos = vector3(spawnPos.x, spawnPos.y, groundZ)
        end
        
        local trollCop = SpawnTrollCop(spawnPos, playerPed)
        table.insert(trollCops, trollCop)
    end
    
    -- Update tracking
    lastTrollCopTime = GetGameTimer()
    trollCopSessionCount = trollCopSessionCount + 1
    
    -- Log event
    TriggerServerEvent('jm-npcrage:trollCopTriggered', {
        jurisdiction = jurisdiction.name,
        copCount = copCount,
        playerCoords = playerPos
    })
    
    -- Set timer to stop shooting
    CreateThread(function()
        Wait(Config.TrollCops.shootDuration)
        
        -- Make cops stop shooting and flee
        for _, trollCop in pairs(trollCops) do
            if DoesEntityExist(trollCop.ped) then
                ClearPedTasks(trollCop.ped)
                TaskSmartFleePed(trollCop.ped, playerPed, 100.0, -1, false, false)
            end
        end
        
        -- Remove cops after disappear time
        CreateThread(function()
            Wait(Config.TrollCops.disappearTime - Config.TrollCops.shootDuration)
            
            for i = #trollCops, 1, -1 do
                local trollCop = trollCops[i]
                if DoesEntityExist(trollCop.ped) then
                    if trollCop.blip then
                        RemoveBlip(trollCop.blip)
                    end
                    DeleteEntity(trollCop.ped)
                end
                table.remove(trollCops, i)
            end
        end)
    end)
end

-- Log weapon filtering information
CreateThread(function()
    Wait(1000) -- Wait for resource to fully load
    
    local totalWeapons = #Config.RageWeapons
    local allowedCount = #allowedWeapons
    local blacklistedCount = Config.BlacklistedWeapons and #Config.BlacklistedWeapons or 0
    
    print('^2[JM-NPCRoadRage] Client loaded successfully!^7')
    print(string.format('^3[JM-NPCRoadRage] Weapon filtering: %d/%d weapons allowed (%d blacklisted)^7', 
          allowedCount, totalWeapons, blacklistedCount))
    
    if Config.TrollCops.enabled then
        print('^6[JM-NPCRoadRage] Troll cop system enabled! Use with caution.^7')
    end
    
    if allowedCount == 0 then
        print('^1[JM-NPCRoadRage] WARNING: No weapons available! NPCs will only use fists.^7')
    end
end)
end)

-- Function to reload weapon list (useful for config updates)
local function ReloadWeaponList()
    allowedWeapons = GetAllowedWeapons()
    print(string.format('^2[JM-NPCRoadRage] Weapon list reloaded. %d weapons available (blacklisted weapons filtered out)^7', #allowedWeapons))
end

-- Initialize
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Main road rage detection thread
CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        
        local playerPed = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        
        if currentVehicle ~= 0 then
            isInVehicle = true
            playerVehicle = currentVehicle
            
            -- Check for road rage triggers
            CheckForRoadRageIncidents()
        else
            isInVehicle = false
            playerVehicle = nil
        end
        
        -- Clean up inactive rage NPCs
        CleanupRageNPCs()
    end
end)

function CheckForRoadRageIncidents()
    if not isInVehicle or #rageNPCs >= Config.MaxRageNPCs then
        return
    end
    
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    
    -- Check if in blacklisted area
    if IsInBlacklistedArea(playerPos) then
        return
    end
    
    -- Check for troll cop trigger (separate from road rage)
    if Config.TrollCops.enabled then
        local jurisdiction = IsPlayerInJurisdiction()
        if jurisdiction and math.random(1, 100) <= Config.TrollCops.triggerChance then
            TriggerTrollCops(jurisdiction)
            return -- Don't trigger regular road rage if troll cops are triggered
        end
    end
    
    -- Get nearby vehicles
    local nearbyVehicles = GetNearbyVehicles(playerPos, Config.TriggerDistance)
    
    for _, vehicle in pairs(nearbyVehicles) do
        if vehicle ~= playerVehicle then
            local npcPed = GetPedInVehicleSeat(vehicle, -1)
            
            if npcPed ~= 0 and not IsPedAPlayer(npcPed) and not IsNPCInRage(npcPed) then
                -- Check for collision or aggressive driving
                if HasVehicleCollidedWithPlayer(vehicle) or IsPlayerDrivingAggressively() then
                    if math.random(1, 100) <= Config.RoadRageChance then
                        TriggerRoadRage(npcPed, vehicle)
                    end
                end
            end
        end
    end
end

function TriggerRoadRage(npcPed, npcVehicle)
    if #rageNPCs >= Config.MaxRageNPCs then
        return
    end
    
    local rageData = {
        ped = npcPed,
        vehicle = npcVehicle,
        startTime = GetGameTimer(),
        phase = 'angry', -- angry, attacking, fleeing
        weapon = nil,
        hasNotifiedPolice = false
    }
    
    table.insert(rageNPCs, rageData)
    
    -- Make NPC angry
    SetPedConfigFlag(npcPed, 208, true) -- PED_CONFIG_FLAG_DisableMelee
    SetPedCombatAttributes(npcPed, 5, true) -- BF_CanFightArmedPedsWhenNotArmed
    SetPedCombatAttributes(npcPed, 46, true) -- BF_AlwaysFight
    
    -- Play angry animation/sound
    PlayRageSound(npcPed)
    
    -- Log incident to Discord
    local incidentData = {
        coords = GetEntityCoords(npcPed),
        weapon = nil, -- Will be updated if weapon is used
        policeNotified = false -- Will be updated if police are called
    }
    
    -- Start rage behavior
    CreateThread(function()
        HandleRageBehavior(rageData, incidentData)
    end)
    
    -- Notify police with chance
    if math.random(1, 100) <= Config.PoliceNotifyChance and not rageData.hasNotifiedPolice then
        TriggerServerEvent('jm-npcrage:notifyPolice', GetEntityCoords(npcPed))
        rageData.hasNotifiedPolice = true
        incidentData.policeNotified = true
    end
end

function HandleRageBehavior(rageData, incidentData)
    local npcPed = rageData.ped
    local playerPed = PlayerPedId()
    
    -- Phase 1: Exit vehicle and approach player
    TaskLeaveVehicle(npcPed, rageData.vehicle, 0)
    
    Wait(2000) -- Wait for NPC to exit vehicle
    
    if not DoesEntityExist(npcPed) then
        return
    end
    
    -- Make NPC approach player aggressively
    TaskGoToEntity(npcPed, playerPed, -1, 3.0, 2.0, 1073741824, 0)
    
    Wait(3000)
    
    -- Phase 2: Decide on attack or just yelling
    if math.random(1, 100) <= Config.AttackChance then
        rageData.phase = 'attacking'
        
        -- Decide on weapon use
        if math.random(1, 100) <= Config.WeaponChance then
            -- Use filtered weapon list to exclude blacklisted weapons
            if #allowedWeapons > 0 then
                local weaponHash = allowedWeapons[math.random(1, #allowedWeapons)]
                GiveWeaponToPed(npcPed, GetHashKey(weaponHash), 50, false, true)
                rageData.weapon = weaponHash
                incidentData.weapon = weaponHash
            else
                -- Fallback to fists if no weapons are allowed
                rageData.weapon = nil
                incidentData.weapon = "none"
                print('^3[JM-NPCRoadRage] Warning: No allowed weapons available, NPC will use fists^7')
            end
        end
        
        -- Attack player
        TaskCombatPed(npcPed, playerPed, 0, 16)
        SetPedCombatMovement(npcPed, 2) -- Aggressive movement
        
        -- Monitor player health for actual injury
        CreateThread(function()
            local initialHealth = GetEntityHealth(playerPed)
            local checkCount = 0
            local maxChecks = 20 -- Check for 10 seconds (500ms intervals)
            
            while checkCount < maxChecks and DoesEntityExist(npcPed) do
                Wait(500) -- Check every 500ms
                local currentHealth = GetEntityHealth(playerPed)
                
                -- Only trigger injury if player actually lost health
                if currentHealth < initialHealth then
                    -- Apply injury chance only when player is actually hurt
                    if math.random(1, 100) <= Config.InjuryChance then
                        TriggerServerEvent('jm-npcrage:injurePlayer')
                        break -- Only trigger once per attack
                    end
                    break -- Exit loop whether injury triggered or not
                end
                checkCount = checkCount + 1
            end
        end)
        
    else
        -- Just yell and gesture angrily
        PlayRageAnimation(npcPed)
    end
    
    -- Log the incident after initial behavior is determined
    CreateThread(function()
        Wait(1000) -- Small delay to ensure weapon data is set
        TriggerServerEvent('jm-npcrage:logIncident', incidentData)
    end)
    
    -- Phase 3: Timeout or flee
    Wait(Config.RageTimeout)
    
    if DoesEntityExist(npcPed) then
        if math.random(1, 100) <= Config.FleeChance then
            rageData.phase = 'fleeing'
            TaskSmartFleePed(npcPed, playerPed, 100.0, -1, false, false)
        else
            -- Just calm down
            ClearPedTasks(npcPed)
            SetPedAsNoLongerNeeded(npcPed)
        end
    end
end

function PlayRageSound(npcPed)
    if Config.UseCustomSounds and #Config.RageSounds > 0 then
        local sound = Config.RageSounds[math.random(1, #Config.RageSounds)]
        PlayPedAmbientSpeechNative(npcPed, sound, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 0)
    end
end

function PlayRageAnimation(npcPed)
    RequestAnimDict("gestures@m@standing@casual")
    while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Wait(100)
    end
    
    TaskPlayAnim(npcPed, "gestures@m@standing@casual", "gesture_point", 8.0, -8.0, 3000, 0, 0, false, false, false)
end

function GetNearbyVehicles(coords, radius)
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

function HasVehicleCollidedWithPlayer(vehicle)
    return HasEntityCollidedWithAnything(vehicle) or HasEntityCollidedWithAnything(playerVehicle)
end

function IsPlayerDrivingAggressively()
    local speed = GetEntitySpeed(playerVehicle) * 2.237 -- Convert to mph
    local maxSpeed = GetVehicleModelMaxSpeed(GetEntityModel(playerVehicle)) * 2.237
    
    -- Consider aggressive if going over 80% max speed or recent collision
    return speed > (maxSpeed * 0.8) or HasEntityCollidedWithAnything(playerVehicle)
end

function IsInBlacklistedArea(coords)
    for _, area in pairs(Config.BlacklistedAreas) do
        local distance = #(coords - vector3(area.x, area.y, area.z))
        if distance <= area.radius then
            return true
        end
    end
    return false
end

function IsNPCInRage(npcPed)
    for _, rageData in pairs(rageNPCs) do
        if rageData.ped == npcPed then
            return true
        end
    end
    return false
end

function CleanupRageNPCs()
    for i = #rageNPCs, 1, -1 do
        local rageData = rageNPCs[i]
        
        if not DoesEntityExist(rageData.ped) or 
           GetGameTimer() - rageData.startTime > Config.RageTimeout + 10000 then
            table.remove(rageNPCs, i)
        end
    end
end

-- Event handlers
RegisterNetEvent('jm-npcrage:policeResponse', function(coords)
    QBCore.Functions.Notify('Police have been dispatched to a road rage incident nearby!', 'primary', 5000)
end)

-- Admin commands (for testing)
RegisterCommand('testrage', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)
        
        if vehicle ~= 0 then
            local npcPed = GetPedInVehicleSeat(vehicle, -1)
            if npcPed ~= 0 and not IsPedAPlayer(npcPed) then
                TriggerRoadRage(npcPed, vehicle)
                QBCore.Functions.Notify('Road rage triggered!', 'success')
            else
                QBCore.Functions.Notify('No valid NPC found in nearby vehicle', 'error')
            end
        else
            QBCore.Functions.Notify('No vehicle found nearby', 'error')
        end
    end
end)

RegisterCommand('clearrage', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        for _, rageData in pairs(rageNPCs) do
            if DoesEntityExist(rageData.ped) then
                ClearPedTasks(rageData.ped)
                SetPedAsNoLongerNeeded(rageData.ped)
            end
        end
        rageNPCs = {}
        QBCore.Functions.Notify('All road rage NPCs cleared!', 'success')
    end
end)

RegisterCommand('reloadweapons', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        ReloadWeaponList()
        QBCore.Functions.Notify(string.format('Weapon list reloaded! %d weapons available', #allowedWeapons), 'success', 5000)
    end
end)

RegisterCommand('weaponinfo', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        local totalWeapons = #Config.RageWeapons
        local allowedCount = #allowedWeapons
        local blacklistedCount = Config.BlacklistedWeapons and #Config.BlacklistedWeapons or 0
        local filteredCount = totalWeapons - allowedCount
        
        QBCore.Functions.Notify(string.format(
            'Weapon Stats: Total: %d | Allowed: %d | Blacklisted: %d | Filtered: %d', 
            totalWeapons, allowedCount, blacklistedCount, filteredCount
        ), 'primary', 8000)
        
        -- Print detailed info to console
        print('^2[JM-NPCRoadRage] Weapon Information:^7')
        print(string.format('^3Total weapons configured: %d^7', totalWeapons))
        print(string.format('^2Allowed weapons: %d^7', allowedCount))
        print(string.format('^1Blacklisted weapons: %d^7', blacklistedCount))
        print(string.format('^6Filtered out: %d^7', filteredCount))
        
        if Config.BlacklistedWeapons and #Config.BlacklistedWeapons > 0 then
            print('^1Blacklisted weapons:^7')
            for _, weapon in pairs(Config.BlacklistedWeapons) do
                print('  - ' .. weapon)
            end
        end
    end
end)

-- Troll cop admin commands
RegisterCommand('trollcops', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        if not Config.TrollCops.enabled then
            QBCore.Functions.Notify('Troll cop system is disabled in config!', 'error')
            return
        end
        
        local jurisdiction = IsPlayerInJurisdiction()
        if jurisdiction then
            TriggerTrollCops(jurisdiction)
            QBCore.Functions.Notify('Troll cops triggered in ' .. jurisdiction.name .. '!', 'success')
        else
            QBCore.Functions.Notify('You are not in a troll cop jurisdiction!', 'error')
        end
    end
end)

RegisterCommand('cleartrollcops', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        local clearedCount = 0
        for i = #trollCops, 1, -1 do
            local trollCop = trollCops[i]
            if DoesEntityExist(trollCop.ped) then
                if trollCop.blip then
                    RemoveBlip(trollCop.blip)
                end
                DeleteEntity(trollCop.ped)
                clearedCount = clearedCount + 1
            end
            table.remove(trollCops, i)
        end
        QBCore.Functions.Notify(string.format('Cleared %d troll cops!', clearedCount), 'success')
    end
end)

RegisterCommand('trollcopinfo', function()
    if PlayerData.job and PlayerData.job.name == 'admin' then
        local activeCops = #trollCops
        local jurisdiction = IsPlayerInJurisdiction()
        local jurisdictionName = jurisdiction and jurisdiction.name or "None"
        local canTrigger = CanTriggerTrollCops()
        local nextTriggerIn = math.max(0, Config.TrollCops.cooldown - (GetGameTimer() - lastTrollCopTime))
        
        QBCore.Functions.Notify(string.format(
            'Troll Cops - Active: %d | Jurisdiction: %s | Can Trigger: %s | Session Count: %d/%d',
            activeCops, jurisdictionName, canTrigger and "Yes" or "No", 
            trollCopSessionCount, Config.TrollCops.maxPerSession
        ), 'primary', 8000)
        
        print('^6[JM-NPCRoadRage] Troll Cop Information:^7')
        print(string.format('^3Active troll cops: %d^7', activeCops))
        print(string.format('^3Current jurisdiction: %s^7', jurisdictionName))
        print(string.format('^3Can trigger: %s^7', canTrigger and "Yes" or "No"))
        print(string.format('^3Session count: %d/%d^7', trollCopSessionCount, Config.TrollCops.maxPerSession))
        if nextTriggerIn > 0 then
            print(string.format('^3Next trigger available in: %.1f seconds^7', nextTriggerIn / 1000))
        end
        
        print('^6Available jurisdictions:^7')
        for _, jurisdiction in pairs(Config.TrollCops.jurisdictions) do
            local status = jurisdiction.enabled and "Enabled" or "Disabled"
            print(string.format('  - %s: %s', jurisdiction.name, status))
        end
    end
end)