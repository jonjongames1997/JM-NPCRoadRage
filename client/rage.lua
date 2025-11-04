-- Client Road Rage Module - Handles NPC rage behavior

local QBCore = exports['qb-core']:GetCoreObject()

RageModule = {}
RageModule.ActiveRageNPCs = {}
RageModule.AllowedWeapons = {}

--- Initialize rage module
function RageModule.Init()
    RageModule.AllowedWeapons = ClientUtils.GetAllowedWeapons()
    ClientUtils.LogWeaponInfo(RageModule.AllowedWeapons)
    RageModule.StartMonitoringThread()
end

--- Start monitoring thread for road rage detection
function RageModule.StartMonitoringThread()
    CreateThread(function()
        while true do
            Wait(1000)
            
            if ClientCore.IsInVehicle then
                RageModule.CheckForRoadRageIncidents()
            end
            
            RageModule.CleanupInactiveNPCs()
        end
    end)
end

--- Check for potential road rage triggers
function RageModule.CheckForRoadRageIncidents()
    if #RageModule.ActiveRageNPCs >= Config.MaxRageNPCs then
        return
    end
    
    local playerPos = ClientCore.GetPlayerPosition()
    
    if ClientUtils.IsInBlacklistedArea(playerPos) then
        return
    end
    
    local nearbyVehicles = ClientUtils.GetNearbyVehicles(playerPos, Config.TriggerDistance)
    
    for _, vehicle in pairs(nearbyVehicles) do
        if vehicle ~= ClientCore.CurrentVehicle then
            local npcPed = GetPedInVehicleSeat(vehicle, -1)
            
            if npcPed ~= 0 and not IsPedAPlayer(npcPed) and not RageModule.IsNPCInRage(npcPed) then
                if ClientUtils.HasVehicleCollided(vehicle, ClientCore.CurrentVehicle) or 
                   ClientUtils.IsPlayerDrivingAggressively(ClientCore.CurrentVehicle) then
                    if math.random(1, 100) <= Config.RoadRageChance then
                        RageModule.TriggerRoadRage(npcPed, vehicle)
                    end
                end
            end
        end
    end
end

--- Trigger road rage for an NPC
---@param npcPed number NPC ped entity
---@param npcVehicle number NPC vehicle entity
function RageModule.TriggerRoadRage(npcPed, npcVehicle)
    if #RageModule.ActiveRageNPCs >= Config.MaxRageNPCs then
        return
    end
    
    local rageData = {
        ped = npcPed,
        vehicle = npcVehicle,
        startTime = GetGameTimer(),
        phase = 'angry',
        weapon = nil,
        hasNotifiedPolice = false
    }
    
    table.insert(RageModule.ActiveRageNPCs, rageData)
    
    -- Configure NPC behavior
    SetPedConfigFlag(npcPed, 208, true)
    SetPedCombatAttributes(npcPed, 5, true)
    SetPedCombatAttributes(npcPed, 46, true)
    
    ClientUtils.PlayRageSound(npcPed)
    
    local incidentData = {
        coords = GetEntityCoords(npcPed),
        weapon = nil,
        policeNotified = false
    }
    
    -- Start rage behavior in separate thread
    CreateThread(function()
        RageModule.HandleRageBehavior(rageData, incidentData)
    end)
    
    -- Notify police with chance
    if math.random(1, 100) <= Config.PoliceNotifyChance and not rageData.hasNotifiedPolice then
        TriggerServerEvent('jm-npcrage:notifyPolice', GetEntityCoords(npcPed))
        rageData.hasNotifiedPolice = true
        incidentData.policeNotified = true
    end
end

--- Handle rage behavior sequence
---@param rageData table Rage data table
---@param incidentData table Incident data for logging
function RageModule.HandleRageBehavior(rageData, incidentData)
    local npcPed = rageData.ped
    local playerPed = ClientCore.GetPlayerPed()
    
    -- Phase 1: Exit vehicle
    TaskLeaveVehicle(npcPed, rageData.vehicle, 0)
    Wait(2000)
    
    if not DoesEntityExist(npcPed) then
        return
    end
    
    -- Phase 2: Approach player
    TaskGoToEntity(npcPed, playerPed, -1, 3.0, 2.0, 1073741824, 0)
    Wait(3000)
    
    -- Phase 3: Attack or yell
    if math.random(1, 100) <= Config.AttackChance then
        rageData.phase = 'attacking'
        
        -- Decide on weapon
        if math.random(1, 100) <= Config.WeaponChance then
            if #RageModule.AllowedWeapons > 0 then
                local weaponHash = RageModule.AllowedWeapons[math.random(1, #RageModule.AllowedWeapons)]
                GiveWeaponToPed(npcPed, GetHashKey(weaponHash), 50, false, true)
                rageData.weapon = weaponHash
                incidentData.weapon = weaponHash
            else
                rageData.weapon = nil
                incidentData.weapon = "none"
            end
        end
        
        -- Attack player
        TaskCombatPed(npcPed, playerPed, 0, 16)
        SetPedCombatMovement(npcPed, 2)
        
        -- Monitor for actual player damage
        RageModule.MonitorPlayerDamage(npcPed, playerPed)
    else
        ClientUtils.PlayRageAnimation(npcPed)
    end
    
    -- Log incident
    CreateThread(function()
        Wait(1000)
        TriggerServerEvent('jm-npcrage:logIncident', incidentData)
    end)
    
    -- Phase 4: Timeout
    Wait(Config.RageTimeout)
    
    if DoesEntityExist(npcPed) then
        if math.random(1, 100) <= Config.FleeChance then
            rageData.phase = 'fleeing'
            TaskSmartFleePed(npcPed, playerPed, 100.0, -1, false, false)
        else
            ClearPedTasks(npcPed)
            SetPedAsNoLongerNeeded(npcPed)
        end
    end
end

--- Monitor player for damage and trigger injury system
---@param npcPed number NPC entity
---@param playerPed number Player entity
function RageModule.MonitorPlayerDamage(npcPed, playerPed)
    CreateThread(function()
        local initialHealth = GetEntityHealth(playerPed)
        local checkCount = 0
        local maxChecks = 20
        
        while checkCount < maxChecks and DoesEntityExist(npcPed) do
            Wait(500)
            local currentHealth = GetEntityHealth(playerPed)
            
            if currentHealth < initialHealth then
                if math.random(1, 100) <= Config.InjuryChance then
                    TriggerServerEvent('jm-npcrage:injurePlayer')
                    break
                end
                break
            end
            
            checkCount = checkCount + 1
        end
    end)
end

--- Check if NPC is already in rage
---@param npcPed number NPC ped entity
---@return boolean
function RageModule.IsNPCInRage(npcPed)
    for _, rageData in pairs(RageModule.ActiveRageNPCs) do
        if rageData.ped == npcPed then
            return true
        end
    end
    return false
end

--- Cleanup inactive rage NPCs
function RageModule.CleanupInactiveNPCs()
    for i = #RageModule.ActiveRageNPCs, 1, -1 do
        local rageData = RageModule.ActiveRageNPCs[i]
        
        if not DoesEntityExist(rageData.ped) or 
           GetGameTimer() - rageData.startTime > Config.RageTimeout + 10000 then
            table.remove(RageModule.ActiveRageNPCs, i)
        end
    end
end

--- Reload weapon list (for admin command)
function RageModule.ReloadWeaponList()
    RageModule.AllowedWeapons = ClientUtils.GetAllowedWeapons()
    print(string.format('^2[JM-NPCRoadRage] Weapon list reloaded. %d weapons available^7', #RageModule.AllowedWeapons))
end

--- Clear all rage NPCs (for admin command)
function RageModule.ClearAllRageNPCs()
    for _, rageData in pairs(RageModule.ActiveRageNPCs) do
        if DoesEntityExist(rageData.ped) then
            ClearPedTasks(rageData.ped)
            SetPedAsNoLongerNeeded(rageData.ped)
        end
    end
    RageModule.ActiveRageNPCs = {}
end

--- Get current rage stats
---@return table
function RageModule.GetStats()
    return {
        activeNPCs = #RageModule.ActiveRageNPCs,
        maxNPCs = Config.MaxRageNPCs,
        allowedWeapons = #RageModule.AllowedWeapons
    }
end

-- Initialize on resource start
CreateThread(function()
    Wait(1500)
    RageModule.Init()
end)

return RageModule
