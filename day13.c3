module aoc2024::day13;

import std::io;
import std::time;
import std::collections;

struct Game
{
    long[<2>] a;
    long[<2>] b;
    long[<2>] prize;
}

fn void! main(String[] args)
{
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

fn long part1(String file)
{
    Game[] games = process_input(file);

    long total_cost;

    foreach(game : games)
    {
        if((game.prize.x * game.b.y - game.b.x * game.prize.y) % (game.a.x * game.b.y - game.b.x * game.a.y) != 0) continue;
        if((game.prize.x * game.a.y - game.a.x * game.prize.y) % (game.b.x * game.a.y - game.a.x * game.b.y) != 0) continue;
        long i = (game.prize.x * game.b.y - game.b.x * game.prize.y) / (game.a.x * game.b.y - game.b.x * game.a.y);
        long j = (game.prize.x * game.a.y - game.a.x * game.prize.y) / (game.b.x * game.a.y - game.a.x * game.b.y);
        if(i >= 100 || j >= 100) continue;
        total_cost += 3 * i + j;
    }
    return total_cost;
}

fn long part2(String file)
{
    Game[] games = process_input(file);

    long total_cost;

    foreach(game : games)
    {
        game.prize += 10000000000000;
        if((game.prize.x * game.b.y - game.b.x * game.prize.y) % (game.a.x * game.b.y - game.b.x * game.a.y) != 0) continue;
        if((game.prize.x * game.a.y - game.a.x * game.prize.y) % (game.b.x * game.a.y - game.a.x * game.b.y) != 0) continue;
        long i = (game.prize.x * game.b.y - game.b.x * game.prize.y) / (game.a.x * game.b.y - game.b.x * game.a.y);
        long j = (game.prize.x * game.a.y - game.a.x * game.prize.y) / (game.b.x * game.a.y - game.a.x * game.b.y);

        total_cost += 3 * i + j;
    }
    return total_cost;
}

fn Game[] process_input(String file)
{
    String[] game_text = ((String) file::load_temp(file)!!).tsplit("\n\n");

    List(<Game>) games;
    games.temp_init(game_text.len);
    Game accumulator;

    foreach(game : game_text)
    {
        accumulator.a.x = game[12..game.index_of_char(',') - 1].to_long()!!;
        accumulator.a.y = game[game.index_of_char_from('+', 12) + 1 .. game.index_of_char('\n') - 1].to_long()!!;
        game = game[game.index_of_char('\n')!! + 1..];
        accumulator.b.x = game[12..game.index_of_char(',') - 1].to_long()!!;
        accumulator.b.y = game[game.index_of_char_from('+', 12) + 1 .. game.index_of_char('\n') - 1].to_long()!!;
        game = game[game.index_of_char('\n')!! + 1..];
        accumulator.prize.x = game[9..game.index_of_char(',') - 1].to_long()!!;
        accumulator.prize.y = game[game.index_of_char_from('=', 9) + 1 ..].to_long()!!;
        games.push(accumulator);
    }
    return games.to_tarray();
}