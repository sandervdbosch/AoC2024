module aoc2024::day19;

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

fn int part1(String file){
	String[] data = ((String) file::load_temp(file)).tsplit("\n\n")!!;

	String[] patterns = data[0].tsplit(", ");
	String[] towels = data[1].tsplit("\n");

	int count = 0;

	foreach(towel : towels){
		if (evaluate_towel(towel, patterns)) ++count;
	}

	return count;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)).tsplit("\n\n")!!;

	String[] patterns = data[0].tsplit(", ");
	String[] towels = data[1].tsplit("\n");

	HashMap{String, long} cache;
	cache.tinit();

	long count;

	foreach(towel : towels){
		count += evaluate_design(towel, patterns, &cache);
	}

	return count;
}

fn bool evaluate_towel(String towel, String[] patterns){
	if (towel == "") return true;
	foreach(pattern : patterns){
		if ((towel.index_of(pattern) ?? -1) == 0 && evaluate_towel(towel[pattern.len..], patterns)) return true;
	}
	return false;
}

fn long evaluate_design(String towel, String[] patterns, HashMap{String, long}* cache){
	if (towel == "") return 1;
	if (cache.has_key(towel)) return cache.get(towel)!!;
	long count = 0;
	foreach(pattern : patterns){
		if (towel.starts_with(pattern)) count += evaluate_design(towel[pattern.len..], patterns, cache);
	}
	if (!cache.has_key(towel)) cache.set(towel, count);
	return count;
}