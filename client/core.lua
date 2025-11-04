-- Client Core Module - Main initialization and state management

local QBCore = exports['qb-core']:GetCoreObject()

ClientCore = {}
ClientCore.PlayerData = {}
ClientCore.IsInVehicle = false
ClientCore.CurrentVehicle = nil

--- Initialize the client
function ClientCore.Init()
    ClientCore.PlayerData = QBCore.Functions.GetPlayerData()
    ClientCore.StartMainThread()
    ClientCore.RegisterEvents()
    ClientCore.LogStartup()
end

--- Start main monitoring thread
function ClientCore.StartMainThread()
    CreateThread(function()
        while true do
            Wait(1000)
            
            local playerPed = PlayerPedId()
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            
            if currentVehicle ~= 0 then
                ClientCore.IsInVehicle = true
                ClientCore.CurrentVehicle = currentVehicle
            else
                ClientCore.IsInVehicle = false
                ClientCore.CurrentVehicle = nil
            end
        end
    end)
end

--- Register core events
function ClientCore.RegisterEvents()
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        ClientCore.PlayerData = QBCore.Functions.GetPlayerData()
    end)
    
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        ClientCore.PlayerData = {}
    end)
    
    RegisterNetEvent('jm-npcrage:policeResponse', function(coords)
        QBCore.Functions.Notify('Police have been dispatched to a road rage incident nearby!', 'primary', 5000)
    end)
end

--- Log startup information
function ClientCore.LogStartup()
    CreateThread(function()
        Wait(1000)
        print('^2[JM-NPCRoadRage] Client loaded successfully!^7')
        
        if Config.TrollCops.enabled then
            print('^6[JM-NPCRoadRage] Troll cop system enabled! Use with caution.^7')
        end
    end)
end

--- Check if player is admin
---@return boolean
function ClientCore.IsPlayerAdmin()
    return ClientCore.PlayerData.job and ClientCore.PlayerData.job.name == 'admin'
end

--- Get player position
---@return vector3
function ClientCore.GetPlayerPosition()
    return GetEntityCoords(PlayerPedId())
end

--- Get player ped
---@return number
function ClientCore.GetPlayerPed()
    return PlayerPedId()
end

-- Initialize on resource start
CreateThread(function()
    ClientCore.Init()
end)

return ClientCore
