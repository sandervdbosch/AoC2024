module aoc2024::day5;

import std::io;
import std::time;
import std::collections;

def Instruction_hashmap = HashMap(<int, List(<int>)>);
def Pages = List(<List(<int>)>);

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

    String[] parts = data.tsplit("\n\n");
    String[] instructions = parts[0].tsplit("\n");

    Instruction_hashmap before, after;
    before.temp_init();
    after.temp_init();

    foreach (instruction : instructions){
        int first, second;
        first = instruction.tsplit("|")[0].to_int()!!;
        second = instruction.tsplit("|")[1].to_int()!!;
        if (!before.has_key(first)){
            List(<int>) list;
            list.temp_init();
            before.set(first, list);
        }
        if (!after.has_key(second)){
            List(<int>) list;
            list.temp_init();
            after.set(second, list);
        }
        before.get_ref(first)!!.push(second);
        after.get_ref(second)!!.push(first);
    }

    Pages prints;
    prints.temp_init();

    foreach(i, line : parts[1].tsplit("\n")){
        List(<int>) values;
        values.temp_init();
        while(try index = line.index_of_char(',')){
            values.push(line[..index - 1].to_int()!!);
            line = line[index + 1..];
        }
        values.push(line.to_int()!!);
        prints.push(values);
    }

    int count;

    foreach(line : prints){
        if (allowed(line, before, after)) count += line[line.len() / 2];
    }

    return count;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    String[] parts = data.tsplit("\n\n");
    String[] instructions = parts[0].tsplit("\n");

    Instruction_hashmap before, after;
    before.temp_init();
    after.temp_init();

    foreach (instruction : instructions){
        int first, second;
        first = instruction.tsplit("|")[0].to_int()!!;
        second = instruction.tsplit("|")[1].to_int()!!;
        if (!before.has_key(first)){
            List(<int>) list;
            list.temp_init();
            before.set(first, list);
        }
        if (!after.has_key(second)){
            List(<int>) list;
            list.temp_init();
            after.set(second, list);
        }
        before.get_ref(first)!!.push(second);
        after.get_ref(second)!!.push(first);
    }

    Pages prints;
    prints.temp_init();

    foreach(i, line : parts[1].tsplit("\n")){
        List(<int>) values;
        values.temp_init();
        while(try index = line.index_of_char(',')){
            values.push(line[..index - 1].to_int()!!);
            line = line[index + 1..];
        }
        values.push(line.to_int()!!);
        prints.push(values);
    }

    int count;

    foreach(line : prints){
        if (!allowed(line, before, after)) {
            io::printn(sort_line(line, before, after));
            count += sort_line(line, before, after)[line.len() / 2];
        }
    }

    return count;
}

fn int[] sort_line(List(<int>) pages, Instruction_hashmap before, Instruction_hashmap after){
    List(<int>) result;
    result.temp_init();
    result.add_all(&pages);
    foreach(i, page : result){
        if (before.has_key(page)){
            for (usz index = 0; index < result.to_tarray()[..i].len; ++index){
                int j = result.to_tarray()[..i][index];
                if (before.get(page)!!.contains(j)) {
                    pages.swap(i, index);
                    index = 0;
                }
            }
        }
        if (after.has_key(page)){
            for (usz index = 0; index < result.to_tarray()[i..].len; ++index){
                int j = result.to_tarray()[i..][index];
                if (after.get(page)!!.contains(j)) {
                    pages.swap(i, index);
                    index == 0;
                }
            }
        }
    }
    return result.to_tarray();
}

fn bool allowed(List(<int>) pages, Instruction_hashmap before, Instruction_hashmap after){
    foreach(i, page : pages){
        if (before.has_key(page)){
            foreach(j : pages.to_tarray()[..i]){
                if (before.get(page)!!.contains(j)) return false;
            }
        }
        if (after.has_key(page)){
            foreach(j : pages.to_tarray()[i..]){
                if (after.get(page)!!.contains(j)) return false;
            }
        }
    }

    return true;
}
