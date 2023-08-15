local function getUtilTables(tables)
    local newUtil = {}
    for i=1,#tables do
        local tbl = tables[i]
        newUtil[tbl] = require("util." .. tbl)
    end
    return newUtil
end

return getUtilTables
