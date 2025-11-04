-- Server Commands Module - Admin commands

local QBCore = exports['qb-core']:GetCoreObject()

ServerCommands = {}

--- Check if player has permission
---@param source number Player source
---@return boolean
function ServerCommands.HasPermission(source)
    local Player = ServerCore.GetPlayer(source)
    if not Player then return false end
    
    return Player.PlayerData.job.name == 'admin' or QBCore.Functions.HasPermission(source, 'admin')
end

--- Display road rage statistics
QBCore.Commands.Add('npcrage-stats', 'View road rage statistics (Admin Only)', {}, false, function(source, args)
    if not ServerCommands.HasPermission(source) then
        TriggerClientEvent('QBCore:Notify', source, 'You don\'t have permission to use this command', 'error')
        return
    end
    
    local policeOnline = ServerCore.GetPoliceOnlineCount()
    local stats = {
        policeOnline = policeOnline,
        minPoliceRequired = Config.MinPoliceOnline,
        rageChance = Config.RoadRageChance,
        maxRageNPCs = Config.MaxRageNPCs
    }
    
    -- Log to Discord
    if Config.Discord.enabled then
        local discordData = {
            player = {
                name = ServerCore.GetPlayerName(source),
                id = source,
                citizenid = ServerCore.GetPlayerCitizenId(source)
            },
            additional = {
                {
                    ["name"] = "📊 Command Used",
                    ["value"] = "/npcrage-stats",
                    ["inline"] = true
                },
                {
                    ["name"] = "👮 Police Online",
                    ["value"] = string.format("%d/%d", policeOnline, Config.MinPoliceOnline),
                    ["inline"] = true
                },
                {
                    ["name"] = "🎲 Rage Chance",
                    ["value"] = Config.RoadRageChance .. "%",
                    ["inline"] = true
                },
                {
                    ["name"] = "🤖 Max NPCs",
                    ["value"] = tostring(Config.MaxRageNPCs),
                    ["inline"] = true
                }
            }
        }
        
        local fields = DiscordModule.CreateFields(discordData)
        
        DiscordModule.SendLog(
            "adminActions",
            "👨‍💼 Admin Command Used",
            "Administrator viewed road rage system statistics.",
            fields,
            Config.Discord.colors.admin
        )
    end
    
    TriggerClientEvent('QBCore:Notify', source, 
        string.format('Road Rage Stats: Police Online: %d/%d, Rage Chance: %d%%, Max NPCs: %d', 
                     stats.policeOnline, stats.minPoliceRequired, stats.rageChance, stats.maxRageNPCs), 
        'primary', 10000)
end)

--- Toggle road rage system
QBCore.Commands.Add('npcrage-toggle', 'Toggle road rage system (Admin Only)', {}, false, function(source, args)
    if not ServerCommands.HasPermission(source) then
        TriggerClientEvent('QBCore:Notify', source, 'You don\'t have permission to use this command', 'error')
        return
    end
    
    -- Log to Discord
    if Config.Discord.enabled then
        local discordData = {
            player = {
                name = ServerCore.GetPlayerName(source),
                id = source,
                citizenid = ServerCore.GetPlayerCitizenId(source)
            },
            additional = {
                {
                    ["name"] = "📊 Command Used",
                    ["value"] = "/npcrage-toggle",
                    ["inline"] = true
                },
                {
                    ["name"] = "⚠️ Note",
                    ["value"] = "Global state management needs implementation",
                    ["inline"] = false
                }
            }
        }
        
        local fields = DiscordModule.CreateFields(discordData)
        
        DiscordModule.SendLog(
            "adminActions",
            "👨‍💼 Admin Command Used",
            "Administrator attempted to toggle road rage system.",
            fields,
            Config.Discord.colors.admin
        )
    end
    
    TriggerClientEvent('QBCore:Notify', source, 
        'Road rage system toggle - implement global state management', 'info')
end)

--- Get player incident history
QBCore.Commands.Add('npcrage-history', 'View a player\'s road rage incident history (Admin Only)', {{name="id", help="Player ID"}}, true, function(source, args)
    if not ServerCommands.HasPermission(source) then
        TriggerClientEvent('QBCore:Notify', source, 'You don\'t have permission to use this command', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('QBCore:Notify', source, 'Invalid player ID', 'error')
        return
    end
    
    local TargetPlayer = ServerCore.GetPlayer(targetId)
    if not TargetPlayer then
        TriggerClientEvent('QBCore:Notify', source, 'Player not found', 'error')
        return
    end
    
    DatabaseModule.GetPlayerStats(TargetPlayer.PlayerData.citizenid, function(stats)
        TriggerClientEvent('QBCore:Notify', source, 
            string.format('Player %s: Total Incidents: %d | Police Called: %d', 
                         ServerCore.GetPlayerName(targetId), 
                         stats.total, 
                         stats.police_notified), 
            'primary', 10000)
    end)
end)

--- Reload configuration
QBCore.Commands.Add('npcrage-reload', 'Reload road rage configuration (Admin Only)', {}, false, function(source, args)
    if not ServerCommands.HasPermission(source) then
        TriggerClientEvent('QBCore:Notify', source, 'You don\'t have permission to use this command', 'error')
        return
    end
    
    -- Note: This would require additional implementation to actually reload config
    TriggerClientEvent('QBCore:Notify', source, 
        'Config reload requested - restart resource to apply changes', 'info')
    
    -- Log to Discord
    if Config.Discord.enabled then
        local discordData = {
            player = {
                name = ServerCore.GetPlayerName(source),
                id = source,
                citizenid = ServerCore.GetPlayerCitizenId(source)
            },
            additional = {
                {
                    ["name"] = "📊 Command Used",
                    ["value"] = "/npcrage-reload",
                    ["inline"] = true
                },
                {
                    ["name"] = "⚠️ Note",
                    ["value"] = "Resource restart recommended for config changes",
                    ["inline"] = false
                }
            }
        }
        
        local fields = DiscordModule.CreateFields(discordData)
        
        DiscordModule.SendLog(
            "adminActions",
            "👨‍💼 Admin Command Used",
            "Administrator requested configuration reload.",
            fields,
            Config.Discord.colors.admin
        )
    end
end)

return ServerCommands
