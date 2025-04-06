module aoc2024::day6;

import std::io;
import std::time;
import std::collections;
import std::core::array::slice;

def Place = Tuple(<Direction, int[<2>]>);

fn void main(String[] args){
    //Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    // if (args.len == 1){
    //     io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
    //     return IoError.FILE_NOT_FOUND?;
    // }

    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

enum Direction : (int[<2>] dir){
    NORTH = {0, -1},
    EAST = {1, 0},
    SOUTH = {0, 1},
    WEST = {-1, 0},
}

fn int part1(String file){
    String maze = (String) file::load_new(file)!!;

    List(<String>) rows;
    rows.temp_init_with_array(maze.tsplit("\n"));

    int[<2>] pos = find_start(rows.array_view());

    Direction direction = NORTH;

    List(<int[<2>]>) visited;
    visited.temp_init(rows.len() * rows[0].len);

    while(pos.x >= 0 && pos.x < rows[0].len && pos.y >= 0 && pos.y < rows.len()){
        if(!visited.contains(pos)) visited.push(pos);

        if(pos.x + direction.dir.x >= 0 && pos.x + direction.dir.x < rows[0].len && pos.y + direction.dir.y>= 0 && pos.y + direction.dir.y < rows.len()){
            if(rows[(usz)(pos.y + direction.dir.y)][(usz)(pos.x + direction.dir.x)] == '#') direction = Direction.from_ordinal((direction.ordinal + 1) % 4);
        }

        pos += direction.dir;
    }

    return (int) visited.len();
}

fn int part2(String file){
    String maze = (String) file::load_new(file)!!;

    List(<String>) rows, columns;
    rows.temp_init_with_array(maze.tsplit("\n"));
    columns.temp_init(rows[0].len);

    DString collector;
    collector.temp_init();

    int[<2>] start, pos;

    for (usz i = 0; i < rows[0].len; ++i){
        foreach (j, row : rows){
            collector.append(row[i]);
            if (row[i] == '^') start = {(int) i, (int) j};
        }
        columns.push(collector.tcopy_str());
        collector.clear();
    }

    List(<Place>) visited;
    visited.temp_init();

    int count;

    Direction direction;

    foreach(i, row : rows){
        foreach(j, cell : row){
            io::printfn("[%d, %d]", j, i);
            if (cell == '#' || cell == '^') continue;
            rows[i][j] = '#';
            columns[j][i] = '#';
            pos = start;
            direction = NORTH;
            visited.clear();
            while(pos.x >= 0 && pos.x < rows[0].len && pos.y >= 0 && pos.y < rows.len()){
                if(visited.contains({direction, pos})) {
                    ++count;
                    break;
                }
                if(!visited.contains({direction, pos})) visited.push({direction, pos});

                if(direction == NORTH){
                    int steps = (int) columns[pos.x][..pos.y].rindex_of("#") ?? -1;
                    if(steps == -1) break;
                    pos += direction.dir * (pos.y - steps - 1);
                }
                if(direction == EAST){
                    int steps = (int) rows[pos.y][pos.x..].index_of("#") ?? -1;
                    if(steps == -1) break;
                    pos += direction.dir * (steps - 1);
                }
                if(direction == SOUTH){
                    int steps = (int) columns[pos.x][pos.y..].index_of("#") ?? -1;
                    if(steps == -1) break;
                    pos += direction.dir * (steps - 1);
                }
                if(direction == WEST){
                    int steps = (int) rows[pos.y][..pos.x].rindex_of("#") ?? -1;
                    if(steps == -1) break;
                    pos += direction.dir * (pos.x - steps - 1);
                }
                direction = Direction.from_ordinal((direction.ordinal + 1) % 4);
            }
            rows[i][j] = '.';
            columns[j][i] = '.';
        }
    }

    return count;
}

fn bool List(<Place>).contains(&self, Place value){
    foreach (i, v : self)
	{
		if (v.first == value.first && v.second == value.second) return true;
	}
	return false;
}

fn int[<2>] find_start(String[] input){
    foreach(int j, row : input) foreach(int i, letter : row) if(letter == '^') return {i, j};
    return {0, 0};
}