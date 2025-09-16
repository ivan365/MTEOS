local textLib={}

textLib.printText = function(x, y, text, win)
    win.setCursorPos(x, y)
    win.write(text)
end

textLib.printTextBox = function(x, y, w, h, text, win, alignx, aligny)
    for i = 0, w do
        for k = 0, h, 1 do
            win.setCursorPos(x + i, y + k)
            win.write(" ")
        end
    end
    local lines = {}
    local currentLine = ""
    for word in text:gmatch("%S+") do
        if #currentLine + #word + 1 <= w then
            if currentLine == "" then
                currentLine = word
            else
                currentLine = currentLine .. " " .. word
            end
        else
            table.insert(lines, currentLine)
            currentLine = word
        end
    end
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    local startY = y
    if aligny == "center" then
        startY = y + math.floor((h - #lines) / 2)
    elseif aligny == "bottom" then
        startY = y + h - #lines
    end

    for i = 1, math.min(#lines, h) do
        local line = lines[i]
        local startX = x
        if alignx == "center" then
            startX = x + math.floor((w - #line) / 2)
        elseif alignx == "right" then
            startX = x + w - #line
        end
        win.setCursorPos(startX, startY + i - 1)
        win.write(line)
    end
end

textLib.printTextBoxCutByWord = function(x, y, w, h, text, win, alignx, aligny)
    for i = 0, w do
        for k = 0, h, 1 do
            win.setCursorPos(x + i, y + k)
            win.write(" ")
        end
    end
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end

    local lines = {}
    local line = ""
    for i, word in ipairs(words) do
        if #line + #word + (#line > 0 and 1 or 0) <= w then
            if #line == 0 then
                line = word
            else
                line = line .. " " .. word
            end
        else
            table.insert(lines, line)
            line = word
        end
    end
    if #line > 0 then
        table.insert(lines, line)
    end

    local startY = y
    if aligny == "center" then
        startY = y + math.floor((h - #lines) / 2)
    elseif aligny == "bottom" then
        startY = y + h - #lines
    end

    for i = 1, math.min(#lines, h) do
        local currentLine = lines[i]
        local startX = x
        if alignx == "center" then
            startX = x + math.floor((w - #currentLine) / 2)
        elseif alignx == "right" then
            startX = x + w - #currentLine
        end

        win.setCursorPos(startX, startY + i - 1)
        win.write(currentLine)
    end
end

textLib.printTextBoxCutBySep = function(x, y, w, h, text, win, alignx, aligny, sep)
    for i = 0, w do
        for k = 0, h, 1 do
            win.setCursorPos(x + i, y + k)
            win.write(" ")
        end
    end
    sep = sep or "%s+" 
    local lines = {}
    local currentLine = ""

    for word in text:gmatch("[^" .. sep .. "]+") do
        if #currentLine + #word + 1 <= w then
            if currentLine == "" then
                currentLine = word
            else
                currentLine = currentLine .. " " .. word
            end
        else
            table.insert(lines, currentLine)
            currentLine = word
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    local startY = y
    if aligny == "center" then
        startY = y + math.floor((h - #lines) / 2)
    elseif aligny == "bottom" then
        startY = y + h - #lines
    end

    for i = 1, math.min(#lines, h) do
        local line = lines[i]
        local startX = x
        if alignx == "center" then
            startX = x + math.floor((w - #line) / 2)
        elseif alignx == "right" then
            startX = x + w - #line
        end
        win.setCursorPos(startX, startY + i - 1)
        win.write(line)
    end
end

textLib.printTextBoxCutByLen = function(x, y, w, h, text, win, alignx, aligny)
    for i = 0, w do
        for k = 0, h, 1 do
            win.setCursorPos(x + i, y + k)
            win.write(" ")
        end
    end

    local lines = {}
    local i = 1
    while i <= #text do
        table.insert(lines, text:sub(i, i + w - 1))
        i = i + w
    end


    local startY = y
    if aligny == "center" then
        startY = y + math.floor((h - #lines) / 2)
    elseif aligny == "bottom" then
        startY = y + h - #lines
    end

    for j = 1, math.min(#lines, h) do
        local currentLine = lines[j]

        local startX = x
        if alignx == "center" then
            startX = x + math.floor((w - #currentLine) / 2)
        elseif alignx == "right" then
            startX = x + w - #currentLine
        end

        win.setCursorPos(startX, startY + j - 1)
        win.write(currentLine)
    end
end

return textLib