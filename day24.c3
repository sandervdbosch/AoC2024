module aoc2024::day24;

import std::io;
import std::time;
import std::collections;

fn void main(String[] args){
    @pool()
    {
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

enum Operator{
    AND,
    OR,
    XOR,
}

struct Gate{
    String input1;
    Operator operator;
    String input2;
    String output;
}

fn long part1(String file){
    String[] data = ((String) file::load_temp(file)).tsplit("\n\n")!!;

    HashMap{String, bool} variables;
    variables.tinit();

    foreach(line : data[0].tsplit("\n")){
        variables.set(line[:3], line[5] == '1');
    }

    List{Gate} gates;
    gates.tinit();

    foreach(line : data[1].tsplit("\n")){
        Gate gate;
        gate.input1 = line[:3];

        if(line[3..].contains("AND")) gate.operator = AND;
        if(line[3..].contains("OR")) gate.operator = OR;
        if(line[3..].contains("XOR")) gate.operator = XOR;

        gate.input2 = line[^10 : 3];
        gate.output = line[^3 : 3];

        gates.push(gate);
    }

    while(!gates.is_empty()){
        for(usz index = 0; index < gates.len(); ++index){
            if (variables.has_key(gates[index].input1) && variables.has_key(gates[index].input2)){
                bool input1 = variables.get(gates[index].input1)!!;
                bool input2 = variables.get(gates[index].input2)!!;
                if (gates[index].operator == AND) variables.set(gates[index].output, input1 & input2);
                if (gates[index].operator == OR) variables.set(gates[index].output, input1 | input2);
                if (gates[index].operator == XOR) variables.set(gates[index].output, input1 ^ input2);

                gates.remove_at(index);

                --index;
            }
        }
    }

    long result;

    for (usz i = 0; variables.has_key(string::tformat("z%02d", i)); ++i){
        result |= ((long) variables.get(string::tformat("z%02d", i))!! << (i));
    }

    return result;
}

fn long part2(String file){
    String[] data = ((String) file::load_temp(file)).tsplit("\n\n")!!;

    long x, y;

    foreach(line : data[0].tsplit("\n")){
        if (line[0] == 'x') x |= (long)(line[5] - '0') << line[1:2].to_long()!!;
        if (line[0] == 'y') y |= (long)(line[5] - '0') << line[1:2].to_long()!!;
    }

    io::printfn("x = %b, y = %b", x, y);
    io::printfn("  = %b", x + y);
    io::printfn("z = %b", part1(file));
    io::printfn("  = %046b", (x + y) ^ part1(file));

    return 0;
}