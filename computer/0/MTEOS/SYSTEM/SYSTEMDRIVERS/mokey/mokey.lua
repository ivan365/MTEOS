
while true do
    local package = MTEeventEngine:readEvent(0, 'mokey', true, true)
    if MTEeventEngine.activeWin ~= 0 then
        if package.data.event == 'mouse_click' or package.data.event == 'mouse_scroll' then
            if package.data.arg3 <= 2 then
                appEngine:onlyShow(15)
                MTEeventEngine:registerEvent(15, package.data, 0, 'mokey', os.clock())
            else
                appEngine:showAppByPort(appEngine.activeWin)
                package.data.arg3 = package.data.arg3 - 2
                MTEeventEngine:registerEvent(appEngine.activeWin, package.data, 0, 'mokey', os.clock())
            end 
        else
            --appEngine:showAppByPort(appEngine.activeWin)
            if package.data.event == 'mouse_click' or package.data.event == 'mouse_scroll' or package.data.event == 'mouse_drag' or package.data.event == 'mouse_up' then
                package.data.arg3 = package.data.arg3 - 2
            end 
            MTEeventEngine:registerEvent(appEngine.activeWin, package.data, 0, 'mokey', os.clock())
        end
        
    end
end