local function enum(names)
    assert( table.IsSequential(names), "bad argument #1 ('names' should be a sequntial table)" )


    local instance, mt = newproxy(), {}
    debug.setmetatable(instance, mt)
    
    local list, defined, len = {}, {}, #names
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

    local _, bits = math.frexp(len - 1)
    index.bits = bits


    for i = 1, len do
        local name = names[i]
        local n = i - 1

        list[name] = n
        defined[n] = true
    end
    

    return instance
end

_G.enum = enum