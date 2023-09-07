local replacements = {}
local mathReplacements = {}  -- Separate table for math-specific replacements

function CodeBlock(elem)
    if elem.classes[1] == "replacements" or elem.classes[1] == "replace" then
        local content = elem.text
        for line in content:gmatch("[^\r\n]+") do
            local key, value, target = line:match("([^:]+):([^:]+):([^:]+)")
            if key and value then
                if target == "math" then
                    mathReplacements[key] = value
                elseif target == "text" then
                    replacements[key] = value
                else
                    replacements[key] = value 
                    mathReplacements[key] = value
                end
            else
                local key, value = line:match("([^:]+):([^:]+)")
                if key and value then
--                     key = escapeChars(key)
--                     key = key:gsub("%.", "%%%.")
                    replacements[key] = value
                    mathReplacements[key] = value
                end
            end
        end
        return {}
    end
end

function Str(elem)
    local text = elem.text
    for key, value in pairs(replacements) do
       local pattern = key:gsub("[*--[[]]]", ".*")  -- Convert * to .* for regex pattern
        text = text:gsub(key, value)
    end
    elem.text = text
    return elem
end

function Math(elem)
    local text = elem.text
    for key, value in pairs(mathReplacements) do
--        local pattern = key:gsub("[*]", ".*")  -- Convert * to .* for regex pattern
        text = text:gsub(key, value)
    end
    elem.text = text
    return elem
end

return {
    {CodeBlock = CodeBlock},
    {Str = Str},
    {Math = Math}
}
