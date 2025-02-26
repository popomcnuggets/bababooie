--TODO: typechecking

local _specialmethods = {
    "__new__",
    "__init__"
}

local _metamethods = {
    "__index__",
    "__newindex__",
    "__call__",
    "__concat__",
    "__unm__",
    "__add__",
    "__sub__",
    "__mul__",
    "__div__",
    "__idiv__",
    "__mod__",
    "__pow__",
    "__tostring__",
    "__metatable__",
    "__eq__",
    "__lt__",
    "__le__",
    "__mode__",
    "__gc__",
    "__len__",
    "__iter__"
}

local function class(super)
    local class = super and setmetatable({}, super.__class) or {}
    local proxy = newproxy(true)
    local metatable = getmetatable(proxy)
    class.__class = class
    metatable.__index = class
    metatable.__call = class.__init
    metatable.__newindex = function(table, index, value)
        class[index] = value
    end

    return proxy
end

return class