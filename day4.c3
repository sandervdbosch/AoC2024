module aoc2024::day4;

import std::io;
import std::time;
import std::collections;

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

    String needle = "XMAS";
    String needle_r = "SAMX";

    int count;

    List(<String>) rows, columns, diagonals_L, diagonals_R;
    rows.temp_init_with_array(data.tsplit("\n"));
    columns.temp_init();
    diagonals_L.temp_init();
    diagonals_R.temp_init();
    DString collector;
    collector.temp_init();

    for (usz i = 0; i < rows[0].len; ++i){
        foreach (row : rows){
            collector.append(row[i]);
        }
        columns.push(collector.tcopy_str());
        collector.clear();
    }

    for (isz i = -(rows.len() - 1); i < rows[0].len; ++i){
        foreach (j, row : rows){
            if (i + j >= 0 && i + j < rows.len()) collector.append_char(rows[j][i + j]);
        }
        if (collector.len() >= 4) diagonals_L.push(collector.tcopy_str());
        collector.clear();
    }

    for (isz i = 0; i < 2 * rows.len() - 1; ++i){
        for (isz j = 0; j < rows.len(); ++j){
            if (i - j >= 0 && i - j < rows.len()) collector.append_char(rows[j][i - j]);
        }
        if (collector.len() >= 4) diagonals_R.push(collector.tcopy_str());
        collector.clear();
    }

    List(<String>)[] directions = {rows, columns, diagonals_L, diagonals_R};

    malloc

    foreach(direction : directions){
        count += read_rows(direction, needle, needle_r);

    }
    return count;
}

fn int read_rows(List(<String>) rows, String needle1, String needle2){
    int count;
    usz index;

    foreach(row : rows){
        foreach(direction : String[] {needle1, needle2}){
            while(try i = row[index ..].index_of(direction)){
                ++count;
                index += i + direction.len;
            }
            index = 0;
        }
    }

    return count;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    int count;
    String[] rows = data.tsplit("\n");
    int s, m;

    for (usz i = 1; i < rows.len - 1; ++i){
        for (usz j = 1; j < rows[0].len - 1; ++j){
            // io::printf("%c", rows[i][j]);
            if (rows[i][j] == 'A'){
                if (rows[i-1][j-1] == rows[i+1][j+1]) continue;
                if (rows[i-1][j-1] == 'M') ++m;
                if (rows[i-1][j-1] == 'S') ++s;
                if (rows[i+1][j-1] == 'M') ++m;
                if (rows[i+1][j-1] == 'S') ++s;
                if (rows[i-1][j+1] == 'M') ++m;
                if (rows[i-1][j+1] == 'S') ++s;
                if (rows[i+1][j+1] == 'M') ++m;
                if (rows[i+1][j+1] == 'S') ++s;

                if (m == 2 && s == 2) count++;
                m = 0;
                s = 0;
            }
        }
        // io::printn();
    }

    return count;
}