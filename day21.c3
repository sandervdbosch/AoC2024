module aoc2024::day21;

import std::io;
import std::time;
import std::collections;

fn void main(String[] args){
    @pool()
    {
        Clock c = clock::now();
        cache.tinit();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        // io::printn(cache);
        cache.clear();
        io::printfn("Part2 answer: %d INCORRECT!! - completed in %s", part2(args[1]), c.mark());
    };
}

HashMap{int, long} cache;

fn bool cache_has(char from, char to, int depth){
    int key = depth + (from << 16) + (to << 24);
    return cache.has_key(key);
}

fn long cache_get(char from, char to, int depth){
    int key = depth + (from << 16) + (to << 24);
    if (!cache.has_key(key)) unreachable();
    return cache.get(key)!!;
}

fn void cache_add(char from, char to, int depth, long value){
    int key = depth + (from << 16) + (to << 24);
    cache.set(key, value);
}

fn long dpad_go(char from, char to, int depth){
    if (cache_has(from, to, depth)) return cache_get(from, to, depth);
    if (depth == 0) return 1;
    if (from == to) {
        return dpad_go('A', 'A', depth - 1);
    }
    long length;
    char position = 'A';
    int[<2>] pos, diff;
    pos = position_dpad(from);

    diff = position_dpad(to) - pos;

    while(diff.y < 0){
        if ((pos.x + diff.x) == 0){
            while(diff.x > 0){

                length += dpad_go(position, '>', depth - 1);
                position = '>';
                diff.x--;
            }
        }
        length += dpad_go(position, '^', depth - 1);
        position = '^';
        diff.y++;
    }

    while(diff.x < 0){
        if ((pos.x + diff.x) == 0){
            while(diff.y > 0){

                length += dpad_go(position, 'v', depth - 1);
                position = 'v';
                diff.y--;
            }
        }
        length += dpad_go(position, '<', depth - 1);
        position = '<';
        diff.x++;
    }

    while(diff.y > 0){
        length += dpad_go(position, 'v', depth - 1);
        position = 'v';
        diff.y--;
    }

    while(diff.x > 0){
        length += dpad_go(position, '>', depth - 1);
        position = '>';
        diff.x--;
    }

    length += dpad_go(position, 'A', depth - 1);
    position = 'A';

    cache_add(from, to, depth, length);
    return length;
}

fn int part1(String file){
    String data = (String) file::load_temp(file)!!;

    String[] instuctions = data.tsplit("\n");

    char keypad_position, dpad_position;
    int result;

    foreach(instruction : instuctions){
        int depth = 2;
        keypad_position = 'A';
        dpad_position = 'A';
        long length = 0;
        foreach(key : instruction){
            int[<2>] diff = position_keypad(key) - position_keypad(keypad_position);

            while(diff.y > 0){
                if(position_keypad(keypad_position).x == 0 && position_keypad(keypad_position).y + diff.y == 3){
                    while(diff.x > 0){
                        length += dpad_go(dpad_position, '>', depth);
                        dpad_position = '>';
                        diff.x--;
                    }
                }
                length += dpad_go(dpad_position, 'v', depth);
                dpad_position = 'v';
                diff.y--;
            }

            while(diff.x < 0){
                if(position_keypad(keypad_position).y == 3 && position_keypad(keypad_position).x + diff.x == 0){
                    while(diff.y < 0){
                        length += dpad_go(dpad_position, '^', depth);
                        dpad_position = '^';
                        diff.y++;
                    }
                }
                length += dpad_go(dpad_position, '<', depth);
                dpad_position = '<';
                diff.x++;
            }

            while(diff.x > 0){
                length += dpad_go(dpad_position, '>', depth);
                dpad_position = '>';
                diff.x--;
            }

            while(diff.y < 0){
                length += dpad_go(dpad_position, '^', depth);
                dpad_position = '^';
                diff.y++;
            }

            length += dpad_go(dpad_position, 'A', depth);
            dpad_position = 'A';

            keypad_position = key;
        }
        result += (int) length * instruction[:3].to_int()!!;
    }
    return result;
}

fn long part2(String file){
    String data = (String) file::load_temp(file)!!;

    String[] instuctions = data.tsplit("\n");

    // 154115708116294 example answer

    // 327650326471474 is too high

    // 161838442743664 is too low

    char keypad_position, dpad_position;
    long result;

    foreach(instruction : instuctions){
        int depth = 25;
        keypad_position = 'A';
        dpad_position = 'A';
        long length = 0;
        foreach(key : instruction){
            int[<2>] diff = position_keypad(key) - position_keypad(keypad_position);

            while(diff.x < 0){
                if(position_keypad(keypad_position).y == 3 && position_keypad(keypad_position).x + diff.x == 0){
                    while(diff.y < 0){
                        length += dpad_go(dpad_position, '^', depth);
                        dpad_position = '^';
                        diff.y++;
                    }
                }
                length += dpad_go(dpad_position, '<', depth);
                dpad_position = '<';
                diff.x++;
            }

            while(diff.y > 0){
                if(position_keypad(keypad_position).x == 0 && position_keypad(keypad_position).y + diff.y == 3){
                    while(diff.x > 0){
                        length += dpad_go(dpad_position, '>', depth);
                        dpad_position = '>';
                        diff.x--;
                    }
                }
                length += dpad_go(dpad_position, 'v', depth);
                dpad_position = 'v';
                diff.y--;
            }

            while(diff.y < 0){
                length += dpad_go(dpad_position, '^', depth);
                dpad_position = '^';
                diff.y++;
            }

            while(diff.x > 0){
                length += dpad_go(dpad_position, '>', depth);
                dpad_position = '>';
                diff.x--;
            }

            length += dpad_go(dpad_position, 'A', depth);
            dpad_position = 'A';

            keypad_position = key;
        }
        result += (long) length * instruction[:3].to_int()!!;
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
        case 'A': return {2, 0};
        case '^': return {1, 0};
        case 'v': return {1, 1};
        case '<': return {0, 1};
        case '>': return {2, 1};
        default: unreachable();
    }
}