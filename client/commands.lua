-- Client Commands Module - Admin commands for testing and management

local QBCore = exports['qb-core']:GetCoreObject()

Commands = {}

--- Check if player has admin permissions
---@return boolean
function Commands.HasPermission()
    return ClientCore.IsPlayerAdmin()
end

--- Test rage command
RegisterCommand('testrage', function()
    if not Commands.HasPermission() then
        return
    end
    
    local coords = ClientCore.GetPlayerPosition()
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)
    
    if vehicle ~= 0 then
        local npcPed = GetPedInVehicleSeat(vehicle, -1)
        if npcPed ~= 0 and not IsPedAPlayer(npcPed) then
            RageModule.TriggerRoadRage(npcPed, vehicle)
            QBCore.Functions.Notify('Road rage triggered!', 'success')
        else
            QBCore.Functions.Notify('No valid NPC found in nearby vehicle', 'error')
        end
    else
        QBCore.Functions.Notify('No vehicle found nearby', 'error')
    end
end)

--- Clear all rage NPCs command
RegisterCommand('clearrage', function()
    if not Commands.HasPermission() then
        return
    end
    
    RageModule.ClearAllRageNPCs()
    QBCore.Functions.Notify('All road rage NPCs cleared!', 'success')
end)

--- Reload weapons list command
RegisterCommand('reloadweapons', function()
    if not Commands.HasPermission() then
        return
    end
    
    RageModule.ReloadWeaponList()
    local stats = RageModule.GetStats()
    QBCore.Functions.Notify(
        string.format('Weapon list reloaded! %d weapons available', stats.allowedWeapons), 
        'success', 
        5000
    )
end)

--- Display weapon information command
RegisterCommand('weaponinfo', function()
    if not Commands.HasPermission() then
        return
    end
    
    local totalWeapons = #Config.RageWeapons
    local stats = RageModule.GetStats()
    local blacklistedCount = Config.BlacklistedWeapons and #Config.BlacklistedWeapons or 0
    local filteredCount = totalWeapons - stats.allowedWeapons
    
    QBCore.Functions.Notify(
        string.format(
            'Weapon Stats: Total: %d | Allowed: %d | Blacklisted: %d | Filtered: %d', 
            totalWeapons, stats.allowedWeapons, blacklistedCount, filteredCount
        ), 
        'primary', 
        8000
    )
    
    -- Console output
    print('^2[JM-NPCRoadRage] Weapon Information:^7')
    print(string.format('^3Total weapons configured: %d^7', totalWeapons))
    print(string.format('^2Allowed weapons: %d^7', stats.allowedWeapons))
    print(string.format('^1Blacklisted weapons: %d^7', blacklistedCount))
    print(string.format('^6Filtered out: %d^7', filteredCount))
    
    if Config.BlacklistedWeapons and #Config.BlacklistedWeapons > 0 then
        print('^1Blacklisted weapons:^7')
        for _, weapon in pairs(Config.BlacklistedWeapons) do
            print('  - ' .. weapon)
        end
    end
end)

--- Trigger troll cops command
RegisterCommand('trollcops', function()
    if not Commands.HasPermission() then
        return
    end
    
    if not Config.TrollCops.enabled then
        QBCore.Functions.Notify('Troll cop system is disabled in config!', 'error')
        return
    end
    
    local jurisdiction = TrollCops.IsPlayerInJurisdiction()
    if jurisdiction then
        TrollCops.Trigger(jurisdiction)
        QBCore.Functions.Notify('Troll cops triggered in ' .. jurisdiction.name .. '!', 'success')
    else
        QBCore.Functions.Notify('You are not in a troll cop jurisdiction!', 'error')
    end
end)

--- Clear all troll cops command
RegisterCommand('cleartrollcops', function()
    if not Commands.HasPermission() then
        return
    end
    
    local clearedCount = #TrollCops.ActiveCops
    TrollCops.ClearAllCops()
    QBCore.Functions.Notify(string.format('Cleared %d troll cops!', clearedCount), 'success')
end)

--- Display troll cop information command
RegisterCommand('trollcopinfo', function()
    if not Commands.HasPermission() then
        return
    end
    
    local stats = TrollCops.GetStats()
    
    QBCore.Functions.Notify(
        string.format(
            'Troll Cops - Active: %d | Jurisdiction: %s | Can Trigger: %s | Session Count: %d/%d',
            stats.activeCops, 
            stats.jurisdiction, 
            stats.canTrigger and "Yes" or "No", 
            stats.sessionCount, 
            stats.maxPerSession
        ), 
        'primary', 
        8000
    )
    
    -- Console output
    print('^6[JM-NPCRoadRage] Troll Cop Information:^7')
    print(string.format('^3Active troll cops: %d^7', stats.activeCops))
    print(string.format('^3Current jurisdiction: %s^7', stats.jurisdiction))
    print(string.format('^3Can trigger: %s^7', stats.canTrigger and "Yes" or "No"))
    print(string.format('^3Session count: %d/%d^7', stats.sessionCount, stats.maxPerSession))
    
    if stats.nextTriggerIn > 0 then
        print(string.format('^3Next trigger available in: %.1f seconds^7', stats.nextTriggerIn / 1000))
    end
    
    print('^6Available jurisdictions:^7')
    for _, jurisdiction in pairs(Config.TrollCops.jurisdictions) do
        local status = jurisdiction.enabled and "Enabled" or "Disabled"
        print(string.format('  - %s: %s', jurisdiction.name, status))
    end
end)

--- Display rage stats command
RegisterCommand('ragestats', function()
    if not Commands.HasPermission() then
        return
    end
    
    local rageStats = RageModule.GetStats()
    
    QBCore.Functions.Notify(
        string.format(
            'Road Rage Stats - Active: %d/%d | Weapons: %d | Chance: %d%%',
            rageStats.activeNPCs,
            rageStats.maxNPCs,
            rageStats.allowedWeapons,
            Config.RoadRageChance
        ),
        'primary',
        8000
    )
    
    print('^2[JM-NPCRoadRage] Road Rage Statistics:^7')
    print(string.format('^3Active rage NPCs: %d/%d^7', rageStats.activeNPCs, rageStats.maxNPCs))
    print(string.format('^3Allowed weapons: %d^7', rageStats.allowedWeapons))
    print(string.format('^3Trigger chance: %d%%^7', Config.RoadRageChance))
    print(string.format('^3Attack chance: %d%%^7', Config.AttackChance))
    print(string.format('^3Weapon chance: %d%%^7', Config.WeaponChance))
end)

return Commands
