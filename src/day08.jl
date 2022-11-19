module Day08

using AdventOfCode2018

function day08(input::String = readInput(joinpath(@__DIR__, "..", "data", "day08.txt")))
    data = parse.(Int, split(input))
    p1 = sum_metadata(data, 1, Vector{Int}(), Vector{Int}())[1]
    p2 = sum_tree(data, 1, Vector{Int}(), Vector{Int}())[1]
    return [p1, p2]
end

function sum_metadata(data::Vector{Int}, i::Int, cstack::Vector{Int}, mstack::Vector{Int})
    sum = 0
    push!(cstack, data[i])
    push!(mstack, data[i+1])
    while cstack[end] != 0
        cstack[end] -= 1
        s, i = sum_metadata(data, i+2, cstack, mstack)
        sum += s
    end
    pop!(cstack)
    M = pop!(mstack)
    for _ = 1:M
        sum += data[i+2]
        i += 1
    end
    return (sum, i)
end

function sum_tree(data::Vector{Int}, i::Int, cstack::Vector{Int}, mstack::Vector{Int})
    total = 0
    push!(cstack, data[i])
    push!(mstack, data[i+1])
    if cstack[end] == 0
        pop!(cstack)
        M = pop!(mstack)
        for _ = 1:M
            total += data[i+2]
            i += 1
        end
        return (total, i)
    else
        N = cstack[end]
        sums = zeros(Int, N)
        k = 1
        while cstack[end] != 0
            cstack[end] -= 1
            s, i = sum_tree(data, i+2, cstack, mstack)
            sums[k] = s
            k += 1
        end
        pop!(cstack)
        M = pop!(mstack)
        factors = zeros(Int, N)
        for _ = 1:M
            if data[i+2] >= 1 && data[i+2] <= N
                factors[data[i+2]] += 1
            end
            i += 1
        end
        return (sum(factors .* sums), i)
    end
end

end # module
