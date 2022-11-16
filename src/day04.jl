module Day04

using AdventOfCode2018

struct Timestamp
    year::Int
    month::Int
    day::Int
    hour::Int
    minute::Int
end

struct Event
    shift::Timestamp
    sleeps::Vector{Timestamp}
    wakeups::Vector{Timestamp}
end

function day04(input::String = readInput(joinpath(@__DIR__, "..", "data", "day04.txt")))
    data = parse_input(input)
    return solve(data)
end

function parse_input(input::String)
    d = Dict{Int,Vector{Event}}()
    lines = split(rstrip(input), "\n")
    slines = sort(lines)
    timestampregex = r"\[(\d{4})\-(\d{2})\-(\d{2})\s(\d{2}):(\d{2})\]"
    guardregex = r"#(\d+)"
    i = 1
    while i <= length(slines)
        m = match(timestampregex, slines[i])
        timestamp = Timestamp(parse.(Int, m.captures)...)
        m = match(guardregex, slines[i])
        guard = parse(Int, m.captures[1])
        if haskey(d, guard)
            push!(d[guard], Event(timestamp, Timestamp[], Timestamp[]))
        else
            d[guard] = [Event(timestamp, Timestamp[], Timestamp[])]
        end
        i += 1
        while true
            i > length(slines) && break
            m = match(guardregex, slines[i])
            m !== nothing && break
            m = match(timestampregex, slines[i])
            ts = Timestamp(parse.(Int, m.captures)...)
            i += 1
            m = match(timestampregex, slines[i])
            te = Timestamp(parse.(Int, m.captures)...)
            push!(d[guard][end].sleeps, ts)
            push!(d[guard][end].wakeups, te)
            i += 1
        end
    end
    return d
end

function solve(data::Dict{Int,Vector{Event}})
    sleeps = Dict{Int,Vector{Int}}()
    for (k, v) in data
        sleeps[k] = zeros(Int, 60)
        for shift in v
            for (falls_asleep, wakes_up) in zip(shift.sleeps, shift.wakeups)
                m = falls_asleep.minute
                M = wakes_up.minute
                sleeps[k][(m+1):M] .+= 1
            end
        end
    end
    guard = 0
    max_sleep = 0
    for (k, v) in sleeps
        total_sleep = sum(v)
        if total_sleep > max_sleep
            guard = k
            max_sleep = total_sleep
        end 
    end
    p1_minute = (sleeps[guard] |> argmax) - 1
    p1 = guard * p1_minute

    guard = 0
    most_minute = 0
    max_val = 0
    for (k, v) in sleeps
        mval = maximum(v)
        M = argmax(v) - 1
        if mval > max_val
            guard = k
            most_minute = M
            max_val = mval
        end
    end
    p2 = guard * most_minute
    return [p1, p2]
end

end # module