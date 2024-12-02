module aoc2024::day2;

import std::io;
import std::time;
import std::collections;
import std::math;

fn void! main(String[] args){
    //Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    if (args.len == 1){
        io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
        return IoError.FILE_NOT_FOUND?;
    }

    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn int part1(String file){
    String data = (String) file::load_new(file)!!;

    int diff;
    int sign = 0;
    bool safe;
    int goal = 0;

    foreach (row : data.tsplit("\n"))
    {
        List(<int>) levels;
        for(usz i = 0; i < row.tsplit(" ").len; ++i){
            levels.push(row.tsplit(" ")[i].to_int()!!);
        }
        sign = math::sign(levels[1] - levels[0]);
        safe = true;

        for(usz i = 1; i < levels.len(); ++i){
            diff = levels[i] - levels[i-1];
            if (diff == 0) safe = false;
            if (math::sign(diff) != sign) safe = false;
            if (sign > 0 && diff > 3) safe = false;
            if (sign < 0 && diff < -3) safe = false;
        }
        if (safe) ++goal;
    }
    return goal;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    int goal = 0;
    foreach (row : data.tsplit("\n"))
    {
        List(<int>) levels;
        for(usz i = 0; i < row.tsplit(" ").len; ++i){
            levels.push(row.tsplit(" ")[i].to_int()!!);
        }
        if (part2_levels_check(levels, 0)) {++goal;}
    }
    return goal;
}

fn bool part2_levels_check(List(<int>) levels, int unsafe){
    int sign = math::sign(levels[1] - levels[0]);
    for(isz i = 1; i < levels.len(); ++i){
        if (unsafe >= 2) return false;
        int diff = levels[i] - levels[i-1];
        if (diff == 0) {
            ++unsafe;
            List(<int>) first;
            List(<int>) second;
            first.add_all(&levels);
            second.add_all(&levels);
            first.remove_at(i - 1);
            second.remove_at(i);
            return (part2_levels_check(first, unsafe) || part2_levels_check(second, unsafe));
        }
        if (sign > 0 && diff > 3) {
            ++unsafe;
            List(<int>) first;
            List(<int>) second;
            first.add_all(&levels);
            second.add_all(&levels);
            first.remove_at(i - 1);
            second.remove_at(i);
            return (part2_levels_check(first, unsafe) || part2_levels_check(second, unsafe));
        }
        if (sign < 0 && diff < -3) {
            ++unsafe;
            List(<int>) first;
            List(<int>) second;
            first.add_all(&levels);
            second.add_all(&levels);
            first.remove_at(i - 1);
            second.remove_at(i);
            return (part2_levels_check(first, unsafe) || part2_levels_check(second, unsafe));
        }
        if (math::sign(diff) != sign) {
            ++unsafe;
            List(<int>) first;
            List(<int>) second;
            List(<int>) third;
            first.add_all(&levels);
            second.add_all(&levels);
            third.add_all(&levels);
            first.remove_first();
            second.remove_at(i - 1);
            third.remove_at(i);
            return (part2_levels_check(first, unsafe) || part2_levels_check(second, unsafe) || part2_levels_check(third, unsafe));
        }
    }
    return true;
}