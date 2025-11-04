Config = {}

-- ============================================
-- CORE SETTINGS
-- ============================================

Config.Debug = false -- Enable debug mode (additional console logging)
Config.Version = "1.0.0" -- Script version

-- ============================================
-- ROAD RAGE SETTINGS
-- ============================================

Config.RoadRageChance = 15 -- Percentage chance for road rage to trigger (1-100)
Config.TriggerDistance = 20.0 -- Distance to check for collisions/incidents (in game units)
Config.RageTimeout = 30000 -- Time in ms before NPC calms down
Config.MaxRageNPCs = 5 -- Maximum concurrent road rage NPCs
Config.InjuryChance = 30 -- Chance player gets injured requiring medical attention (1-100)

-- ============================================
-- NPC BEHAVIOR SETTINGS
-- ============================================

Config.AttackChance = 70 -- Chance NPC will attack vs just yell (1-100)
Config.WeaponChance = 40 -- Chance NPC will use weapon vs fists (1-100)
Config.FleeChance = 20 -- Chance NPC will flee after initial rage (1-100)

-- ============================================
-- WEAPON SETTINGS
-- ============================================

-- Weapons NPCs can potentially use (filtered by blacklist)
Config.RageWeapons = {
    'WEAPON_KNIFE',
    'WEAPON_BAT',
    'WEAPON_CROWBAR',
    'WEAPON_HAMMER',
    'WEAPON_PISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_BOTTLE',
    'WEAPON_SWITCHBLADE',
    'WEAPON_BATTLEAXE',
    'WEAPON_MACHETE',
    'WEAPON_BZGAS',
    'WEAPON_MOLOTOV'
}

-- Blacklisted weapons (NPCs will NEVER use these - for safety/balance)
Config.BlacklistedWeapons = {
    'WEAPON_STICKYBOMB',        -- Sticky bombs
    'WEAPON_GRENADELAUNCHER',   -- Grenade launcher
    'WEAPON_RPG',               -- RPG
    'WEAPON_MINIGUN',           -- Minigun
    'WEAPON_RAILGUN',           -- Railgun
    'WEAPON_HOMINGLAUNCHER',    -- Homing launcher
    'WEAPON_COMPACTLAUNCHER',   -- Compact launcher
    'WEAPON_WIDOWMAKER',        -- Widowmaker
    'WEAPON_RAYMINIGUN',        -- Ray minigun
    'WEAPON_EMPLAUNCHER',       -- EMP launcher
    'WEAPON_GRENADE',           -- Hand grenades
    'WEAPON_PROXMINE',          -- Proximity mines
    'WEAPON_PIPEBOMB',          -- Pipe bombs
    'WEAPON_SMOKEGRENADE',      -- Smoke grenades
    'WEAPON_FLARE',             -- Flares
    'WEAPON_PETROLCAN',         -- Petrol can
    'WEAPON_FIREEXTINGUISHER',  -- Fire extinguisher
}

-- ============================================
-- POLICE INTEGRATION SETTINGS
-- ============================================

Config.PoliceNotifyChance = 80 -- Chance police will be notified (1-100)
Config.PoliceJob = 'police' -- QBCore police job name
Config.PoliceResponseTime = 120000 -- Time in ms for police response
Config.MinPoliceOnline = 2 -- Minimum police online for notifications

-- ============================================
-- TROLL COP FEATURE (ADMIN ONLY - ENTERTAINMENT)
-- ============================================
-- WARNING: This is a comedic/entertainment feature for testing
-- Should be used carefully and disabled on serious RP servers

Config.TrollCops = {
    enabled = false,                -- Enable/disable troll cop feature (ADMIN COMMAND ONLY)
    triggerChance = 5,             -- Chance to trigger troll cops (1-100) - Very low by default
    
    -- Specific jurisdictions where troll cops can spawn
    jurisdictions = {
        {
            name = "Sandy Shores Sheriff",
            coords = {x = 1853.0, y = 3686.0, z = 34.0}, -- Sandy Shores area
            radius = 500.0,
            enabled = true
        },
        {
            name = "Paleto Bay Police",
            coords = {x = -448.0, y = 6008.0, z = 31.0}, -- Paleto Bay area
            radius = 400.0,
            enabled = true
        },
        {
            name = "Downtown LSPD",
            coords = {x = 425.0, y = -979.0, z = 30.0}, -- Mission Row PD
            radius = 300.0,
            enabled = false -- Disabled by default for main city
        },
        {
            name = "Vespucci Beach",
            coords = {x = -1108.0, y = -1528.0, z = 4.0}, -- Beach area
            radius = 350.0,
            enabled = true
        }
    },
    
    -- Troll cop behavior
    copCount = {min = 2, max = 4},     -- Number of cops to spawn
    weapons = {                        -- Weapons troll cops use
        'WEAPON_PISTOL',
        'WEAPON_SMG',
        'WEAPON_CARBINERIFLE'
    },
    spawnDistance = 50.0,              -- Distance to spawn cops from player
    shootDuration = 15000,             -- How long cops will shoot (15 seconds)
    disappearTime = 30000,             -- Time before cops disappear (30 seconds)
    
    -- Admin controls
    adminOnly = true,                  -- Only admins can trigger manually
    logToDiscord = true,               -- Log troll cop events to Discord
    warningMessage = "⚠️ TROLL COPS INCOMING! ⚠️", -- Message shown to player
    
    -- Cooldown system
    cooldown = 300000,                 -- 5 minute cooldown between troll cop events
    maxPerSession = 3,                 -- Maximum troll cop events per server session
    
    -- Special effects
    useBlips = true,                   -- Show red blips for troll cops
    useSirens = true,                  -- Play police sirens
    useSpotlight = false,              -- Use police spotlight (can be laggy)
}

-- ============================================
-- SAFE ZONES (NO ROAD RAGE)
-- ============================================

-- Areas where road rage will never trigger
Config.BlacklistedAreas = {
    {x = -545.0, y = -204.0, z = 38.0, radius = 100.0}, -- Hospital
    {x = 440.0, y = -982.0, z = 30.0, radius = 150.0}, -- Police Station
    {x = -1037.0, y = -2737.0, z = 20.0, radius = 200.0}, -- Airport
    -- Add more safe zones as needed
}

-- ============================================
-- SOUND SETTINGS
-- ============================================

Config.UseCustomSounds = true
Config.RageSounds = {
    'GENERIC_INSULT_HIGH',
    'GENERIC_INSULT_MED',
    'GENERIC_CURSE_HIGH',
    'GENERIC_CURSE_MED',
    'PROVOKE_RESP'
}

-- ============================================
-- DISCORD WEBHOOK INTEGRATION
-- ============================================

Config.Discord = {
    enabled = true, -- Set to false to disable Discord logging
    webhook = "", -- Your Discord webhook URL (REQUIRED if enabled = true)
    botName = "Road Rage Bot",
    serverName = "Your Server Name", -- Change this to your server name
    avatar = "https://i.imgur.com/4M34hi2.png", -- Bot avatar URL (optional)
    
    -- Webhook colors (decimal format)
    colors = {
        incident = 16776960, -- Orange - Road rage incident
        police = 3447003,    -- Blue - Police notification
        injury = 15158332,   -- Red - Player injury
        admin = 9442302,     -- Purple - Admin actions
        system = 65280       -- Green - System messages
    },
    
    -- What events to log
    logEvents = {
        roadRageIncidents = true,  -- Log when road rage is triggered
        policeNotifications = true, -- Log when police are notified
        playerInjuries = true,     -- Log when players get injured
        adminActions = true,       -- Log admin command usage
        systemStats = false        -- Log system statistics (hourly)
    },
    
    -- Anti-spam settings
    spamPrevention = {
        enabled = true,                 -- Enable spam prevention
        cooldownTime = 60000,          -- Cooldown between similar logs (60 seconds)
        maxLogsPerMinute = 5,          -- Maximum logs per minute per type
        combineIncidents = true,       -- Combine multiple incidents into single log
        quietHours = {                 -- Reduce logging during specific hours
            enabled = false,
            startHour = 2,             -- 2 AM
            endHour = 8,               -- 8 AM
            reducedTypes = {"roadRageIncidents", "policeNotifications"}
        }
    },
    
    -- Advanced settings
    includePlayerInfo = true,      -- Include player name and ID in logs
    includeCoordinates = true,     -- Include incident coordinates
    includeWeaponInfo = true,      -- Include weapon used information
    includeThumbnail = true,       -- Include server thumbnail
    mentionRoles = {
        adminRole = "",            -- Discord role ID to mention for admin logs (optional)
        policeRole = ""            -- Discord role ID to mention for police logs (optional)
    }
}