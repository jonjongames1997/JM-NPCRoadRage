-- Shared utility functions used by both client and server

Utils = {}

--- Check if a position is within a radius of another position
---@param pos1 vector3 First position
---@param pos2 vector3 Second position
---@param radius number Radius to check
---@return boolean
function Utils.IsInRadius(pos1, pos2, radius)
    return #(pos1 - pos2) <= radius
end

--- Get formatted timestamp
---@return string
function Utils.GetTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

--- Check if a value is in a table
---@param tbl table Table to search
---@param value any Value to find
---@return boolean
function Utils.TableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

--- Deep copy a table
---@param orig table Original table
---@return table
function Utils.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Utils.DeepCopy(orig_key)] = Utils.DeepCopy(orig_value)
        end
        setmetatable(copy, Utils.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

--- Format coordinates as string
---@param coords vector3 Coordinates
---@return string
function Utils.FormatCoords(coords)
    return string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z)
end

--- Generate random number with seed
---@param min number Minimum value
---@param max number Maximum value
---@return number
function Utils.RandomRange(min, max)
    return math.random(min, max)
end

--- Validate config table structure
---@param config table Config table to validate
---@return boolean, string
function Utils.ValidateConfig(config)
    if not config then
        return false, "Config table is nil"
    end
    
    -- Validate required fields
    local requiredFields = {
        "RoadRageChance",
        "TriggerDistance",
        "RageTimeout",
        "MaxRageNPCs",
        "AttackChance"
    }
    
    for _, field in ipairs(requiredFields) do
        if config[field] == nil then
            return false, string.format("Missing required config field: %s", field)
        end
    end
    
    return true, "Config validated successfully"
end

return Utils
