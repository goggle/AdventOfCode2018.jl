using AdventOfCode2018
using Test

@testset "Day 1" begin
    @test AdventOfCode2018.Day01.day01() == [445, 219]
end

@testset "Day 2" begin
    @test AdventOfCode2018.Day02.day02() == [7776, "wlkigsqyfecjqqmnxaktdrhbz"]
end

@testset "Day 3" begin
    @test AdventOfCode2018.Day03.day03() == [109716, 124]
end

@testset "Day 4" begin
    sample = "[1518-11-01 00:00] Guard #10 begins shift\n" *
             "[1518-11-01 00:05] falls asleep\n" *
             "[1518-11-01 00:25] wakes up\n" *
             "[1518-11-01 00:30] falls asleep\n" *
             "[1518-11-01 00:55] wakes up\n" *
             "[1518-11-01 23:58] Guard #99 begins shift\n" *
             "[1518-11-02 00:40] falls asleep\n" *
             "[1518-11-02 00:50] wakes up\n" *
             "[1518-11-03 00:05] Guard #10 begins shift\n" *
             "[1518-11-03 00:24] falls asleep\n" *
             "[1518-11-03 00:29] wakes up\n" *
             "[1518-11-04 00:02] Guard #99 begins shift\n" *
             "[1518-11-04 00:36] falls asleep\n" *
             "[1518-11-04 00:46] wakes up\n" *
             "[1518-11-05 00:03] Guard #99 begins shift\n" *
             "[1518-11-05 00:45] falls asleep\n" *
             "[1518-11-05 00:55] wakes up\n"
    @test AdventOfCode2018.Day04.day04(sample) == [240, 4455]
    @test AdventOfCode2018.Day04.day04() == [84834, 53427]
end

@testset "Day 5" begin
    @test AdventOfCode2018.Day05.day05() == [10708, 5330]
end

@testset "Day 6" begin
    @test AdventOfCode2018.Day06.day06() == [4589, 40252]
end

@testset "Day 7" begin
    @test AdventOfCode2018.Day07.day07() == ["LFMNJRTQVZCHIABKPXYEUGWDSO", 1180]
end

@testset "Day 8" begin
    sample = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    @test AdventOfCode2018.Day08.day08(sample) == [138, 66]
    @test AdventOfCode2018.Day08.day08() == [36566, 30548]
end

@testset "Day 9" begin
    @test AdventOfCode2018.Day09.day09() == [375465, 3037741441]
end

@testset "Day 10" begin
    expected = "█    █  █████   █    █  ██████  ██████  █    █   ████      ███\n" *
               "██   █  █    █  █    █  █            █  █    █  █    █      █ \n" *
               "██   █  █    █  █    █  █            █  █    █  █           █ \n" *
               "█ █  █  █    █  █    █  █           █   █    █  █           █ \n" *
               "█ █  █  █████   ██████  █████      █    ██████  █           █ \n" *
               "█  █ █  █    █  █    █  █         █     █    █  █           █ \n" *
               "█  █ █  █    █  █    █  █        █      █    █  █           █ \n" *
               "█   ██  █    █  █    █  █       █       █    █  █       █   █ \n" *
               "█   ██  █    █  █    █  █       █       █    █  █    █  █   █ \n" *
               "█    █  █████   █    █  ██████  ██████  █    █   ████    ███  \n"
    @test AdventOfCode2018.Day10.day10() == [expected, 10558]
end

@testset "Day 11" begin
    @test AdventOfCode2018.Day11.day11() == [(21, 76), (234, 108, 16)]
end

@testset "Day 12" begin
    @test AdventOfCode2018.Day12.day12() == [3915, 4900000001793]
end

@testset "Day 13" begin
    sample = "/->-\\        \n" *
             "|   |  /----\\\n" *
             "| /-+--+-\\  |\n" *
             "| | |  | v  |\n" *
             "\\-+-/  \\-+--/\n" *
             "  \\------/   \n"
    sample2 = "/>-<\\  \n" *
              "|   |  \n" *
              "| /<+-\\\n" *
              "| | | v\n" *
              "\\>+</ |\n" *
              "  |   ^\n" *
              "  \\<->/\n"
    @test AdventOfCode2018.Day13.day13(sample) == [(7, 3), (0, 0)]
    @test AdventOfCode2018.Day13.day13(sample2) == [(2, 0), (6, 4)]
    @test AdventOfCode2018.Day13.day13() == [(26, 92), (86, 18)]
end

@testset "Day 14" begin
    @test AdventOfCode2018.Day14.day14() == [9315164154, 20231866]
end

@testset "Day 15" begin
    sample1 = "#######\n" *   
              "#.G...#\n" *
              "#...EG#\n" *
              "#.#.#G#\n" *
              "#..G#E#\n" *
              "#.....#\n" *   
              "#######\n"
    @test AdventOfCode2018.Day15.day15(sample1) == [27730, 4988]

    sample2 = "#######\n" *
              "#G..#E#\n" *
              "#E#E.E#\n" *
              "#G.##.#\n" *
              "#...#E#\n" *
              "#...E.#\n" *
              "#######\n"
    @test AdventOfCode2018.Day15.day15(sample2) == [36334, 29064]

    sample3 = "#######\n" *
              "#E..EG#\n" *
              "#.#G.E#\n" *
              "#E.##E#\n" *
              "#G..#.#\n" *
              "#..E#.#\n" *
              "#######\n"
    @test AdventOfCode2018.Day15.day15(sample3) == [39514, 31284]

    sample4 = "#######\n" *
              "#E.G#.#\n" *
              "#.#G..#\n" *
              "#G.#.G#\n" *
              "#G..#.#\n" *
              "#...E.#\n" *
              "#######\n"
    @test AdventOfCode2018.Day15.day15(sample4) == [27755, 3478]

    sample5 = "#######\n" *
              "#.E...#\n" *
              "#.#..G#\n" *
              "#.###.#\n" *
              "#E#G#G#\n" *
              "#...#G#\n" *
              "#######\n"
    @test AdventOfCode2018.Day15.day15(sample5) == [28944, 6474]

    sample6 = "#########\n" *
              "#G......#\n" *
              "#.E.#...#\n" *
              "#..##..G#\n" *
              "#...##..#\n" *
              "#...#...#\n" *
              "#.G...G.#\n" *
              "#.....G.#\n" *
              "#########\n"
    @test AdventOfCode2018.Day15.day15(sample6) == [18740, 1140]

    @test AdventOfCode2018.Day15.day15() == [239010, 62468]
end

@testset "Day 16" begin
    @test AdventOfCode2018.Day16.day16() == [531, 649]
end

@testset "Day 17" begin
    sample = "x=495, y=2..7\n" *
             "y=7, x=495..501\n" *
             "x=501, y=3..7\n" *
             "x=498, y=2..4\n" *
             "x=506, y=1..2\n" *
             "x=498, y=10..13\n" *
             "x=504, y=10..13\n" *
             "y=13, x=498..504\n"
    @test AdventOfCode2018.Day17.day17(sample) == [57, 29]
    @test AdventOfCode2018.Day17.day17() == [31949, 26384]
end

@testset "Day 18" begin
    sample = ".#.#...|#.\n" *
             ".....#|##|\n" *
             ".|..|...#.\n" *
             "..|#.....#\n" *
             "#.#|||#|#|\n" *
             "...#.||...\n" *
             ".|....|...\n" *
             "||...#|.#|\n" *
             "|.||||..|.\n" *
             "...#.|..|.\n"
    @test AdventOfCode2018.Day18.day18(sample) == [1147, 0]
    @test AdventOfCode2018.Day18.day18() == [663502, 201341]
end

@testset "Day 19" begin
    @test AdventOfCode2018.Day19.day19() == [1872, 18992592]
end

@testset "Day 21" begin
    @test AdventOfCode2018.Day21.day21() == [11050031, 11341721]
end

@testset "Day 20" begin
    @test AdventOfCode2018.Day20.day20("^WNE\$") == [3, 0]
    @test AdventOfCode2018.Day20.day20("^ENWWW(NEEE|SSE(EE|N))\$") == [10, 0]
    @test AdventOfCode2018.Day20.day20("^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN\$") == [18, 0]
    @test AdventOfCode2018.Day20.day20("^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))\$") == [23, 0]
    @test AdventOfCode2018.Day20.day20("^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))\$") == [31, 0]
    @test AdventOfCode2018.Day20.day20() == [3971, 8578]
end

@testset "Day 22" begin
    sample = "depth: 510\n" *
             "target: 10,10\n"
    @test AdventOfCode2018.Day22.day22(sample) == [114, 45]
    @test AdventOfCode2018.Day22.day22() == [8575, 999]
end

@testset "Day 23" begin
    @test AdventOfCode2018.Day23.day23() == [383, 100474026]
end

@testset "Day 25" begin
    sample1 = "0,0,0,0\n" *
              "3,0,0,0\n" *
              "0,3,0,0\n" *
              "0,0,3,0\n" *
              "0,0,0,3\n" *
              "0,0,0,6\n" *
              "9,0,0,0\n" *
              "12,0,0,0\n"
    @test AdventOfCode2018.Day25.day25(sample1) == 2

    sample2 = "-1,2,2,0\n" *
              "0,0,2,-2\n" *
              "0,0,0,-2\n" *
              "-1,2,0,0\n" *
              "-2,-2,-2,2\n" *
              "3,0,2,-1\n" *
              "-1,3,2,2\n" *
              "-1,0,-1,0\n" *
              "0,2,1,-2\n" *
              "3,0,0,0\n"
    @test AdventOfCode2018.Day25.day25(sample2) == 4

    sample3 = "1,-1,0,1\n" *
              "2,0,-1,0\n" *
              "3,2,-1,0\n" *
              "0,0,3,1\n" *
              "0,0,-1,-1\n" *
              "2,3,-2,0\n" *
              "-2,2,0,0\n" *
              "2,-2,0,-1\n" *
              "1,-1,0,-1\n" *
              "3,2,0,2\n"
    @test AdventOfCode2018.Day25.day25(sample3) == 3
    
    sample4 = "1,-1,-1,-2\n" *
              "-2,-2,0,1\n" *
              "0,2,1,3\n" *
              "-2,3,-2,1\n" *
              "0,2,3,-2\n" *
              "-1,-1,1,-2\n" *
              "0,-2,-1,0\n" *
              "-2,2,3,-1\n" *
              "1,2,2,0\n" *
              "-1,-2,0,-2\n"
    @test AdventOfCode2018.Day25.day25(sample4) == 8

    @test AdventOfCode2018.Day25.day25() == 420
end