module Day13

using AdventOfCode2018
using StaticArrays

mutable struct Cart
    pos::MVector{2,Int}
    dir::MVector{2,Int}
    # 0: left
    # 1: straight
    # 2: right
    next_turn::Int
end

function Base.isless(a::Cart, b::Cart)
    if a.pos[1] < b.pos[1]
        return true
    elseif a.pos[1] == b.pos[1]
        return a.pos[2] < b.pos[2]
    end
    return false
end

function add_carts(carts, tracks)
    t = copy(tracks)
    for cart ∈ carts
        s = ' '
        if cart.dir == SVector(1, 0)
            s = 'v'
        elseif cart.dir == SVector(-1, 0)
            s = '^'
        elseif cart.dir == SVector(0, 1)
            s = '>'
        else
            s = '<'
        end
        t[cart.pos...] = s 
    end
    return t
end

function day13(input::String = readInput(joinpath(@__DIR__, "..", "data", "day13.txt")))
    tracks, carts = parse_input(input)
    solve!(carts, tracks)
end

function parse_input(input)
    c = collect.(split(input, "\n"))[1:end-1]
    tracks = mapreduce(permutedims, vcat, c)

    carts = Vector{Cart}()
    nrows, ncols = size(tracks)
    for i = 1:nrows
        for j = 1:ncols
            if tracks[i, j] == '>'
                pos = MVector{2}(i, j)
                dir = MVector{2}(0, 1)
                push!(carts, Cart(pos, dir, 0))
                tracks[i, j] = '-'
            elseif tracks[i, j] == '<'
                pos = MVector{2}(i, j)
                dir = MVector{2}(0, -1)
                push!(carts, Cart(pos, dir, 0))
                tracks[i, j] = '-'
            elseif tracks[i, j] == 'v'
                pos = MVector{2}(i, j)
                dir = MVector{2}(1, 0)
                push!(carts, Cart(pos, dir, 0))
                tracks[i, j] = '|'
            elseif tracks[i, j] == '^'
                pos = MVector{2}(i, j)
                dir = MVector{2}(-1, 0)
                push!(carts, Cart(pos, dir, 0))
                tracks[i, j] = '|'
            end
        end
    end
    return tracks, carts
end

function turn_left!(cart::Cart)
    cart.dir = SMatrix{2,2}(0, 1, -1, 0) * cart.dir
end

function turn_right!(cart::Cart)
    cart.dir = SMatrix{2,2}(0, -1, 1, 0) * cart.dir
end

function solve!(carts::Vector{Cart}, tracks::Matrix{Char})
    first = (0, 0)
    while true
        sort!(carts)
        s = Set{Int}()
        push!(s, keys(carts)...)
        if length(s) == 1
            return [first, (carts[s...].pos[2] - 1, carts[s...].pos[1] - 1)]
        end
        for (i, cart) ∈ enumerate(carts)
            if i ∉ s
                continue
            end
            cart.pos += cart.dir
            for j ∈ s
                if j == i
                    continue
                end
                if cart.pos == carts[j].pos
                    if first == (0, 0)
                        first = (cart.pos[2] - 1, cart.pos[1] - 1)
                    end
                    pop!(s, i)
                    pop!(s, j)
                    if length(s) == 0
                        return [first, (0, 0)]
                    end
                end
            end
            if tracks[cart.pos...] == '/'
                if cart.dir == SVector(-1, 0) || cart.dir == SVector(1, 0)
                    turn_right!(cart)
                else
                    turn_left!(cart)
                end
            elseif tracks[cart.pos...] == '\\'
                if cart.dir == SVector(0, 1) || cart.dir == SVector(0, -1)
                    turn_right!(cart)
                else
                    turn_left!(cart)
                end
            elseif tracks[cart.pos...] == '+'
                if cart.next_turn == 0
                    turn_left!(cart)
                elseif cart.next_turn == 2
                    turn_right!(cart)
                end
                cart.next_turn = mod(cart.next_turn + 1, 3)
            end
        end
        carts = carts[collect(s)]
    end
end

end # module
