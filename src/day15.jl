module Day15
using AdventOfCode2018

struct Position
    y::Int
    x::Int
end

Base.isless(a::Position, b::Position) = a.y < b.y || (a.y == b.y && a.x < b.x)
Base.:(==)(a::Position, b::Position) = a.y == b.y && a.x == b.x
Base.hash(p::Position, h::UInt) = hash(p.y, hash(p.x, h))

const DIRECTIONS = (
    Position(-1, 0),  # Up
    Position(0, -1),  # Left
    Position(0, 1),   # Right
    Position(1, 0)    # Down
)

mutable struct Unit
    position::Position
    type::Char
    hp::Int
    attack::Int
    alive::Bool
end

function neighbors!(result::Vector{Position}, pos::Position)
    empty!(result)
    for d ∈ DIRECTIONS
        push!(result, Position(pos.y + d.y, pos.x + d.x))
    end
    return result
end

function neighbors(pos::Position)
    return [Position(pos.y + d.y, pos.x + d.x) for d in DIRECTIONS]
end

function parse_input(input::String)
    lines = split(rstrip(input), '\n')
    height = length(lines)
    width = length(lines[1])
    
    grid = fill('.', (height, width))
    units = Unit[]
    
    for (y, line) ∈ enumerate(lines)
        for (x, char) ∈ enumerate(line)
            if char ∈ ('E', 'G')
                push!(units, Unit(Position(y, x), char, 200, 3, true))
            elseif char == '#'
                grid[y, x] = '#'
            end
        end
    end
    return grid, units
end

@inline function is_open(grid, pos::Position)
    return 1 <= pos.y <= size(grid, 1) && 
           1 <= pos.x <= size(grid, 2) && 
           grid[pos.y, pos.x] == '.'
end

function find_enemies(unit::Unit, units::Vector{Unit})
    enemies = Unit[]
    for u in units
        if u.alive && u.type != unit.type
            push!(enemies, u)
        end
    end
    return enemies
end

function get_occupied_positions(units::Vector{Unit})
    positions = Set{Position}()
    for u ∈ units
        u.alive && push!(positions, u.position)
    end
    return positions
end

function find_adjacent_enemies(unit::Unit, units::Vector{Unit})
    adjacent = Unit[]
    unit_pos = unit.position
    
    for u ∈ units
        if !u.alive || u.type == unit.type
            continue
        end
        
        enemy_pos = u.position
        if abs(enemy_pos.y - unit_pos.y) + abs(enemy_pos.x - unit_pos.x) == 1
            push!(adjacent, u)
        end
    end
    
    return adjacent
end

function shortest_path(grid, occupied::Set{Position}, start::Position, targets::Vector{Position})
    if start in targets
        return start, 0
    end
    
    queue = Tuple{Position, Int}[(start, 0)]
    visited = Set{Position}([start])
    best_target = nothing
    best_dist = typemax(Int)
    neighbor_buffer = Position[]
    
    while !isempty(queue)
        pos, dist = popfirst!(queue)
        
        # Early termination when we've found the shortest path
        if dist >= best_dist
            break
        end
        
        # Get neighbors efficiently
        neighbors!(neighbor_buffer, pos)
        for next_pos ∈ neighbor_buffer
            if next_pos ∈ visited || next_pos ∈ occupied || !is_open(grid, next_pos)
                continue
            end
            
            next_dist = dist + 1
            
            # Check if this is a target
            if next_pos ∈ targets
                if next_dist < best_dist || (next_dist == best_dist && next_pos < best_target)
                    best_target = next_pos
                    best_dist = next_dist
                end
            end
            
            push!(visited, next_pos)
            push!(queue, (next_pos, next_dist))
        end
    end
    
    return best_target, best_dist
end

function next_step_towards(grid, occupied::Set{Position}, start::Position, target::Position)
    neighbor_buffer = Position[]
    neighbors!(neighbor_buffer, start)
    
    valid_steps = Position[]
    for next_pos ∈ neighbor_buffer
        if !(next_pos ∈ occupied) && is_open(grid, next_pos)
            push!(valid_steps, next_pos)
        end
    end
    
    if isempty(valid_steps)
        return nothing
    end
    
    step_distances = Tuple{Position, Int}[]
    
    for next_pos ∈ valid_steps
        temp_occupied = copy(occupied)
        delete!(temp_occupied, start)
        push!(temp_occupied, next_pos)
        
        queue = Tuple{Position, Int}[(next_pos, 0)]
        visited = Set{Position}([next_pos])
        found_target = false
        dist_to_target = typemax(Int)
        
        while !isempty(queue) && !found_target
            pos, dist = popfirst!(queue)
            
            if pos == target
                dist_to_target = dist
                found_target = true
                break
            end
            
            pos_neighbors = neighbors(pos)
            for step_pos ∈ pos_neighbors
                if step_pos ∈ visited || step_pos ∈ temp_occupied || !is_open(grid, step_pos)
                    continue
                end
                
                push!(visited, step_pos)
                push!(queue, (step_pos, dist + 1))
            end
        end
        
        if found_target
            push!(step_distances, (next_pos, dist_to_target))
        end
    end
    
    if isempty(step_distances)
        return nothing
    end
    
    sort!(step_distances, by = x -> (x[2], x[1]))
    
    return step_distances[1][1]
end

function move_unit!(grid, unit::Unit, units::Vector{Unit}, occupied::Set{Position})
    enemies = find_enemies(unit, units)
    if isempty(enemies)
        return false  # No enemies, combat ends
    end
    
    adjacent_enemies = find_adjacent_enemies(unit, units)
    if !isempty(adjacent_enemies)
        return true  # Already in range, no need to move
    end
    
    # Find all squares in range of any enemy
    in_range = Position[]
    neighbor_buffer = Position[]
    
    for enemy ∈ enemies
        neighbors!(neighbor_buffer, enemy.position)
        for pos ∈ neighbor_buffer
            if is_open(grid, pos) && !(pos in occupied)
                push!(in_range, pos)
            end
        end
    end
    
    # Remove duplicates from in_range
    unique!(in_range)
    
    if isempty(in_range)
        return true  # No accessible targets
    end
    
    # Find nearest reachable target position
    target, _ = shortest_path(grid, occupied, unit.position, in_range)
    
    if target === nothing
        return true  # No path to any target
    end
    
    # Determine the first step towards the target
    next_pos = next_step_towards(grid, occupied, unit.position, target)
    
    if next_pos !== nothing
        # Update occupied positions
        delete!(occupied, unit.position)
        unit.position = next_pos
        push!(occupied, next_pos)
    end
    
    return true
end

function attack_unit!(unit::Unit, units::Vector{Unit})
    # Find adjacent enemies
    adjacent_enemies = find_adjacent_enemies(unit, units)
    
    if isempty(adjacent_enemies)
        return true  # No enemies to attack
    end
    
    # Find enemy with fewest HP
    sort!(adjacent_enemies, by = e -> (e.hp, e.position))
    target = adjacent_enemies[1]
    
    # Attack the target
    target.hp -= unit.attack
    
    # Check if target dies
    if target.hp <= 0
        target.alive = false
    end
    
    return true
end

function play_round!(grid, units::Vector{Unit})
    # Sort units in reading order
    sort!(units, by = u -> u.position)
    
    # Pre-compute occupied positions
    occupied = get_occupied_positions(units)
    
    for unit ∈ units
        if !unit.alive
            continue
        end
        
        # Check if any enemies remain
        enemies_exist = false
        unit_type = unit.type
        for u ∈ units
            if u.alive && u.type != unit_type
                enemies_exist = true
                break
            end
        end
        
        if !enemies_exist
            return false  # Combat ends
        end
        
        # Move phase
        moved = move_unit!(grid, unit, units, occupied)
        if !moved
            return false  # Combat ends
        end
        
        # Attack phase
        attack_unit!(unit, units)
        
        # Update occupied positions after potential death
        occupied = get_occupied_positions(units)
    end
    
    return true
end

function run_simulation(input::String, elf_attack::Int = 3)
    grid, units = parse_input(input)
    
    # Set elf attack power
    for unit ∈ units
        if unit.type == 'E'
            unit.attack = elf_attack
        end
    end
    
    # Count initial elves
    initial_elves = count(u -> u.type == 'E', units)
    
    rounds = 0
    while true
        round_completed = play_round!(grid, units)
        if !round_completed
            break
        end
        rounds += 1
        
        # Check if any elf has died (for part 2)
        if elf_attack > 3
            current_elves = count(u -> u.alive && u.type == 'E', units)
            if current_elves < initial_elves
                return -1, false  # Elf died, failed scenario
            end
        end
    end
    
    # Calculate remaining hit points
    remaining_hp = sum(u.hp for u in filter(u -> u.alive, units))
    
    # Check if elves won
    elves_won = any(u -> u.type == 'E' && u.alive, units)
    
    outcome = rounds * remaining_hp
    
    if elf_attack > 3 && !elves_won
        return -1, false  # Elves didn't win, failed scenario
    end
    
    return outcome, elves_won
end

function day15(input::String = readInput(joinpath(@__DIR__, "..", "data", "day15.txt")))
    # Part 1: Standard battle with attack power 3
    part1 = run_simulation(input)[1]
    
    # Part 2: Find minimum elf attack power for a win with no losses
    elf_attack = 4
    part2 = -1
    
    while part2 == -1
        outcome, elves_won = run_simulation(input, elf_attack)
        
        if outcome > 0 && elves_won
            part2 = outcome
            break
        end
        
        elf_attack += 1
    end
    
    return [part1, part2]
end
end  # module
