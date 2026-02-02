module aoc2024::day10;

import std::io;
import std::time;
import std::collections;

fn void main(String[] args){
	@pool()
	{
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

fn int trace_paths(HashMap{int[<2>], char}* map, int[<2>] pos, int value = 0, HashSet{int[<2>]}* values = null){

	if (values == null){
		HashSet{int[<2>]} set;
		set.tinit();
		values = &set;
	}

	if (value == 9) values.add(pos);

	foreach(int[<2>] dir : {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}){
		if (map.has_key(pos + dir) && (map.get(pos + dir)!! == value + 1)){
			trace_paths(map, pos + dir, value + 1, values);
		}
	}

	return (int) values.len();
}

fn int part1(String file){
	String[] data = ((String) file::load_temp(file)).tsplit("\n")!!;

	HashMap{int[<2>], char} map;
	map.tinit();

	int total = 0;

	foreach(int j, line : data){
		foreach(int i, value : line){
			map.set({i, j}, value - '0');
		}
	}

	foreach(int j, line : data){
		foreach(int i, value : line){
			if(value == '0') total += trace_paths(&map, {i, j});
		}
	}

	return total;
}

fn long trace_rating(HashMap{int[<2>], char}* map, int[<2>] pos, int value = 0, HashMap{int[<2>], int}* values = null){

	if (values == null){
		HashMap{int[<2>], int} finishes;
		finishes.tinit();
		values = &finishes;
	}

	if (value == 9){
		if (values.has_key(pos)){
			values.set(pos, values.get(pos)!! + 1);
		} else {
			values.set(pos, 1);
		}
	}

	foreach(int[<2>] dir : {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}){
		if (map.has_key(pos + dir) && (map.get(pos + dir)!! == value + 1)){
			trace_rating(map, pos + dir, value + 1, values);
		}
	}

	int result;
	int[] results = values.tvalues();

	foreach(thing : results){
		result += thing;
	}

	return result;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)).tsplit("\n")!!;

	HashMap{int[<2>], char} map;
	map.tinit();

	long total = 0;

	foreach(int j, line : data){
		foreach(int i, value : line){
			map.set({i, j}, value - '0');
		}
	}

	foreach(int j, line : data){
		foreach(int i, value : line){
			if(value == '0') total += trace_rating(&map, {i, j});
		}
	}

	return total;
}
