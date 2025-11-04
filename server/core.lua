-- Server Core Module - Main initialization and utilities

local QBCore = exports['qb-core']:GetCoreObject()

ServerCore = {}

--- Initialize the server
function ServerCore.Init()
    ServerCore.RegisterEvents()
    ServerCore.RegisterCallbacks()
    ServerCore.LogStartup()
end

--- Register core events
function ServerCore.RegisterEvents()
    RegisterNetEvent('jm-npcrage:logIncident', function(incidentData)
        local src = source
        DatabaseModule.LogIncident(src, incidentData)
    end)
    
    RegisterNetEvent('jm-npcrage:trollCopTriggered', function(data)
        local src = source
        PoliceModule.HandleTrollCopEvent(src, data)
    end)
end

--- Register callbacks
function ServerCore.RegisterCallbacks()
    QBCore.Functions.CreateCallback('jm-npcrage:hasPermission', function(source, cb, permission)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then
            cb(false)
            return
        end
        
        cb(QBCore.Functions.HasPermission(source, permission) or Player.PlayerData.job.name == 'admin')
    end)
end

--- Get police online count
---@return number
function ServerCore.GetPoliceOnlineCount()
    local policeCount = 0
    local players = QBCore.Functions.GetPlayers()
    
    for _, playerId in pairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player and Player.PlayerData.job.name == Config.PoliceJob and Player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end
    
    return policeCount
end

--- Get player object safely
---@param source number Player source
---@return table|nil
function ServerCore.GetPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

--- Get player name
---@param source number Player source
---@return string
function ServerCore.GetPlayerName(source)
    local Player = ServerCore.GetPlayer(source)
    if not Player then
        return "Unknown"
    end
    
    return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
end

--- Get player citizen ID
---@param source number Player source
---@return string
function ServerCore.GetPlayerCitizenId(source)
    local Player = ServerCore.GetPlayer(source)
    if not Player then
        return "Unknown"
    end
    
    return Player.PlayerData.citizenid
end

--- Log startup
function ServerCore.LogStartup()
    CreateThread(function()
        Wait(5000)
        print('^2[JM-NPCRoadRage]^7 Server script loaded successfully!')
        
        if Config.Discord.enabled and Config.Discord.webhook ~= "" then
            DiscordModule.SendStartupLog()
        end
    end)
end

-- Initialize on resource start
CreateThread(function()
    ServerCore.Init()
end)

return ServerCore
