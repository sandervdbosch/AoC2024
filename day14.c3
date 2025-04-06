module aoc2024::day14;

import std::io;
import std::time;
import std::collections;
import libc;

fn void main(String[] args){
    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn long part1(String file){
    String data = (String) file::load_new(file)!!;

    List(<int[<2>][2]>) input;
    input.temp_init();

    foreach(line : data.tsplit("\n")){
        int[<2>][2] collector;
        libc::sscanf(line, "p=%d,%d v=%d,%d", &collector[0].x, &collector[0].y, &collector[1].x, &collector[1].y);
        input.push(collector);
    }

    int[<2>] field_size = file.contains("example") ? {11, 7} : {101, 103};

    foreach(j, rule : input){
        input[j][0] += rule[1] * 100;
        input[j][0].x = input[j][0].x % field_size.x;
        input[j][0].y = input[j][0].y % field_size.y;
        if (input[j][0].x < 0) input[j][0].x += field_size.x;
        if (input[j][0].y < 0) input[j][0].y += field_size.y;
    }

    long[4] quadrants;

    foreach(rule : input){

        if (rule[0].x < field_size.x / 2){
            if (rule[0].y < field_size.y / 2) ++quadrants[0];
            if (rule[0].y > field_size.y / 2) ++quadrants[3];
        }
        if (rule[0].x > field_size.x / 2){
            if (rule[0].y < field_size.y / 2) ++quadrants[1];
            if (rule[0].y > field_size.y / 2) ++quadrants[2];
        }
    }
    return (long)(quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]);
}

fn long part2(String file){
    String data = (String) file::load_new(file)!!;

    List(<int[<2>][2]>) input;
    input.temp_init();

    foreach(line : data.tsplit("\n")){
        int[<2>][2] collector;
        libc::sscanf(line, "p=%d,%d v=%d,%d", &collector[0].x, &collector[0].y, &collector[1].x, &collector[1].y);
        input.push(collector);
    }

    int[<2>] field_size = file.contains("example") ? {11, 7} : {101, 103};

    bool skip;

    List(<int[<2>]>) positions;
    positions.temp_init();

    for(usz i = 1;; ++i){
        skip = false;
        foreach(j, rule : input){
            input[j][0] += rule[1];
            input[j][0].x = input[j][0].x % field_size.x;
            input[j][0].y = input[j][0].y % field_size.y;
            if (input[j][0].x < 0) input[j][0].x += field_size.x;
            if (input[j][0].y < 0) input[j][0].y += field_size.y;
            if (!skip && positions.contains(input[j][0])) skip = true;
            if (!skip) positions.push(input[j][0]);
        }
        if (!skip) return i;
        positions.clear();
    }
}
