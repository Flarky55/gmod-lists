local function queue()
    local instance, mt = newproxy(true), {}
    debug.setmetatable(instance, mt)


    local list, offset, len = {}, 1, 0

    function mt:__len()
        return len
    end

    local index = {}; mt.__index = index

    index.enqueue = function(item)
        len = len + 1
        list[len] = item
    end

    index.dequeue = function(n)
        if len == 0 then return nil end

        local item = list[offset]
        list[offset] = nil

        offset = offset + 1

        len = len - 1
    
        return item
    end

    index.peek = function()
        return list[offset]
    end

    return instance
end

_G.queue = queue