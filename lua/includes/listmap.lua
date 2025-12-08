local function ListMap()
    local instance, mt = newproxy(true), {}
    debug.setmetatable(instance, mt)

    local map, keys, positions, len = {}, {}, {}, 0

    function mt:__len()
        return len
    end

    function mt:__index(k)
        return rawget(mt, k) or map[k]
    end

    function mt:__newindex(k, v)
        if v == nil then
            -- remove
            local pos = positions[k]
            if pos == nil then return end

            local lastKey = keys[len]

            keys[pos] = lastKey
            positions[lastKey] = pos

            keys[len] = nil
            positions[k] = nil
            map[k] = nil

            len = len - 1
        else
            if map[k] == nil then
                -- insert
                len = len + 1

                keys[len] = k
                positions[k] = len

                map[k] = v
            else
                -- update
                map[k] = v
            end
        end
    end

    function mt:ipairs()
        local i = 0
        local key 

        return function()
            i = i + 1
            key = keys[i]

            if key == nil then return nil end

            return i, map[key]
        end
    end

    function mt:pairs()
        local i = 0
        local key

        return function()
            i = i + 1
            key = keys[i]

            if key == nil then return nil end
            
            return key, map[key]
        end
    end

    return instance
end

_G.ListMap = ListMap