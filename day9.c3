module aoc2024::day9;

import std::io;
import std::time;
import std::collections;
import std::math;

fn void! main(String[] args)
{
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

fn long part1(String file){
    String data = (String) file::load_temp(file)!!;

    List(<int>) output;
    output.temp_init();
    int current_number = 0;

    foreach(i, letter : data){
        int digit = (int)(letter - '0');
        if (i % 2 == 0){
            for(usz j = 0; j < digit; ++j) output.push(current_number);
            ++current_number;
        } else {
            for(usz j = 0; j < digit; ++j) output.push(-1);
        }
    }
    long result;

    for(usz i = 0; i < output.len(); ++i){
        if (output[i] == -1){
            output.swap(i, output.len() - 1);
            while (output.last()!! == -1) output.remove_last();
        }
        result += i * output[i];
    }
    return result;
}

fn long part2(String file){
    String data = (String) file::load_temp(file)!!;

    List(<int[<3>]>) values, spaces;
    values.temp_init();
    spaces.temp_init();
    int current_number, current_pos;

    foreach(int i, letter : data){
        int length = (int)(letter - '0');
        if (i % 2 == 0){
            values.push({current_number, current_pos, length});
            ++current_number;
            current_pos += length;
        } else {
            spaces.push({0, current_pos, length});
            current_pos += length;
        }
    }
    long result;

    foreach_r(i, entry : values){
        foreach(j, space : spaces){
            if (space.y > entry.y) continue;

            if (entry.z == space.z){
                values[i].y = space.y;
                spaces[j].y = entry.y;
                break;
            }

            if (entry.z < space.z){
                values[i].y = space.y;
                spaces[j].y += entry.z;
                spaces[j].z -= entry.z;
                spaces.insert_at(j, {0, entry.y, entry.z});
                break;
            }
        }
    }

    foreach(entry : values){
        for (usz i = 0; i < entry.z; ++i){
            result += entry.x * (entry.y + i);
        }
    }

    return result;
}