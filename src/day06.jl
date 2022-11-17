module Day06

using AdventOfCode2018

function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    coords = [parse.(Int, split(x, ", ")) for x in split(rstrip(input), "\n")]
    xmin = minimum(x[1] for x in coords)
    ymin = minimum(x[2] for x in coords)
    xmax = maximum(x[1] for x in coords)
    ymax = maximum(x[2] for x in coords)

    belongs = zeros(Int, xmax-xmin+1, ymax-ymin+1)
    distances = ones(Int, xmax-xmin+1, ymax-ymin+1) * xmax*ymax

    xs, ys = size(distances)
    for (p, (x, y)) in enumerate(coords)
        for i = 1:xs
            for j = 1:ys
                dist = manhatten(i, j, x-xmin+1, y-ymin+1)
                if dist < distances[i,j]
                    distances[i,j] = dist
                    belongs[i,j] = p
                elseif dist == distances[i,j]
                    belongs[i,j] = 0
                end
            end
        end
    end

    borderpoints = Set{Int}()
    for i = 1:xs
        push!(borderpoints, belongs[i,1])
        push!(borderpoints, belongs[i,ys])
    end
    for j = 1:ys
        push!(borderpoints, belongs[1,j])
        push!(borderpoints, belongs[xs,j])
    end

    p1 = 0
    for p in 1:length(coords)
        if p ∈ borderpoints
            continue
        end
        c = (belongs .== p) |> sum
        if c > p1
            p1 = c
        end
    end
    p1

    distances_to_points = []
    for (x, y) in coords
        # Note: This is a rough estimate on how big the box should be chosen
        dists = zeros(Int, 800, 800)
        for i = 1:800
            for j = 1:800
                dists[i,j] = manhatten(i-400, j-400, x, y)
            end
        end
        push!(distances_to_points, dists)
    end
    p2 = (sum(distances_to_points) .< 10_000) |> sum

    return [p1, p2]
end

function manhatten(x1, y1, x2, y2)
    abs(x1-x2) + abs(y1-y2)
end

end # module