module Day05

using AdventOfCode2018

function day05(input::String = readInput(joinpath(@__DIR__, "..", "data", "day05.txt")))
    data = collect(rstrip(input))

    data = reduce(data)
    p1 = length(data)

    lletters = unique(lowercase.(data))
    p2 = p1
    for l in lletters
        d = filter(x -> x ∉ (l, uppercase(l)), data)
        rl = length(reduce(d))
        if rl < p2
            p2 = rl
        end
    end
    return [p1, p2]
end

function reduce(data::Vector{Char})
    changed = true
    while changed
        changed = false
        i = 2
        deleteidx = Set{Int}()
        while i < length(data)
            prev, curr = data[i-1], data[i]
            if (uppercase(prev) == curr && islowercase(prev)) || (uppercase(curr) == prev && islowercase(curr))
                changed = true
                push!(deleteidx, i-1)
                push!(deleteidx, i)
                i += 2
                continue
            end
            i += 1
        end
        keepidx = sort!(collect(setdiff(1:length(data), deleteidx)))
        data = data[keepidx]
    end
    return data
end

end # module
