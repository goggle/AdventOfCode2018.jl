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