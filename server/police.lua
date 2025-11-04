-- Server Police Module - Handles police notifications and responses

local QBCore = exports['qb-core']:GetCoreObject()

PoliceModule = {}

--- Handle police notification for road rage incident
---@param source number Player source
---@param coords vector3 Incident coordinates
RegisterNetEvent('jm-npcrage:notifyPolice', function(coords)
    local src = source
    local Player = ServerCore.GetPlayer(src)
    
    if not Player then return end
    
    local policeOnline = ServerCore.GetPoliceOnlineCount()
    
    if policeOnline < Config.MinPoliceOnline then
        return
    end
    
    local alertData = {
        title = "Road Rage Incident",
        message = "Reports of aggressive driver attacking civilians",
        coords = coords,
        priority = 2,
        code = "10-54",
        source = src
    }
    
    PoliceModule.SendAlertToPolice(alertData)
    PoliceModule.LogPoliceNotification(src, coords, policeOnline)
    PoliceModule.SchedulePoliceResponse(src, coords)
    
    print(string.format('[JM-NPCRoadRage] Road rage incident reported at %s, %s, %s', 
          coords.x, coords.y, coords.z))
end)

--- Send alert to all online police
---@param alertData table Alert data
function PoliceModule.SendAlertToPolice(alertData)
    TriggerClientEvent('jm-npcrage:policeAlert', -1, alertData)
end

--- Police alert receiver (for individual officers)
RegisterNetEvent('jm-npcrage:policeAlert', function(alertData)
    local src = source
    local Player = ServerCore.GetPlayer(src)
    
    if not Player then return end
    
    if Player.PlayerData.job.name == Config.PoliceJob and Player.PlayerData.job.onduty then
        TriggerClientEvent('qb-policejob:client:policeAlert', src, alertData)
    end
end)

--- Log police notification to Discord
---@param source number Player source
---@param coords vector3 Incident coordinates
---@param policeOnline number Number of police online
function PoliceModule.LogPoliceNotification(source, coords, policeOnline)
    if not Config.Discord.enabled then return end
    
    local discordData = {
        player = {
            name = ServerCore.GetPlayerName(source),
            id = source,
            citizenid = ServerCore.GetPlayerCitizenId(source)
        },
        coords = coords,
        policeNotified = true,
        policeOnline = policeOnline
    }
    
    local fields = DiscordModule.CreateFields(discordData)
    
    DiscordModule.SendLog(
        "policeNotifications",
        "🚔 Police Dispatch Alert",
        string.format("**Code 10-54** - Road rage incident reported\n\n**Responding Units:** %d officers available", policeOnline),
        fields,
        Config.Discord.colors.police
    )
end

--- Schedule police response
---@param source number Player source
---@param coords vector3 Incident coordinates
function PoliceModule.SchedulePoliceResponse(source, coords)
    CreateThread(function()
        Wait(Config.PoliceResponseTime)
        TriggerClientEvent('jm-npcrage:policeResponse', source, coords)
    end)
end

--- Handle troll cop event
---@param source number Player source
---@param data table Event data
function PoliceModule.HandleTrollCopEvent(source, data)
    local Player = ServerCore.GetPlayer(source)
    if not Player then return end
    
    -- Log to Discord
    if Config.Discord.enabled and Config.TrollCops.logToDiscord then
        local discordData = {
            player = {
                name = ServerCore.GetPlayerName(source),
                id = source,
                citizenid = ServerCore.GetPlayerCitizenId(source)
            },
            coords = data.playerCoords,
            additional = {
                {
                    ["name"] = "🚨 Troll Cop Event",
                    ["value"] = "TRIGGERED",
                    ["inline"] = true
                },
                {
                    ["name"] = "📍 Jurisdiction",
                    ["value"] = data.jurisdiction,
                    ["inline"] = true
                },
                {
                    ["name"] = "👮 Cops Spawned",
                    ["value"] = tostring(data.copCount),
                    ["inline"] = true
                },
                {
                    ["name"] = "⚠️ Warning",
                    ["value"] = "This is a troll/entertainment feature",
                    ["inline"] = false
                }
            }
        }
        
        local fields = DiscordModule.CreateFields(discordData)
        
        DiscordModule.SendLog(
            "adminActions",
            "🚨 Troll Cops Activated",
            string.format("**Troll cop event triggered!** %d officers spawned in %s jurisdiction.", 
                         data.copCount, data.jurisdiction),
            fields,
            16711680
        )
    end
    
    -- Log to console
    print(string.format('[JM-NPCRoadRage] Troll cops triggered for %s (%s) in %s - %d cops spawned', 
          ServerCore.GetPlayerName(source), ServerCore.GetPlayerCitizenId(source), 
          data.jurisdiction, data.copCount))
    
    -- Notify admins
    PoliceModule.NotifyAdmins(string.format('Troll cops triggered by %s in %s', 
        ServerCore.GetPlayerName(source), data.jurisdiction))
end

--- Notify all online admins
---@param message string Message to send
function PoliceModule.NotifyAdmins(message)
    local players = QBCore.Functions.GetPlayers()
    for _, playerId in pairs(players) do
        local AdminPlayer = QBCore.Functions.GetPlayer(playerId)
        if AdminPlayer and AdminPlayer.PlayerData.job.name == 'admin' then
            TriggerClientEvent('QBCore:Notify', playerId, message, 'primary', 5000)
        end
    end
end

return PoliceModule
