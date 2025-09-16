local PixelArt = {}
PixelArt.__index = PixelArt

function PixelArt:new(win)
    local obj = { win = win }
    setmetatable(obj, PixelArt)
    return obj
end

function PixelArt:draw(pic, x, y)
    x = x or 1
    y = y or 1

    local h = #pic
    for j = 1, h do
        local row = pic[j]
        if row then
            local w = #row
            for i = 1, w do
                local color = row[i]
                if color then
                    self.win.setCursorPos(x + i - 1, y + j - 1)
                    self.win.setBackgroundColor(color)
                    self.win.write(" ")
                end
            end
        end
    end

    self.win.setBackgroundColor(colors.black)
end

return PixelArt