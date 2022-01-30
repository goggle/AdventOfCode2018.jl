module Day02

using AdventOfCode2018
using DataStructures

function day02(input::String = readInput(joinpath(@__DIR__, "..", "data", "day02.txt")))
    lines = split(rstrip(input), "\n")
    twos = threes = 0
    for line ∈ lines
        d = DefaultDict{Char,Int}(0)
        for c ∈ line
            d[c] += 1
        end
        if any(values(d) .== 2)
            twos += 1
        end
        if any(values(d) .== 3)
            threes += 1
        end
    end
    p1 = twos * threes
    for i ∈ 1:length(lines)
        for j ∈ i+1:length(lines)
            eq = collect(lines[i]) .== collect(lines[j])
            if count(x -> x == 0, eq) == 1
                p2 = collect(lines[i])[eq] |> join
                return [p1, p2]
            end
        end
    end
end

end # module
