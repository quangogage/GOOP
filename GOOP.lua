
--- ** UTIL/TABLE.LUA ** --
---Various table manipulation functions.
local util = {}
util.table = {}
function util.table.copy(new, original)
    for key,value in pairs(original) do
        new[key] = value
    end
end
function util.table.deepCopy(new, original)
    if type(original) == "table" then
        local mt = getmetatable(original)
        setmetatable(new, mt)
    end
    for key,value in pairs(original) do
        if type(value) == "table" then
            new[key] = {}
            util.table.deepCopy(new[key], value)
        else
            new[key] = value
        end
    end
end
function util.table.createDeepCopy(original)
    local newCopy = {}
    if type(original) == "table" then
        local mt = getmetatable(original)
        setmetatable(newCopy, mt)
    end
    for key,value in pairs(original) do
        if type(value) == "table" then
            newCopy[key] = util.table.createDeepCopy(value)
        else
            newCopy[key] = value
        end
    end
    return newCopy
end


--- ** GOOP.LUA ** ---
local Goop = {}
---Check that all required parameters are present
---@param params table
---@param requiredParams table
function checkParameters(params, requiredParams)
    for i=1,#requiredParams do
        local key
        if type(requiredParams[i]) == "table" then
            key = requiredParams[i][1]
        else
            key = requiredParams[i]
        end
        if key then
            local expectedType = requiredParams[i][2]
            if params[key] == nil then
                error("GOOP: Missing parameter '" .. key .. "'.")
            elseif expectedType ~= nil then ---If a type was specified for this parameter
                local invalidType = true
                if type(params[key]) ~= expectedType then ---If it doesn't have the correct type.
                    if type(params[key]) == "table" then ---If it's a table, BUT it has a hardcoded `.type` value that matches the expected type.
                        if params[key].type == expectedType then
                            invalidType = false
                        end
                    end
                    if invalidType then
                        error("GOOP: " .. key .. " is wrong type. Expected '" .. expectedType .. "'. Received '" .. type(params[key]) .. "'.")
                    end
                end
            end
        end
    end
end

---Check if the class being instantiated is a sub-class (inherits from another class).
function isSubClass(...)
    local args = {...}
    for i=1,#args do
        local arg = args[i]
        if type(arg) == "table" then
            if arg._isSubClass then
                return true
            end
        end
    end
    return false
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

    ---Metatable
    local mt = {
        __call = function(_,...)
            local passedState

            ---Parameters
            if data.parameters then
                passedState = select(1, ...)
                assert(... ~= nil, "GOOP: Class insantiated without required parameters")
                assert(type(...) == "table", "GOOP: Class expected parameters (table), received: " .. type(...))
                checkParameters(passedState, data.parameters)
            ---Arguments
            elseif data.arguments then
                local args = {...}
                passedState = {}
                for i=1,#data.arguments do
                    local key = data.arguments[i]
                    if type(key) == "table" then
                        key = data.arguments[i][1]
                    end
                    passedState[key] = args[i]
                    if args[i] == nil then
                        error("GOOP: Missing arguments, expected " .. #data.arguments .. ". Received " .. #args)
                    elseif type(data.arguments[i]) == "table" then ---If a type was specified and needs to be checked for this argument.
                        local expectedType = data.arguments[i][2]
                        if type(args[i]) ~= expectedType then
                            local invalidType = true
                            if type(args[i]) == "table" then
                                if args[i].type == expectedType then
                                    invalidType = false
                                end
                            end
                            if invalidType then
                                error("GOOP: Argument #" .. i .. " is wrong type. Expected '" .. expectedType .. "'. Received '" .. type(args[i]) .. "'.")
                            end
                        end
                    else
                        passedState[key] = args[i]
                    end
                end
            end

            ---Create new references for all dynamic data - but use __index fallback for static.
            local newInstance
            if data.extends then
                ---Create a new instance of the parent class
                local args = {...}
                table.insert(args, {_isSubClass = true})
                newInstance = data.extends(unpack(args))
                util.table.deepCopy(newInstance,state.dynamic)
                util.table.copy(newInstance,state.static)
            else
                ---Create new references of the dynamic state values.
                newInstance = util.table.createDeepCopy(state.dynamic)
            end
            if passedState then
                util.table.copy(newInstance, passedState)
            end

            setmetatable(newInstance, {__index = newClassDefinition})
            if newInstance.init and not isSubClass(...) then
                newInstance:init(...)
            end
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
