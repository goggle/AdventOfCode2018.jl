module Day12

using AdventOfCode2018
using DataStructures

function day12(input::String = readInput(joinpath(@__DIR__, "..", "data", "day12.txt")))
    state, growrules = parse_input(input)
    return [part1(state, growrules), part2(state, growrules)]
end

function parse_input(input)
    lines = split(rstrip(input), "\n")
    state = DefaultDict{Int,Bool,Bool}(false)
    for (i, c) in enumerate(lines[1])
        if c == '#'
            state[i-16] = true
        elseif c == '.'
            state[i-16] = false
        end
    end
    growrules = Set{Vector{Bool}}()
    for line in lines[3:end]
        if line[end] == '#'
            push!(growrules, map(x -> x == '#', collect(line[1:5])))
        end
    end
    return state, growrules
end

function part1(state::DefaultDict{Int,Bool,Bool}, growrules::Set{Vector{Bool}})
    state = deepcopy(state)
    for i = 1:20
        step!(state, growrules)
    end
    return sum([k for (k, v) ∈ state if v])
end

function part2(state::DefaultDict{Int,Bool,Bool}, growrules::Set{Vector{Bool}})
    state = deepcopy(state)
    prev = Vector{Bool}()
    prev_score = 0
    diff = 0
    ind = 0
    for i = 1:50_000_000_000
        curr = step!(state, growrules)
        # Detect 1-cycles:
        # Not sure if this works for every input, but it does for mine.
        if curr == prev
            diff = sum([k for (k, v) ∈ state if v]) - prev_score
            ind = i
            break
        end
        prev = curr
        prev_score = sum([k for (k, v) ∈ state if v])
    end
    return sum([k for (k, v) ∈ state if v]) + (50_000_000_000 - ind) * diff
end

function step!(state::DefaultDict{Int,Bool,Bool}, growrules::Set{Vector{Bool}})
    m, M = extrema(collect(keys(state)))
    ll, l = false, false
    tmp = false
    for k = m-2:M+2
        tmp = state[k]
        if _get(state, ll, l, k) ∈ growrules
            state[k] = true
        else
            state[k] = false
        end
        ll = l
        l = tmp
    end

    # remove trailing entries
    k = m-2
    while k <= M+2
        m = k
        if !state[k]
            delete!(state, k)
            k += 1
            continue
        end
        break
    end

    k = M+2
    while k >= m-2
        M = k
        if !state[k]
            delete!(state, k)
            k -= 1
            continue
        end
        break
    end

    return [state[k] for k ∈ m:M]
end

function _get(state::DefaultDict{Int,Bool,Bool}, ll::Bool, l::Bool, at::Int)
    res = zeros(Bool, 5)
    s = at - 2
    res[1] = ll
    res[2] = l
    for i = 3:5
        res[i] = state[s + i - 1]
    end
    return res
end

end # module