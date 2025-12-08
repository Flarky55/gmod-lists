local remove = table.remove


-- local mt = {}
-- mt.__index = mt

-- function mt:__len()
--     return self.len
-- end
-- function mt:enqueue(item)
--     self.len = self.len + 1
--     self.list[self.len] = item
-- end
-- function mt:dequeue()
--     if self.len == 0 then return nil end
--     local item = remove(self.list, 1)
    
--     self.len = self.len - 1
    
--     return item
-- end
-- function mt:peek()
--     return self.list[1]
-- end


-- local function queue()
--     return setmetatable({
--         len = 0,
--         list = {},
--     }, mt)
-- end

local function queue()
    local instance, mt = newproxy(true), {}
    debug.setmetatable(instance, mt)

    mt.__index = mt

    local list, offset, len = {}, 0, 0

    function mt:__len()
        return len
    end

    function mt:enqueue(item)
        len = len + 1
        list[len] = item
    end

    function mt:dequeue()
        if len == 0 then return nil end

        offset = offset + 1

        local item = list[offset]
        list[offset] = nil

        if offset * 2 >= len then
            -- print("optimize at", offset * 2, len, #list)
            local pos = 1
            
            for i = offset, #list do
                list[pos] = list[i]
                list[i] = nil

                pos = pos + 1
            end

            offset = 1
        end

        len = len - 1
    
        return item
    end

    function mt:peek()
        return list[1]
    end

    return instance
end



local gc_start = collectgarbage("count")

local q = queue() 

local time_start = SysTime()
do
    for i = 1, 100000 do
        q:enqueue(i)
    end
end
local time_end = SysTime()

print( Format("enequeue took %f", time_end - time_start) )


local time_start = SysTime()
do
    for i = 1, 100000 do
        local item = q:dequeue()
    end
end
local time_end = SysTime()

print( Format("dequeue took %f", time_end - time_start) )

local gc_end = collectgarbage("count")

print(gc_end - gc_start)