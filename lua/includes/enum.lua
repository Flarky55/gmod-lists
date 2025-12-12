local function enum(names)
    local instance, mt = newproxy(), {}
    debug.setmetatable(instance, mt)

    
    local list, defined, len = {}, {}, 0
    local index = {}

    function mt:__len()
        return len
    end
    
    function mt:__index(k)
        return index[k] or list[k]
    end

    function mt:__newindex()
        error("enum is immutable!")
    end
    
    index.is_defined = function(self, k)
        return defined[k] == true
    end

    local _, bits = math.frexp(#names - 1)
    index.bits = bits
    

    return instance
end

_G.enum = enum