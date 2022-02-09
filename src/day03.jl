module Day03

using AdventOfCode2018

struct Claim
    id::Int
    hrange::UnitRange{Int}
    vrange::UnitRange{Int}
end

function day03(input::String = readInput(joinpath(@__DIR__, "..", "data", "day03.txt")))
    claims = parse_input(input)
    return [part1(claims), part2(claims)]
end

function part1(claims::Vector{Claim})
    w = maximum(cl.hrange.stop for cl ∈ claims)
    h = maximum(cl.vrange.stop for cl ∈ claims)
    M = zeros(UInt8, w, h)
    for cl ∈ claims
        M[cl.hrange, cl.vrange] .+= 1
    end
    return count(x -> x > 1, M)
end

function part2(claims::Vector{Claim})
    for i ∈ 1:length(claims)
        l = 0
        for j ∈ 1:length(claims)
            i == j && continue
            hint = intersect(claims[i].hrange, claims[j].hrange)
            vint = intersect(claims[i].vrange, claims[j].vrange)
            l += length(hint) * length(vint)
            l > 0 && break
        end
        l == 0 && return claims[i].id
    end
end

function parse_input(input::String)
    claims = Vector{Claim}()
    r = r"#(\d+)\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)"
    for line in split(rstrip(input), "\n")
        m = match(r, line)
        numbers = parse.(Int, m.captures)
        cl = Claim(numbers[1], numbers[2]+1:numbers[2]+numbers[4], numbers[3]+1:numbers[3]+numbers[5])
        push!(claims, cl)
    end
    return claims
end

end # module