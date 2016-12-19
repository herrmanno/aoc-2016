function getTile(c1, c2, c3)
    if(c1 == "^" and c3 == ".") then
        return "^"
    elseif(c3 == "^" and c1 == ".") then
        return "^"
    else
        return "."
    end
end

function buildLine(prev)
    local line = ""

    for i=1, prev:len(), 1 do
        local c1
        if(i == 1) then
            c1 = "."
        else
            c1 = prev:sub(i-1, i-1)
        end
        
        local c2 = prev:sub(i, i)

        local c3
        if(i == prev:len()) then
            c3 = "."
        else
            c3 = prev:sub(i+1, i+1)
        end

        line = line .. getTile(c1, c2, c3)
    end

    return line

end

local input = {".^^.^^^..^.^..^.^^.^^^^.^^.^^...^..^...^^^..^^...^..^^^^^^..^.^^^..^.^^^^.^^^.^...^^^.^^.^^^.^.^^.^."}
local N_COLS = input[1]:len()
local N_ROWS = 40
for i=2, N_ROWS, 1 do
    input[i] = buildLine(input[i-1])
end

local sum = 0
for i=1, N_ROWS, 1 do
    for j=1, N_COLS, 1 do
        local c = input[i]:sub(j, j)
        if(c == ".") then
            sum = sum + 1
        end
    end
end

print(sum)