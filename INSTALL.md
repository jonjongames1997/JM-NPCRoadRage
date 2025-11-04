# 🚀 Installation Guide - JM-NPCRoadRage v1.1.0

<div align="center">

[![Installation](https://img.shields.io/badge/Difficulty-Easy-green.svg)](https://github.com/your-repo)
[![Time](https://img.shields.io/badge/Setup_Time-10_minutes-blue.svg)](#quick-setup)
[![Support](https://img.shields.io/badge/Support-Available-purple.svg)](#-support--troubleshooting)

*Complete installation guide for the advanced FiveM road rage system*

</div>

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Setup](#-quick-setup)
- [Detailed Installation](#-detailed-installation)
- [Configuration Guide](#-configuration-guide)
- [Discord Integration](#-discord-integration)
- [Testing & Verification](#-testing--verification)
- [Performance Optimization](#-performance-optimization)
- [Troubleshooting](#-troubleshooting)
- [Advanced Setup](#-advanced-setup)

---

## ✅ Prerequisites

### 📦 **Required Dependencies**

| Dependency | Version | Status | Download Link |
|------------|---------|--------|---------------|
| **QBCore Framework** | v1.0+ | 🔴 **Required** | [GitHub](https://github.com/qbcore-framework/qb-core) |
| **qb-policejob** | Latest | 🔴 **Required** | [GitHub](https://github.com/qbcore-framework/qb-policejob) |
| **qb-ambulancejob** | Latest | 🔴 **Required** | [GitHub](https://github.com/qbcore-framework/qb-ambulancejob) |
| **MySQL Database** | 5.7+ | 🟡 **Optional** | [Installation Guide](https://dev.mysql.com/doc/) |

### 🔧 **Optional Dependencies**

| Dependency | Purpose | Status |
|------------|---------|--------|
| **qb-target** | Enhanced interactions | 🟢 **Optional** |
| **qb-hud** | Stress system integration | 🟢 **Optional** |
| **Discord Webhook** | Event logging | 🟢 **Recommended** |

### 🖥️ **Server Requirements**

- **FiveM Server Artifacts**: Build 4752 or higher
- **RAM**: Minimum 4GB (8GB+ recommended)
- **CPU**: Multi-core processor recommended
- **OneSync**: Infinity (recommended for best performance)

---

## 🚀 Quick Setup

### ⚡ **5-Minute Installation**

```bash
# 1. Navigate to your resources folder
cd /path/to/your/fivem/server/resources

# 2. Clone or download the script
git clone https://github.com/your-repo/JM-NPCRoadRage.git

# 3. Add to server.cfg
echo "ensure JM-NPCRoadRage" >> server.cfg

# 4. Restart your server
# Script is now ready with default settings!
```

### 🎯 **Default Configuration**
The script comes pre-configured with balanced settings:
- **Road Rage Chance**: 15% trigger rate
- **Injury Chance**: 30% when hit
- **Max Concurrent NPCs**: 5
- **Safe Zones**: Hospital, Police Station, Airport

---

## 📖 Detailed Installation

### 📁 **Step 1: File Setup**

1. **Download the Script**
   ```bash
   # Option A: Git Clone (recommended)
   git clone https://github.com/your-repo/JM-NPCRoadRage.git
   
   # Option B: Manual Download
   # Download ZIP and extract to resources folder
   ```

2. **Verify File Structure**
   ```
   resources/
   └── JM-NPCRoadRage/
       ├── fxmanifest.lua
       ├── config.lua
       ├── database.sql
       ├── client/
       │   └── main.lua
       ├── server/
       │   └── main.lua
       └── locales/
           └── en.lua
   ```

3. **Check File Permissions**
   ```bash
   # Ensure files are readable
   chmod -R 755 JM-NPCRoadRage/
   ```

### ⚙️ **Step 2: Server Configuration**

1. **Add to server.cfg**
   ```cfg
   # Add this line to your server.cfg
   ensure JM-NPCRoadRage
   
   # Optional: Set debug mode
   setr jm_npcrage_debug "false"
   ```

2. **Dependency Order** (Important!)
   ```cfg
   # Ensure dependencies load first
   ensure qb-core
   ensure qb-policejob
   ensure qb-ambulancejob
   
   # Then load road rage script
   ensure JM-NPCRoadRage
   ```

### 🗄️ **Step 3: Database Setup** (Optional)

```sql
-- Import database.sql for incident logging
-- This step is optional but recommended for statistics

USE your_database_name;
SOURCE database.sql;

-- Verify table creation
SHOW TABLES LIKE 'npc_road_rage_incidents';
```

---

## ⚙️ Configuration Guide

### 🎯 **Basic Configuration**

Edit `config.lua` to customize the experience:

```lua
-- Basic Behavior Settings
Config.RoadRageChance = 15        -- 15% chance (1-100)
Config.AttackChance = 70          -- 70% will attack vs yell
Config.WeaponChance = 40          -- 40% will use weapons
Config.InjuryChance = 30          -- 30% injury chance on hit
Config.FleeChance = 20            -- 20% will flee after rage

-- Performance Settings
Config.MaxRageNPCs = 5            -- Max concurrent NPCs
Config.TriggerDistance = 20.0     -- Detection radius (meters)
Config.RageTimeout = 30000        -- 30 seconds before calming down

-- Police Integration
Config.PoliceNotifyChance = 80    -- 80% chance to call police
Config.MinPoliceOnline = 2        -- Minimum police required
Config.PoliceJob = 'police'       -- QBCore police job name
```

### 🚫 **Safe Zone Configuration**

```lua
Config.BlacklistedAreas = {
    -- Default safe zones
    {x = -545.0, y = -204.0, z = 38.0, radius = 100.0}, -- Hospital
    {x = 440.0, y = -982.0, z = 30.0, radius = 150.0},  -- Police Station
    {x = -1037.0, y = -2737.0, z = 20.0, radius = 200.0}, -- Airport
    
    -- Add your custom safe zones
    {x = 123.45, y = -678.90, z = 21.0, radius = 75.0},  -- Custom Location
    {x = -987.65, y = 432.10, z = 15.0, radius = 50.0},  -- Another Location
}
```

### 🔫 **Weapon Customization**

```lua
Config.RageWeapons = {
    -- Melee Weapons
    'WEAPON_KNIFE',
    'WEAPON_BAT',
    'WEAPON_CROWBAR',
    'WEAPON_HAMMER',
    'WEAPON_MACHETE',
    
    -- Firearms (if desired)
    'WEAPON_PISTOL',
    'WEAPON_MICROSMG',
    
    -- Custom weapons (add your own)
    'WEAPON_CUSTOM_1',
    'WEAPON_CUSTOM_2',
}
```

---

## 🔗 Discord Integration

### 📝 **Setup Discord Logging**

1. **Create Discord Webhook**
   ```
   1. Go to your Discord server
   2. Navigate to channel settings
   3. Go to Integrations → Webhooks
   4. Create New Webhook
   5. Copy the webhook URL
   ```

2. **Configure Webhook in config.lua**
   ```lua
   Config.Discord = {
       enabled = true,
       webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL_HERE",
       botName = "Road Rage Bot",
       serverName = "Your Server Name",
       
       -- Event Logging
       logEvents = {
           roadRageIncidents = true,     -- Log incidents
           policeNotifications = true,   -- Log police calls
           playerInjuries = true,        -- Log injuries
           adminActions = true,          -- Log admin commands
           systemStats = false           -- Hourly statistics (optional)
       }
   }
   ```

### 🛡️ **Anti-Spam Configuration** (New in v1.1.0)

```lua
Config.Discord.spamPrevention = {
    enabled = true,                    -- Enable spam prevention
    cooldownTime = 60000,             -- 60 seconds between similar logs
    maxLogsPerMinute = 5,             -- Maximum 5 logs per minute per type
    combineIncidents = true,          -- Combine multiple incidents
    
    -- Quiet Hours (Optional)
    quietHours = {
        enabled = true,               -- Enable quiet hours
        startHour = 2,               -- 2 AM start
        endHour = 8,                 -- 8 AM end
        reducedTypes = {             -- Reduce these log types during quiet hours
            "roadRageIncidents",
            "policeNotifications"
        }
    }
}
```

### 🎨 **Discord Customization**

```lua
-- Custom colors (decimal format)
Config.Discord.colors = {
    incident = 16776960,    -- Orange
    police = 3447003,       -- Blue
    injury = 15158332,      -- Red
    admin = 9442302,        -- Purple
    system = 65280          -- Green
}

-- Role mentions (optional)
Config.Discord.mentionRoles = {
    adminRole = "123456789012345678",    -- Admin role ID
    policeRole = "876543210987654321"    -- Police role ID
}
```

---

## 🧪 Testing & Verification

### ✅ **Installation Verification**

1. **Check Server Console**
   ```
   Look for: "[JM-NPCRoadRage] Server script loaded successfully!"
   ```

2. **In-Game Tests**
   ```
   /testrage    # Trigger road rage (admin only)
   /npcrage-stats   # View system statistics
   ```

3. **F8 Console Check**
   ```
   # Should show no errors related to JM-NPCRoadRage
   # Look for successful resource start message
   ```

### 🎮 **Functionality Testing**

#### **Road Rage Testing**
1. **Basic Trigger Test**
   - Drive into NPC vehicles
   - Check for NPC reaction
   - Verify they exit vehicles and approach

2. **Combat System Test**
   - Let NPC attack you
   - Check injury system activation
   - Verify health-based injury detection (v1.1.0)

3. **Police Integration Test**
   - Ensure police players are online
   - Trigger road rage incident
   - Check for police notification

#### **Admin Command Testing**
```lua
-- Test all admin commands
/testrage           -- Should trigger nearby NPC
/clearrage          -- Should clear all rage NPCs
/npcrage-stats      -- Should show system info
/npcrage-toggle     -- Should toggle system on/off
```

### 📊 **Performance Monitoring**

```lua
-- Monitor server performance
resmon              # Check resource usage
perfmon             # Monitor performance metrics

-- Expected usage:
-- CPU: < 0.01ms per tick
-- Memory: ~2-5MB
-- Network: Minimal
```

---

## ⚡ Performance Optimization

### 🚀 **Optimization Settings**

#### **For High-Traffic Servers**
```lua
-- Reduce frequency and limits
Config.RoadRageChance = 10        -- Lower trigger rate
Config.MaxRageNPCs = 3            -- Fewer concurrent NPCs
Config.TriggerDistance = 15.0     -- Smaller detection radius

-- Increase intervals
-- In client/main.lua, change detection interval:
Wait(2000) -- Instead of Wait(1000)
```

#### **For Low-Population Servers**
```lua
-- Increase activity for more engagement
Config.RoadRageChance = 25        -- Higher trigger rate
Config.MaxRageNPCs = 8            -- More concurrent NPCs
Config.AttackChance = 80          -- More aggressive NPCs
```

### 📈 **Performance Monitoring**

```lua
-- Add performance monitoring (optional)
-- In server.cfg:
setr jm_npcrage_debug "true"
setr jm_npcrage_perf_monitor "true"

-- Monitor with:
monitor JM-NPCRoadRage
```

---

## 🔧 Troubleshooting

### ❗ **Common Issues & Solutions**

<details>
<summary>🚫 <strong>Script not starting</strong></summary>

**Symptoms:**
- No console message about script loading
- Admin commands not working

**Solutions:**
1. Check server.cfg for typos: `ensure JM-NPCRoadRage`
2. Verify file permissions: `chmod -R 755 JM-NPCRoadRage/`
3. Check fxmanifest.lua syntax
4. Ensure QBCore is loaded first

**Debug Commands:**
```bash
refresh             # Refresh resources
start JM-NPCRoadRage # Manual start
stop JM-NPCRoadRage  # Stop if needed
```
</details>

<details>
<summary>🤖 <strong>NPCs not responding</strong></summary>

**Symptoms:**
- Collisions don't trigger road rage
- NPCs remain in vehicles

**Solutions:**
1. Check if in blacklisted area
2. Increase `Config.RoadRageChance` for testing
3. Verify `Config.MaxRageNPCs` not reached
4. Use `/testrage` to manually trigger

**Debug Steps:**
```lua
-- Temporarily increase for testing
Config.RoadRageChance = 100  -- 100% trigger
Config.MaxRageNPCs = 10      -- Allow more NPCs
```
</details>

<details>
<summary>👮 <strong>Police notifications failing</strong></summary>

**Symptoms:**
- No police alerts
- Console shows police notification errors

**Solutions:**
1. Check `Config.MinPoliceOnline` setting
2. Verify police job name: `Config.PoliceJob = 'police'`
3. Ensure qb-policejob is running
4. Check if police players are on duty

**Verification:**
```lua
-- Check police count with:
/npcrage-stats  -- Shows police online count
```
</details>

<details>
<summary>🏥 <strong>Injury system not working</strong></summary>

**Status:** ✅ **Improved in v1.1.0**

**New Health-Based System:**
- Injuries only trigger when player actually takes damage
- Real-time health monitoring during combat
- Server-side health verification

**Solutions:**
1. Ensure qb-ambulancejob is installed
2. Check `Config.InjuryChance` setting
3. Verify player actually took damage (new in v1.1.0)

**Debug:**
```lua
-- Check injury logs in console
-- Should see: "Injury blocked - no health damage detected"
```
</details>

<details>
<summary>📝 <strong>Discord logging issues</strong></summary>

**Status:** ✅ **Enhanced in v1.1.0**

**New Anti-Spam Features:**
- Cooldown timers between logs
- Rate limiting
- Incident combining

**Solutions:**
1. Verify webhook URL in config.lua
2. Check Discord webhook permissions
3. Test webhook with curl:
```bash
curl -X POST "YOUR_WEBHOOK_URL" \
     -H "Content-Type: application/json" \
     -d '{"content": "Test message"}'
```

**Configuration Check:**
```lua
-- Verify spam prevention settings
Config.Discord.spamPrevention.enabled = true
Config.Discord.logEvents.roadRageIncidents = true
```
</details>

### 🔍 **Advanced Debugging**

#### **Enable Debug Mode**
```cfg
# Add to server.cfg
setr jm_npcrage_debug "true"

# View detailed logs
tail -f server.log | grep "JM-NPCRoadRage"
```

#### **Performance Debugging**
```lua
-- Monitor resource usage
resmon

-- Check for memory leaks
profiler save 60  # Profile for 60 seconds

-- Monitor network traffic
netgraph
```

#### **Database Debugging**
```sql
-- Check incident logging
SELECT * FROM npc_road_rage_incidents ORDER BY timestamp DESC LIMIT 10;

-- Check for database errors
SHOW ENGINE INNODB STATUS;
```

---

## 🔬 Advanced Setup

### 🎯 **Multi-Server Configuration**

```lua
-- config.lua for multiple servers
Config.Discord.serverName = GetConvar("server_name", "Unknown Server")
Config.Discord.webhook = GetConvar("discord_webhook", "")

-- In server.cfg
setr server_name "Your Server Name"
setr discord_webhook "https://discord.com/api/webhooks/..."
```

### 🔄 **Custom Event Integration**

```lua
-- Add custom triggers
RegisterNetEvent('your-script:triggerRoadRage', function(coords)
    -- Custom road rage trigger from other scripts
    TriggerEvent('jm-npcrage:manualTrigger', coords)
end)

-- Custom injury handling
RegisterNetEvent('your-ambulance:customInjury', function(player, severity)
    -- Handle custom injury types
    TriggerServerEvent('jm-npcrage:customInjury', player, severity)
end)
```

### 📊 **Statistics & Analytics**

```lua
-- Enable detailed statistics
Config.Discord.logEvents.systemStats = true

-- Custom analytics endpoint
Config.Analytics = {
    enabled = true,
    endpoint = "https://your-analytics-server.com/api/incidents",
    apiKey = "your-api-key"
}
```

### 🔧 **Framework Compatibility**

#### **ESX Compatibility** (Community Modification)
```lua
-- Replace QBCore references with ESX
local ESX = exports["es_extended"]:getSharedObject()

-- Modify player data access
local PlayerData = ESX.GetPlayerData()

-- Adjust job checks
if PlayerData.job.name == 'police' then
    -- Police logic
end
```

---

## 📞 Support & Troubleshooting

### 🆘 **Getting Help**

| Issue Type | Contact Method | Response Time |
|------------|----------------|---------------|
| 🐛 **Bug Reports** | [GitHub Issues](https://github.com/your-repo/issues) | < 24 hours |
| ⚙️ **Configuration Help** | [Discord Server](https://discord.gg/your-server) | < 6 hours |
| 🔧 **Technical Support** | support@jmmodifications.com | < 48 hours |
| 💬 **General Questions** | [Community Forum](https://forum.yoursite.com) | < 12 hours |

### 📋 **When Reporting Issues**

Please provide:
1. **Server Information**
   - FiveM artifacts version
   - QBCore version
   - Operating system

2. **Error Logs**
   - Server console output
   - Client F8 console errors
   - Any database errors

3. **Configuration**
   - Your config.lua settings
   - Modified files (if any)
   - Other related resources

4. **Reproduction Steps**
   - What you were doing when the issue occurred
   - Steps to reproduce the problem
   - Expected vs actual behavior

### 📚 **Additional Resources**

- 📖 [Configuration Reference](CONFIG.md)
- 🔗 [Discord Setup Guide](DISCORD_SETUP.md)
- 🛠️ [API Documentation](docs/API.md)
- 🎥 [Video Installation Guide](https://youtube.com/watch?v=example)

---

<div align="center">

### 🎉 **Installation Complete!**

Your JM-NPCRoadRage system is now ready to bring realistic road rage to your FiveM server!

**🚗💥 Happy Road Raging! 💥🚗**

[⬆️ Back to Top](#-installation-guide---jm-npcroadvage-v110)

---

**Created with ❤️ by JM Modifications**

</div>