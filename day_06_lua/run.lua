pgrid = function(grid, len) for k, v in pairs(grid) do if v == 1 then io.write(1) else io.write(v) end if k % len == 0 then io.write('\n') end end end

t1 = os.time()

Coord = {x = 0, y = 0}
function Coord:in_bounds(len) return 0 <= self.x and self.x < len and 0 <= self.y and self.y < len end
function Coord:new(x, y)
    o = {}
    setmetatable(o, self)
    o.x = x
    o.y = y
    self.__index = self
    return o
end
function Coord:str() return "("..self.x..","..self.y..')' end
function Coord:clone() return Coord:new(self.x, self.y) end
function Coord:add(other) return Coord:new(self.x + other.x, self.y + other.y) end
function Coord:idx(len) return self.y * len + self.x end

local dirs, f, i, grid, len = {[0]=Coord:new(0, -1), Coord:new(1, 0), Coord:new(0, 1), Coord:new(-1, 0)}, io.open("in.txt", 'r'), 0, {}, 0
local g, sum1, sum2 = Coord:new(), 0, 0
for str in string.gmatch(f:read('a'), "([^\n\r]+)") do
    len = #str
    for idx = 1, len do
        if (str:byte(idx) == 94) then g = Coord:new(idx - 1, i) end
        if str:byte(idx) == 35 then grid[i * len + idx - 1] = 1 else grid[i * len + idx - 1] = 0 end
    end
    i = i + 1
end
f:close()
for y = 0, len - 1 do
    for x = 0, len - 1 do
        if grid[len * y + x] == 1 then goto continue end
        local guard, dir, edge, last = g:clone(), 0, {}, 0
        local b = y == guard.y and x == guard.x
        while true do
            local guard1 = guard:add(dirs[dir])
            if not guard1:in_bounds(len) then break end
            local id = guard1:idx(len)
            if (b or guard1.y ~= y or guard1.x ~= x) and grid[id] ~= 1 then
                guard = guard1
                if (b and grid[id] ~= 2) then
                    sum1 = sum1 + 1
                    grid[id] = 2
                end
            else
                dir = (dir + 1) % 4
                local k = (last * 10000) + (guard.y * 100) + guard.x
                if edge[k] then
                    sum2 = sum2 + 1
                    break
                end
                edge[k] = true
                last = (guard.y * 100) + guard.x
            end
        end
        ::continue::
    end
end
print(sum1, sum2)
print(os.difftime(os.time(), t1))