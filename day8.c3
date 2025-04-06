module aoc2024::day8;

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
    // if(!valid_arguments(args)) {
    //     io::printn(IoError.FILE_NOT_FOUND);
    //     return;
    // }

    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

def Antenna = Tuple(<char, List(<int[<2>]>)>);

fn int part1(String file = "day8_example.txt"){
    String[] data = ((String) file::load_new(file)).tsplit("\n")!!;

    List(<Antenna>) alphabet;
    alphabet.temp_init();

    int[<2>] size = {data[0].len, data.len};

    foreach(int j, line : data){
        foreach(int i, letter : line){
            if (letter == '.') continue;

            if (try k = compare(letter, alphabet)){
                alphabet[k].second.push({i, j});
                continue;
            }

            Antenna new;
            new.second.new_init();
            new.first = letter;
            new.second.push({i, j});

            alphabet.push(*@clone(new));
        }
    }

    List(<int[<2>]>) nodes;
    nodes.temp_init();

    foreach(entry : alphabet){
        for(usz i = 0; i < entry.second.len() - 1; ++i){
            for(usz j = i + 1; j < entry.second.len(); ++j){
                int[<2>] diff = entry.second[i] - entry.second[j];
                if (!nodes.contains(entry.second[i] + diff)) nodes.push(entry.second[i] + diff);
                if (!nodes.contains(entry.second[j] - diff)) nodes.push(entry.second[j] - diff);
            }
        }
    }

    for(usz i = 0; i < nodes.len(); ++i){
        if(nodes[i].x < 0 || nodes[i].x > size.x - 1 || nodes[i].y < 0 || nodes[i].y > size.y - 1){
            nodes.remove_at(i);
            --i;
        }
    }
    return (int) nodes.len();
}

fn int part2(String file){
    String[] data = ((String) file::load_new(file)).tsplit("\n")!!;

    List(<Antenna>) alphabet;
    alphabet.temp_init();

    int[<2>] size = {data[0].len, data.len};

    foreach(int j, line : data){
        foreach(int i, letter : line){
            if (letter == '.') continue;

            if (try k = compare(letter, alphabet)){
                alphabet[k].second.push({i, j});
                continue;
            }

            Antenna new;
            new.second.new_init();
            new.first = letter;
            new.second.push({i, j});

            alphabet.push(*@clone(new));
        }
    }

    List(<int[<2>]>) nodes;
    nodes.temp_init();

    foreach(entry : alphabet){
        for(usz i = 0; i < entry.second.len() - 1; ++i){
            for(usz j = i + 1; j < entry.second.len(); ++j){
                int[<2>] diff = entry.second[i] - entry.second[j];
                int[<2>] current = entry.second[i];

                do{
                    if (!nodes.contains(current)) nodes.push(current);
                    current += diff;
                }
                while(current.x >= 0 && current.x < size.x && current.y >= 0 && current.y < size.y);

                current = entry.second[j];

                do{
                    if (!nodes.contains(current)) nodes.push(current);
                    current -= diff;
                }
                while(current.x >= 0 && current.x < size.x && current.y >= 0 && current.y < size.y);
            }
        }
    }
    return (int) nodes.len();
}

fn usz! compare(char letter, List(<Antenna>) alphabet){
    foreach(i, entry : alphabet) if (entry.first == letter) return i;
    return IoError.FILE_NOT_FOUND?;
}