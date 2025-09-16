local ProgressBarAdvanced = {}
ProgressBarAdvanced.__index = ProgressBarAdvanced

-- Создание
function ProgressBarAdvanced:new(x, y, w, h, win)
    local obj = {
        x = x,
        y = y,
        w = w,
        h = h,
        win = win,
        value = 0,
        fillColor = colors.green,
        bgColor = colors.gray,
        textColor = colors.white,
        text = "",
        animate = true,
        spinnerFrames = {"|","/","-","\\"},
        spinnerIndex = 1,
        showPercent = true,
        align = "left"
    }
    setmetatable(obj, ProgressBarAdvanced)
    return obj
end

function ProgressBarAdvanced:setValue(v)
    if v < 0 then v = 0 end
    if v > 1 then v = 1 end
    self.value = v
end

function ProgressBarAdvanced:draw()
    local filled = math.floor(self.w * self.value)
    local barText = self.text

    if self.showPercent then
        local percentText = string.format(" %d%%", math.floor(self.value * 100))
        barText = barText .. percentText
    end
    local startX = 1
    if #barText > self.w then
        barText = barText:sub(1, self.w)
    end
    if self.align == "center" then
        startX = math.floor((self.w - #barText) / 2) + 1
    elseif self.align == "right" then
        startX = self.w - #barText + 1
    end
    for i = 1, self.w do
        local char = " "
        local color = self.bgColor
        if i <= filled then
            color = self.fillColor
        end

        local textPos = i - startX + 1
        if textPos >= 1 and textPos <= #barText then
            char = barText:sub(textPos,textPos)
        end

        self.win.setBackgroundColor(color)
        self.win.setCursorPos(self.x + i - 1, self.y)
        self.win.setTextColor(self.textColor)
        self.win.write(char)
    end
    if self.animate then
        self.win.setCursorPos(self.x + self.w + 1, self.y)
        self.win.write(self.spinnerFrames[self.spinnerIndex])
        self.spinnerIndex = self.spinnerIndex % #self.spinnerFrames + 1
    end
    self.win.setBackgroundColor(colors.black)
end

return ProgressBarAdvanced