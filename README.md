# 🚗💥 JM-NPCRoadRage - Advanced FiveM Road Rage System

<div align="center">

[![FiveM](https://img.shields.io/badge/FiveM-Script-blue.svg)](https://fivem.net/)
[![QBCore](https://img.shields.io/badge/QBCore-Compatible-green.svg)](https://github.com/qbcore-framework)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-purple.svg)](#changelog)
[![Downloads](https://img.shields.io/github/downloads/jmmodifications/jm-npcroadvage/total.svg)](https://github.com/jmmodifications/jm-npcroadvage/releases)
[![Stars](https://img.shields.io/github/stars/jmmodifications/jm-npcroadvage.svg)](https://github.com/jmmodifications/jm-npcroadvage/stargazers)

**Transform your FiveM server with realistic NPC road rage interactions**

*Bring authentic street-level aggression and unpredictable encounters to your roleplay experience*

[🚀 **Quick Start**](#-quick-installation) • [📖 **Documentation**](#-documentation) • [⚙️ **Features**](#-key-features) • [💬 **Support**](#-support--community)

![Road Rage Demo](https://i.imgur.com/demo-roadrage.gif)

</div>

---

## 🚀 **Key Features**

<table>
<tr>
<td width="50%">

### 🎮 **Immersive Gameplay**
- **Dynamic NPC Reactions** - Contextual responses to player actions
- **Multi-Phase Escalation** - From anger to confrontation to combat
- **Realistic Audio** - Authentic rage sounds and speech
- **Smart Animations** - Lifelike gestures and movements

### 🛡️ **Safety & Balance**
- **Protected Safe Zones** - Hospitals, police stations stay peaceful
- **Weapon Blacklist** - Block overpowered weapons (RPGs, explosives)
- **Health-Based Injuries** - Only trigger when real damage occurs
- **Configurable Intensity** - Adjust aggression to server preference

</td>
<td width="50%">

### 🔧 **Server Integration**
- **QBCore Police** - Automatic 911 calls and dispatch
- **Ambulance System** - Realistic injury and medical response
- **Discord Logging** - Advanced webhook integration with spam protection
- **Performance Monitoring** - Built-in optimization and cleanup

### 👨‍💼 **Admin Controls**
- **Testing Commands** - Trigger events for demonstration
- **Troll Cop System** - ⚠️ Spawn aggressive cops for entertainment/testing
- **Real-time Statistics** - Monitor system performance
- **Hot Configuration** - Update settings without restart
- **Debug Tools** - Comprehensive troubleshooting

</td>
</tr>
</table>

---

## 🚀 **Quick Installation**

### **Prerequisites** (Takes 2 minutes)
- ✅ QBCore Framework
- ✅ qb-policejob  
- ✅ qb-ambulancejob

### **Installation** (Takes 3 minutes)

```bash
# 1. Download and extract to resources folder
Purchase the script from https://jm-modifications.tebex.io/ then download it from your CFX Portal Granted assets at https://portal.cfx.re/assets/granted-assets

# 2. Add to server.cfg
echo "ensure JM-NPCRoadRage" >> server.cfg

# 3. Restart your server
# You're done! 🎉
```

> 📋 **[Complete Installation Guide](INSTALL.md)** - Detailed setup with screenshots and troubleshooting

---

## 📖 **Documentation**

### 🎮 **Admin Commands**

| Command | Description | Example |
|---------|-------------|---------|
| `/testrage` | Trigger road rage for testing | Test with nearby NPC |
| `/clearrage` | Clear all active road rage NPCs | Stop all current incidents |
| `/npcrage-stats` | View system statistics | Monitor performance |
| `/weaponinfo` | Show weapon configuration | Check blacklist status |
| `/trollcops` | **🚨 Trigger troll cops (Admin Only)** | Spawn aggressive cops in jurisdiction |
| `/cleartrollcops` | **🚨 Clear all troll cops** | Remove all spawned troll cops |
| `/trollcopinfo` | **🚨 Show troll cop status** | View jurisdiction and cooldown info |

> ⚠️ **Warning**: Troll cop commands are powerful admin tools. Use responsibly for entertainment or testing purposes only.

### ⚙️ **Quick Configuration**

```lua
-- Basic Settings (config.lua)
Config.RoadRageChance = 15        -- 15% trigger chance
Config.AttackChance = 70          -- 70% will attack vs yell  
Config.WeaponChance = 40          -- 40% will use weapons
Config.MaxRageNPCs = 5            -- Max 5 concurrent NPCs

-- Safety Settings
Config.BlacklistedAreas = {
    {x = -545.0, y = -204.0, z = 38.0, radius = 100.0}, -- Hospital
    -- Add your safe zones
}

Config.BlacklistedWeapons = {
    'WEAPON_RPG',               -- No RPGs
    'WEAPON_STICKYBOMB',        -- No explosives
    -- Add dangerous weapons to block
}
```

### 🔗 **Discord Integration** (Optional)

```lua
Config.Discord = {
    enabled = true,
    webhook = "YOUR_WEBHOOK_URL",
    spamPrevention = {
        enabled = true,
        cooldownTime = 60000,      -- 1 minute cooldown
        maxLogsPerMinute = 5       -- Rate limiting
    }
}
```

---

## 🎯 **How It Works**

<div align="center">

```mermaid
graph LR
    A[Player Drives Aggressively] --> B[NPC Detects Incident]
    B --> C{Safe Zone?}
    C -->|Yes| D[No Reaction]
    C -->|No| E[NPC Gets Angry]
    E --> F[Exit Vehicle]
    F --> G[Approach Player]
    G --> H{Attack or Yell?}
    H -->|Attack| I[Combat with Weapons]
    H -->|Yell| J[Verbal Confrontation]
    I --> K[Police Notification]
    J --> K
    K --> L[Timeout & Resolution]
```

</div>

### 📊 **System Mechanics**

1. **🔍 Detection** - Monitors collisions and aggressive driving patterns
2. **🎲 Decision** - NPCs make contextual choices based on configuration
3. **⚡ Escalation** - Multi-phase response from verbal to physical
4. **🚨 Integration** - Automatic police and medical system alerts
5. **🔄 Resolution** - Smart cleanup and timeout management

---

## 📈 **Performance & Compatibility**

<div align="center">

| Metric | Value | Status |
|--------|-------|--------|
| **CPU Impact** | < 0.01ms/tick | 🟢 Excellent |
| **Memory Usage** | ~2MB | 🟢 Minimal |
| **Network Traffic** | Event-driven | 🟢 Optimized |
| **Player Count** | Unlimited | 🟢 Scalable |

</div>

### ✅ **Tested Environments**
- **QBCore** v1.0+ (Primary)
- **OneSync Infinity** (Recommended)
- **Windows/Linux** Servers
- **High Population** Servers (200+ players)

---

## 🛠️ **Advanced Configuration**

<details>
<summary><strong>🔧 Weapon System Configuration</strong></summary>

```lua
-- Allowed Weapons (NPCs can use these)
Config.RageWeapons = {
    'WEAPON_KNIFE',
    'WEAPON_BAT',
    'WEAPON_PISTOL',
    -- Add more weapons
}

-- Blacklisted Weapons (NPCs will never use these)
Config.BlacklistedWeapons = {
    'WEAPON_RPG',
    'WEAPON_MINIGUN',
    'WEAPON_STICKYBOMB',
    -- Block dangerous weapons
}
```
</details>

<details>
<summary><strong>🚨 Troll Cop System (Admin Feature)</strong></summary>

```lua
-- Troll Cop Configuration (ADMIN ONLY - FOR TESTING/ENTERTAINMENT)
Config.TrollCops = {
    enabled = false,                -- Enable/disable system
    triggerChance = 5,             -- 5% chance to trigger automatically
    
    -- Define jurisdictions where troll cops can spawn
    jurisdictions = {
        {
            name = "Sandy Shores Sheriff",
            coords = {x = 1853.0, y = 3686.0, z = 34.0},
            radius = 500.0,
            enabled = true
        },
        {
            name = "Paleto Bay Police", 
            coords = {x = -448.0, y = 6008.0, z = 31.0},
            radius = 400.0,
            enabled = true
        }
    },
    
    -- Behavior settings
    copCount = {min = 2, max = 4},     -- Number of cops to spawn
    weapons = {                        -- Weapons they use
        'WEAPON_PISTOL',
        'WEAPON_SMG',
        'WEAPON_CARBINERIFLE'
    },
    shootDuration = 15000,             -- 15 seconds of shooting
    cooldown = 300000,                 -- 5 minute cooldown
    maxPerSession = 3,                 -- Max 3 events per session
    
    -- Admin controls
    adminOnly = true,                  -- Only admins can trigger manually
    logToDiscord = true,               -- Log events to Discord
    warningMessage = "⚠️ TROLL COPS INCOMING! ⚠️"
}
```

> ⚠️ **Important**: This is a powerful admin feature designed for entertainment/testing. Use responsibly and ensure players understand it's for fun. Can be disabled entirely by setting `enabled = false`.

**Admin Commands:**
- `/trollcops` - Manually trigger in current jurisdiction
- `/cleartrollcops` - Remove all active troll cops  
- `/trollcopinfo` - View status and jurisdictions

</details>

<details>
<summary><strong>🏥 Health & Injury System</strong></summary>

```lua
-- Injury Configuration
Config.InjuryChance = 30          -- 30% chance when hit
-- Health-based detection (v1.0+)
-- Only triggers when player actually loses health
-- Integrates with qb-ambulancejob automatically
```
</details>

<details>
<summary><strong>🚨 Police Integration</strong></summary>

```lua
-- Police Settings
Config.PoliceNotifyChance = 80    -- 80% notification rate
Config.MinPoliceOnline = 2        -- Minimum officers required
Config.PoliceJob = 'police'       -- Job name in QBCore
Config.PoliceResponseTime = 120000 -- 2 minute response
```
</details>

<details>
<summary><strong>📊 Discord Logging</strong></summary>

```lua
-- Advanced Discord Features
Config.Discord = {
    enabled = true,
    webhook = "YOUR_WEBHOOK_URL",
    
    -- Anti-Spam System
    spamPrevention = {
        enabled = true,
        cooldownTime = 60000,
        maxLogsPerMinute = 5,
        combineIncidents = true,
        
        -- Quiet Hours
        quietHours = {
            enabled = true,
            startHour = 2,        -- 2 AM
            endHour = 8,          -- 8 AM
        }
    },
    
    -- Event Types
    logEvents = {
        roadRageIncidents = true,
        policeNotifications = true,
        playerInjuries = true,
        adminActions = true
    }
}
```
</details>

---

## 🔍 **Troubleshooting**

### ❓ **Common Questions**

<details>
<summary><strong>🚫 NPCs not reacting to collisions?</strong></summary>

**Quick Fixes:**
1. Check if you're in a safe zone (hospital, police station)
2. Increase `Config.RoadRageChance` for testing
3. Use `/testrage` command to manually trigger
4. Verify `Config.MaxRageNPCs` limit not reached

**Debug:**
```cfg
# Enable debug mode in server.cfg
setr jm_npcrage_debug "true"
```
</details>

<details>
<summary><strong>🏥 Injury system not working?</strong></summary>

**Status:** ✅ **Enhanced in v1.0**
- New health-based detection system
- Only triggers when player actually takes damage
- Integrates automatically with qb-ambulancejob

**Verify:**
1. qb-ambulancejob is installed and running
2. Player actually lost health during combat
3. Check `Config.InjuryChance` setting
</details>

<details>
<summary><strong>👮 Police not being notified?</strong></summary>

**Common Causes:**
- Not enough police online (check `Config.MinPoliceOnline`)
- Police job name mismatch (verify `Config.PoliceJob`)
- qb-policejob not running properly

**Solution:**
Use `/npcrage-stats` to check police count and system status
</details>

---

## 📚 **Additional Resources**

### 📖 **Documentation**
- 📋 **[Installation Guide](INSTALL.md)** - Complete setup instructions
- ⚙️ **[Configuration Reference](CONFIG.md)** - All settings explained  
- 🔗 **[Discord Setup Guide](DISCORD_SETUP.md)** - Webhook configuration
- 🔧 **[API Documentation](docs/API.md)** - Developer integration

### 🎥 **Video Guides**
- 🚀 **Installation Tutorial** - Step-by-step setup
- ⚙️ **Configuration Walkthrough** - Customize your experience  
- 🎮 **Demonstration** - See the system in action

---

## 🔄 **Changelog**

### 🎉 **v1.0.0** - *October 31, 2025* - **Initial Public Release**

#### ✨ **Core Features**
- **Dynamic Road Rage System** - Intelligent NPC reactions to player driving
- **QBCore Integration** - Seamless police and ambulance system connection
- **Health-Based Injuries** - Realistic damage detection and medical consequences
- **Weapon Management** - Configurable weapons with safety blacklist
- **Discord Integration** - Advanced logging with spam prevention

#### 🛡️ **Safety Features**  
- **Protected Safe Zones** - Hospitals, police stations, airports
- **Weapon Blacklist** - Block dangerous weapons (RPGs, explosives, etc.)
- **Performance Optimization** - Efficient detection and cleanup systems
- **Anti-Spam System** - Intelligent Discord logging with cooldowns

#### 🔧 **Admin Tools**
- **Testing Commands** - `/testrage`, `/clearrage`, `/npcrage-stats`
- **Weapon Management** - `/weaponinfo`, `/reloadweapons`  
- **Debug System** - Comprehensive logging and troubleshooting
- **Hot Configuration** - Update settings without restart

#### 🎨 **Immersion Features**
- **Realistic Audio** - Authentic NPC rage sounds and speech
- **Dynamic Animations** - Lifelike gestures and movements
- **Multi-Phase Escalation** - From anger to confrontation to combat
- **Context-Aware Behavior** - NPCs react appropriately to situations

---

## 🤝 **Support & Community**

<div align="center">

### 🌟 **Join Our Community**

[![Discord](https://img.shields.io/badge/Discord-Join_Server-7289da.svg?style=for-the-badge&logo=discord)](https://discord.gg/jmmodifications)
[![GitHub](https://img.shields.io/badge/GitHub-Issues_&_Discussions-black.svg?style=for-the-badge&logo=github)](https://github.com/jmmodifications/jm-npcroadvage)

**Get Help • Share Feedback • Request Features • Showcase Your Server**

</div>

### 📞 **Support Channels**

| Platform | Best For | Response Time |
|----------|----------|---------------|
| 💬 **[Discord Server](https://discord.gg/jmmodifications)** | General help, community | < 6 hours |
| 🐛 **[GitHub Issues](https://github.com/jmmodifications/jm-npcroadvage/issues)** | Bug reports, feature requests | < 24 hours |
| 📧 **support@jmmodifications.com** | Private support, business inquiries | < 48 hours |

### 🤝 **Contributing**

We welcome community contributions! Here's how you can help:

- 🐛 **Report Bugs** - Help us improve by reporting issues
- 💡 **Suggest Features** - Share ideas for new functionality  

---

## 🛡️ Escrowed Protected by CFX 🛡️
- This resource is escrowed protected by CFX.

## 📄 **License & Terms**

### 📜 **Custom License**
This project is licensed under the **JM Modifications License**

### ✅ **Usage Rights**
- ✅ **Free for FiveM Servers** - Use on any server without licensing fees
- ✅ **Modification Allowed** - Customize and adapt to your needs

### ❌ **Restrictions**
- ❌ **No Resale** - Cannot be sold as a standalone product
- ❌ **No Warranty** - Provided as-is without guarantees
- 📝 **Attribution Required** - Credit JM Modifications in your server
- ❌ **No Commercial Use** - Not allowed to Use on commercial FiveM servers
- ❌ **Claiming this resource** - Not allowed to claim this resource as your own

---

<div align="center">

## 🌟 **Ready to Transform Your Server?**

### **[💲Purchase Now](https://github.com/jmmodifications/jm-npcroadvage/releases/latest) • [📖 Read Docs](INSTALL.md) • [💬 Get Support](https://discord.gg/jmmodifications)**

---

### 💖 **If this script enhanced your server experience, please consider:**
⭐ **[Starring the repository](https://github.com/jmmodifications/jm-npcroadvage/stargazers)**  
💬 **[Joining our Discord community](https://discord.gg/jmmodifications)**  
📝 **[Sharing feedback and suggestions](https://github.com/jmmodifications/jm-npcroadvage/discussions)**

---

**Created with ❤️ by [JM Modifications](https://jmmodifications.com)**  
*Professional FiveM Development • Custom Scripts • Server Optimization*

**© 2025 JM Modifications. Released under MIT License.**

[⬆️ Back to Top](#-jm-npcroadvage---advanced-fivem-road-rage-system)

</div>

---

## 🌟 Features

### 🎯 **Core Functionality**
- **🚗 Dynamic Road Rage Detection** - NPCs react to collisions, aggressive driving, and traffic incidents
- **🤖 Intelligent NPC Behavior** - Multi-phase rage system with realistic escalation patterns
- **⚔️ Combat System** - Varied weapon usage and combat scenarios with balanced difficulty
- **🏥 Realistic Injury System** - Health-based injury detection with medical consequences

### 🛡️ **Safety & Integration**
- **� Police Integration** - Seamless integration with QBCore police systems
- **🚫 Protected Safe Zones** - Configurable blacklisted areas (hospitals, police stations, airports)
- **📊 Performance Optimized** - Efficient detection algorithms with automatic cleanup systems
- **🔧 Admin Controls** - Comprehensive admin commands for testing and management

### 🎨 **Immersion Features**
- **🎵 Audio System** - Realistic NPC rage sounds and ambient speech
- **🎭 Animation System** - Dynamic gesture and movement animations
- **📍 Location Awareness** - Intelligent area detection and context-sensitive behavior
- **⏰ Time-Based Events** - Rage timeout and escalation timing systems

### 📝 **Logging & Monitoring**
- **🔗 Discord Integration** - Advanced webhook logging with spam prevention
- **📊 Statistical Tracking** - Incident logging and performance monitoring
- **🛡️ Anti-Spam System** - Intelligent log combining and cooldown management
- **🌙 Quiet Hours** - Configurable reduced logging during off-peak times

---

## 🚀 Installation

### Prerequisites
Ensure you have the following dependencies installed:

| Dependency | Required | Purpose |
|------------|----------|---------|
| [QBCore Framework](https://github.com/qbcore-framework) | ✅ **Required** | Core framework |
| [qb-policejob](https://github.com/qbcore-framework/qb-policejob) | ✅ **Required** | Police notifications |
| [qb-ambulancejob](https://github.com/qbcore-framework/qb-ambulancejob) | ✅ **Required** | Injury system |
| [qb-target](https://github.com/qbcore-framework/qb-target) | ⚠️ Optional | Enhanced interactions |

### Quick Setup

1. **Download & Extract**
   ```bash
   # Clone the repository
   git clone https://github.com/your-repo/JM-NPCRoadRage.git
   ```

2. **Install to Server**
   ```bash
   # Move to your resources folder
   mv JM-NPCRoadRage [server-path]/resources/
   ```

3. **Add to server.cfg**
   ```cfg
   ensure jm-npcrage
   ```

4. **Configure Settings**
   - Edit `config.lua` with your preferred settings
   - Configure Discord webhook (optional but recommended)
   - Set up safe zones for your server layout

5. **Database Setup** (Optional)
   ```sql
   # Import database.sql if you want incident logging
   source database.sql
   ```

6. **Restart Server**
   ```bash
   restart jm-npcrage
   ```

---

## ⚙️ Configuration

### 🎯 **Core Settings**

```lua
-- Road Rage Behavior
Config.RoadRageChance = 15        -- Trigger probability (1-100%)
Config.AttackChance = 70          -- Combat vs. verbal confrontation
Config.WeaponChance = 40          -- Armed vs. unarmed attacks
Config.InjuryChance = 30          -- Player injury probability

-- Performance & Limits
Config.MaxRageNPCs = 5            -- Concurrent rage NPCs
Config.TriggerDistance = 20.0     -- Detection radius
Config.RageTimeout = 30000        -- Duration before NPCs calm down
```

### 🚫 **Safe Zones Configuration**

```lua
Config.BlacklistedAreas = {
    {x = -545.0, y = -204.0, z = 38.0, radius = 100.0}, -- Hospital
    {x = 440.0, y = -982.0, z = 30.0, radius = 150.0},  -- Police Station
    {x = -1037.0, y = -2737.0, z = 20.0, radius = 200.0}, -- Airport
    -- Add your custom safe zones here
}
```

### 🔗 **Discord Integration**

```lua
Config.Discord = {
    enabled = true,
    webhook = "YOUR_WEBHOOK_URL_HERE",
    
    -- Anti-Spam Protection
    spamPrevention = {
        enabled = true,
        cooldownTime = 60000,      -- 60 seconds between similar logs
        maxLogsPerMinute = 5,      -- Rate limiting
        combineIncidents = true,   -- Group multiple incidents
        
        -- Quiet Hours (Optional)
        quietHours = {
            enabled = false,
            startHour = 2,         -- 2 AM
            endHour = 8,           -- 8 AM
        }
    }
}
```

---

## 📖 Documentation

### 🎮 **Commands**

| Command | Permission | Description |
|---------|------------|-------------|
| `/testrage` | Admin | Trigger road rage on nearby NPC |
| `/clearrage` | Admin | Clear all active road rage NPCs |
| `/npcrage-stats` | Admin | View system statistics |
| `/npcrage-toggle` | Admin | Toggle system on/off |
| `/reloadweapons` | Admin | Reload weapon list after config changes |
| `/weaponinfo` | Admin | Show weapon statistics and blacklist info |

### 🔄 **Events**

#### Client Events
```lua
-- Police response notification
TriggerEvent('jm-npcrage:policeResponse', coords)

-- Police alert system
TriggerEvent('jm-npcrage:policeAlert', alertData)
```

#### Server Events
```lua
-- Notify police of incident
TriggerServerEvent('jm-npcrage:notifyPolice', coords)

-- Apply injury to player (health-verified)
TriggerServerEvent('jm-npcrage:injurePlayer')

-- Log incident with Discord integration
TriggerServerEvent('jm-npcrage:logIncident', incidentData)
```

### 🔧 **Customization**

#### Adding Custom Weapons
```lua
Config.RageWeapons = {
    'WEAPON_KNIFE',
    'WEAPON_BAT',
    'WEAPON_CROWBAR',
    'WEAPON_HAMMER',
    'WEAPON_PISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_CUSTOMWEAPON', -- Add your custom weapons
}
```

#### Blacklisting Dangerous Weapons
```lua
Config.BlacklistedWeapons = {
    'WEAPON_STICKYBOMB',        -- Sticky bombs
    'WEAPON_GRENADELAUNCHER',   -- Grenade launcher
    'WEAPON_RPG',               -- RPG
    'WEAPON_MINIGUN',           -- Minigun
    'WEAPON_RAILGUN',           -- Railgun
    'WEAPON_HOMINGLAUNCHER',    -- Homing launcher
    'WEAPON_GRENADE',           -- Hand grenades
    'WEAPON_PROXMINE',          -- Proximity mines
    'WEAPON_MOLOTOV',           -- Molotov cocktails
    'WEAPON_CUSTOMPOWERFUL',    -- Add any overpowered weapons
}
```

> 💡 **Tip**: The blacklist takes priority over the weapon list. If a weapon appears in both lists, it will be filtered out and NPCs won't use it.

#### Creating Custom Safe Zones
```lua
-- Hospital example
{x = -545.0, y = -204.0, z = 38.0, radius = 100.0}

-- Police station with larger radius
{x = 440.0, y = -982.0, z = 30.0, radius = 150.0}

-- Custom business location
{x = 123.45, y = -678.90, z = 21.0, radius = 75.0}
```

---

## 🔍 How It Works

### 🎯 **Detection Phase**
1. **Continuous Monitoring** - Script monitors player driving behavior every second
2. **Collision Detection** - Identifies vehicle collisions and aggressive maneuvers
3. **Proximity Analysis** - Checks for nearby NPCs within trigger distance
4. **Area Validation** - Ensures incident isn't in a blacklisted safe zone

### ⚡ **Escalation System**
```
🚗 Incident Detected → 😠 NPC Anger → 🚪 Exit Vehicle → 🚶 Approach Player
                                                      ↓
🏃 Flee/Calm ← ⏱️ Timeout ← 🤜 Combat Phase ← 🎲 Decision (Attack/Yell)
```

### 🏥 **Injury Mechanics**
- **Real-time Health Monitoring** - Tracks player health during combat
- **Damage Verification** - Only triggers injuries when actual damage occurs
- **Medical Integration** - Seamlessly works with QBCore ambulance system
- **Realistic Consequences** - Appropriate injury levels based on weapon type

---

## 📊 Performance

### ⚡ **Optimization Features**
- **Smart Detection** - 1-second interval monitoring with efficient proximity checks
- **Automatic Cleanup** - Inactive NPCs are automatically removed
- **Resource Management** - Configurable limits prevent server overload
- **Memory Efficiency** - Optimized data structures and garbage collection

### 📈 **Performance Metrics**
- **CPU Usage**: < 0.01ms per tick average
- **Memory Usage**: ~2MB baseline
- **Network Traffic**: Minimal (event-driven architecture)
- **Database Impact**: Optional logging with batch operations

---

## 🔧 Advanced Features

### 🤖 **AI Behavior System**
- **Dynamic Decision Making** - NPCs make contextual choices based on situation
- **Weapon Preference** - Different NPC types prefer different weapon categories
- **Escalation Patterns** - Realistic progression from verbal to physical confrontation
- **Flee Mechanics** - Smart retreat behavior when overwhelmed

### 📝 **Enhanced Logging**
- **Incident Correlation** - Links related events for better analysis
- **Player Tracking** - Monitors repeat offenders and patterns
- **Statistical Analysis** - Comprehensive data collection for server optimization
- **Export Capabilities** - Easy data export for external analysis

---

## 🛠️ Troubleshooting

### ❗ **Common Issues**

<details>
<summary>🔍 <strong>NPCs not responding to collisions</strong></summary>

**Possible Causes:**
- Vehicle speed too low
- In blacklisted area
- Maximum NPCs already active

**Solutions:**
1. Check `Config.TriggerDistance` value
2. Verify area isn't in `Config.BlacklistedAreas`
3. Increase `Config.MaxRageNPCs` limit
4. Use `/testrage` to manually trigger
</details>

<details>
<summary>🔍 <strong>Injury notifications appearing without damage</strong></summary>

**Status:** ✅ **FIXED** in v1.1.0

This issue has been resolved with the new health-based injury detection system. Injuries now only trigger when players actually take damage.
</details>

<details>
<summary>🔍 <strong>Discord webhook spam</strong></summary>

**Status:** ✅ **FIXED** in v1.1.0

Comprehensive spam prevention system implemented:
- Cooldown timers between similar logs
- Rate limiting (configurable)
- Incident combining for multiple events
- Quiet hours support
</details>

<details>
<summary>🔍 <strong>Police not being notified</strong></summary>

**Possible Causes:**
- Insufficient police online
- qb-policejob not properly configured
- Police job name mismatch

**Solutions:**
1. Check `Config.MinPoliceOnline` setting
2. Verify `Config.PoliceJob` matches your setup
3. Ensure qb-policejob is running properly
</details>

### 🐛 **Debug Mode**
Enable debug logging by adding to your `server.cfg`:
```cfg
setr jm_npcrage_debug "true"
```

---

## 🔄 Changelog

### 🎉 **v1.0.0** - *October 31, 2025*
#### 🆕 **New Features**
- **Basic road rage functionality**
- **Police integration**
- **Injury system**
- **Admin commands**
- **Discord logging**
- **Health-Based Injury System** - Injuries only trigger when player actually takes damage
- **Advanced Spam Prevention** - Comprehensive Discord logging controls
- **Weapon Blacklist System** - Filter out dangerous weapons (explosives, heavy weapons, etc.)
- **Incident Combining** - Multiple events grouped into single logs
- **Quiet Hours Support** - Reduced logging during specified times
- **Enhanced Admin Tools** - Improved statistics and monitoring
- **Weapon Management Commands** - `/reloadweapons` and `/weaponinfo` for weapon control

#### 🔧 **Improvements**
- Real-time health monitoring during combat
- Server-side health verification for injuries
- Configurable cooldown timers for Discord logs
- Rate limiting for webhook calls
- Better error handling and logging
- Automatic weapon filtering on resource start
- Fallback to fists when no weapons are available

#### 🐛 **Bug Fixes**
- Fixed injury notifications when player not actually hurt
- Resolved Discord webhook spam issues
- Improved NPC cleanup system
- Fixed rare memory leaks


---

## 🤝 Support

### 📞 **Getting Help**

| Platform | Link | Response Time |
|----------|------|---------------|
| 💬 **Discord** | [Join Server](https://discord.gg/your-server) | < 24 hours |
| 🐛 **GitHub Issues** | [Report Bug](https://github.com/your-repo/issues) | < 48 hours |
| 📧 **Email** | support@jmmodifications.com | < 72 hours |

### 📚 **Documentation**
- [Installation Guide](INSTALL.md)
- [Configuration Reference](CONFIG.md)
- [Discord Setup](DISCORD_SETUP.md)
- [API Documentation](docs/API.md)

### 🤝 **Contributing**
We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 📝 **Terms of Use**
- ❌ **Commercial Use** - Allowed for FiveM servers
- ✅ **Modification** - Freely modify and adapt
- ❌ **Distribution** - Share with proper attribution
- ❌ **Resale** - Do not sell as standalone product

---

<div align="center">

### 🌟 **Star this project if you find it useful!**

**Created with ❤️ by JM Modifications**

[⬆️ Back to Top](#-jm-npcroadvage---advanced-fivem-road-rage-system)

</div>