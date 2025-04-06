module aoc2024::day21;

import std::io;
import std::time;
import std::collections;

fn bool valid_arguments(String[] args){
    if (args.len == 1){
        io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
        return false;
    }
    return true;
}

fn void main(String[] args){
    //Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    if(!valid_arguments(args)) {
        io::printn(IoError.FILE_NOT_FOUND);
        return;
    }

    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        // io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

enum Direction{
    UP,
    DOWN,
    LEFT,
    RIGHT,
    PRESS,
}

fn int part1(String file){
    String data = (String) file::load_new(file)!!;

    String[] instuctions = data.tsplit("\n");

    int[<2>] keypad_position;
    Direction dpad_position = PRESS;
    keypad_position = position_keypad('A');

    int instruction_length, result;

    // 157108 is too high

    // 150364 is too low


    foreach (instruction : instuctions) {
        io::printf("%s : ", instruction);
        foreach (letter : instruction){
            // io::printf("%c : ", letter);
            int[<2>] next_keypad = position_keypad(letter);

            int diff_x = next_keypad.x - keypad_position.x;
            int diff_y = next_keypad.y - keypad_position.y;

            // io::printfn("\n%d %d", diff_x, diff_y);

            while (diff_x < 0){
                if (keypad_position.y == 3 && next_keypad.x != 1){
                    while (diff_y < 0){
                        instruction_length += move(dpad_position, UP);
                        dpad_position = UP;
                        keypad_position.y -= 1;
                        diff_y += 1;
                    }
                }
                instruction_length += move(dpad_position, LEFT);
                dpad_position = LEFT;
                keypad_position.x -= 1;
                diff_x += 1;

            }

            while (diff_y > 0){
                if (keypad_position.x == 0 && next_keypad.y != 3){
                    while (diff_x > 0){
                        instruction_length += move(dpad_position, RIGHT);
                        dpad_position = RIGHT;
                        keypad_position.x += 1;
                        diff_x -= 1;
                    }
                }
                instruction_length += move(dpad_position, DOWN);
                dpad_position = DOWN;
                keypad_position.y += 1;
                diff_y -= 1;
            }

            while (diff_y < 0){
                instruction_length += move(dpad_position, UP);
                dpad_position = UP;
                keypad_position.y -= 1;
                diff_y += 1;
            }

            while (diff_x > 0){
                instruction_length += move(dpad_position, RIGHT);
                dpad_position = RIGHT;
                keypad_position.x += 1;
                diff_x -= 1;
            }

            instruction_length += move(dpad_position, PRESS);
            dpad_position = PRESS;

            // io::printfn(" : %d", instruction_length);
            // instruction_length = 0;
        }
        io::printfn(" : %d", instruction_length);
        result += instruction_length * instruction[:3].to_int()!!;
        instruction_length = 0;
    }
    return result;
}

fn int[<2>] position_keypad(char c){
    switch (c){
        case 'A': return {2, 3};
        case '0': return {1, 3};
        case '1': return {0, 2};
        case '2': return {1, 2};
        case '3': return {2, 2};
        case '4': return {0, 1};
        case '5': return {1, 1};
        case '6': return {2, 1};
        case '7': return {0, 0};
        case '8': return {1, 0};
        case '9': return {2, 0};
        default: unreachable();
    }
}

fn int[<2>] position_dpad(char c){
    switch (c){
        case 'A': return {0, 2};
        case '^': return {0, 1};
        case 'v': return {1, 1};
        case '<': return {1, 0};
        case '>': return {1, 2};
        default: unreachable();
    }
}

fn int move(Direction last, Direction new) {
    switch (new){
        case UP:
            io::print("^");
            switch (last){
                case UP:    return 1;
                case DOWN:  return 4;
                case LEFT:  return 7;
                case RIGHT: return 9;
                case PRESS: return 8;
                default: unreachable();
            }
        case DOWN:
            io::print("v");
            switch (last){
                case UP:    return 6;
                case DOWN:  return 1;
                case LEFT:  return 4;
                case RIGHT: return 8;
                case PRESS: return 9;
                default: unreachable();
            }
        case LEFT:
            io::print("<");
            switch (last){
                case UP:    return 9;
                case DOWN:  return 8;
                case LEFT:  return 1;
                case RIGHT: return 9;
                case PRESS: return 10;
                default: unreachable();
            }
        case RIGHT:
            io::print(">");
            switch (last){
                case UP:    return 7;
                case DOWN:  return 4;
                case LEFT:  return 5;
                case RIGHT: return 1;
                case PRESS: return 6;
                default: unreachable();
            }
        case PRESS:
            io::print("A");
            switch (last){
                case UP:    return 4;
                case DOWN:  return 7;
                case LEFT:  return 8;
                case RIGHT: return 4;
                case PRESS: return 1;
                default: unreachable();
            }
        default: unreachable();
    }
}