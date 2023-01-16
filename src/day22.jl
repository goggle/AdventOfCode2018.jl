module Day22

using AdventOfCode2018
using DataStructures

function day22(input::String = readInput(joinpath(@__DIR__, "..", "data", "day22.txt")))
    depth, target = parse_input(input)

    N = 2*max(target[1], target[2])
    geologic_indices = calculate_geologic_indices(target[1], target[2], depth, N, N)
    total_risk = 0
    for x ∈ 0:target[1]
        for y ∈ 0:target[2]
            total_risk += risk_level(x, y, geologic_indices, depth)
        end
    end
    
    datamap = zeros(Int, N+1, N+1)
    for x ∈ 0:N
        for y ∈ 0:N
            datamap[x+1,y+1] = risk_level(x, y, geologic_indices, depth)
        end
    end

    best_time = typemax(Int)
    tx, ty = target[1]+1, target[2]+1
    seen = DefaultDict{NTuple{3,Int},Int}(1_000_000_000)
    pq = PriorityQueue{NTuple{4,Int},Int}()
    start = (1, 1, 1)
    seen[start] = 0
    time = 0
    enqueue!(pq, (1, 1, 1, 0), dist(1, 1, tx, ty))
    while !isempty(pq)
        x, y, tool, time = dequeue!(pq)
        for tooln ∈ (0, 1, 2)
            tooln == tool && continue
            tooln == datamap[x, y] && continue
            seen[(x, y, tooln)] <= time + 7 && continue
            best_time <= time + 7 && continue
            seen[(x, y, tooln)] = time + 7
            if x == tx && y == ty
                best_time = minimum(seen[tx, ty, i] for i ∈ (0, 1, 2))
                continue
            end
            enqueue!(pq, (x, y, tooln, time + 7), time + 7)
        end
        for dir ∈ ((1, 0), (0, 1), (-1, 0), (0, -1))
            xn, yn = x + dir[1], y + dir[2]
            (xn <= 0 || yn <= 0) && continue
            (xn > N || yn > N) && continue
            datamap[xn, yn] == tool && continue
            seen[(xn, yn, tool)] <= time + 1 && continue
            best_time <= time + 1 && continue
            seen[(xn, yn, tool)] = time + 1
            if xn == tx && yn == ty
                best_time = minimum(seen[tx, ty, i] for i ∈ (0, 1, 2))
                continue
            end
            enqueue!(pq, (xn, yn, tool, time + 1), time + 1)
        end
    end
    seen[(tx, ty, 2)] += 7
    seen[(tx, ty, 0)] += 7

    p2 = minimum(seen[tx, ty, tool] for tool ∈ (0, 1, 2))
    
    return [total_risk, p2]
end

dist(x::Int, y::Int, a::Int, b::Int) = abs(x - a) + abs(y - b)

function calculate_geologic_indices(tx::Int, ty::Int, depth::Int, maptx::Int, mapty::Int)
    geologic = Dict{Tuple{Int,Int},Int}()
    geologic[(0,0)] = 0
    N = maptx + mapty
    for x ∈ 1:N
        geologic[(x,0)] = x * 16807
    end
    for y ∈ 1:N
        geologic[(0,y)] = y * 48271
    end
    for k ∈ 2:N
        for x ∈ 1:min(k-1, maptx)
            y = k - x
            geologic[(x,y)] = erosion_level(x - 1, y, geologic, depth) * erosion_level(x, y - 1, geologic, depth)
        end
    end
    geologic[(tx,ty)] = 0
    return geologic
end

erosion_level(x::Int, y::Int, g::Dict{Tuple{Int,Int},Int}, depth::Int) = mod(g[(x,y)] + depth, 20183)
risk_level(x::Int, y::Int, g::Dict{Tuple{Int,Int},Int}, depth::Int) = mod(erosion_level(x, y, g, depth), 3)

function parse_input(input::AbstractString)
    lines = split(input, "\n", keepempty=false)
    depth = parse(Int, split(lines[1])[2])
    target = parse.(Int, split(split(lines[2])[2], ','))
    return depth, (target[1], target[2])
end

end # module
