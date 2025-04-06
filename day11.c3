module aoc2024::day11;

import std::io;
import std::time;
import std::collections;
import std::math;

fn bool valid_arguments(String[] args){
    if (args.len == 1){
        io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
        return false;
    }
    return true;
}

fn void main(String[] args){
    //Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    if(!valid_arguments(args)) {
        io::printn(IoError.FILE_NOT_FOUND);
        return;
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

    List(<int128>) memory_eater;
    memory_eater.temp_init(2^15);

    foreach(value : data.tsplit(" ")){
        memory_eater.push(value.to_int()!!);
    }

    int goal = 25;

    for(int j = 0; j < goal; ++j){
        foreach(i, number : memory_eater){
            if (number == 0){
                memory_eater[i] = 1;
                continue;
            }

            if ((int) math::log10(number) % 2 != 0){
                String temp = string::new_format("%s", number);

                memory_eater[i] = temp[..temp.len/2 - 1].to_int()!!;
                memory_eater.push(temp[temp.len/2..].to_int()!!);
                continue;
            }
            memory_eater[i] *= 2024;
        }
    }
    return (int) memory_eater.len();
}

fn int128 part2(String file){
    String data = (String) file::load_new(file)!!;

    Map(<int128, int128>) bigmap = map::temp(<int128, int128>)(2^12);

    foreach(value : data.tsplit(" ")){
        bigmap.increment_value(value.to_int()!!);
    }

    int goal = 75;
    int128 result;
    String temp;

    for (usz i = 0; i < goal; ++i){
        int128[] keys = bigmap.temp_keys_list();
        int128[] values = bigmap.temp_values_list();
        
        for(usz j = 0; j < keys.len; ++j) bigmap.set(keys[j], 0);

        foreach(j, key : keys){
            if (values[j] == 0) continue;

            if (key == 0) {
                bigmap.increment_value(1, values[j]);
                continue;
            }

            if ((int) math::log10(key) % 2 != 0){
                temp = string::new_format("%s", key);

                bigmap.increment_value(temp[..temp.len/2 - 1].to_int()!!, values[j]);
                bigmap.increment_value(temp[temp.len/2..].to_int()!!, values[j]);
                continue;
            }
            bigmap.increment_value(key * 2024, values[j]);
        }
    }
    foreach(value : bigmap.temp_values_list()){
        result += value;
    }
    return result;
}

fn void Map(<int128, int128>).increment_value(self, int128 key, int128 value = 1){
    if (self.has_key(key)) {
        self.set(key, self.get(key)!! + value);
    } else {
        self.set(key, value);
    }
}
