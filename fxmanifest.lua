fx_version 'cerulean'
game 'gta5'

author 'JM Modifications'
description 'NPC Road Rage Script for QBCore - Refactored & Modular'
version '1.0.0'

-- ============================================
-- SHARED SCRIPTS
-- ============================================
shared_scripts {
    'config.lua',
    'locales/en.lua',
    'shared/utils.lua'
}

-- ============================================
-- CLIENT SCRIPTS (Load order matters!)
-- ============================================
client_scripts {
    'client/core.lua',       -- Core initialization
    'client/utils.lua',      -- Utility functions
    'client/rage.lua',       -- Road rage system
    'client/trollcops.lua',  -- Troll cop system
    'client/commands.lua'    -- Admin commands
}

-- ============================================
-- SERVER SCRIPTS (Load order matters!)
-- ============================================
server_scripts {
    'server/core.lua',       -- Core initialization
    'server/discord.lua',    -- Discord logging
    'server/police.lua',     -- Police integration
    'server/database.lua',   -- Database & injuries
    'server/commands.lua'    -- Admin commands
}

-- ============================================
-- DEPENDENCIES
-- ============================================
dependencies {
    'qb-core',
    'qb-policejob',
    'qb-ambulancejob'
}

lua54 'yes'