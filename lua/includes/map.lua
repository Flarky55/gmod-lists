local function map()
    local instance, mt = newproxy(), {}
    debug.setmetatable(instance, mt)


    local list, keys, positions, len = {}, {}, {}, 0
    local index = {}

    function mt:__len()
        return len
    end

    function mt:__index(k)
        return index[k] or list[k]
    end

    function mt:__newindex(k, v)
        if v == nil then
            if list[k] == nil then return end

            list[k] = nil

            local lastkey = keys[len]
            local pos = positions[k]

            keys[pos] = lastkey
            keys[len] = nil

            positions[lastkey] = pos
            positions[k] = nil

            len = len - 1

            return
        end

        if list[k] == nil then
            len = len + 1

            keys[len] = k
            positions[k] = len

            list[k] = v
        else
            list[k] = v
        end
    end

    index.ipairs = function()
        local i = 0
        local key

        return function()
            i = i + 1
            key = keys[i]

            if key == nil then return nil end

            return i, list[key]
        end
    end

    return instance
end

_G.map = map