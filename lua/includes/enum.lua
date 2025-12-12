local function enum(names)
    assert( table.IsSequential(names), "enum must be a sequential table" )

    local len = #names
    assert( len >= 2, "enum must contain at least 2 members" )

    local list, defined = {}, {}

    for i = 1, len do
        local name = names[i]
        assert( list[name] == nil, "duplicate name: " .. name )

        local n = i - 1

        list[name] = n
        defined[n] = true
    end

    local mt = {}
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

    index.bits = math.ceil(math.log(len, 2))
    
    local instance = newproxy()
    debug.setmetatable(instance, mt)

    return instance
end

_G.enum = enum