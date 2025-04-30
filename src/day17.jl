module Day17

using AdventOfCode2018

function day17(input::String = readInput(joinpath(@__DIR__, "..", "data", "day17.txt")))
    blocked = Dict{Tuple{Int,Int},Symbol}()
    
    for line in split(input, '\n')
        m = match(r"(x|y)=(\d+), (?:x|y)=(\d+)..(\d+)", line)
        m === nothing && continue
        
        coord1, val1, val2, val3 = m.captures
        val1, val2, val3 = parse(Int, val1), parse(Int, val2), parse(Int, val3)
        is_x = coord1 == "x"
        for c in val2:val3
            pos = is_x ? (val1, c) : (c, val1)
            blocked[pos] = :clay
        end
    end

    ys = [p[2] for p in keys(blocked)]
    minY, maxY = extrema(ys)

    visited = Set{Tuple{Int,Int}}()

    function endpoint(y::Int, x::Int, dx::Int)
        while !haskey(blocked, (x + dx, y)) && haskey(blocked, (x, y + 1))
            x += dx
        end
        return x
    end

    function follow(y::Int, x::Int)
        L = endpoint(y, x, -1)
        R = endpoint(y, x, 1)
        
        for nx in L:R
            push!(visited, (nx, y))
        end

        # Check if water can flow down from left or right
        if !haskey(blocked, (L, y + 1)) && !((L, y + 1) in visited)
            down(y, L)
        end
        if !haskey(blocked, (R, y + 1)) && !((R, y + 1) in visited)
            down(y, R)
        end

        # If both sides are blocked, fill with water and move up
        if haskey(blocked, (L, y + 1)) && haskey(blocked, (R, y + 1))
            for nx in L:R
                blocked[(nx, y)] = :water
            end
            follow(y - 1, x)
        end
    end

    function down(y::Int, x::Int)
        while !haskey(blocked, (x, y + 1)) && y != maxY
            y += 1
            push!(visited, (x, y))
        end
        y != maxY && follow(y, x)
    end

    # Start water flow from spring at (500, minY-1) - now in (x,y) order
    down(minY - 1, 500)

    # Part 1: Count tiles water can reach (visited within y bounds)
    part1 = count(p -> minY <= p[2] <= maxY, visited)
    
    # Part 2: Count settled water tiles
    part2 = count(v -> v == :water, values(blocked))

    return [part1, part2]
end

end # module