local ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar:new(x, y, w, h, win)
    local obj = {
        x = x,
        y = y,
        w = w,
        h = h,
        win = win,
        value = 0,
    }
    setmetatable(obj, ProgressBar)
    return obj
end

function ProgressBar:draw()
    local filled = math.floor(self.w * self.value)
    self.win.setCursorPos(self.x, self.y)
    self.win.write(string.rep("=", filled) .. string.rep(" ", self.w - filled))
end

-- Метод: задать значение
function ProgressBar:setValue(v)
    if v < 0 then v = 0 end
    if v > 1 then v = 1 end
    self.value = v
end




return ProgressBar