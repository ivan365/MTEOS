local w, h = term.getSize()
local welcomeText = "Welcome to MTEOS!"

term.clear()
term.setCursorPos(math.floor((w - #welcomeText) / 2)+1, 2)
term.write(welcomeText)
sleep(3)
term.setCursorPos(1, h)

term.clear()
shell.run("MTEOS/SYSTEM/CORE/MTEOSCore.lua")