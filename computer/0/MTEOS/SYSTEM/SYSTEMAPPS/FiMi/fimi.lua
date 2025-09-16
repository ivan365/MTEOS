-- vfileman.lua — simple visual file manager for CC
-- Uses readEvent('mokey', true, true)
-- Mouse controls:
--   LMB on folder  → enter folder
--   LMB on file    → run file
--   LMB on ".. Back" → go up
--   LMB on "Exit"  → quit

local currentPath = "/"
local items = {}
local w, h = term.getSize()

-- refresh item list
local function updateItems()
    items = fs.list(currentPath)
    table.sort(items)
    if currentPath ~= "/" then
        table.insert(items, 1, ".. Back")
    end
    table.insert(items, "Exit")
end

-- draw interface
local function draw()
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.yellow)
    print("File Manager")
    term.setTextColor(colors.white)
    print("Path: " .. currentPath)
    print(string.rep("-", w))

    for i, item in ipairs(items) do
        if item == ".. Back" then
            term.setTextColor(colors.orange)
            print("[ "..item.." ]")
        elseif item == "Exit" then
            term.setTextColor(colors.red)
            print("[ "..item.." ]")
        elseif fs.isDir(fs.combine(currentPath, item)) then
            term.setTextColor(colors.lime)
            print(item.."/")
        else
            term.setTextColor(colors.white)
            print(item)
        end
    end
    term.setTextColor(colors.white)
end

-- handle mouse click
local function handleClick(x, y)
    -- list starts from line 4
    local index = y - 3
    if index < 1 or index > #items then return end

    local item = items[index]
    if item == "Exit" then
        term.clear()
        term.setCursorPos(1,1)
        print("Exiting file manager.")
        return false
    elseif item == ".. Back" then
        currentPath = fs.getDir(currentPath)
        if currentPath == "" then currentPath = "/" end
        updateItems()
        draw()
    else
        local fullPath = fs.combine(currentPath, item)
        if fs.isDir(fullPath) then
            currentPath = fullPath
            updateItems()
            draw()
        else
            term.clear()
            term.setCursorPos(1,1)
            print("Running: " .. fullPath)

            -- запуск через appEngine
            local args = {}
            appEngine:startAppAdvanced(fullPath, "-d ", args)

            print("\nClick mouse to return...")
            readEvent('mokey', true, true) -- ждём клик
            updateItems()
            draw()
        end
    end
    return true
end

-- main loop
updateItems()
draw()
while true do
    local data = readEvent('mokey', true, true)
    if data and data.data and data.data.event == "mouse_click" then
        local button = data.data.arg1
        local x = data.data.arg2
        local y = data.data.arg3
        if button == 1 then -- LMB
            local cont = handleClick(x, y)
            if not cont then break end
        end
    end
end