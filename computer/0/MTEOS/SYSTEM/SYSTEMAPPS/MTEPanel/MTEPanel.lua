local w, h = term.getSize()
term.setBackgroundColor(colors.lightBlue)
local scroll = 0
local function clamp(x, min, max)
    if x < min then return min
    elseif x > max then return max end
    if max < min then return 0 end
    return x
end

while true do
    local windows = {}
    for i, procces in pairs(appEngine.appRunning) do 
        if procces.window then
            table.insert(windows, procces)
        end
    end
    local buttons = {}
    local lastPos = 0
    local lineStr = ''
    for i, winProc in ipairs(windows) do
        local namestr = ' ' .. winProc.name .. ' '
        lineStr = lineStr .. namestr
        table.insert(buttons, {x = lastPos, str = namestr, endPos = lastPos+#namestr, port = winProc.port, window = winProc.window})
        lastPos = lastPos + #namestr
    end

    

    term.setCursorPos(-scroll, 2)
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.black)
    term.clearLine()
    for i, value in pairs(buttons) do
        if i % 2 == 0 then
            term.setBackgroundColor(colors.orange)
        else
            term.setBackgroundColor(colors.yellow)
        end 
        term.write(value.str)
    end
    term.setBackgroundColor(colors.red)
    term.setCursorPos(w, h)
    term.write('X')
    local data = readEvent('mokey', true, true)
    if data.data.event == 'mouse_scroll' then
        scroll = scroll + data.data.arg1
        scroll = clamp(scroll, 0, #lineStr-w-1)
    elseif data.data.event == 'mouse_click' and data.data.arg3 == 2 then
        if data.data.arg2 == w then
            if appEngine.activeWin ~= 15 then
                appEngine:closeAndFocusPrev(appEngine.activeWin)
            end
        else
            local buttonorgPos = data.data.arg2 + scroll
            for i, value in pairs(buttons) do
                if buttonorgPos <= value.endPos and buttonorgPos >= value.x then
                    appEngine:showAppByPort(15)
                    sleep(0)
                    appEngine:showAppByPort(value.port)
                end
            end
        end 
    end
end
