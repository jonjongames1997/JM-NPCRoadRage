# Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     JM-NPCRoadRage Architecture                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        SHARED LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  utils.lua                                                       │
│  • Distance calculations                                         │
│  • Table operations                                              │
│  • Config validation                                             │
│  • Common utilities                                              │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────────────┬──────────────────────────────────┐
│         CLIENT SIDE          │         SERVER SIDE              │
├──────────────────────────────┼──────────────────────────────────┤
│                              │                                  │
│  ┌────────────────────────┐  │  ┌────────────────────────────┐  │
│  │      core.lua          │  │  │      core.lua              │  │
│  │  • Initialization      │  │  │  • Server init             │  │
│  │  • Player state        │  │  │  • Police count            │  │
│  │  • Event registration  │  │  │  • Player data             │  │
│  └────────────────────────┘  │  └────────────────────────────┘  │
│            ▼                 │             ▼                    │
│  ┌────────────────────────┐  │  ┌────────────────────────────┐  │
│  │     utils.lua          │  │  │    discord.lua             │  │
│  │  • Weapon filtering    │  │  │  • Webhook logging         │  │
│  │  • Vehicle detection   │  │  │  • Spam prevention         │  │
│  │  • Animations          │  │  │  • Field formatting        │  │
│  └────────────────────────┘  │  └────────────────────────────┘  │
│            ▼                 │             ▼                    │
│  ┌────────────────────────┐  │  ┌────────────────────────────┐  │
│  │      rage.lua          │  │  │     police.lua             │  │
│  │  • Detection logic     │  │  │  • Alert dispatching       │  │
│  │  • NPC behavior        │  │  │  • Response scheduling     │  │
│  │  • Attack sequences    │  │  │  • Admin notifications     │  │
│  └────────────────────────┘  │  └────────────────────────────┘  │
│            ▼                 │             ▼                    │
│  ┌────────────────────────┐  │  ┌────────────────────────────┐  │
│  │   trollcops.lua        │  │  │    database.lua            │  │
│  │  • Cop spawning        │  │  │  • Injury system           │  │
│  │  • Jurisdiction check  │  │  │  • Incident logging        │  │
│  │  • Behavior control    │  │  │  • Statistics              │  │
│  └────────────────────────┘  │  └────────────────────────────┘  │
│            ▼                 │             ▼                    │
│  ┌────────────────────────┐  │  ┌────────────────────────────┐  │
│  │    commands.lua        │  │  │    commands.lua            │  │
│  │  • Admin commands      │  │  │  • Admin commands          │  │
│  │  • Permission checks   │  │  │  • Statistics commands     │  │
│  │  • Statistics display  │  │  │  • Toggle system           │  │
│  └────────────────────────┘  │  └────────────────────────────┘  │
│                              │                                  │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        CONFIGURATION                             │
├─────────────────────────────────────────────────────────────────┤
│  config.lua                                                      │
│  • Core settings          • Discord integration                 │
│  • Road rage behavior     • Safe zones                          │
│  • Weapon configuration   • Troll cops setup                    │
│  • Police integration     • Sound settings                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      DATA FLOW EXAMPLE                           │
└─────────────────────────────────────────────────────────────────┘

Player Drives Aggressively
    │
    ▼
[client/rage.lua] Detects collision
    │
    ▼
[client/rage.lua] Triggers road rage
    │
    ├──────────────────────────────────┐
    │                                  │
    ▼                                  ▼
[client/rage.lua]                [server/police.lua]
Makes NPC attack                 Sends police alert
    │                                  │
    │                                  ▼
    │                            [server/discord.lua]
    │                            Logs to webhook
    ▼                                  │
[client/rage.lua]                      │
Monitors player health                 │
    │                                  │
    ▼                                  │
[server/database.lua] ◄────────────────┘
Logs injury & incident

┌─────────────────────────────────────────────────────────────────┐
│                      MODULE DEPENDENCIES                         │
└─────────────────────────────────────────────────────────────────┘

CLIENT:
  shared/utils.lua
       │
       ├──► client/core.lua
       │         │
       │         ├──► client/utils.lua
       │         │         │
       │         │         ├──► client/rage.lua
       │         │         │         │
       │         │         │         └──► client/commands.lua
       │         │         │
       │         │         └──► client/trollcops.lua
       │         │                   │
       │         │                   └──► client/commands.lua
       │         │
       │         └──► All other modules

SERVER:
  shared/utils.lua
       │
       ├──► server/core.lua
       │         │
       │         ├──► server/discord.lua
       │         │         │
       │         │         ├──► server/police.lua
       │         │         │
       │         │         └──► server/database.lua
       │         │
       │         └──► server/commands.lua

┌─────────────────────────────────────────────────────────────────┐
│                    KEY DESIGN PATTERNS                           │
└─────────────────────────────────────────────────────────────────┘

1. MODULE PATTERN
   Each file exports a module object with related functions

2. SEPARATION OF CONCERNS
   Each module handles a specific responsibility

3. DEPENDENCY INJECTION
   Modules use other modules through shared interfaces

4. EVENT-DRIVEN
   Client and server communicate via events

5. LAZY INITIALIZATION
   Modules initialize only when needed

┌─────────────────────────────────────────────────────────────────┐
│                   EXTENSION POINTS                               │
└─────────────────────────────────────────────────────────────────┘

Want to add new features? Easy!

• New NPC behavior → Add to client/rage.lua
• New admin command → Add to client/commands.lua or server/commands.lua
• New logging type → Add to server/discord.lua
• New jurisdiction → Add to config.lua trollcops section
• New weapon type → Add to config.lua weapons section
• New safe zone → Add to config.lua blacklisted areas

┌─────────────────────────────────────────────────────────────────┐
│                    PERFORMANCE NOTES                             │
└─────────────────────────────────────────────────────────────────┘

• Client threads: 2 main threads (core + rage monitoring)
• Server threads: 2 background threads (discord reset + stats)
• Event handlers: Registered once at initialization
• Cleanup: Automatic inactive NPC cleanup every second
• Optimization: Efficient proximity searches and entity checks

┌─────────────────────────────────────────────────────────────────┐
│                      SECURITY MODEL                              │
└─────────────────────────────────────────────────────────────────┘

CLIENT SIDE:
• Permission checks before command execution
• Validates player data before actions
• Sanitizes user input

SERVER SIDE:
• Double-checks permissions on events
• Validates source and player objects
• Prevents spam with cooldowns and rate limits
• Sanitizes Discord webhook data

┌─────────────────────────────────────────────────────────────────┐
│                         SCALABILITY                              │
└─────────────────────────────────────────────────────────────────┘

The modular architecture allows:
• Easy horizontal scaling (add more modules)
• Independent feature updates
• Parallel development by multiple developers
• Plugin-style extensions
• Custom module replacement without affecting others
