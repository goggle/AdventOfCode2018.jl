module Day24
using AdventOfCode2018

mutable struct Group
    id::Int
    army::Symbol  # :immune or :infection
    units::Int
    hit_points::Int
    weaknesses::Vector{String}
    immunities::Vector{String}
    attack_damage::Int
    attack_type::String
    initiative::Int
end

function parse_input(input::String)
    lines = split(strip(input), '\n')
    groups = Group[]
    current_army = nothing
    id_counter = Dict(:immune => 0, :infection => 0)
    
    units_pattern = r"(\d+) units each with (\d+) hit points"
    modifiers_pattern = r"\((.+?)\)"
    attack_pattern = r"with an attack that does (\d+) (\w+) damage at initiative (\d+)"
    
    for line in lines
        if line == "Immune System:"
            current_army = :immune
            continue
        elseif line == "Infection:"
            current_army = :infection
            continue
        elseif isempty(line)
            continue
        end
        
        id_counter[current_army] += 1
        
        m1 = match(units_pattern, line)
        units = parse(Int, m1.captures[1])
        hit_points = parse(Int, m1.captures[2])
        
        weaknesses = String[]
        immunities = String[]
        m_mod = match(modifiers_pattern, line)
        if m_mod !== nothing
            modifiers = m_mod.captures[1]
            for modifier in split(modifiers, "; ")
                if startswith(modifier, "weak to ")
                    weak_types = split(modifier[9:end], ", ")
                    sizehint!(weaknesses, length(weak_types))
                    append!(weaknesses, weak_types)
                elseif startswith(modifier, "immune to ")
                    immune_types = split(modifier[11:end], ", ")
                    sizehint!(immunities, length(immune_types))
                    append!(immunities, immune_types)
                end
            end
        end
        
        m2 = match(attack_pattern, line)
        attack_damage = parse(Int, m2.captures[1])
        attack_type = m2.captures[2]
        initiative = parse(Int, m2.captures[3])
        
        push!(groups, Group(
            id_counter[current_army],
            current_army,
            units,
            hit_points,
            weaknesses,
            immunities,
            attack_damage,
            attack_type,
            initiative
        ))
    end
    
    return groups
end

@inline effective_power(group::Group) = group.units * group.attack_damage

function potential_damage(attacker::Group, defender::Group)
    if attacker.attack_type in defender.immunities
        return 0
    elseif attacker.attack_type in defender.weaknesses
        return 2 * attacker.units * attacker.attack_damage
    else
        return attacker.units * attacker.attack_damage
    end
end

function select_targets(attackers::Vector{Group}, defenders::Vector{Group})
    if isempty(attackers) || isempty(defenders)
        return Dict{Group, Union{Group, Nothing}}()
    end
    
    targets = Dict{Group, Union{Group, Nothing}}()
    sizehint!(targets, length(attackers))
    chosen_defenders = Set{Group}()
    sizehint!(chosen_defenders, min(length(attackers), length(defenders)))
    
    sort!(attackers, by=g -> (-effective_power(g), -g.initiative))
    
    dummy_group = Group(0, :none, 0, 0, String[], String[], 0, "", 0)
    
    for attacker in attackers
        best_target = nothing
        max_damage = 0
        best_power = 0
        best_initiative = 0
        
        for defender in defenders
            defender in chosen_defenders && continue
            
            damage = potential_damage(attacker, defender)
            
            damage == 0 && continue
            
            defender_power = effective_power(defender)
            
            if damage > max_damage || 
               (damage == max_damage && (
                   defender_power > best_power || 
                   (defender_power == best_power && defender.initiative > best_initiative)
               ))
                max_damage = damage
                best_target = defender
                best_power = defender_power
                best_initiative = defender.initiative
            end
        end
        
        if best_target !== nothing
            targets[attacker] = best_target
            push!(chosen_defenders, best_target)
        else
            targets[attacker] = nothing
        end
    end
    
    return targets
end

function attack!(attacker::Group, defender::Group)
    damage = potential_damage(attacker, defender)
    units_killed = min(defender.units, damage ÷ defender.hit_points)
    defender.units -= units_killed
    return units_killed
end

function combat!(groups::Vector{Group})
    immune_groups = filter(g -> g.army == :immune && g.units > 0, groups)
    infection_groups = filter(g -> g.army == :infection && g.units > 0, groups)
    
    if isempty(immune_groups) || isempty(infection_groups)
        return 0
    end
    
    immune_targets = select_targets(immune_groups, infection_groups)
    infection_targets = select_targets(infection_groups, immune_groups)
    
    all_targets = Dict{Group, Union{Group, Nothing}}()
    sizehint!(all_targets, length(immune_targets) + length(infection_targets))
    merge!(all_targets, immune_targets, infection_targets)
    
    attackers = [g for g in groups if g.units > 0 && get(all_targets, g, nothing) !== nothing]
    sort!(attackers, by=g -> -g.initiative)
    
    total_killed = 0
    for attacker in attackers
        attacker.units <= 0 && continue
        
        defender = all_targets[attacker]
        if defender !== nothing && defender.units > 0
            units_killed = attack!(attacker, defender)
            total_killed += units_killed
        end
    end
    
    filter!(g -> g.units > 0, groups)
    
    return total_killed
end

function battle(groups::Vector{Group})
    local_groups = deepcopy(groups)
    
    while true
        immune_units = 0
        infection_units = 0
        
        for g in local_groups
            if g.army == :immune
                immune_units += g.units
            else
                infection_units += g.units
            end
        end
        
        if immune_units == 0 || infection_units == 0
            break
        end
        
        units_killed = combat!(local_groups)
        
        if units_killed == 0
            return :stalemate, local_groups
        end
    end
    
    winner = any(g -> g.army == :immune, local_groups) ? :immune : :infection
    return winner, local_groups
end

function part1(groups::Vector{Group})
    _, final_groups = battle(groups)
    return sum(g.units for g in final_groups)
end

function part2(groups::Vector{Group})
    original_groups = deepcopy(groups)
    
    # Binary search for minimum boost needed
    min_boost = 0
    max_boost = 10000
    last_winning_units = 0
    
    while min_boost <= max_boost
        mid_boost = (min_boost + max_boost) ÷ 2
        test_groups = deepcopy(original_groups)
        
        for group in test_groups
            if group.army == :immune
                group.attack_damage += mid_boost
            end
        end
        
        result, final_groups = battle(test_groups)
        
        if result == :immune
            immune_units = sum(g.units for g in final_groups if g.army == :immune)
            last_winning_units = immune_units
            max_boost = mid_boost - 1
        else
            min_boost = mid_boost + 1
        end
    end
    
    return last_winning_units
end

function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
    groups = parse_input(input)
    
    p1 = part1(groups)
    p2 = part2(groups)
    
    return [p1, p2]
end

end # module