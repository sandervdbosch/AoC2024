module aoc2024::day7;

import std::io;
import std::time;
import std::collections;
import std::math;

def EquationList = List(<Tuple(<long, int[]>)>);

fn void main(String[] args)
{
    //Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    // if (args.len == 1){
    //     io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
    //     return IoError.FILE_NOT_FOUND?;
    // }

    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn long part1(String file) {
    String data = (String) file::load_temp(file)!!;

    EquationList equations;
    equations.temp_init();
    List(<int>) values;
    values.temp_init();

    foreach(lines : data.tsplit("\n")){
        String[] line = lines.tsplit(": ");
        foreach(value : line[1].tsplit(" ")) values.push(value.to_int()!!);
        equations.push({line[0].to_long()!!, values.to_tarray()});
        values.clear();
    }

    long total;

    foreach(equation : equations){
        if(validate_equation(equation.first, 0, equation.second, false)) total += equation.first;
    }

    return total;
}

fn long part2(String file) {
    String data = (String) file::load_temp(file)!!;

    EquationList equations;
    equations.temp_init();
    List(<int>) values;
    values.temp_init();

    foreach(lines : data.tsplit("\n")){
        String[] line = lines.tsplit(": ");
        foreach(value : line[1].tsplit(" ")) values.push(value.to_int()!!);
        equations.push({line[0].to_long()!!, values.to_tarray()});
        values.clear();
    }

    long total;

    foreach(equation : equations){
        if(validate_equation(equation.first, equation.second[0], equation.second[1..], true)) total += equation.first;
    }

    return total;
}


fn bool validate_equation(long goal, long current, int[] list, bool part2){
    if (current > goal) return false;
    if (list.len == 0) return current == goal ? true : false;

    if (validate_equation(goal, current * list[0], list[1..], part2)) return true;
    if (validate_equation(goal, current + list[0], list[1..], part2)) return true;
    return part2 ? validate_equation(goal, concat_num(current, list[0]), list[1..], part2) : false;
}

fn long concat_num(long first, int second) @inline {
    return first * (long)math::pow(10, (int)(math::log10(second) + 1)) + second;
}
