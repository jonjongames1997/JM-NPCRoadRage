-- Server Discord Module - Handles Discord webhook logging

DiscordModule = {}
DiscordModule.Cooldowns = {}
DiscordModule.Counts = {}
DiscordModule.PendingIncidents = {}

--- Initialize Discord module
function DiscordModule.Init()
    DiscordModule.StartResetThread()
    DiscordModule.StartStatsThread()
end

--- Reset counts every minute
function DiscordModule.StartResetThread()
    CreateThread(function()
        while true do
            Wait(60000)
            DiscordModule.Counts = {}
        end
    end)
end

--- Start hourly stats thread if enabled
function DiscordModule.StartStatsThread()
    if not Config.Discord.logEvents.systemStats then
        return
    end
    
    CreateThread(function()
        while true do
            Wait(3600000) -- 1 hour
            DiscordModule.SendStatsLog()
        end
    end)
end

--- Check if log can be sent
---@param logType string Type of log
---@return boolean
function DiscordModule.CanSendLog(logType)
    if not Config.Discord.enabled or Config.Discord.webhook == "" then
        return false
    end
    
    if not Config.Discord.logEvents[logType] then
        return false
    end
    
    if not Config.Discord.spamPrevention.enabled then
        return true
    end
    
    -- Check quiet hours
    if DiscordModule.IsQuietHours(logType) then
        return false
    end
    
    -- Check cooldowns
    local currentTime = GetGameTimer()
    if DiscordModule.Cooldowns[logType] and 
       (currentTime - DiscordModule.Cooldowns[logType]) < Config.Discord.spamPrevention.cooldownTime then
        return false
    end
    
    -- Check rate limits
    DiscordModule.Counts[logType] = DiscordModule.Counts[logType] or 0
    if DiscordModule.Counts[logType] >= Config.Discord.spamPrevention.maxLogsPerMinute then
        return false
    end
    
    return true
end

--- Check if currently in quiet hours
---@param logType string Type of log
---@return boolean
function DiscordModule.IsQuietHours(logType)
    if not Config.Discord.spamPrevention.quietHours.enabled then
        return false
    end
    
    local currentHour = tonumber(os.date("%H"))
    local startHour = Config.Discord.spamPrevention.quietHours.startHour
    local endHour = Config.Discord.spamPrevention.quietHours.endHour
    
    local isQuietTime = false
    if startHour <= endHour then
        isQuietTime = currentHour >= startHour and currentHour < endHour
    else
        isQuietTime = currentHour >= startHour or currentHour < endHour
    end
    
    if isQuietTime then
        for _, reducedType in pairs(Config.Discord.spamPrevention.quietHours.reducedTypes) do
            if logType == reducedType then
                return true
            end
        end
    end
    
    return false
end

--- Update tracking
---@param logType string Type of log
function DiscordModule.UpdateTracking(logType)
    if Config.Discord.spamPrevention.enabled then
        DiscordModule.Cooldowns[logType] = GetGameTimer()
        DiscordModule.Counts[logType] = (DiscordModule.Counts[logType] or 0) + 1
    end
end

--- Send Discord log
---@param logType string Type of log
---@param title string Log title
---@param message string Log message
---@param fields table Log fields
---@param color number Embed color
function DiscordModule.SendLog(logType, title, message, fields, color)
    if not DiscordModule.CanSendLog(logType) then
        if Config.Discord.spamPrevention.combineIncidents and logType == "roadRageIncidents" then
            DiscordModule.CombineIncident(title, message, fields, color)
        end
        return
    end
    
    DiscordModule.SendLogDirect(logType, title, message, fields, color)
    DiscordModule.UpdateTracking(logType)
end

--- Send log directly (bypasses spam prevention)
---@param logType string Type of log
---@param title string Log title
---@param message string Log message
---@param fields table Log fields
---@param color number Embed color
function DiscordModule.SendLogDirect(logType, title, message, fields, color)
    if not Config.Discord.enabled or Config.Discord.webhook == "" then
        return
    end
    
    local embeds = {{
        ["title"] = title,
        ["description"] = message,
        ["type"] = "rich",
        ["color"] = color or Config.Discord.colors.system,
        ["fields"] = fields or {},
        ["footer"] = {
            ["text"] = "JM NPC Road Rage System • " .. Config.Discord.serverName,
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }}
    
    if Config.Discord.includeThumbnail then
        embeds[1]["thumbnail"] = {
            ["url"] = "https://i.imgur.com/4M34hi2.png"
        }
    end
    
    local payload = {
        username = Config.Discord.botName,
        embeds = embeds
    }
    
    if Config.Discord.avatar and Config.Discord.avatar ~= "" then
        payload.avatar_url = Config.Discord.avatar
    end
    
    -- Add role mentions
    local content = DiscordModule.GetMention(logType)
    if content ~= "" then
        payload.content = content
    end
    
    PerformHttpRequest(Config.Discord.webhook, function(statusCode, responseText, headers)
        if statusCode ~= 200 and statusCode ~= 204 then
            print(string.format('^1[JM-NPCRoadRage] Discord webhook error: status=%s, response=%s^7', 
                  tostring(statusCode), tostring(responseText)))
        end
    end, 'POST', json.encode(payload), {['Content-Type'] = 'application/json'})
end

--- Get role mention for log type
---@param logType string Type of log
---@return string
function DiscordModule.GetMention(logType)
    if logType == "adminActions" and Config.Discord.mentionRoles.adminRole ~= "" then
        return string.format("<@&%s>", Config.Discord.mentionRoles.adminRole)
    elseif logType == "policeNotifications" and Config.Discord.mentionRoles.policeRole ~= "" then
        return string.format("<@&%s>", Config.Discord.mentionRoles.policeRole)
    end
    return ""
end

--- Combine multiple incidents
---@param title string Log title
---@param message string Log message
---@param fields table Log fields
---@param color number Embed color
function DiscordModule.CombineIncident(title, message, fields, color)
    if not DiscordModule.PendingIncidents.count then
        DiscordModule.PendingIncidents.count = 0
        DiscordModule.PendingIncidents.lastTime = GetGameTimer()
    end
    
    DiscordModule.PendingIncidents.count = DiscordModule.PendingIncidents.count + 1
    
    if DiscordModule.PendingIncidents.count >= 10 or 
       (GetGameTimer() - DiscordModule.PendingIncidents.lastTime) >= 300000 then
        
        local combinedFields = {
            {
                ["name"] = "📊 Multiple Incidents",
                ["value"] = string.format("%d road rage incidents occurred in the last few minutes", 
                                        DiscordModule.PendingIncidents.count),
                ["inline"] = false
            },
            {
                ["name"] = "⏰ Time Period",
                ["value"] = string.format("Last %d minutes", 
                                        math.floor((GetGameTimer() - DiscordModule.PendingIncidents.lastTime) / 60000)),
                ["inline"] = true
            }
        }
        
        DiscordModule.SendLogDirect(
            "roadRageIncidents",
            "🚗💥 Multiple Road Rage Incidents",
            string.format("**%d Road Rage Incidents** occurred recently. Logging has been combined to reduce spam.", 
                         DiscordModule.PendingIncidents.count),
            combinedFields,
            Config.Discord.colors.incident
        )
        
        DiscordModule.PendingIncidents.count = 0
        DiscordModule.PendingIncidents.lastTime = GetGameTimer()
    end
end

--- Create Discord fields from data
---@param data table Data to create fields from
---@return table
function DiscordModule.CreateFields(data)
    local fields = {}
    
    if data.player and Config.Discord.includePlayerInfo then
        table.insert(fields, {
            ["name"] = "👤 Player",
            ["value"] = string.format("%s (ID: %s)", data.player.name or "Unknown", data.player.id or "N/A"),
            ["inline"] = true
        })
        
        if data.player.citizenid then
            table.insert(fields, {
                ["name"] = "🆔 Citizen ID",
                ["value"] = data.player.citizenid,
                ["inline"] = true
            })
        end
    end
    
    if data.coords and Config.Discord.includeCoordinates then
        table.insert(fields, {
            ["name"] = "📍 Location",
            ["value"] = Utils.FormatCoords(data.coords),
            ["inline"] = false
        })
    end
    
    if data.weapon and Config.Discord.includeWeaponInfo then
        table.insert(fields, {
            ["name"] = "🔫 Weapon Used",
            ["value"] = data.weapon == "none" and "Fists" or data.weapon,
            ["inline"] = true
        })
    end
    
    if data.policeNotified ~= nil then
        table.insert(fields, {
            ["name"] = "👮 Police Notified",
            ["value"] = data.policeNotified and "✅ Yes" or "❌ No",
            ["inline"] = true
        })
    end
    
    if data.policeOnline then
        table.insert(fields, {
            ["name"] = "👮 Police Online",
            ["value"] = string.format("%d officers", data.policeOnline),
            ["inline"] = true
        })
    end
    
    if data.additional then
        for _, field in pairs(data.additional) do
            table.insert(fields, field)
        end
    end
    
    return fields
end

--- Send startup log
function DiscordModule.SendStartupLog()
    local startupData = {
        additional = {
            {
                ["name"] = "🟢 Status",
                ["value"] = "System Online",
                ["inline"] = true
            },
            {
                ["name"] = "📊 Settings",
                ["value"] = string.format("Rage Chance: %d%%\nMax NPCs: %d\nMin Police: %d", 
                          Config.RoadRageChance, Config.MaxRageNPCs, Config.MinPoliceOnline),
                ["inline"] = true
            },
            {
                ["name"] = "🔧 Version",
                ["value"] = "v1.0.0",
                ["inline"] = true
            }
        }
    }
    
    local fields = DiscordModule.CreateFields(startupData)
    
    DiscordModule.SendLog(
        "system",
        "🚀 Road Rage System Started",
        string.format("**%s** road rage system has been initialized and is now monitoring traffic incidents.", 
                     Config.Discord.serverName),
        fields,
        Config.Discord.colors.system
    )
end

--- Send stats log
function DiscordModule.SendStatsLog()
    local policeOnline = ServerCore.GetPoliceOnlineCount()
    local playerCount = #GetPlayers()
    
    local statsData = {
        additional = {
            {
                ["name"] = "👥 Players Online",
                ["value"] = tostring(playerCount),
                ["inline"] = true
            },
            {
                ["name"] = "👮 Police Online",
                ["value"] = string.format("%d/%d", policeOnline, Config.MinPoliceOnline),
                ["inline"] = true
            },
            {
                ["name"] = "⚙️ System Status",
                ["value"] = "Active",
                ["inline"] = true
            }
        }
    }
    
    local fields = DiscordModule.CreateFields(statsData)
    
    DiscordModule.SendLog(
        "systemStats",
        "📈 Hourly Statistics",
        "Automated system statistics report.",
        fields,
        Config.Discord.colors.system
    )
end

-- Initialize on resource start
CreateThread(function()
    Wait(2000)
    DiscordModule.Init()
end)

return DiscordModule
