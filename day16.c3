module aoc2024::day16;

import std::io;
import std::time;
import std::collections;
import std::hash;

fn void main(String[] args)
{
	@pool()
	{
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %s - completed in %s", part2(args[1]), c.mark());
	};
}

enum Dir : int(int[<2>] value){
	NORTH = {0, -1},
	EAST = {1, 0},
	SOUTH = {0, 1},
	WEST = {-1, 0},
}

struct Node1{
	int cost;
	Dir dir;
}

fn int part1(String file){
	String data = (String) file::load_temp(file)!!;

	int[<2>] start, end;

	HashSet{int[<2>]} walls;
	walls.tinit();

	foreach(int j, row : data.tsplit("\n")){
		foreach(int i, column : row){
			if (column == 'S') start = {i, j};
			if (column == 'E') end = {i, j};
			if (column == '#') walls.add({i, j});
		}
	}

	HashMap{int[<2>], Node1} nodes;
	nodes.tinit();
	List{int[<2>]} open;
	open.tinit();
	HashSet{int[<2>]} closed;
	closed.tinit();

	open.push(start);
	nodes.set(start, {0, EAST});

	while(!open.is_empty()){
		int min_cost = int.max;
		usz index;

		foreach(i, node : open){
			if((nodes.get(node).cost ?? int.max) < min_cost){
				min_cost = nodes.get(node)!!.cost;
				index = i;
			}
		}

		int[<2>] current_pos = open.get(index);
		Node1 current = nodes.get(current_pos)!!;
		closed.add(current_pos);
		open.remove_at(index);

		foreach(dir : Dir.values){
			int[<2>] next_pos = current_pos + dir.value;

			if(walls.contains(next_pos)) continue;

			Node1 next = {current.cost + (dir == current.dir ? 1 : 1001), dir};

			if(next_pos == end) return next.cost;

			if(closed.contains(next_pos) || open.contains(next_pos)) if(nodes.get(next_pos)!!.cost <= next.cost) continue;

			open.push(next_pos);
			nodes.set(next_pos, next);
		}
	}
	return -1;
}

struct Node2{
	int[<2>] pos;
	Dir dir;
	int cost;
	int[<2>][] parent;
}

fn bool List{Node2}.contains_heading(&self, Node2 other){
	foreach(node : self){
		if (node.pos == other.pos && node.dir == other.dir) return true;
	}
	return false;
}

fn Node2? List{Node2}.get_heading(&self, Node2 other){
	foreach(i, node : self){
		if (node.pos == other.pos && node.dir == other.dir) return node;
	}
	return NOT_FOUND~;
}

fn int part2(String file){
	String data = (String) file::load_temp(file)!!;

	// Part1 answer: 106512 - completed in 29ms733µs43ns
	// Part2 answer: 563 - completed in 14m39.236s

	// To Try: Recursion???

	int[<2>] start, end;

	int min_final_cost = int.max;

	HashSet{int[<2>]} walls;
	walls.tinit();

	foreach(int j, row : data.tsplit("\n")){
		foreach(int i, column : row){
			if (column == 'S') start = {i, j};
			if (column == 'E') end = {i, j};
			if (column == '#') walls.add({i, j});
		}
	}

	List{Node2} open;
	open.tinit();
	List{Node2} closed;
	closed.tinit();

	List{Node2} trace_back;
	trace_back.tinit();

	open.push({start, EAST, 0, {}});

	while(!open.is_empty()){
		int min_cost = int.max;
		usz index;

		foreach(i, node : open){
			if(node.cost < min_cost){
				min_cost = node.cost;
				index = i;
			}
		}

		Node2 current = open.get(index);
		closed.push(current);
		open.remove_at(index);

		foreach(dir : Dir.values){
			if ((current.dir.ordinal + 2) % 4 == dir.ordinal) continue;
			int[<2>] next_pos = current.pos + dir.value;

			if(walls.contains(next_pos)) continue;

			Node2 next = {next_pos, dir, current.cost + (dir == current.dir ? 1 : 1001), array::tconcat(current.parent, (int[<2>][]){current.pos})};

			if(next.cost > min_final_cost) continue;

			if(next_pos == end) {
				if(min_final_cost == int.max) min_final_cost = next.cost;
				if(next.cost <= min_final_cost) trace_back.push(next);
			}

			if(closed.contains_heading(next) || open.contains_heading(next)){
				if((open.get_heading(next).cost ?? int.max) < next.cost) continue;
				if((closed.get_heading(next).cost ?? int.max) < next.cost) continue;
			}

			open.push(next);
		}
		io::printf("\rOpen : %d, Closed : %d", open.len(), closed.len());
	}
	io::printf("\n");

	HashSet{int[<2>]} visited;

	visited.add(end);

	foreach(item : trace_back){
		visited.add_all(item.parent);
	}

	return (int) visited.len();
}