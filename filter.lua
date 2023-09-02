local replacements = {}

function CodeBlock(elem)
    if elem.classes[1] == "replacements" then
        local content = elem.text
        for line in content:gmatch("[^\r\n]+") do
            local key, value = line:match("([^:]+):([^:]+)")
            if key and value then
                replacements[key] = value
            end
        end
        return {}
    end
end

function Str(elem)
    local text = elem.text
    if replacements[text] then
        elem.text = replacements[text]
    end
    return elem
end

return {
    {CodeBlock = CodeBlock},
    {Str = Str}
}