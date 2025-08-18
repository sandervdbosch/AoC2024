module aoc2024::day23;

import std::io;
import std::time;
import std::collections;
import std::sort;

fn void main(String[] args){
    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %s - completed in %s", part2(args[1]), c.mark());
    };
}

alias ComputerHash = HashMap{String, HashSet{String}};

fn int part1(String file){
    String[] data = ((String) file::load_temp(file)).tsplit("\n")!!;

    ComputerHash computers;
    computers.tinit();

    List{String[3]} triplets;
    triplets.tinit();

    foreach(line : data){
        String first = line[:2];
        String second = line[3..];

        HashSet{String}* connections;

        connections = !computers.has_key(first) ? (HashSet{String}){}.tinit(): computers.get_ref(first)!!;
        if(!connections.contains(second)) {
            connections.add(second);
            computers.set(first, *connections);
        }

        connections = !computers.has_key(second) ? (HashSet{String}){}.tinit(): computers.get_ref(second)!!;
        if(!connections.contains(first)) {
            connections.add(first);
            computers.set(second, *connections);
        }

        HashSet{String} a = computers.get(first)!!;
        HashSet{String} b = computers.get(second)!!;

        String[] c = a.tintersection(&b).tvalues();

        foreach(third : c){
            if(first.starts_with("t") || second.starts_with("t") || third.starts_with("t")) triplets.push((String[3]){first, second, third});
        }
    }

    return (int)triplets.len();
}

fn bool test_contains(HashSet{String} set, List{String} list){
    foreach(item : list){
        if (!set.contains(item)) return false;
    }
    return true;
}

fn String part2(String file){
    String[] data = ((String) file::load_temp(file)).tsplit("\n")!!;

    ComputerHash computers;
    computers.tinit();

    List{String[3]} triplets;
    triplets.tinit();

    usz best;
    String[] best_list;

    foreach(line : data){
        String first = line[:2];
        String second = line[3..];

        HashSet{String}* connections;

        connections = !computers.has_key(first) ? (HashSet{String}){}.tinit(): computers.get_ref(first)!!;
        if(!connections.contains(second)) {
            connections.add(second);
            computers.set(first, *connections);
        }

        connections = !computers.has_key(second) ? (HashSet{String}){}.tinit(): computers.get_ref(second)!!;
        if(!connections.contains(first)) {
            connections.add(first);
            computers.set(second, *connections);
        }

        List{String} temp_list;
        temp_list.tinit();

        temp_list.push(first);
        temp_list.push(second);

        HashSet{String} a = computers.get(first)!!;
        HashSet{String} b = computers.get(second)!!;

        String[] c = a.tintersection(&b).tvalues();

        foreach(other : c){
            HashSet{String} otherset = computers.get(other)!!;
            if (test_contains(otherset, temp_list)){
                temp_list.push(other);
            }
        }

        if(temp_list.len() > best) {
            best = temp_list.len();
            best_list = temp_list.to_tarray();
        }
        temp_list.clear();
    }

    sort::quicksort(best_list);

    String result;

    foreach(item : best_list){
        result = result.tconcat(item);
        result = result.tconcat(",");
    }

    return result[.. ^2];
}

fn bool String.less(self, String other)
{
	usz i;
	for(; i < self.len && i < other.len && self[i] == other[i]; ++i);
	if (i == self.len || i == other.len) return self.len < other.len;
	return self[i] < other[i];
}