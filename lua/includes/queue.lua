local function queue()
    local instance, mt = newproxy(), {}
    debug.setmetatable(instance, mt)

    local list, offset, len = {}, 1, 0
    local index = {}
    
    function mt:__len()
        return len
    end

    mt.__index = index

    index.enqueue = function(self, item)
        local pos = offset + len
        
        list[pos] = item
        
        len = len + 1

        return pos
    end

    index.dequeue = function()
        if len == 0 then return nil end

        local item = list[offset]
        
        list[offset] = nil

        offset = offset + 1
        len = len - 1
    
        return item
    end

    index.remove = function(self, n)
        local item = list[n]
        if item == nil then return nil end

        list[n] = nil

        for i = n + 1, offset + len - 1 do
            list[i - 1] = list[i]
        end

        len = len - 1

        return item
    end

    index.peek = function()
        return list[offset]
    end

    return instance
end

_G.queue = queue