local function bitflags(names)
    assert( table.IsSequential(names), "bitflags must be a sequential table" )

    local len = #names
    assert( len <= 32, "too many flags (max 32)" )
    
    local list = {}

    for i = 1, len do
        local name = name[i]
        assert( list[name] == nil, "duplicate name: " .. name )

        list[name] = 2 ^ (i - 1)
    end

    local mt = {}
    local index = {}

    function mt:__len()
        return len
    end
    
    function mt:__index(k)
        return index[k] or list[k]
    end

    function mt:__newindex(k, v)
        error("bitflags is immutable!")
    end

    index.bits = len

    local instance = newproxy()
    debug.setmetatable(instance, mt)

    return instance
end

_G.bitflags = bitflags