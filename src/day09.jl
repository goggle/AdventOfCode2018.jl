module Day09

using AdventOfCode2018
using CircularList

function day09(input::String = readInput(joinpath(@__DIR__, "..", "data", "day09.txt")))
    nplayers, last = parse_input(input)
    p1 = solve(nplayers, last)
    p2 = solve(nplayers, last * 100)
    return [p1, p2]

end

function parse_input(input)
    r = r"(\d+)\s+players.+worth\s+(\d+)\s+points"
    m = match(r, input)
    return parse.(Int, m.captures)
end

function solve(nplayers::Int, last::Int)
    scores = zeros(Int, nplayers)
    player = 1
    cl = circularlist(0)
    for marble in 1:last
        if mod(marble, 23) != 0
            forward!(cl)
            insert!(cl, marble)
        else
            scores[player] += marble
            shift!(cl, 7, :backward)
            scores[player] += current(cl).data
            delete!(cl)
            forward!(cl)
        end
        player = mod1(player + 1, nplayers)
    end
    return maximum(scores)
end

end # module
