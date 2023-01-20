module Day25

using AdventOfCode2018

function day25(input::String = readInput(joinpath(@__DIR__, "..", "data", "day25.txt")))
    data = [parse.(Int, split(x, ',')) for x ∈ eachsplit(input, "\n", keepempty=false)]
    D = fill(1_000_000, length(data), length(data))
    for i ∈ axes(data, 1)
        for j ∈ axes(data, 1)
            D[i,j] = dist(data[i]..., data[j]...)
        end
    end
    constellations = Vector{Vector{Int}}()
    for i ∈ axes(data, 1)
        in_constellations(i, constellations) && continue
        add = findall(x -> x <= 3, D[i, :])
        to_check = copy(add)
        while !isempty(to_check)
            j = popfirst!(to_check)
            candids = findall(x -> x <= 3, D[j,:])
            for c ∈ candids
                if c ∉ add
                    push!(add, c)
                    push!(to_check, c)
                end
            end
        end
        push!(constellations, add)
    end
    return length(constellations)
end

dist(x1::Int, x2::Int, x3::Int, x4::Int, y1::Int, y2::Int, y3::Int, y4::Int) = abs(x1-y1) + abs(x2-y2) + abs(x3-y3) + abs(x4-y4)
in_constellations(i::Int, constellations::Vector{Vector{Int}}) = any(i .∈ constellations)

end # module