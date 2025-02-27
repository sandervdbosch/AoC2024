module aoc2024::day20;

import std::io;
import std::time;
import std::collections;
import std::math;

fn void main(String[] args)
{
    // Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    if (args.len == 1){
        io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
        return;
    }

    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %s - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

enum Direction : int (int[<2>] dir){
    NORTH = {0, -1},
    EAST = {1, 0},
    SOUTH = {0, 1},
    WEST = {-1, 0},
}

def VisitedList = List(<Tuple(<int[<2>], int>)>);

struct Node{
    int[<2>] pos;
    int time;
    VisitedList visited;
}

fn bool VisitedList.contains_pos(self, int[<2>] pos){
    foreach(entry : self){
        if (entry.first == pos) return true;
    }
    return false;
}

fn int VisitedList.get_pos(self, int[<2>] pos){
    foreach(int i, entry : self){
        if (entry.first == pos) return i;
    }
    return 0;
}

fn int part1(String file){
    String data = (String) file::load_temp(file)!!;

    int[<2>] start, end, size;

    String[] rows = data.tsplit("\n");
    size.x = rows[0].len;
    size.y = rows.len;

    foreach(int j, row : rows){
        int i = (int) row.index_of_char('S') ?? -1;
        if (i >= 0) start = {i, j};
        i = (int) row.index_of_char('E') ?? -1;
        if (i >= 0) end = {i, j};
    }

    List(<Node>) queue;
    queue.tinit();
    queue.push({start, 0, {}});

    Node current;
    while(!queue.is_empty()){
        current = queue.pop_first()!!;
        current.visited.push({current.pos, current.time});

        if (current.pos == end) break;

        foreach(dir : Direction.values){
            int[<2>] next_pos = current.pos + dir.dir;
            if (
                next_pos.x >= 0 && next_pos.x < size.x &&
                next_pos.y >= 0 && next_pos.y < size.y &&
                !current.visited.contains_pos(next_pos) &&
                rows[next_pos.y][next_pos.x] != '#'
            ){
                VisitedList new_list;
                new_list.init(allocator::heap(), current.visited.len() + 1);
                new_list.add_all(&current.visited);
                queue.push({next_pos, current.time + 1, new_list});
            }
        }
        current.visited.free();
    }

    int big_cheats;

    foreach(place : current.visited){
        foreach(dir : Direction.values){
            int[<2>] next_pos = place.first + dir.dir * 2;
            if(current.visited.get_pos(next_pos) - place.second >= 102) ++big_cheats;
        }
    }
    current.visited.free();
    return big_cheats;
}

fn int part2(String file){
    String data = (String) file::load_temp(file)!!;

    int[<2>] start, end, size;

    String[] rows = data.tsplit("\n");
    size.x = rows[0].len;
    size.y = rows.len;

    foreach(int j, row : rows){
        int i = (int) row.index_of_char('S') ?? -1;
        if (i >= 0) start = {i, j};
        i = (int) row.index_of_char('E') ?? -1;
        if (i >= 0) end = {i, j};
    }

    List(<Node>) queue;
    queue.tinit();
    queue.push({start, 0, {}});

    Node current;
    while(!queue.is_empty()){
        current = queue.pop_first()!!;
        current.visited.push({current.pos, current.time});

        if (current.pos == end) break;

        foreach(dir : Direction.values){
            int[<2>] next_pos = current.pos + dir.dir;
            if (
                next_pos.x >= 0 && next_pos.x < size.x &&
                next_pos.y >= 0 && next_pos.y < size.y &&
                !current.visited.contains_pos(next_pos) &&
                rows[next_pos.y][next_pos.x] != '#'
            ){
                VisitedList new_list;
                new_list.init(allocator::heap(), current.visited.len() + 1);
                new_list.add_all(&current.visited);
                queue.push({next_pos, current.time + 1, new_list});
            }
        }
        current.visited.free();
    }

    int big_cheats, distance;
    int threshold = 100;
    Tuple(<int[<2>], int>) place1, place2;

    for(usz i = threshold; i < current.visited.len(); ++i){
        for(usz j = 0; j < i - threshold; ++j){
            place1 = current.visited[i];
            place2 = current.visited[j];
            distance = math::abs(place1.first.x - place2.first.x) + math::abs(place1.first.y - place2.first.y);
            if(distance <= 20 && i - j - distance >= threshold) ++big_cheats;
        }
    }

    current.visited.free();
    return big_cheats;
}