module Day11

using AdventOfCode2018

function day11(input::String = readInput(joinpath(@__DIR__, "..", "data", "day11.txt")))
    serial = parse(Int, input)
    grid = zeros(Int, 300, 300)
    for x = 1:300
        for y = 1:300
            grid[x, y] = power_level(x, y, serial)
        end
    end
    I = summed_area_table(grid)
    p1 = max_power(I, 3)[1:2]

    p2x, p2y, p2p, p2s = 0, 0, 0, 0
    for s = 1:300
        x, y, p = max_power(I, s)
        if p > p2p
            p2x = x
            p2y = y
            p2p = p
            p2s = s
        end
    end
    p2 = (p2x, p2y, p2s)
    return [p1, p2]
end

function power_level(x::Int, y::Int, serial::Int)
    rack_id = x + 10
    pl = rack_id * y + serial
    pl = pl * rack_id
    pl = mod(pl ÷ 100, 10) - 5
    return pl
end

function summed_area_table(grid::Matrix{Int})
    # Computes the summed-area table of the power grid, see
    # https://en.wikipedia.org/wiki/Summed-area_table
    function get(i::Int, j::Int)
        (i < 1 || j < 1) && return 0
        return I[i, j]
    end
    I = zeros(Int, size(grid))
    for i = 1:size(grid)[1]
        for j = 1:size(grid)[2]
            I[i, j] = grid[i, j] + get(i, j-1) + get(i-1, j) - get(i-1, j-1)
        end
    end
    return I
end

function max_power(I::Matrix{Int}, s::Int)
    xmax, ymax, pmax = 0, 0, 0
    for x = 1:300-s
        for y = 1:300-s
            p = I[x+s, y+s] + I[x, y] - I[x, y+s] - I[x+s, y]
            # println(p)
            if p > pmax
                pmax = p
                xmax = x + 1
                ymax = y + 1
            end
        end
    end
    return xmax, ymax, pmax
end

end # module
