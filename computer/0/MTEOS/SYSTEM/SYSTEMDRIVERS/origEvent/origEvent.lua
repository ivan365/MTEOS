local EventTypes = {
    key = 'mokey',
    key_up = 'mokey',
    char = 'mokey',
    mouse_click = 'mokey',
    mouse_up = 'mokey',
    mouse_drag = 'mokey',
    mouse_scroll = 'mokey',
    rednet_message = 'MTERedNet'
}
sleep(2)
while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()
    MTEeventEngine:registerEvent(0, {
        event = event, 
        arg1 = p1,
        arg2 = p2, 
        arg3 = p3, 
        arg4 = p4, 
        arg5 = p5 
        }, 0, EventTypes[event], os.clock())
end