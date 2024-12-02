module aoc2024::day1;

import std::io;
import std::time;
import std::collections;
import std::sort;
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

    List(<int>) list1;
    List(<int>) list2;

    foreach (line : data.tsplit("\n"))
    {
        list1.push(line.tsplit("   ")[0].to_int()!!);
        list2.push(line.tsplit("   ")[1].to_int()!!);
    }

    sort::quicksort(list1);
    sort::quicksort(list2);

    int total_distance;

    for (usz i = 0; i < list1.len(); ++i)
    {
        total_distance += math::abs(list1[i] - list2[i]);
    }

    return total_distance;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    List(<int>) list1;
    List(<int>) list2;

    foreach (line : data.tsplit("\n"))
    {
        list1.push(line.tsplit("   ")[0].to_int()!!);
        list2.push(line.tsplit("   ")[1].to_int()!!);
    }

    int total_distance;
    int matches;

    for (usz i = 0; i < list1.len(); ++i)
    {
        for (usz j = 0, matches = 0; j < list2.len(); ++j)
        {
            if (list1[i] == list2[j]) matches++;
        }
        total_distance += list1[i] * matches;
    }

    return total_distance;

}