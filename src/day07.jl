module Day07

using AdventOfCode2018
using StaticArrays

struct Workers
    times::MVector{5,Int}
    steps::MVector{5,Char}
end


function day07(input::String = readInput(joinpath(@__DIR__, "..", "data", "day07.txt")))
    data = parse_input(input)
    rules = generate_rules(data)
    p1 = part1!(deepcopy(rules))
    p2 = part2!(rules)
    return [p1, p2]
end

function parse_input(input)
    data = Vector{Pair{Char,Char}}()
    r = r"Step\s+(\w+)\s+must\s+be\s+finished\s+before\s+step\s+(\w+)\s+can\s+begin\."
    for line in split(rstrip(input), "\n")
        m = match(r, line)
        push!(data, Pair(m.captures[1][1], m.captures[2][1]))
    end
    return data
end

function get_steps(data::Vector{Pair{Char,Char}})
    r = [x[1] for x in data]
    s = [x[2] for x in data]
    return unique(union(r, s))
end

function generate_rules(data::Vector{Pair{Char,Char}})
    steps = get_steps(data)
    rules = Dict{Char,Set{Char}}()
    for step in steps
        rules[step] = Set{Char}()
    end
    for (req, s) in data
        push!(rules[s], req)
    end
    return rules
end

function part1!(rules::Dict{Char,Set{Char}})
    available = Set{Char}()
    solution = Vector{Char}()
    for (k, v) in rules
        if isempty(v)
            push!(available, k)
        end
    end

    while !isempty(available)
        step = sort(collect(available))[1]
        push!(solution, step)
        pop!(available, step)
        for (k, v) in rules
            if step ∈ v
                pop!(v, step)
            end
            if isempty(v) && k ∉ solution
                push!(available, k)
            end
        end
    end

    return join(solution)
end

function part2!(rules::Dict{Char,Set{Char}})
    total_time = 0
    available = Set{Char}()
    solution = Set{Char}()
    workers = Workers([0, 0, 0, 0, 0], ['a', 'a', 'a', 'a', 'a'])
    for (k, v) in rules
        if isempty(v)
            push!(available, k)
        end
    end

    while !isempty(available) || !workers_done(workers)
        for s ∈ sort(collect(available))
            i = get_available_worker_id(workers)
            if i == 0
                break
            end
            push!(solution, pop!(available, s))
            init_worker(workers, i, s)
        end
        t, done = run_workers(workers)
        total_time += t
        for s ∈ done
            for (k, v) ∈ rules
                if s ∈ v
                    pop!(v, s)
                end
                if isempty(v) && k ∉ solution
                    push!(available, k)
                end
            end
        end

    end
    return total_time
end

function get_available_worker_id(w::Workers)
    for i = 1:5
        if w.times[i] <= 0
            return i
        end
    end
    return 0
end

function init_worker(w::Workers, i::Int, s::Char)
    w.steps[i] = s
    w.times[i] = init_time(s)
end

function workers_done(w::Workers)
    return all(w.times .<= 0)
end

function run_workers(w::Workers)
    time = minimum(w.times[w.times .> 0])
    done = Set{Char}()
    for i = 1:5
        w.times[i] -= time
        if w.times[i] == 0
            push!(done, w.steps[i])
        end
    end
    return time, done
end

function init_time(c::Char)
    return Int(c - 64) + 60
end

end # module
