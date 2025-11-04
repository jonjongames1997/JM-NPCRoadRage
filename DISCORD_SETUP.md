# Discord Webhook Integration Guide

## Overview
The JM-NPCRoadRage script includes comprehensive Discord webhook integration to log all road rage incidents, police notifications, player injuries, and admin actions to your Discord server.

## Setting Up Discord Webhooks

### Step 1: Create a Discord Webhook

1. **Open Discord** and go to your server
2. **Right-click** on the channel where you want to receive logs
3. **Select "Edit Channel"**
4. **Go to "Integrations"** tab
5. **Click "Create Webhook"**
6. **Name your webhook** (e.g., "Road Rage Bot")
7. **Copy the webhook URL**

### Step 2: Configure the Script

Edit `config.lua` and update the Discord settings:

```lua
-- Discord Webhook Integration
Config.Discord = {
    enabled = true, -- Set to true to enable Discord logging
    webhook = "YOUR_WEBHOOK_URL_HERE", -- Paste your webhook URL here
    botName = "Road Rage Bot",
    serverName = "Your Server Name", -- Change this to your server name
    avatar = "https://i.imgur.com/4M34hi2.png", -- Bot avatar URL (optional)
    
    -- What events to log (set to false to disable specific logs)
    logEvents = {
        roadRageIncidents = true,  -- Log when road rage is triggered
        policeNotifications = true, -- Log when police are notified
        playerInjuries = true,     -- Log when players get injured
        adminActions = true,       -- Log admin command usage
        systemStats = false        -- Log system statistics (hourly)
    },
}
```

## Log Types and Examples

### 🚗💥 Road Rage Incidents
**Triggered when:** An NPC attacks a player due to road rage
**Information logged:**
- Player name and ID
- Location coordinates
- Weapon used by NPC
- Whether police were notified
- Incident timestamp

### 🚔 Police Notifications
**Triggered when:** Police are automatically notified of an incident
**Information logged:**
- Player involved
- Location of incident
- Number of police officers online
- Response code (10-54)

### 🚑 Player Injuries
**Triggered when:** A player gets injured during road rage
**Information logged:**
- Injured player details
- Injury type and severity
- Location of incident
- Medical attention required

### 👨‍💼 Admin Actions
**Triggered when:** Admins use road rage commands
**Information logged:**
- Admin who used the command
- Command executed
- System statistics (if viewing stats)
- Timestamp of action

### 📈 System Statistics (Optional)
**Triggered when:** Every hour (if enabled)
**Information logged:**
- Players online
- Police officers on duty
- System status

## Advanced Configuration

### Custom Colors
You can customize the embed colors for different log types:

```lua
colors = {
    incident = 16776960, -- Orange - Road rage incident
    police = 3447003,    -- Blue - Police notification  
    injury = 15158332,   -- Red - Player injury
    admin = 9442302,     -- Purple - Admin actions
    system = 65280       -- Green - System messages
}
```

### Role Mentions
To mention specific Discord roles when certain events occur:

```lua
mentionRoles = {
    adminRole = "123456789012345678",    -- Discord role ID for admin logs
    policeRole = "987654321098765432"    -- Discord role ID for police logs
}
```

**To get role IDs:**
1. Enable Developer Mode in Discord (User Settings > Advanced > Developer Mode)
2. Right-click on the role and select "Copy ID"

### Custom Bot Avatar
Set a custom avatar for your webhook bot:

```lua
avatar = "https://your-image-url.com/avatar.png"
```

## Troubleshooting

### Webhook Not Working
- **Check the webhook URL** - Make sure it's correctly copied
- **Verify Discord permissions** - Ensure the webhook has permission to post
- **Check server console** - Look for HTTP error codes
- **Test the webhook** - Use an online webhook tester

### Missing Information in Logs
- **Player data issues** - Verify QBCore is working correctly
- **Coordinate problems** - Check if players are spawned properly
- **Permission errors** - Ensure script has database access (if using DB logging)

### Rate Limiting
Discord has rate limits for webhooks:
- **50 requests per 10 seconds**
- If you hit the limit, messages will be queued

To avoid rate limiting:
- Disable unnecessary log types
- Reduce frequency of system stats (or disable them)

## Testing Your Setup

1. **Start the server** - You should see a startup message in Discord
2. **Trigger road rage** - Use `/testrage` command as admin
3. **Check notifications** - Verify police alerts work
4. **Test admin commands** - Use `/npcrage-stats` to test admin logging

## Sample Discord Embed

Here's what a road rage incident log looks like:

```
🚗💥 Road Rage Incident
Road Rage Incident Occurred

An NPC has attacked a player due to aggressive driving behavior.

Weapon Used: WEAPON_KNIFE
Police Response: ✅ Dispatched

👤 Player: John Doe (ID: 1)
🆔 Citizen ID: ABC12345
📍 Location: X: 123.45, Y: -678.90, Z: 21.34
🔫 Weapon Used: WEAPON_KNIFE
👮 Police Notified: ✅ Yes
⏰ Incident Time: 2025-10-28 15:30:45
🎯 Incident Type: NPC Road Rage Attack
```

## Security Notes

- **Keep your webhook URL private** - Don't share it publicly
- **Use a dedicated channel** - Create a staff-only channel for logs
- **Regular cleanup** - Consider auto-deleting old messages
- **Backup logs** - Discord messages can be deleted, consider additional logging

## Additional Features

### Custom Thumbnails
Add custom thumbnails to your embeds by modifying the server script:

```lua
embeds[1]["thumbnail"] = {
    ["url"] = "https://your-custom-thumbnail.png"
}
```

### Webhook Management
Create separate webhooks for different log types:
- One for incidents
- One for admin actions  
- One for police notifications

This allows better organization and different permission levels.

---

**Need help?** Check the server console for error messages or test your webhook URL with online tools.