module aoc2024::day22;

import std::io;
import std::time;
import std::collections;
import std::math;
import std::sort;

fn void main(String[] args){
	@pool()
	{
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

fn long part1(String file){
	String[] data = ((String) file::load_temp(file)).tsplit("\n")!!;

	long pruner = 16777216;

	long total;

	foreach(line : data){
		long buyer = line.to_int()!!;
		for(usz i = 0; i < 2000; ++i){
			buyer = ((buyer << 6) ^ buyer) & (pruner - 1);
			buyer = ((buyer >> 5) ^ buyer) & (pruner - 1);
			buyer = ((buyer << 11) ^ buyer) & (pruner - 1);
		}
		total += buyer;
	}
	return total;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)).tsplit("\n")!!;

	List{int[2001]} prices;
	prices.tinit(data.len);

	long pruner = 16777216;

	foreach(index, line : data){
		long buyer = line.to_int()!!;
		int[2001] result;
		result[0] = (int) buyer % 10;
		for(usz i = 1; i < 2001; ++i){
			buyer = ((buyer << 6) ^ buyer) & (pruner - 1);
			buyer = ((buyer >> 5) ^ buyer) & (pruner - 1);
			buyer = ((buyer << 11) ^ buyer) & (pruner - 1);
			result[i] = (int)buyer % 10;
		}
		prices.push(result);
	}

	List{int[2000]} diffs;
	diffs.tinit(prices.len());

	foreach(monkey : prices){
		int[2000] results;
		for (usz i = 1; i < monkey.len; ++i){
			results[i - 1] = monkey[i] - monkey[i - 1];
		}
		diffs.push(results);
	}

	HashMap{int[4], int} patterns;
	patterns.tinit();

	HashSet{int[4]} visited;
	visited.tinit();

	foreach(index, monkey : diffs){
		int[4] temp;
		for(usz i = 3; i < monkey.len; ++i){
			temp = monkey[i - 3 : 4];
			if(visited.contains(temp)) continue;
			if(!patterns.has_key(temp)) patterns.set(temp, 0);
			int score = patterns.get(temp)!!;
			patterns.set(temp, score + prices[index][i + 1]);
			visited.add(temp);
		}
		visited.clear();
	}

	int[] values = patterns.tvalues();

	sort::quicksort(values);

	return values[^1];
}