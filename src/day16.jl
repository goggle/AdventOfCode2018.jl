module Day16

using AdventOfCode2018

function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    before, middle, after, code = parse_input(input)
    p1 = part1(before, middle, after)
    translation = translate(before, middle, after)
    p2 = part2(translation, code)
    return [p1, p2]
end

function parse_input(input::AbstractString)
    one, two = split(input, "\n\n\n\n")
    before = Vector{Vector{Int}}()
    middle = Vector{Vector{Int}}()
    after = Vector{Vector{Int}}()
    reg = r"Before:\s*\[(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\]\s*\n(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s*\nAfter:\s*\[(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\].*"
    for entry ∈ split(one, "\n\n")
        m = match(reg, entry)
        push!(before, parse.(Int, m.captures[1:4]))
        push!(middle, parse.(Int, m.captures[5:8]))
        push!(after, parse.(Int, m.captures[9:12]))
    end
    code = [parse.(Int, x) for x ∈ split.(split(two, "\n"; keepempty=false))]
    return before, middle, after, code
end

function set_registers(values::Vector{Int})
    return Dict(0=>values[1], 1=>values[2], 2=>values[3], 3=>values[4])
end

function registers_equals(registers::Dict{Int,Int}, values::Vector{Int})
    registers[0] != values[1] && return false
    registers[1] != values[2] && return false
    registers[2] != values[3] && return false
    registers[3] != values[4] && return false
    return true
end

function addr!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] + registers[b]
end

function addi!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] + b
end

function mulr!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] * registers[b]
end

function muli!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] * b
end

function banr!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] & registers[b]
end

function bani!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] & b
end

function borr!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] | registers[b]
end

function bori!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    registers[c] = registers[a] | b
end

function setr!(registers::Dict{Int,Int}, a::Int, _::Int, c::Int)
    registers[c] = registers[a]
end

function seti!(registers::Dict{Int,Int}, a::Int, _::Int, c::Int)
    registers[c] = a
end

function gtir!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    if a > registers[b]
        registers[c] = 1
    else
        registers[c] = 0
    end
end

function gtri!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    if registers[a] > b
        registers[c] = 1
    else
        registers[c] = 0
    end
end

function gtrr!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    if registers[a] > registers[b]
        registers[c] = 1
    else
        registers[c] = 0
    end
end

function eqir!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    if a == registers[b]
        registers[c] = 1
    else
        registers[c] = 0
    end
end

function eqri!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    if registers[a] == b
        registers[c] = 1
    else
        registers[c] = 0
    end
end

function eqrr!(registers::Dict{Int,Int}, a::Int, b::Int, c::Int)
    if registers[a] == registers[b]
        registers[c] = 1
    else
        registers[c] = 0
    end
end

function part1(before, middle, after)
    opcodes = [addr!, addi!, mulr!, muli!, banr!, bani!, borr!, bori!, setr!, seti!, gtir!, gtri!, gtrr!, eqir!, eqri!, eqrr!]
    total = 0
    for (bef, mid, aft) ∈ zip(before, middle, after)
        c = 0
        for opc ∈ opcodes
            reg = set_registers(bef)
            opc(reg, mid[2], mid[3], mid[4])
            if registers_equals(reg, aft)
                c += 1
                if c >= 3
                    total += 1
                    break
                end
            end
        end
    end
    return total
end

function translate(before, middle, after)
    opcodes = [addr!, addi!, mulr!, muli!, banr!, bani!, borr!, bori!, setr!, seti!, gtir!, gtri!, gtrr!, eqir!, eqri!, eqrr!]
    translation = Dict{Int,Set{Int}}()
    for i ∈ 0:15
        translation[i] = Set{Int}()
    end
    for (bef, mid, aft) ∈ zip(before, middle, after)
        for (i, opc) ∈ enumerate(opcodes)
            reg = set_registers(bef)
            opc(reg, mid[2], mid[3], mid[4])
            if registers_equals(reg, aft)
                push!(translation[mid[1]], i)
            end
        end
    end

    result = Dict{Int,Int}()
    while !isempty(translation)
        rem = -1
        for (k, v) ∈ translation
            if length(v) == 1
                rem = pop!(v)
                delete!(translation, k)
                result[k] = rem
                break
            end
        end
        for (_, v) ∈ translation
            delete!(v, rem)
        end
    end
    return result
end

function part2(translation, code)
    opcodes = [addr!, addi!, mulr!, muli!, banr!, bani!, borr!, bori!, setr!, seti!, gtir!, gtri!, gtrr!, eqir!, eqri!, eqrr!]
    reg = Dict(0=>0, 1=>0, 2=>0, 3=>0)
    for line ∈ code
        op = opcodes[translation[line[1]]]
        op(reg, line[2], line[3], line[4])
    end
    return reg[0]
end


end # module
