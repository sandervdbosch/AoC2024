module aoc2024::day13;

import std::io;
import std::time;
import std::collections;

import libc;

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
    List(<Game>) games;
    games.temp_init();

    foreach(game : ((String) file::load_temp(file)!!).tsplit("\n\n"))
    {
        Game accumulator;

        if (libc::sscanf(game, "Button A: X+%ld, Y+%ld\nButton B: X+%ld, Y+%ld\nPrize: X=%ld, Y=%ld", &accumulator.a.x, &accumulator.a.y, &accumulator.b.x, &accumulator.b.y, &accumulator.prize.x, &accumulator.prize.y) != 6) assert("sscanf failed!");
        games.push(accumulator);
    }

    long total_cost;

    foreach(game : games)
    {
        if((game.prize.x * game.b.y - game.b.x * game.prize.y) % (game.a.x * game.b.y - game.b.x * game.a.y) != 0) continue;
        long i = (game.prize.x * game.b.y - game.b.x * game.prize.y) / (game.a.x * game.b.y - game.b.x * game.a.y);
        if((game.prize.x - i * game.a.x) % game.b.x != 0) continue;
        long j = (game.prize.x - i * game.a.x) / game.b.x;
        if(i >= 100 || j >= 100) continue;
        total_cost += 3 * i + j;
    }
    return total_cost;
}

fn long part2(String file)
{
    List(<Game>) games;
    games.temp_init();

    foreach(game : ((String) file::load_temp(file)!!).tsplit("\n\n"))
    {
        Game accumulator;

        libc::sscanf(game, "Button A: X+%ld, Y+%ld\nButton B: X+%ld, Y+%ld\nPrize: X=%ld, Y=%ld", &accumulator.a.x, &accumulator.a.y, &accumulator.b.x, &accumulator.b.y, &accumulator.prize.x, &accumulator.prize.y);
        games.push(accumulator);
    }

    long total_cost;

    foreach(game : games)
    {
        game.prize += 10000000000000;
        if((game.prize.x * game.b.y - game.b.x * game.prize.y) % (game.a.x * game.b.y - game.b.x * game.a.y) != 0) continue;
        long i = (game.prize.x * game.b.y - game.b.x * game.prize.y) / (game.a.x * game.b.y - game.b.x * game.a.y);
        if((game.prize.x - i * game.a.x) % game.b.x != 0) continue;
        long j = (game.prize.x - i * game.a.x) / game.b.x;

        total_cost += 3 * i + j;
    }
    return total_cost;
}