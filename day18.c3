module aoc2024::day18;

import std::io;
import std::time;
import std::collections;

fn void main(String[] args)
{
	@pool()
	{
		Clock c = clock::now();
		io::printfn("Part1 answer: %s - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %s - completed in %s", part2(args[1]), c.mark());
	};
}

fn int part1(String file){
	String data = (String) file::load_temp(file)!!;

	int[<2>] size = file.contains("example") ? {7, 7} : {71, 71};
	int[<2>] start = {0, 0};
	int[<2>] finish = file.contains("example") ? {6, 6} : {70, 70};

	HashMap{int[<2>], bool} maze;
	maze.tinit();

	foreach(i, byte : data.tsplit("\n")){
		if (i >= (file.contains("example") ? 12 : 1024)) break;
		maze.set({byte.tsplit(",")[0].to_int()!!, byte.tsplit(",")[1].to_int()!!}, true);
	}

	List{int[<2>]} open;
	open.tinit();
	HashSet{int[<2>]} closed;
	closed.tinit();
	HashMap{int[<2>], int} distance;

	open.push(start);
	distance.set(start, 0);

	while(!open.is_empty()){
		int min_distance = int.max;
		usz index;
		foreach(i, place : open){
			if ((distance.get(place) ?? int.max) < min_distance){
				min_distance = distance.get(place)!!;
				index = i;
			}
		}
		int[<2>] current = open.get(index);
		open.remove_at(index);
		closed.add(current);

		foreach(dir : (int[<2>][]) {{-1, 0}, {1, 0}, {0, 1}, {0, -1}}){
			int[<2>] next = current + dir;

			if (maze.has_key(next) || next.x < 0 || next.x == size.x || next.y < 0 || next.y == size.y) continue;

			if (next == finish) return min_distance + 1;

			if (closed.contains(next) || open.contains(next)) if (distance.get(next)!! <= min_distance + 1) continue;

			open.push(next);
			distance.set(next, min_distance + 1);
		}
	}
	return -1;
}

fn String part2(String file){
	String data = (String) file::load_temp(file)!!;

	// Todo: Find all possible paths and check when they get blocked when a new byte falls.

	int[<2>] size = file.contains("example") ? {7, 7} : {71, 71};
	int[<2>] start = {0, 0};
	int[<2>] finish = file.contains("example") ? {6, 6} : {70, 70};

	HashSet{int[<2>]} maze;
	maze.tinit();

	foreach(i, byte : data.tsplit("\n")){
		maze.add({byte.tsplit(",")[0].to_int()!!, byte.tsplit(",")[1].to_int()!!});
		if (i < (file.contains("example") ? 12 : 1024)) continue;
		if(!possible_maze(maze, size, start, finish)) return byte;
	}
	return "";
}

fn bool possible_maze(HashSet{int[<2>]} maze, int[<2>] size, int[<2>] start, int[<2>] finish){
	List{int[<2>]} open;
	open.tinit();
	HashSet{int[<2>]} closed;
	closed.tinit();

	open.push(start);

	while(!open.is_empty()){
		usz best_index;
		int smallest_distance = int.max;

		foreach(i, place : open){
			if ((finish.x - place.x) + (finish.y - place.y) < smallest_distance){
				smallest_distance = (finish.x - place.x) + (finish.y - place.y);
				best_index = i;
			}
		}
		int[<2>] current = open.get(best_index);
		open.remove_at(best_index);
		closed.add(current);

		foreach(dir : (int[<2>][]) {{-1, 0}, {1, 0}, {0, 1}, {0, -1}}){
			int[<2>] next = current + dir;

			if (maze.contains(next) || next.x < 0 || next.x == size.x || next.y < 0 || next.y == size.y) continue;

			if (next == finish) return true;

			if (closed.contains(next) || open.contains(next)) continue;

			open.push(next);
		}
	}
	return false;
}