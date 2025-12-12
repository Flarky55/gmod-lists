local mt = {}
mt.__index = mt

local methods = {}

function mt:__index(k)
    return methods[k] or self.list[k]
end

function mt:__newindex()
    error("enum is immutable!")
end


function methods:is_defined(v)
    return self.defined[v] == true
end


local function enum(names)
    local list, defined = {}, {}
    
    for i, name in ipairs(names) do
        list[name] = i-1
        defined[i-1] = true
    end 

    local _, bits = math.frexp(#names)
    
    return setmetatable({list = list, defined = defined, bits = bits}, mt)
end

_G.enum = enum