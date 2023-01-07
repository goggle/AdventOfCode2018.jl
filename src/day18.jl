module Day18

using AdventOfCode2018
using DataStructures

function day18(input::String = readInput(joinpath(@__DIR__, "..", "data", "day18.txt")))
    d = Dict(
        '.' => Int8(0),
        '|' => Int8(1),
        '#' => Int8(2)
    )
    orig = map(x -> d[x[1]], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    data = copy(orig)
    for _ ∈ 1:10
        newstate = round(data)
        data = newstate
    end
    p1 = resource_value(data)

    
    n = 1_000_000_000
    λ, μ = floyd(orig)
    data = copy(orig)
    stop = μ + (n - μ) % λ
    for _ ∈ 1:stop
        newstate = round(data)
        data = newstate
    end
    p2 = resource_value(data)

    return [p1, p2]
end

resource_value(data::Matrix{Int8}) = count(x->x==1, data) * count(x->x==2, data)

function round(data::Matrix{Int8})
    dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
    newstate = similar(data)
    for i ∈ axes(data, 1)
        for j ∈ axes(data, 2)
            neighbours = [data[i+d[1], j+d[2]] for d ∈ dirs if checkbounds(Bool, data, i+d[1], j+d[2])]
            if data[i,j] == 0
                if count(x -> x==1, neighbours) >= 3
                    newstate[i,j] = 1
                else
                    newstate[i,j] = 0
                end
            elseif data[i,j] == 1
                if count(x->x==2, neighbours) >= 3
                    newstate[i,j] = 2
                else
                    newstate[i,j] = 1
                end
            else
                if count(x->x==2, neighbours) >= 1 && count(x->x==1, neighbours) >= 1
                    newstate[i,j] = 2
                else
                    newstate[i,j] = 0
                end
            end
        end
    end
    return newstate
end

# Floyd's cycle detection:
# https://en.wikipedia.org/wiki/Cycle_detection#Floyd's_Tortoise_and_Hare
function floyd(data::Matrix{Int8})
    tortoise = round(data)
    hare = round(tortoise)
    while tortoise != hare
        tortoise = round(tortoise)
        hare = round(round(hare))
    end

    μ = 0
    tortoise = data
    while tortoise != hare
        tortoise = round(tortoise)
        hare = round(hare)
        μ += 1
    end

    λ = 1
    hare = round(tortoise)
    while tortoise != hare
        hare = round(hare)
        λ += 1
    end

    return λ, μ
end

end # module
