local ObjectFactory = {}

function ObjectFactory:newTemplate(template)
    local obj = {}
    obj.__template = template
    obj.__index = template
    setmetatable(obj, {__call = function(_, ...)
        local instance = {}
        for k, v in pairs(template) do
            if type(v) == "table" then
                local tcopy = {}
                for kk, vv in pairs(v) do
                    tcopy[kk] = vv
                end
                instance[k] = tcopy
            else
                instance[k] = v
            end
        end
        setmetatable(instance, template)
        if template.init then
            template.init(instance, ...)
        end
        return instance
    end})
    return obj
end

return ObjectFactory