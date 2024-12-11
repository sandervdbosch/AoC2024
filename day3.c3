module aoc2024::day3;

import std::io;
import std::time;
import std::collections;

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

    String[] step1, step2;
    step1 = data.tsplit("mul(")[1..];
    int[2] computation;
    List(<int[2]>) computations;

    for (usz i = 0; i < step1.len; ++i)
    {
        step2 = step1[i].tsplit(",");
        if (step2.len == 1) continue;
        if (!is_all_digit(step2[0])) continue;

        computation[0] = step2[0].to_int()!!;

        step2 = step2[1].tsplit(")");
        if (step2.len == 1) continue;
        if (!is_all_digit(step2[0])) continue;

        computation[1] = step2[0].to_int()!!;

        computations.push(computation);
    }

    int result;

    foreach (mult : computations){
        result += mult[0] * mult[1];
    }
    return result;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    bool on = true;

    String[] step1, step2;
    step1 = data.tsplit("mul(")[1..];
    int[2] computation;
    List(<int[2]>) computations;

    for (usz i = 0; i < step1.len; ++i)
    {
        if (on) {
            step2 = step1[i].tsplit(",");
            if (step2.len == 1) continue;
            if (!is_all_digit(step2[0])) continue;

            computation[0] = step2[0].to_int()!!;

            step2 = step2[1].tsplit(")");
            if (step2.len == 1) continue;
            if (!is_all_digit(step2[0])) continue;
            computation[1] = step2[0].to_int()!!;

            computations.push(computation);
        }
        if (on && step1[i].contains("don't()")) on = false;
        if (!on && step1[i].contains("do()")) on = true;
    }

    int result;

    foreach (mult : computations){
        result += mult[0] * mult[1];
    }
    return result;
}

fn bool is_all_digit(String in){
    foreach (letter : in)
    {
        if (letter.is_digit() == false) return false;
    }
    return true;
}
