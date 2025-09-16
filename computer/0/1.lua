--!!ASKPORT = 16
--!!ASKNAME = testApp
local index = 0
local data = {}
local packageindex = 0
term.setBackgroundColor(colors.lightGray)
term.clear()
while true do
    --term.clear()
    term.setCursorPos(1, 1)
    term.write(appData.mode .. ' i am port ' .. appData.port .. ' ' .. index .. ' ' .. (_arrgs.text or 'nothing'))
    index = index + 1

    term.setCursorPos(1, 5)
    data = readEvent('mokey', true, true)
    if data then
        term.clear()
        term.write(data.data.event)
        term.write('---')
        term.write(appData.name)
        term.write('---')
    end 

    term.setCursorPos(1, 10)
    --term.write(appData.appPath .. '\n')
    --term.write(appData.port .. '\n')
    --term.write(appData.mode .. '\n')

    
    --sleep(0)
end

    if index% 10 == 0 then
        term.setCursorPos(1, 3)
        createEvent(16, {main = 'kozel', pack = packageindex}, nil)
        term.write("Event Created -> " .. packageindex, index)
        packageindex = packageindex+1
    end

    -- Процесс 2: каждые 10 секунд, но со сдвигом +5

    if (index - 5) % 10 == 0 and index >= 10 then
        term.setCursorPos(1, 5)
        data = readEvent(nil, true, false)
        term.write(data.data.main .. " -> " .. data.data.pack)
    end