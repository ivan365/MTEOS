local centerForText = {}

function centerForText.getCenteredPosition(len, width)
    local x = math.floor((width - len) / 2) + 1 -- +1 for 1-based index in Lua
    return x
end

return centerForText