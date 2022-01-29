module Day01

using AdventOfCode2018

function day01(input::String = readInput(joinpath(@__DIR__, "..", "data", "day01.txt")))
    frequencies = parse.(Int, split(input))
    p1 = frequencies |> sum
    seen = Set{Int}(0)
    s = 0
    while true
        for freq ∈ frequencies
            s += freq
            if s ∈ seen
                return [p1, s]
            end
            push!(seen, s)
        end
    end
end

end # module
