module Day23

using AdventOfCode2018
using DataStructures

struct Cube
    # coordinates of the left-most corner of the cube
    # in each dimension (x, y, z):
    pos::Tuple{Int,Int,Int}
    # sidelength of the cube:
    side::Int
end

struct Bot
    pos::Tuple{Int,Int,Int}
    radius::Int
end

function day23(input::String = readInput(joinpath(@__DIR__, "..", "data", "day23.txt")))
    bots = parse_input(input)
    max_radius_idx = findmax(map(x -> x.radius, bots))[2]
    p1 = count(
        sum(abs.(x.pos .- bots[max_radius_idx].pos)) <= bots[max_radius_idx].radius for x ∈ bots
    )

    # The general idea is to implement a divide and conquer type
    # of algorithm: Start with a big cube (with side lengths of a multiple
    # of 2) that contains all the nanobots. Divide that cube into
    # 8 smaller cubes. For each of these 8 cubes, count the number
    # of nanobots which are in the range. Add the cubes into a
    # priority queue. Continue this process. If we reach a cube
    # of side length 1, we might have a candidate...
    M = maximum(maximum(abs.(bot.pos)) for bot ∈ bots)
    s = 1
    while s <= M
        s *= 2
    end

    cube = Cube((-s, -s, -s), 2*s)
    count(intersects(bot, cube) for bot ∈ bots)

    best = 0
    dist = 1_000_000_000

    pq = PriorityQueue{Cube,Int}()
    pq[Cube((-s, -s, -s), 2*s)] = -count(intersects(bot, cube) for bot ∈ bots)
    i = 0
    while !isempty(pq)
        i += 1
        cube = dequeue!(pq)
        if cube.side == 1
            c = count(intersects(bot, cube) for bot ∈ bots)
            if c > best
                best = c
                dist = abs.(cube.pos) |> sum
            elseif c == best
                d = abs.(cube.pos) |> sum
                if d < dist
                    dist = d
                end
            end
        else
            ncubes = divide(cube)
            for ncube ∈ ncubes
                c = count(intersects(bot, ncube) for bot ∈ bots)
                c < best && continue
                enqueue!(pq, ncube, -c)
            end
        end
    end
    return [p1, dist]
end

function divide(cube::Cube)
    half = cube.side ÷ 2
    return Cube[
        Cube((cube.pos[1], cube.pos[2], cube.pos[3]), half),
        Cube((cube.pos[1] + half, cube.pos[2], cube.pos[3]), half),
        Cube((cube.pos[1], cube.pos[2] + half, cube.pos[3]), half),
        Cube((cube.pos[1] + half, cube.pos[2] + half, cube.pos[3]), half),
        Cube((cube.pos[1], cube.pos[2], cube.pos[3] + half), half),
        Cube((cube.pos[1] + half, cube.pos[2], cube.pos[3] + half), half),
        Cube((cube.pos[1], cube.pos[2] + half, cube.pos[3] + half), half),
        Cube((cube.pos[1] + half, cube.pos[2] + half, cube.pos[3] + half), half)
    ]
end

intersects(bot::Bot, cube::Cube) = distance(bot, cube) <= bot.radius

function distance(bot::Bot, cube::Cube)
    d = 0
    for i ∈ 1:3
        if cube.pos[i] <= bot.pos[i] <= cube.pos[i] + cube.side - 1
            continue
        else
            d += min(abs(cube.pos[i] - bot.pos[i]), abs(cube.pos[i] + cube.side - 1 - bot.pos[i]))
        end
    end
    return d
end

function parse_input(input::AbstractString)
    bots = Bot[]
    for line ∈ eachsplit(input, "\n", keepempty=false)
        m = match(r"pos=<(\-?\d+),(\-?\d+),(\-?\d+)>,\s+r=(\d+)", line)
        push!(bots, Bot((parse(Int, m.captures[1]), parse(Int, m.captures[2]), parse(Int, m.captures[3])), parse(Int, m.captures[4])))
    end
    return bots
end

end # module
