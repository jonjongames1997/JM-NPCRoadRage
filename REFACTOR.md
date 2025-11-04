# JM-NPCRoadRage - Refactored Structure

## Overview
This script has been completely refactored into a modular architecture for better maintainability, readability, and extensibility.

## New File Structure

```
JM-NPCRoadRage/
├── fxmanifest.lua          # Updated manifest with new structure
├── config.lua              # Reorganized configuration with clear sections
├── database.sql            # Database schema (optional)
├── README.md               # Main documentation
├── REFACTOR.md             # This file - refactoring documentation
├── INSTALL.md              # Installation guide
├── DISCORD_SETUP.md        # Discord webhook setup
│
├── shared/                 # Shared between client and server
│   └── utils.lua           # Common utility functions
│
├── locales/                # Localization files
│   └── en.lua              # English translations
│
├── client/                 # Client-side modules
│   ├── core.lua            # Core initialization & state management
│   ├── utils.lua           # Client-specific utilities
│   ├── rage.lua            # Road rage system logic
│   ├── trollcops.lua       # Troll cop spawning & behavior
│   └── commands.lua        # Admin commands (client-side)
│
└── server/                 # Server-side modules
    ├── core.lua            # Core initialization & utilities
    ├── discord.lua         # Discord webhook logging
    ├── police.lua          # Police integration & notifications
    ├── database.lua        # Database logging & injury system
    └── commands.lua        # Admin commands (server-side)
```

## Key Improvements

### 1. Modular Architecture
- **Separated concerns**: Each file has a single, clear responsibility
- **Easier maintenance**: Bug fixes and updates are isolated to specific modules
- **Better organization**: Related functions are grouped together

### 2. Client Modules

#### `client/core.lua`
- Player state management
- Main initialization
- Event registration
- Core utility functions

#### `client/utils.lua`
- Weapon filtering
- Vehicle detection
- Animation/sound helpers
- Model loading utilities

#### `client/rage.lua`
- Road rage detection logic
- NPC behavior sequencing
- Attack/flee mechanics
- Damage monitoring

#### `client/trollcops.lua`
- Troll cop spawning
- Jurisdiction checking
- Cop behavior scheduling
- Session tracking

#### `client/commands.lua`
- All admin commands
- Permission checking
- Statistics display

### 3. Server Modules

#### `server/core.lua`
- Server initialization
- Player data retrieval
- Police count tracking
- Core utilities

#### `server/discord.lua`
- Discord webhook logging
- Spam prevention
- Field formatting
- Combined incident logs

#### `server/police.lua`
- Police notifications
- Alert dispatching
- Response scheduling
- Troll cop event handling

#### `server/database.lua`
- Incident logging
- Player injury system
- Database operations (optional)
- Statistics queries

#### `server/commands.lua`
- Admin command handlers
- Permission validation
- Statistics commands

### 4. Shared Module

#### `shared/utils.lua`
- Common utility functions
- Distance calculations
- Table operations
- Config validation

### 5. Configuration Improvements

The `config.lua` file has been reorganized with:
- **Clear sections** with headers
- **Better comments** explaining each setting
- **Logical grouping** of related settings
- **Validation helpers** in shared utils

## Migration from Old Structure

### Old Files (Backup Recommended)
The old monolithic files were:
- `client/main.lua` (652 lines)
- `server/main.lua` (777 lines)

### New Files
These have been split into multiple focused modules as shown above.

### Breaking Changes
**None!** The refactoring maintains full backward compatibility:
- All events use the same names
- All exports work the same way
- Config structure is unchanged (only formatted better)
- Commands remain identical

## Benefits

### For Developers
1. **Easier to understand**: Each file has a clear purpose
2. **Faster debugging**: Issues are isolated to specific modules
3. **Better collaboration**: Multiple devs can work on different modules
4. **Simpler testing**: Individual modules can be tested in isolation

### For Server Owners
1. **More reliable**: Better code organization = fewer bugs
2. **Easier customization**: Modify specific features without touching others
3. **Better performance**: Optimized structure and load order
4. **Future-proof**: Easier to add new features

### For Users
1. **Same functionality**: All features work exactly as before
2. **Better stability**: Cleaner code = fewer crashes
3. **Faster updates**: Easier for developers to add improvements

## Load Order

The manifest ensures proper load order:

1. **Shared**: `shared/utils.lua`
2. **Client**: core → utils → rage → trollcops → commands
3. **Server**: core → discord → police → database → commands

This order ensures dependencies are met before modules that need them load.

## Code Quality Improvements

### 1. Consistent Naming
- Modules use PascalCase (e.g., `RageModule`, `TrollCops`)
- Functions use camelCase (e.g., `getTotalCount`, `checkPermission`)
- Constants use UPPER_SNAKE_CASE in config

### 2. Documentation
- All major functions have JSDoc-style comments
- Parameter types are documented
- Return types are specified

### 3. Error Handling
- Proper validation of player objects
- Safe entity checks before operations
- Graceful fallbacks for missing data

### 4. Performance
- Efficient thread management
- Optimized searches and loops
- Reduced redundant calculations

## Backwards Compatibility

All original functionality is preserved:
- ✅ Road rage detection
- ✅ NPC behavior (attack, yell, flee)
- ✅ Weapon filtering
- ✅ Police notifications
- ✅ Discord logging
- ✅ Troll cops feature
- ✅ Admin commands
- ✅ Injury system
- ✅ Safe zones

## Testing Recommendations

After installing the refactored version:

1. **Test basic road rage**: Drive aggressively, verify NPCs react
2. **Test weapons**: Check that blacklisted weapons are filtered
3. **Test police**: Verify alerts are sent when configured
4. **Test Discord**: Check webhook logs are sent properly
5. **Test commands**: Try all admin commands
6. **Test troll cops**: If enabled, verify spawning works
7. **Test injuries**: Verify medical system integration

## Future Enhancements

The modular structure makes these easier to add:
- Custom NPC models per jurisdiction
- Advanced AI behavior patterns
- Statistical tracking dashboard
- Web panel integration
- Multi-language support expansion
- Economy integration (fines, payouts)

## Support

If you encounter issues after the refactor:
1. Check console for error messages
2. Verify all new files are present
3. Ensure proper load order in fxmanifest
4. Test with original config first
5. Review this documentation

## Credits

- **Original Script**: JM Modifications
- **Refactoring**: Modular architecture implementation
- **Version**: 1.0.0 (Refactored)

---

**Note**: The old `client/main.lua` and `server/main.lua` files should be backed up before deletion, but are no longer needed with this refactored structure.
