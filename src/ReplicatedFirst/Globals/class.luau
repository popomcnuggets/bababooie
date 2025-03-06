local function CreateObjectTable(parentTable)
    local objectTable = {}
    objectTable.table = parentTable and setmetatable({}, parentTable) or {}
    objectTable.proxy = newproxy(true)
    objectTable.metatable = setmetatable({}, table)
    objectTable.proxyMetatable = getmetatable(objectTable.proxy)
    objectTable.metatable.__index = parentTable
    objectTable.proxyMetatable.__index = objectTable.table
    objectTable.proxyMetatable.__newindex = objectTable.table
    return objectTable
end

local function InitializeClass(class, ...)
    local classObject = CreateObjectTable(class.table)
    classObject.proxyMetatable.__call = function(...)
        if classObject.table.__call then
            classObject.table.__call(...)
        end
    end
    if classObject.table.__init then
        classObject.table.__init(...)
    end
    return classObject.proxy
end

local function class(super)
    local class = CreateObjectTable(super and getmetatable(super).__class)
    class.proxyMetatable.__call = function(...)
        return InitializeClass(class, ...)
    end
    class.proxyMetatable.__class = class
    return class.proxy
end

return class