local simpleLoadSlash = {}

simpleLoadSlash.animation = {'|', '/', '-', '\\', '|', '/', '-', '\\'}
function simpleLoadSlash.startAnimation(w, h, speed)
    local index = 1
    while true do
        term.setCursorPos(w, h)
        term.write(simpleLoadSlash.animation[index])
        index = index + 1
        if index > #simpleLoadSlash.animation then
            index = 1
        end
        sleep(speed)
    end
end

return simpleLoadSlash