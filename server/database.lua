-- Server Database Module - Handles incident logging and player injuries

local QBCore = exports['qb-core']:GetCoreObject()

DatabaseModule = {}

--- Handle player injury
RegisterNetEvent('jm-npcrage:injurePlayer', function()
    local src = source
    local Player = ServerCore.GetPlayer(src)
    
    if not Player then return end
    
    local playerPed = GetPlayerPed(src)
    local currentHealth = GetEntityHealth(playerPed)
    local maxHealth = GetEntityMaxHealth(playerPed)
    
    -- Validate health damage
    if currentHealth >= maxHealth then
        print(string.format('[JM-NPCRoadRage] Injury blocked for %s - no health damage detected', 
              ServerCore.GetPlayerName(src)))
        return
    end
    
    -- Apply injury
    local injuryLevel = math.random(1, 4)
    TriggerClientEvent('hospital:client:SetInjury', src, 'head', injuryLevel)
    TriggerClientEvent('QBCore:Notify', src, 'You have been injured in the road rage incident!', 'error', 8000)
    
    -- Add stress if using stress system
    TriggerClientEvent('hud:client:UpdateStress', src, math.random(15, 30))
    
    -- Log to Discord
    DatabaseModule.LogInjury(src, currentHealth, maxHealth, injuryLevel)
    
    print(string.format('[JM-NPCRoadRage] Player %s (%s) injured in road rage incident (Health: %.0f/%.0f)', 
          ServerCore.GetPlayerName(src), ServerCore.GetPlayerCitizenId(src), currentHealth, maxHealth))
end)

--- Log player injury to Discord
---@param source number Player source
---@param currentHealth number Current health
---@param maxHealth number Max health
---@param injuryLevel number Injury severity level
function DatabaseModule.LogInjury(source, currentHealth, maxHealth, injuryLevel)
    if not Config.Discord.enabled then return end
    
    local coords = GetEntityCoords(GetPlayerPed(source))
    
    local discordData = {
        player = {
            name = ServerCore.GetPlayerName(source),
            id = source,
            citizenid = ServerCore.GetPlayerCitizenId(source)
        },
        coords = coords,
        additional = {
            {
                ["name"] = "🏥 Injury Type",
                ["value"] = "Head injury (severity: " .. injuryLevel .. "/4)",
                ["inline"] = true
            },
            {
                ["name"] = "💊 Medical Attention",
                ["value"] = "Required",
                ["inline"] = true
            },
            {
                ["name"] = "❤️ Health Status",
                ["value"] = string.format("%.0f/%.0f HP", currentHealth, maxHealth),
                ["inline"] = true
            }
        }
    }
    
    local fields = DiscordModule.CreateFields(discordData)
    
    DiscordModule.SendLog(
        "playerInjuries",
        "🚑 Player Injured",
        "**Medical Emergency** - Player injured during road rage incident and requires medical attention.",
        fields,
        Config.Discord.colors.injury
    )
end

--- Log incident to database and Discord
---@param source number Player source
---@param incidentData table Incident data
function DatabaseModule.LogIncident(source, incidentData)
    local Player = ServerCore.GetPlayer(source)
    if not Player then return end
    
    -- Database logging (optional - uncomment and configure for your database)
    --[[
    exports.oxmysql:execute('INSERT INTO npc_road_rage_incidents (citizenid, coords, weapon_used, police_notified, timestamp) VALUES (?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        json.encode(incidentData.coords),
        incidentData.weapon or 'none',
        incidentData.policeNotified and 1 or 0,
        os.time()
    })
    --]]
    
    -- Discord logging
    if not Config.Discord.enabled then return end
    
    local discordData = {
        player = {
            name = ServerCore.GetPlayerName(source),
            id = source,
            citizenid = ServerCore.GetPlayerCitizenId(source)
        },
        coords = incidentData.coords,
        weapon = incidentData.weapon or "none",
        policeNotified = incidentData.policeNotified,
        additional = {
            {
                ["name"] = "⏰ Incident Time",
                ["value"] = Utils.GetTimestamp(),
                ["inline"] = true
            },
            {
                ["name"] = "🎯 Incident Type",
                ["value"] = "NPC Road Rage Attack",
                ["inline"] = true
            }
        }
    }
    
    local fields = DiscordModule.CreateFields(discordData)
    
    local description = string.format(
        "**Road Rage Incident Occurred**\n\nAn NPC has attacked a player due to aggressive driving behavior.\n\n**Weapon Used:** %s\n**Police Response:** %s",
        incidentData.weapon and incidentData.weapon ~= "none" and incidentData.weapon or "Fists",
        incidentData.policeNotified and "✅ Dispatched" or "❌ Not called"
    )
    
    DiscordModule.SendLog(
        "roadRageIncidents",
        "🚗💥 Road Rage Incident",
        description,
        fields,
        Config.Discord.colors.incident
    )
end

--- Create database table (optional - for oxmysql)
function DatabaseModule.CreateTable()
    --[[
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS npc_road_rage_incidents (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            coords TEXT NOT NULL,
            weapon_used VARCHAR(100),
            police_notified TINYINT(1) DEFAULT 0,
            timestamp INT NOT NULL,
            INDEX idx_citizenid (citizenid),
            INDEX idx_timestamp (timestamp)
        )
    ]], {}, function(result)
        print('^2[JM-NPCRoadRage] Database table created successfully^7')
    end)
    --]]
end

--- Get incident statistics for a player
---@param citizenid string Player citizen ID
---@param callback function Callback function
function DatabaseModule.GetPlayerStats(citizenid, callback)
    --[[
    exports.oxmysql:execute('SELECT COUNT(*) as total, SUM(police_notified) as police_notified FROM npc_road_rage_incidents WHERE citizenid = ?', {
        citizenid
    }, function(result)
        if result and result[1] then
            callback(result[1])
        else
            callback({total = 0, police_notified = 0})
        end
    end)
    --]]
    
    -- Fallback if not using database
    callback({total = 0, police_notified = 0})
end

return DatabaseModule
