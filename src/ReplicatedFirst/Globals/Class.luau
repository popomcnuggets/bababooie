local function __call()

end

local function class(super)
    local class = {}
    class.__call = __call
    
    return class
end

return class