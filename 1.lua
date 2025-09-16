--!!ASKPORT = 26

local index = 0
term.setBackgroundColor(colors.red)
while true do
    term.clear()
    term.setCursorPos(1, 1)
    term.write(appMode .. ' i am port ' .. port .. ' ' .. index)
    index = index + 1
    sleep(1)
    
    if index > 15 then
        appExit()
        reopenApp()
    end
end