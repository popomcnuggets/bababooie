local function CreateObjectTable(parentTable)
    local objectTable = {
        table = parentTable and setmetatable({}, parentTable) or {},
        proxy = newproxy(true),
        metatable = getmetatable(table),
        proxyMetatable = getmetatable(proxy)
    }
    objectTable.metatable.__index = parentTable
    objectTable.proxyMetatable.__index = objectTable.table
    objectTable.proxyMetatable.__newindex = objectTable.table
    return objectTable
end

local function InitializeClass(super, ...)
    local class = CreateObjectTable(super)
    class.proxyMetatable.__call = function(...)
        if class.__call then
            class.__call(...)
        end
    end
    if class.table.__init then
        class.table.__init(...)
    end
    return class.proxy
end

local function class(super)
    local class = CreateObjectTable(super and super.__class)
    class.proxyMetatable.__call = function(...)
        InitializeClass(class, ...)
    end
    class.proxyMetatable.__class = class
    return class.proxy
end

return class