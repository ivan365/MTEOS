term.setBackgroundColor(colors.red)
term.setTextColor(colors.black)
local w, h = term.getSize()
term.clear()
term.setCursorPos(1, 1)
--term.write(_arrgs.error)
textformat.printTextBoxCutByLen(2, 2, w-2, 5, "err: " .. _arrgs.error, term, "center", "center")


local index = 0 
for i, value in pairs(_arrgs.from) do
    term.setCursorPos(1, 7+index)
    term.write(i)
    term.write(' > ')
    index = index + 1
    term.setCursorPos(1, 7+index)
    term.write(value)
    index = index + 1
end

while true do
    
    sleep(10)
end