# Migration Guide - Old to Refactored Version

## 📋 Overview

This guide helps you migrate from the old monolithic version to the new refactored version.

---

## 🔄 Migration Steps

### Step 1: Backup Current Installation

```powershell
# Create a backup folder
New-Item -Path "d:\FiveM Scripts\JM-NPCRoadRage-backup" -ItemType Directory

# Copy everything
Copy-Item -Path "d:\FiveM Scripts\JM-NPCRoadRage\*" -Destination "d:\FiveM Scripts\JM-NPCRoadRage-backup\" -Recurse
```

### Step 2: Verify New Files

Ensure these new files exist:

```
✅ shared/utils.lua
✅ client/core.lua
✅ client/utils.lua
✅ client/rage.lua
✅ client/trollcops.lua
✅ client/commands.lua
✅ server/core.lua
✅ server/discord.lua
✅ server/police.lua
✅ server/database.lua
✅ server/commands.lua
✅ REFACTOR.md
✅ SUMMARY.md
✅ QUICKSTART.md
✅ ARCHITECTURE.md
```

### Step 3: Update Manifest

Your `fxmanifest.lua` should now include:

```lua
shared_scripts {
    'config.lua',
    'locales/en.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/core.lua',
    'client/utils.lua',
    'client/rage.lua',
    'client/trollcops.lua',
    'client/commands.lua'
}

server_scripts {
    'server/core.lua',
    'server/discord.lua',
    'server/police.lua',
    'server/database.lua',
    'server/commands.lua'
}
```

### Step 4: Keep Your Config

**Your existing `config.lua` will work!** 

The refactored version is 100% compatible with your old configuration.

### Step 5: Remove Old Files (Optional)

After testing, you can remove:
- `client/main.lua` (backed up automatically)
- `server/main.lua.backup`

```powershell
# Only do this after confirming everything works!
Remove-Item "d:\FiveM Scripts\JM-NPCRoadRage\client\main.lua" -Force
Remove-Item "d:\FiveM Scripts\JM-NPCRoadRage\server\main.lua.backup" -Force
```

### Step 6: Restart Resource

```
# In your server console
restart jm-npcrage
```

---

## ✅ Verification Checklist

After migration, verify:

- [ ] Server starts without errors
- [ ] Console shows: "Client loaded successfully!"
- [ ] Console shows: "Server script loaded successfully!"
- [ ] Road rage triggers when driving aggressively
- [ ] NPCs attack/yell as configured
- [ ] Police notifications work (if enabled)
- [ ] Discord logs work (if enabled)
- [ ] Admin commands work (`/testrage`, `/ragestats`)
- [ ] Troll cops work (if enabled)
- [ ] Injury system works (if enabled)

---

## 🔧 Configuration Changes

### No Changes Required!

The refactored version uses the **exact same** configuration structure.

Your existing settings for:
- ✅ Road rage chances
- ✅ Weapon lists
- ✅ Blacklisted weapons
- ✅ Police integration
- ✅ Discord webhooks
- ✅ Troll cops
- ✅ Safe zones

...will all work without modification!

### Optional Improvements

The refactored `config.lua` has better organization with section headers:

```lua
-- ============================================
-- CORE SETTINGS
-- ============================================
Config.Debug = false
Config.Version = "1.0.0"

-- ============================================
-- ROAD RAGE SETTINGS
-- ============================================
Config.RoadRageChance = 15
-- ... etc
```

You can adopt this format for better readability, but it's not required.

---

## 🔄 What Changed (Technically)

### Code Structure
```
OLD:
  client/main.lua (652 lines)
  server/main.lua (777 lines)

NEW:
  11 focused module files
  Shared utilities
  Better organization
```

### Functionality
```
NONE! Everything works the same.
```

---

## 🚨 Common Migration Issues

### Issue 1: "Module not found"

**Symptom**: Error about missing module

**Solution**: Verify all new files exist and manifest is updated

### Issue 2: Old main.lua conflicts

**Symptom**: Duplicate function errors

**Solution**: Ensure old `client/main.lua` is removed or renamed

### Issue 3: Commands not working

**Symptom**: Admin commands don't respond

**Solution**: Verify `client/commands.lua` and `server/commands.lua` are loaded

### Issue 4: Events not firing

**Symptom**: Road rage doesn't trigger

**Solution**: Check that `client/core.lua` loaded first (load order in manifest)

---

## 📊 Before vs After Comparison

### File Count
- **Before**: 2 main files
- **After**: 11 module files

### Lines of Code
- **Before**: ~1,429 lines in 2 files
- **After**: ~1,500 lines across 11 files (includes documentation)

### Maintainability
- **Before**: Find function in 600+ line file
- **After**: Each module has ~150 lines, focused purpose

### Debugging
- **Before**: Error somewhere in main.lua
- **After**: Error in specific module (e.g., rage.lua line 45)

### Adding Features
- **Before**: Edit massive file, hope nothing breaks
- **After**: Add to relevant module, isolated impact

---

## 🎯 Testing Procedure

### 1. Basic Functionality

```
1. Start server
2. Join game
3. Drive into NPC vehicle
4. Verify NPC reacts
5. Check console for errors
```

### 2. Police System

```
1. Trigger road rage
2. Check if police notified (if online)
3. Verify dispatch message
4. Check Discord webhook (if enabled)
```

### 3. Admin Commands

```
/ragestats      - Should show statistics
/weaponinfo     - Should show weapon count
/testrage       - Should trigger on nearby NPC
/clearrage      - Should clear all rage NPCs
```

### 4. Injury System

```
1. Let NPC attack you
2. Lose health
3. Verify injury applied
4. Check medical system integration
```

### 5. Discord Integration

```
1. Ensure webhook URL configured
2. Trigger road rage
3. Check Discord channel
4. Verify log appears
```

---

## 💾 Rollback Procedure

If you need to revert to the old version:

### Step 1: Stop Resource
```
stop jm-npcrage
```

### Step 2: Restore Backup
```powershell
# Remove new files
Remove-Item -Path "d:\FiveM Scripts\JM-NPCRoadRage\*" -Recurse -Force

# Restore from backup
Copy-Item -Path "d:\FiveM Scripts\JM-NPCRoadRage-backup\*" -Destination "d:\FiveM Scripts\JM-NPCRoadRage\" -Recurse
```

### Step 3: Restart
```
start jm-npcrage
```

---

## 📈 Performance Comparison

### Memory Usage
- **Same** - No additional overhead

### CPU Usage
- **Same** - Identical thread structure

### Network Usage
- **Same** - Same event frequency

### Load Time
- **Slightly faster** - Better module initialization

---

## 🎓 Learning Resources

### Understanding the New Structure

1. **Read**: `REFACTOR.md` - Detailed explanation
2. **Read**: `ARCHITECTURE.md` - Visual diagrams
3. **Read**: `SUMMARY.md` - Quick overview
4. **Test**: Use admin commands to explore

### Customization

To modify specific features:

- **Road rage behavior** → Edit `client/rage.lua`
- **Police alerts** → Edit `server/police.lua`
- **Discord logs** → Edit `server/discord.lua`
- **Admin commands** → Edit `client/commands.lua` or `server/commands.lua`
- **Settings** → Edit `config.lua`

---

## 🤝 Support

### Getting Help

1. **Check console** for specific error messages
2. **Review documentation** in REFACTOR.md
3. **Verify configuration** in config.lua
4. **Test step-by-step** using this guide

### Reporting Issues

If you find a bug:

1. Note the exact error message
2. Identify which module (e.g., rage.lua)
3. Note what you were doing when it happened
4. Check if it happens with default config

---

## ✨ Benefits of Migration

### Immediate
- ✅ Better error messages
- ✅ Easier debugging
- ✅ Cleaner console output

### Long-term
- ✅ Easier to customize
- ✅ Simpler to update
- ✅ Better maintainability
- ✅ Professional structure

### For Server
- ✅ More stable
- ✅ Easier to extend
- ✅ Better documentation
- ✅ Future-proof

---

## 🎉 Migration Complete!

Once you've completed these steps and verified everything works:

1. ✅ Remove backup folder (optional)
2. ✅ Update your documentation
3. ✅ Inform your team of new structure
4. ✅ Enjoy the improved codebase!

---

## 📞 Quick Reference

### Important Files
- `config.lua` - All settings
- `fxmanifest.lua` - Resource configuration
- `REFACTOR.md` - Detailed documentation
- `QUICKSTART.md` - Quick commands reference

### Key Modules
- `client/rage.lua` - Core road rage logic
- `server/police.lua` - Police integration
- `server/discord.lua` - Webhook logging

### Admin Commands
- `/ragestats` - Show statistics
- `/testrage` - Test functionality
- `/weaponinfo` - Weapon information

---

*Migration guide complete! Enjoy your refactored script.* 🚀
