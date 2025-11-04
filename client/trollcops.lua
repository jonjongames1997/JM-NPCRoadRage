-- Client Troll Cops Module - Handles troll cop spawning and behavior

local QBCore = exports['qb-core']:GetCoreObject()

TrollCops = {}
TrollCops.ActiveCops = {}
TrollCops.LastTriggerTime = 0
TrollCops.SessionCount = 0

--- Check if player is in a troll cop jurisdiction
---@return table|boolean Jurisdiction data or false
function TrollCops.IsPlayerInJurisdiction()
    if not Config.TrollCops.enabled then
        return false
    end
    
    local playerPos = ClientCore.GetPlayerPosition()
    
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

--- Check if troll cops can be triggered
---@return boolean
function TrollCops.CanTrigger()
    if not Config.TrollCops.enabled then
        return false
    end
    
    local currentTime = GetGameTimer()
    
    if (currentTime - TrollCops.LastTriggerTime) < Config.TrollCops.cooldown then
        return false
    end
    
    if TrollCops.SessionCount >= Config.TrollCops.maxPerSession then
        return false
    end
    
    return true
end

--- Spawn a single troll cop
---@param spawnPos vector3 Spawn position
---@param targetPed number Target ped
---@return table Cop data
function TrollCops.SpawnCop(spawnPos, targetPed)
    local copHash = GetHashKey("s_m_y_cop_01")
    
    if not ClientUtils.LoadModel(copHash) then
        return nil
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
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Troll Cop")
        EndTextCommandSetBlipName(blip)
    end
    
    -- Make cop attack player
    TaskCombatPed(cop, targetPed, 0, 16)
    
    return {
        ped = cop,
        blip = blip,
        spawnTime = GetGameTimer()
    }
end

--- Trigger troll cops event
---@param jurisdiction table Jurisdiction data
function TrollCops.Trigger(jurisdiction)
    if not TrollCops.CanTrigger() then
        return
    end
    
    local playerPed = ClientCore.GetPlayerPed()
    local playerPos = ClientCore.GetPlayerPosition()
    
    -- Show warning
    if Config.TrollCops.warningMessage and Config.TrollCops.warningMessage ~= "" then
        QBCore.Functions.Notify(Config.TrollCops.warningMessage, 'error', 5000)
    end
    
    -- Play sirens
    if Config.TrollCops.useSirens then
        PlaySoundFrontend(-1, "POLICE_HELICOPTER_SPOTLIGHT_MOVEMENT", "HUD_FRONTEND_SOUNDSET", 1)
    end
    
    -- Spawn cops
    local copCount = math.random(Config.TrollCops.copCount.min, Config.TrollCops.copCount.max)
    
    for i = 1, copCount do
        local angle = (i / copCount) * 360
        local rad = math.rad(angle)
        local spawnPos = vector3(
            playerPos.x + math.cos(rad) * Config.TrollCops.spawnDistance,
            playerPos.y + math.sin(rad) * Config.TrollCops.spawnDistance,
            playerPos.z
        )
        
        -- Get ground Z
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 10.0, false)
        if foundGround then
            spawnPos = vector3(spawnPos.x, spawnPos.y, groundZ)
        end
        
        local cop = TrollCops.SpawnCop(spawnPos, playerPed)
        if cop then
            table.insert(TrollCops.ActiveCops, cop)
        end
    end
    
    -- Update tracking
    TrollCops.LastTriggerTime = GetGameTimer()
    TrollCops.SessionCount = TrollCops.SessionCount + 1
    
    -- Log event
    TriggerServerEvent('jm-npcrage:trollCopTriggered', {
        jurisdiction = jurisdiction.name,
        copCount = copCount,
        playerCoords = playerPos
    })
    
    -- Schedule cop behavior
    TrollCops.ScheduleBehavior(playerPed)
end

--- Schedule troll cop behavior (stop shooting, flee, despawn)
---@param playerPed number Player ped
function TrollCops.ScheduleBehavior(playerPed)
    CreateThread(function()
        Wait(Config.TrollCops.shootDuration)
        
        -- Make cops flee
        for _, cop in pairs(TrollCops.ActiveCops) do
            if DoesEntityExist(cop.ped) then
                ClearPedTasks(cop.ped)
                TaskSmartFleePed(cop.ped, playerPed, 100.0, -1, false, false)
            end
        end
        
        -- Despawn cops
        Wait(Config.TrollCops.disappearTime - Config.TrollCops.shootDuration)
        TrollCops.ClearAllCops()
    end)
end

--- Clear all active troll cops
function TrollCops.ClearAllCops()
    for i = #TrollCops.ActiveCops, 1, -1 do
        local cop = TrollCops.ActiveCops[i]
        if DoesEntityExist(cop.ped) then
            if cop.blip then
                RemoveBlip(cop.blip)
            end
            DeleteEntity(cop.ped)
        end
        table.remove(TrollCops.ActiveCops, i)
    end
end

--- Get troll cop stats
---@return table
function TrollCops.GetStats()
    local jurisdiction = TrollCops.IsPlayerInJurisdiction()
    local canTrigger = TrollCops.CanTrigger()
    local nextTriggerIn = math.max(0, Config.TrollCops.cooldown - (GetGameTimer() - TrollCops.LastTriggerTime))
    
    return {
        activeCops = #TrollCops.ActiveCops,
        jurisdiction = jurisdiction and jurisdiction.name or "None",
        canTrigger = canTrigger,
        sessionCount = TrollCops.SessionCount,
        maxPerSession = Config.TrollCops.maxPerSession,
        nextTriggerIn = nextTriggerIn
    }
end

return TrollCops
