local loadAnim = require("/MTEOS/SYSTEM/LIBRARIES/loadingGUI/simpleLoadSlash")
local files = require("/MTEOS/SYSTEM/SYSTEMDATA/DATA/systemFilesToCheck")
local centerForText = require("/MTEOS/SYSTEM/LIBRARIES/math/centerForText")
local textformat = require("/MTEOS/SYSTEM/LIBRARIES/text/printText")
local progressBarAdvanced = require("/MTEOS/SYSTEM/LIBRARIES/loadingGUI/progressBarAdvanced")
local easyPic = require("/MTEOS/SYSTEM/LIBRARIES/pic/easyPic")
local drivers = require("/MTEOS/SYSTEM/SYSTEMDATA/DATA/systemDrivers")

term.setPaletteColour(colors.white,         0xFFFFFF)
term.setPaletteColour(colors.lightGray,     0xC0C0C0)
term.setPaletteColour(colors.gray,          0x606060)
term.setPaletteColour(colors.black,         0x000000)
term.setPaletteColour(colors.red,           0xDC1414)
term.setPaletteColour(colors.lime,          0x228B22)
term.setPaletteColour(colors.green,         0x00E000)
term.setPaletteColour(colors.lightBlue,     0x1E90FF)
term.setPaletteColour(colors.blue,          0x00008B)
term.setPaletteColour(colors.yellow,        0xFFD700)
term.setPaletteColour(colors.orange,        0xFFA500)
term.setPaletteColour(colors.purple,        0x800080)
term.setPaletteColour(colors.cyan,          0x00CED1)
term.setPaletteColour(colors.magenta,       0xFF00FF)
term.setPaletteColour(colors.brown,         0x8B4513)

MEMAPP = 32
SYSREZERV = 16
local w, h = term.getSize()

Time = os.time()

----- logo -----
local wc, bc = colors.gray, nil
local EMT = {
    {wc, bc, bc, bc, wc, bc, bc, wc, wc, wc, wc, wc, bc, bc, wc, wc, wc, wc, wc},
    {wc, wc, bc, wc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc},
    {wc, bc, wc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, wc, wc, bc, bc},
    {wc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc},
    {wc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc},
    {wc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc}
}
local pa = easyPic:new(term)
local pocW = (w-#EMT[1])/2+2
pa:draw(EMT, pocW, 2)
wc, bc = colors.white, nil
EMT = {
    {wc, bc, bc, bc, wc, bc, bc, wc, wc, wc, wc, wc, bc, bc, wc, wc, wc, wc, wc},
    {wc, wc, bc, wc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc},
    {wc, bc, wc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, wc, wc, bc, bc},
    {wc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc},
    {wc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc},
    {wc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc, wc, bc, bc, bc, bc}
}
local pocW = (w-#EMT[1])/2+1
pa:draw(EMT, pocW, 2)
----- logo -----



parallel.waitForAny(
    function()
        local x = centerForText.getCenteredPosition(1, w)
        loadAnim.startAnimation(x, h, 0.15)
    end,
    function()
        --local pb = progressBarSimple:new(2, h/2+7, w-2, 1, term)
        local bar = progressBarAdvanced:new(2, h/2+7, w-2, 1, term)
        bar.fillColor = colors.green
        bar.bgColor = colors.gray
        bar.textColor = colors.white
        bar.text = 'load'
        bar.showPercent = true
        bar.align = "center" -- "left", "center", "right"
        for i, value in pairs(files.getFilesToCheck()) do
            if fs.exists(value) then
                textformat.printTextBoxCutByLen(2, h/2, w-2, 5, "V: " .. value, term, "center", "center")
                bar:setValue(i / #files.getFilesToCheck())
                bar:draw()
            else
                textformat.printTextBoxCutByLen(2, h/2, w-2, 5, "X: " .. value, term, "center", "center")
                bar:setValue(i / #files.getFilesToCheck())
                bar:draw()
            end
            sleep(0.1)
        end
        sleep(1)
    end
)

term.clear()
local motherWin = term.current()

local appEngine = {
    appRunning = {}, -- { [port] = {appPath, window, running} }
    slots = {},
    activeWin = 0,
    _lowestPort = function(self, isSystem)
        local startPort, endPort
        if isSystem == 1 then
            startPort = 1
            endPort = SYSREZERV or 16
        else
            startPort = SYSREZERV or (16 + 1)
            endPort = MEMAPP
        end
        for port = startPort, endPort do
            if not self.appRunning[port] then
                return port
            end
        end
        return nil
    end,

    runnedAppsList = function(self)
        return self.appRunning
    end,

    startApp = function(self, appPath, mode, arrgs)
        mode = mode or "-d"
        local port = self:_lowestPort()
        if not port then error("No free slot") end
        local win = window.create(motherWin, 1, 3, w, h-2, true)
        win.setVisible(false)
        self.appRunning[port] = {   
            appPath = appPath, 
            window = win, 
            running = "init", 
            port = port, 
            mode = mode, 
            arrgs = arrgs
        }
        return port
    end,

    closeApp = function(self, port)
        local app = self.appRunning[port]
        if app then
            app.running = "closing"
        end
    end,

    showAppByPort = function(self, port)
        for p, app in pairs(self.appRunning) do
            if p == port then
                if app.window then
                    app.window.setVisible(true)
                    term.redirect(app.window)
                    self.activeWin = p
                end
            else
                if app.window then
                    app.window.setVisible(false)
                end 
            end
        end
    end,

    onlyShow = function(self, port)
        for p, app in pairs(self.appRunning) do
            if p == port then
                if app.window then
                    app.window.setVisible(true)
                    term.redirect(app.window)
                end
            else
                if app.window then
                    app.window.setVisible(false)
                end 
            end
        end
    end,

    _usedPorts = function(self)
        local ports = {}
        for port, _ in pairs(self.appRunning) do
            table.insert(ports, port)
        end
        return ports
    end, 

    _getPrevPort = function(self, currentPort)
        local ports = self:_usedPorts()
        if #ports == 0 then return nil end

        local prev = nil
        for i, port in ipairs(ports) do
            if port == currentPort then
                if i > 1 then
                    prev = ports[i-1]
                elseif #ports > 1 then
                    prev = ports[i+1]
                end
                break
            end
        end
        return prev
    end,

    closeAndFocusPrev = function(self, port)
        local prevPort = self:_getPrevPort(port)
        self:closeApp(port)
        if prevPort then
            self:showAppByPort(prevPort)
            self.activeWin = prevPort
        end
    end,

    getProgramName = function(path)
        local filename = path:match("([^/]+)$")
        return filename:match("(.+)%..+$") or filename
    end,

    startAppAdvanced = function (self, appPath, flagString, arrgs)
        local flags = {}
        local lines = {}
        local f = fs.open(appPath, "r")
        if f then
            while true do
                local line = f.readLine()
                if not line then break end
                table.insert(lines, line)
            end
            f.close()
        end

        local function parseFileFlag(key)
            local prefix = "--!!" .. key .. " ="
            for _, line in ipairs(lines) do
                local val = line:match("^%s*" .. prefix .. "%s*(.+)")
                if val then return val end
            end
            return nil
        end

        local tokens = {}
        for token in flagString:gmatch("%S+") do table.insert(tokens, token) end
        local i = 1
        while i <= #tokens do
            local t = tokens[i]
            if t == "-s" or t == "-d" then
                flags.mode = t
                i = i + 1
            elseif t == "-n" then
                i = i + 1
                flags.name = tokens[i] or self.getProgramName(appPath)
                i = i + 1
            elseif t == "-nf" then
                local n = parseFileFlag("ASKNAME")
                if n then flags.name = n end
                i = i + 1
            elseif t == "-ws" then
                local windowArgs = {}
                for j = 1,4 do
                    i = i + 1
                    windowArgs[j] = tonumber(tokens[i])
                end
                flags.window = windowArgs
                i = i + 1
            elseif t == "-wsf" then
                local val = parseFileFlag("ASKWIN")
                if val then
                    local x,y,w,h = val:match("(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
                    flags.window = {tonumber(x), tonumber(y), tonumber(w), tonumber(h)}
                end
                i = i + 1
            elseif t == "-wh" then
                flags.noWindow = true
                i = i + 1
            elseif t == "-p" then
                i = i + 1
                local port = tonumber(tokens[i])
                flags.port = port
                i = i + 1
            elseif t == "-pf" then
                local p = parseFileFlag("ASKPORT")
                if p then flags.port = tonumber(p) end
                i = i + 1
            else
                error("Unknown flag: "..t)
            end
        end

        if not flags.mode then flags.mode = "-d" end

        local port = flags.port
        if not port or self.appRunning[port] then
            port = self:_lowestPort(flags.mode == "-s" and 1 or 0)
        end
        if not port then return end --error("No free port")

        if not flags.name or flags.name == "" then
            local folderName = appPath:match("([^/\\]+)$")
            flags.name = (folderName or "App") .. "_" .. port
        end

        local win = nil
        if not flags.noWindow then
            local x,y,w,h = 1,3,term.getSize()
            if flags.window and #flags.window==4 and flags.mode == "-s" then
                local wx, wy, ww, wh = table.unpack(flags.window)
                x = wx or 1
                y = wy or 3
                w = ww or select(1, term.getSize())
                h = wh or select(2, term.getSize())
            end
            win = window.create(motherWin, x, y, w, h, true)
            win.setVisible(false)
        end

        self.appRunning[port] = {
            appPath = appPath,
            window = win,
            running = "init",
            port = port,
            mode = flags.mode,
            name = flags.name, 
            arrgs = arrgs
        }

        return port
    end
}

term.setCursorPos(1,h)
for i = 1, MEMAPP do
    appEngine.slots[i] = function()
        local port = i
        while true do
            local app = appEngine.appRunning[port]
            if app and app.running == "init" then
                parallel.waitForAny(
                    function()                 
                        local fn, err = loadfile(app.appPath)
                        if err then
                            appEngine:startAppAdvanced("/MTEOS/SYSTEM/SYSTEMAPPS/ErrorTracker/ErrorTracker.lua", "-d -p", {error = err})
                            app.running = "closing"
                            return
                        end
                        local env = {}
                        if not fn then
                            print("Error loading: " .. err)
                            app.running = "closing"
                        else
                            app.running = "run"
                            if app.mode == "-d" then
                                env = {
                                    term = app.window,
                                    port = port,
                                    sleep = sleep,
                                    loadAnim = loadAnim,
                                    files = files,
                                    centerForText = centerForText,
                                    print = print,
                                    http = http,
                                    colors = colors,
                                    appExit = function() app.running = "closing" end,
                                    appData = app,
                                    createEvent = function(victim, data, filter)
                                        MTEeventEngine:registerEvent(victim, data, app.port, filter, os.clock())
                                    end, 
                                    readEvent = function(filter, remove, wait)
                                        return MTEeventEngine:readEvent(app.port, filter, remove, wait)
                                    end, 
                                    _arrgs = app.arrgs,
                                    textformat = textformat, 
                                    pairs = pairs, 
                                    type = type
                                }
                            else
                                env = {}
                                setmetatable(env, { __index = _G })
                                env.term = app.window
                                env.port = app.port
                                env.appMode = app.mode
                                env.appExit = function() app.running = "closing" end
                                env.createEvent = function(victim, data, filter)
                                        MTEeventEngine:registerEvent(victim, data, app.port, filter, os.clock())
                                    end
                                env.readEvent = function(filter, remove, wait)
                                        return MTEeventEngine:readEvent(app.port, filter, remove, wait)
                                    end
                                env._arrgs = app.arrgs
                                env.textformat = textformat
                                env.MTEeventEngine = MTEeventEngine
                                env.appEngine = appEngine
                                
                            end
                            setfenv(fn, env)
                            if app.window then
                                appEngine:showAppByPort(port)
                            end
                            local success, err = pcall(fn)
                            if not success then
                                appEngine:startAppAdvanced("/MTEOS/SYSTEM/SYSTEMAPPS/ErrorTracker/ErrorTracker.lua", "-s -p", {error = err, from = app})
                                --app.running = "closing"
                            end
                            app.running = "closing" 
                        end
                    end,
                    function() 
                        while true do
                            if app.running == "closing" then
                                --app.window.setVisible(false)
                                --app.window.clear()
                                appEngine:closeAndFocusPrev(app.port)
                                break
                            end
                            sleep(0.5)
                        end
                    end
                )
            elseif app and app.running == "closing" then
                if app.window then
                    app.window.setVisible(false)
                end
                appEngine.appRunning[port] = {}
            end
            sleep(0.5)
        end
    end
end

-------EVENT MANAGER-------
MTEeventEngine = {
    EventDataBase = {},

    registerEvent = function(self, victim, data, sender, filter, time)
        if self.EventDataBase[victim] == nil then
            self.EventDataBase[victim] = {}
        end 
        table.insert(self.EventDataBase[victim], {
            victim = victim,
            data = data,
            sender = sender,
            filter = filter,
            time = time
        })
    end,

    _lookForEvent = function(self, port, filter, remove)
        if self.EventDataBase[port] == nil or self.EventDataBase[port] == {} then
            return
        end
        if remove then
            if filter then
                for i, event in pairs(self.EventDataBase[port]) do
                    if event.filter == filter then
                        local ev = event
                        table.remove(self.EventDataBase[port], i)
                        return ev
                    end
                end
            else
                local ev = self.EventDataBase[port][1]
                table.remove(self.EventDataBase[port], 1)
                return ev
            end
        else
            if filter then
                for i = #self.EventDataBase[port], 1, -1 do
                    if self.EventDataBase[port][i].filter == filter then
                        return self.EventDataBase[port][i]
                    end
                end
            else 
                return self.EventDataBase[port][#self.EventDataBase[port]]
            end 
        end 
    end,

    readEvent = function(self, port, filter, remove, wait)
        if wait then
            local data = {}
            repeat
                data = self:_lookForEvent(port, filter, remove)
                sleep(0)
            until data
            return data
        else
            return self:_lookForEvent(port, filter, remove)
        end 
    end
}
for i = 0, SYSREZERV do
    MTEeventEngine.EventDataBase[i] = {}
end
--------------------------

for i, driver in pairs(drivers.driverList)do
    appEngine:startAppAdvanced(driver.path, driver.flags, driver.args)
end
appEngine:startAppAdvanced("/MTEOS/SYSTEM/SYSTEMAPPS/MTEPanel/MTEPanel.lua", "-s -p 15 -ws 1 1 " .. tostring(w) .. ' 2' , {text = 'penis'})
appEngine:startAppAdvanced("/MTEOS/SYSTEM/SYSTEMAPPS/FiMi/fimi.lua", "-s -pf", {})

parallel.waitForAll(table.unpack(appEngine.slots))
