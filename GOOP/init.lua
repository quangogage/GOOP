-- Get the current script's directory
local currentDir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
-- Modify package.path to include the current directory
package.path = package.path .. ";" .. currentDir .. "?.lua"

local util = require("util.util")({"table"})
local Goop = {}

---Check that all required parameters are present
---@param params table
---@param requiredParams table
function checkParameters(params, requiredParams)
    for i=1,#requiredParams do
        local key = requiredParams[i][1]
        if key then
            local expectedType = requiredParams[i][2]
            if params[key] == nil then
                error("Missing parameter '" .. key .. "'.")
            elseif type(params[key]) ~= expectedType and params[key].type ~= expectedType then
                error(key .. " is wrong type. Expected '" .. expectedType .. "'. Received '" .. type(params[key]) .. "'.")
            end
        end
    end
end

---Define a new class
---@param data {static?: table, dynamic?: table, extends?: table, parameters: table[]}
function Goop.Class(data)

    ---Add static and dynamic state to the definition's table.
    local state = {
        static = data.static or {},
        dynamic = data.dynamic or {}
    }
    local newClassDefinition = {}
    util.table.copy(newClassDefinition, state.static)
    util.table.copy(newClassDefinition, state.dynamic)

    ---Set required parameters
    newClassDefinition.requiredParameters = data.parameters or {}

    ---Metatable
    local mt = {
        __call = function(_,params)
            local params = params or {}
            checkParameters(params,newClassDefinition.requiredParameters)
            ---Create new references for all dynamic data - but use __index fallback for static.
            local newInstance
            if data.extends then
                newInstance = data.extends(params)
            else
                newInstance = util.table.createDeepCopy(state.dynamic)
            end
            util.table.copy(newInstance,params)
            setmetatable(newInstance, {__index = newClassDefinition})
            return newInstance
        end
    }
    if data.extends then
        mt.__index = data.extends
    end
    setmetatable(newClassDefinition, mt)
    return newClassDefinition
end

return Goop
