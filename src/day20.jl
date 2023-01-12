module Day20

using AdventOfCode2018
using DataStructures

function day20(input::String = readInput(joinpath(@__DIR__, "..", "data", "day20.txt")))
    data = DefaultDict{Tuple{Int,Int},Char}('#')
    discover_map!(data, Tuple{Int,Int}[], Set{Int}(), input, 0, 0, 2)
    M = _to_matrix(data)
    D = distance_matrix(M)
    return [maximum(D), count(x -> x >= 1000, D)]
end

function Base.show(io::IO, M::Matrix{Char})
    for i ∈ axes(M, 1)
        for j ∈ axes(M, 2)
            print(M[i,j])
        end
        println()
    end
end

function distance_matrix(M::Matrix{Char})
    D = zeros(Int, size(M))
    pos = [findfirst(x -> x == 'X', M).I]
    d = 0
    while !isempty(pos)
        l = length(pos)
        for _ ∈ 1:l
            p = popfirst!(pos)
            D[p...] ≠ 0 && continue
            D[p...] = d
            if M[(p .+ (1, 0))...] == '-' && M[(p .+ (2, 0))...] == '.'
                push!(pos, p .+ (2, 0))
            end
            if M[(p .+ (-1, 0))...] == '-' && M[(p .+ (-2, 0))...] == '.'
                push!(pos, p .+ (-2, 0))
            end
            if M[(p .+ (0, 1))...] == '|' && M[(p .+ (0, 2))...] == '.'
                push!(pos, p .+ (0, 2))
            end
            if M[(p .+ (0, -1))...] == '|' && M[(p .+ (0, -2))...] == '.'
                push!(pos, p .+ (0, -2))
            end
        end
        d += 1
    end
    return D
end

function _to_matrix(data::DefaultDict{Tuple{Int,Int},Char})
    coords = findall(x -> x != '#', data)
    mini = minimum(x -> x[1], coords) - 1
    maxi = maximum(x -> x[1], coords) + 1
    minj = minimum(x -> x[2], coords) - 1
    maxj = maximum(x -> x[2], coords) + 1
    nrows = maxi - mini + 1
    ncols = maxj - minj + 1
    offi = 1 - mini
    offj = 1 - minj
    M = fill('#', (nrows, ncols))
    for (i, j) ∈ coords
        M[i + offi, j + offj] = data[(i,j)]
    end
    return M
end

function discover_map!(data::DefaultDict{Tuple{Int,Int},Char}, stack::Vector{Tuple{Int,Int}}, call_positions::Set{Int}, input::AbstractString, starti::Int, startj::Int, i::Int)
    if starti == startj == 0
        data[(0,0)] = 'X'
    end
    current = (starti, startj)
    while input[i] != '$'
        if input[i] == 'N'
            data[current .+ (-1, 0)] = '-'
            data[current .+ (-2, 0)] = '.'
            current = current .+ (-2, 0)
            i += 1
        elseif input[i] == 'S'
            data[current .+ (1, 0)] = '-'
            data[current .+ (2, 0)] = '.'
            current = current .+ (2, 0)
            i += 1
        elseif input[i] == 'W'
            data[current .+ (0, -1)] = '|'
            data[current .+ (0, -2)] = '.'
            current = current .+ (0, -2)
            i += 1
        elseif input[i] == 'E'
            data[current .+ (0, 1)] = '|'
            data[current .+ (0, 2)] = '.'
            current = current .+ (0, 2)
            i += 1
        elseif input[i] == '('
            push!(stack, current)
            i += 1
        elseif input[i] == '|'
            current = stack[end]
            i += 1
            if input[i] == ')'
                newstack = copy(stack)
                newcurrent = pop!(newstack)
                i + 1 ∈ call_positions && break
                push!(call_positions, i+1)
                discover_map!(data, newstack, call_positions, input, newcurrent[1], newcurrent[2], i+1)
            end
        elseif input[i] == ')'
            pop!(stack)
            i += 1
        end

    end
end

end # module
