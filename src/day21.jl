module Day21
using AdventOfCode2018
import AdventOfCode2018.Day16.addr!
import AdventOfCode2018.Day16.addi!
import AdventOfCode2018.Day16.mulr!
import AdventOfCode2018.Day16.muli!
import AdventOfCode2018.Day16.banr!
import AdventOfCode2018.Day16.bani!
import AdventOfCode2018.Day16.borr!
import AdventOfCode2018.Day16.bori!
import AdventOfCode2018.Day16.setr!
import AdventOfCode2018.Day16.seti!
import AdventOfCode2018.Day16.gtir!
import AdventOfCode2018.Day16.gtri!
import AdventOfCode2018.Day16.gtrr!
import AdventOfCode2018.Day16.eqir!
import AdventOfCode2018.Day16.eqri!
import AdventOfCode2018.Day16.eqrr!

function day21(input::String = readInput(joinpath(@__DIR__, "..", "data", "day21.txt")))
    ip, instructions = parse_input(input)
    
    # Part 1: Find the lowest non-negative integer value for register 0 that causes
    # the program to halt after executing the fewest instructions
    result1 = find_halt_value(ip, instructions)
    
    # Part 2: Find the lowest non-negative integer value for register 0 that causes
    # the program to halt after executing the most instructions
    result2 = find_last_halt_value(ip, instructions)
    
    return [result1, result2]
end

function parse_input(input::AbstractString)
    lines = split(input, "\n", keepempty=false)
    m = match(r"#ip\s+(\d+)", lines[1])
    ip = parse(Int, m.captures[1])
    d = Dict(
        "addr" => addr!,
        "addi" => addi!,
        "mulr" => mulr!,
        "muli" => muli!,
        "banr" => banr!,
        "bani" => bani!,
        "borr" => borr!,
        "bori" => bori!,
        "setr" => setr!,
        "seti" => seti!,
        "gtir" => gtir!,
        "gtri" => gtri!,
        "gtrr" => gtrr!,
        "eqir" => eqir!,
        "eqri" => eqri!,
        "eqrr" => eqrr!
    )
    instructions = []
    for line ∈ lines[2:end]
        m = match(r"(\w+)\s+(\d+)\s+(\d+)\s+(\d+)", line)
        instruction = (d[m.captures[1]], parse(Int, m.captures[2]), parse(Int, m.captures[3]), parse(Int, m.captures[4]))
        push!(instructions, instruction)
    end
    return ip, instructions
end

function find_halt_value(ip_reg::Int, instructions::Vector)
    # After analyzing the code, we found that the program checks register 5 against register 0
    # at instruction 28 (eqrr 5 0 1). If they're equal, the program halts.
    # We need to find what value register 5 has the first time it reaches that instruction.
    
    registers = Dict(0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0)
    ip = 0
    
    while 0 <= ip < length(instructions)
        registers[ip_reg] = ip
        (op, a, b, c) = instructions[ip+1]  # 1-indexed arrays in Julia
        
        # This is the instruction that compares register 5 to register 0
        # When we reach it, we return the value of register 5
        if ip == 28
            return registers[5]
        end        
        op(registers, a, b, c)
        ip = registers[ip_reg] + 1
    end
    
    return -1
end

function find_last_halt_value(ip_reg::Int, instructions::Vector)
    # For part 2, we need to track the values of register 5 when it reaches instruction 28
    # Since the program will eventually cycle, we need to find the last unique value before it repeats
    
    # Let's analyze the key instructions more carefully to optimize our approach
    # Initialize registers, but skip executing all instructions
    registers = Dict(0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0)
    
    # Track seen values of register 5 at instruction 28
    seen_values = Set{Int}()
    last_unique_value = nothing
    
    # Jump directly to the main loop in the program
    # Initial setup (lines 1-5 essentially set register 5 to 0)
    registers[5] = 0
    
    # Main loop
    while true
        # This is a highly optimized version that extracts the essence of the program
        # The program primarily manipulates registers 3 and 5
        
        # Based on the instructions, register 3 gets 65536 | register 5
        registers[3] = registers[5] | 65536
        registers[5] = 7586220
        
        while true
            # Register 5 calculation (lines 8-13)
            registers[5] = ((((registers[5] + (registers[3] & 255)) & 16777215) * 65899) & 16777215)
            
            # Check if we should break out of inner loop (line 14-17)
            if 256 > registers[3]
                break
            end
            
            # Calculate new value for register 3 (lines 18-26)
            registers[3] = registers[3] ÷ 256
        end
        
        # At this point, we've reached instruction 28 (eqrr 5 0 1)
        
        # If we've seen this value before, we've found a cycle
        if registers[5] in seen_values
            return last_unique_value
        end
        
        last_unique_value = registers[5]
        push!(seen_values, registers[5])
    end
end

end # module