module aoc2024::day25;

import std::io;
import std::time;
import std::collections;

fn void main(String[] args){
    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        // io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn void map(String[] pattern, List{char[5]}* locks, List{char[5]}* keys){
    switch(pattern[0][0]){
        case '#':
            char[5] lock;
            for(usz i = 1; i < pattern.len - 1; ++i){
                foreach(j, pin : pattern[i]) if (pin == '#') lock[j]++;
            }
            locks.push(lock);
        case '.':
            char[5] key;
            for(usz i = 5; i > 0; --i){
                foreach(j, pin : pattern[i]) if (pin == '#') key[j]++;
            }
            keys.push(key);
    }
}

fn bool fit(char[5] lock, char[5] key){
    for(usz i; i < lock.len; ++i){
        if (lock[i] + key[i] > 5) return false;
    }
    return true;
}

fn int part1(String file){
    String[] data = ((String) file::load_temp(file)).tsplit("\n\n")!!;

    List{char[5]} locks;
    locks.tinit();
    List{char[5]} keys;
    keys.tinit();

    foreach(pattern : data){
        map(pattern.tsplit("\n"), &locks, &keys);
    }

    int score;

    foreach(lock : locks){
        foreach(key : keys){
            if (fit(lock, key)) {
                score += 1;
            }
        }
    }
    return score;
}