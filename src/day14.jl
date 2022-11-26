module Day14

using AdventOfCode2018

mutable struct Data
    data::Vector{UInt8}
    length::Int
    oneidx::Int
    twoidx::Int
end

function day14(input::String = readInput(joinpath(@__DIR__, "..", "data", "day14.txt")))
    number = parse(Int, input)
    numbs = digits(number) |> reverse
    data = Data(zeros(UInt8, number*2), 2, 1, 2)
    data.data[1] = 3
    data.data[2] = 7
    p2 = 0
    for i = 1:number
        j = step!(data, numbs)
        if j != 0 && p2 == 0
            p2 = j
        end
    end
    p1 = sum(data.data[number+10-k] * 10^k for k=0:9)
    
    if p2 == 0
        while true
            p2 = step!(data, numbs)
            if p2 != 0
                break
            end
        end
    end
    return [p1, p2]
end

function step!(data::Data, numbs::Vector{Int})
    if length(data.data) - data.length <= 2
        nl = length(data.data) * 2
        resize!(data.data, nl)
    end
    digs = digits(data.data[data.oneidx] + data.data[data.twoidx]) |> reverse
    for (i, d) ∈ enumerate(digs)
        data.data[i + data.length] = d
    end
    data.length += length(digs)
    data.oneidx = mod1(data.oneidx + 1 + data.data[data.oneidx], data.length)
    data.twoidx = mod1(data.twoidx + 1 + data.data[data.twoidx], data.length)
    if data.length > length(numbs)
        found = true
        for i = 0:length(numbs) - 1
            if data.data[data.length-i] != numbs[length(numbs)-i]
                found = false
                break
            end
        end
        if found
            return data.length - length(numbs)
        end
        if length(digs) > 1
            found = true
            for i = 0:length(numbs) - 1
                if data.data[data.length-i-1] != numbs[length(numbs)-i]
                    found = false
                    break
                end
            end
            if found
                return data.length - length(numbs) - 1
            end
        end
    end
    return 0
end

end # module
