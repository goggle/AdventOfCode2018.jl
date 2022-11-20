module Day10

using AdventOfCode2018
using StatsBase

function day10(input::String = readInput(joinpath(@__DIR__, "..", "data", "day10.txt")))
    positions, velocities = parse_input(input)
    solve(positions, velocities)
end

function parse_input(input)
    positions = Vector{Vector{Int}}()
    velocities = Vector{Vector{Int}}()
    r = r"position=<\s*(-?\d+),\s+(-?\d+)>\s+velocity=<\s*(-?\d+),\s+(-?\d+)>"
    for line in split(rstrip(input), "\n")
        m = match(r, line)
        pos = parse.(Int, [m.captures[1], m.captures[2]])
        vel = parse.(Int, [m.captures[3], m.captures[4]])
        push!(positions, pos)
        push!(velocities, vel)
    end
    return positions, velocities
end

function solve(positions, velocities)
    imax = 0
    xymax = 0
    poss = deepcopy(positions)
    for i = 1:20_000
        poss += velocities
        distrx = countmap(x[1] for x in poss)
        Mx = maximum(x -> x[2], distrx)
        distry = countmap(x[2] for x in poss)
        My = maximum(x -> x[2], distry)
        if Mx + My > xymax
            xymax = Mx + My
            imax = i
        end
    end
    poss = positions + imax * velocities
    xmin = minimum(x[1] for x in poss)
    xmax = maximum(x[1] for x in poss)
    ymin = minimum(x[2] for x in poss)
    ymax = maximum(x[2] for x in poss)
    solution = fill('.', xmax - xmin + 1, ymax - ymin + 1)
    for (x, y) in poss
        solution[x-xmin+1, y-ymin+1] = '#'
    end
    return [generate_image(solution), imax]
end

end # module
