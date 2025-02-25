module aoc2024::day17;

import std::io;
import std::time;
import std::collections;
import std::math;
import libc;



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
        io::printfn("Part1 answer: %s - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn String part1(String file){
    String data = (String) file::load_temp(file)!!;

    long a, b, c;

    String registers = data.tsplit("\n\n")[0];
    libc::sscanf(registers, "Register A: %d\nRegister B: %d\nRegister C: %d", &a, &b, &c);

    String[] instructions = data.tsplit("Program: ")[1].tsplit(",");

    return run_program(a, b, c, instructions);
}

fn long part2(String file){
    String data = (String) file::load_temp(file)!!;

    String code = data.tsplit("Program: ")[1];

    String[] instructions = code.tsplit(",");
    // usz instruction_length = instructions.len;

    long a;
    foreach_r(i, item : instructions){
        a <<= 3;
        while(run_program(a, 0, 0, instructions) != code[i * 2..]){
            ++a;
        }
    }
    return a;
}

fn long get_combo(long value, long a, long b, long c) @inline{
    if(value == 4) return a;
    if(value == 5) return b;
    if(value == 6) return c;
    return value;
}

fn String run_program(long a, long b, long c, String[] code){
    usz i;
    usz instruction_length = code.len;

    short instruction, value;

    DString result;
    result.temp_init();

    while(i < instruction_length - 1){
        instruction = code[i++].to_short()!!;
        value = code[i++].to_short()!!;

        switch(instruction){
            case 0:
                a >>= get_combo(value, a, b, c);
            case 1:
                b ^= value;
            case 2:
                b = get_combo(value, a, b, c) % 8;
            case 3:
                if (a == 0) break;
                i = value;
            case 4:
                b ^= c;
            case 5:
                result.append_char((char)(get_combo(value, a, b, c) % 8) + '0');
                result.append_char(',');
            case 6:
                b = a >> get_combo(value, a, b, c);
            case 7:
                c = a >> get_combo(value, a, b, c);
        }
    }
    return result.str_view()[..^2];
}