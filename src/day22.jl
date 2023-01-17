module Day22

using AdventOfCode2018
using DataStructures
using Memoize

function day22(input::String = readInput(joinpath(@__DIR__, "..", "data", "day22.txt")))
    depth, (tx, ty) = parse_input(input)

    total_risk = 0
    for x ∈ 0:tx
        for y ∈ 0:ty
            total_risk += risk_level(x, y, tx, ty, depth)
        end
    end

    best_time = 1_000_000_000
    seen = DefaultDict{NTuple{3,Int},Int}(1_000_000_000)
    seen[(0, 0, 1)] = 0
    pq = PriorityQueue{NTuple{4,Int},Int}()
    time = 0
    enqueue!(pq, (0, 0, 1, 0), time)
    while !isempty(pq)
        x, y, tool, time = dequeue!(pq)
        for tooln ∈ (0, 1, 2)
            tooln == tool && continue
            tooln == risk_level(x, y, tx, ty, depth) && continue
            seen[(x, y, tooln)] <= time + 7 && continue
            best_time < time + 7 && continue
            seen[(x, y, tooln)] = time + 7
            if x == tx && y == ty && tooln == 1
                if best_time > time + 7
                    best_time = time + 7
                end
                continue
            end
            enqueue!(pq, (x, y, tooln, time + 7), time + 7)
        end
        for dir ∈ ((1, 0), (0, 1), (-1, 0), (0, -1))
            xn, yn = x + dir[1], y + dir[2]
            (xn < 0 || yn < 0) && continue
            risk_level(xn, yn, tx, ty, depth) == tool && continue
            seen[(xn, yn, tool)] <= time + 1 && continue
            best_time < time + 1 && continue
            seen[(xn, yn, tool)] = time + 1
            if xn == tx && yn == ty && tool == 1
                if best_time > time + 1
                    best_time = time + 1
                end
                continue
            end
            enqueue!(pq, (xn, yn, tool, time + 1), time + 1)
        end
    end
    return [total_risk, best_time]
end

@memoize function geologic_index(x::Int, y::Int, tx::Int, ty::Int, depth::Int)
    y == 0 && return x * 16807
    x == 0 && return y * 48271
    x == tx && y == ty && return 0
    return erosion_level(x-1, y, tx, ty, depth) * erosion_level(x, y-1, tx, ty, depth)
end

@memoize erosion_level(x::Int, y::Int, tx::Int, ty::Int, depth::Int) = mod(geologic_index(x, y, tx, ty, depth) + depth, 20183)
@memoize risk_level(x::Int, y::Int, tx::Int, ty::Int, depth::Int) = mod(erosion_level(x, y, tx, ty, depth), 3)

function parse_input(input::AbstractString)
    lines = split(input, "\n", keepempty=false)
    depth = parse(Int, split(lines[1])[2])
    target = parse.(Int, split(split(lines[2])[2], ','))
    return depth, (target[1], target[2])
end

end # module
