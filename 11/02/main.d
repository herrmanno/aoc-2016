import std.stdio;
import std.array;
import std.string;
import std.algorithm: canFind;
import std.container.binaryheap;
import std.container.rbtree;
import std.algorithm.sorting;


alias ushort Floor; //1111111111 10 bits - RTGS first, chips second
alias ulong Floors; //4 floors concatenated - last 10 bits are floor 0
alias ushort Elevator;
alias ubyte Level;
alias uint Step;


const ushort ALL_RTG =  0b11111110000000;
const ushort ALL_CHIP = 0b00000001111111;

struct State {
    Floors floors;
    Level level;
    Step step;

    Floor getFloor(Level level) {
        return (floors >> level * 14) & (ALL_RTG | ALL_CHIP);
    }

    bool equals(State other) {
        return this.floors == other.floors;
    }

    debug:
    string toString() {
        return join([
            "State:----",
            b(this.getFloor(3)),
            b(this.getFloor(2)),
            b(this.getFloor(1)),
            b(this.getFloor(0)),
        ], "\n");
    }

}

debug:
string b(ulong n) {
    string s = "";
    while(n) {        
        s = ((n & 0b1) == 1 ? "1" : "0") ~ s;
        n >>= 1;
    }
    return rightJustify(s, 14, '0');
}


State[] getNextStates(State state) {
    Floor currFloor = (state.floors >> state.level * 14) & (ALL_RTG | ALL_CHIP);
    State[] nextStates;
    Floor[] combinations;

    //------- take single item

    for(int i = 0; i < 14; i++) {
        Floor take = currFloor & (1 << i);
        
        if(take == 0)
            continue;
        else
            combinations ~= take;
    }

    //------- take two items

    for(int i = 0; i < 14; i++) {
        for(int j = i + 1; j < 14; j++) {
            
            Floor take = currFloor & (1 << i | 1 << j);
       
            if(take == 0)
                continue;
            else if(!combinations.canFind(take))
                combinations ~= take;
        }

    }

    foreach(comb; combinations) {
        if(!isElevatorValid(comb))
            continue;

        // cycle elevator up and down.
        //
        // as is has to stop on every floor and my fry chips while standing still
        // break the loop if an state is invalid

        if(state.level < 3)
            for(Level nextLevel = cast(Level)(state.level + 1); nextLevel < 4; nextLevel++) {
                Floors floor3 = nextLevel == 3 ? (state.getFloor(3) | comb) : state.level == 3 ? (state.getFloor(3) & ~comb) : state.getFloor(3);
                Floors floor2 = nextLevel == 2 ? (state.getFloor(2) | comb) : state.level == 2 ? (state.getFloor(2) & ~comb) : state.getFloor(2);
                Floors floor1 = nextLevel == 1 ? (state.getFloor(1) | comb) : state.level == 1 ? (state.getFloor(1) & ~comb) : state.getFloor(1);
                Floors floor0 = nextLevel == 0 ? (state.getFloor(0) | comb) : state.level == 0 ? (state.getFloor(0) & ~comb) : state.getFloor(0);

                Floors nextFloors = (floor3 << 42) | (floor2 << 28) | (floor1 << 14) | (floor0);

                State nextState = State(
                    nextFloors,
                    nextLevel,
                    state.step + 1
                );

                if(elCount(nextState) != elCount(state)) {
                    writeln(state.toString);
                    writeln(nextState.toString);
                    throw new Exception("New state has more elements than old state!");
                }

                if(stateIsValid(nextState)) {
                    nextStates ~= nextState;
                } else {
                    break;
                }

                break;
            }

        if(state.level > 0)
            for(Level nextLevel = cast(Level)(state.level - 1); nextLevel > -1; nextLevel--) {
                Floors floor3 = nextLevel == 3 ? (state.getFloor(3) | comb) : state.level == 3 ? (state.getFloor(3) & ~comb) : state.getFloor(3);
                Floors floor2 = nextLevel == 2 ? (state.getFloor(2) | comb) : state.level == 2 ? (state.getFloor(2) & ~comb) : state.getFloor(2);
                Floors floor1 = nextLevel == 1 ? (state.getFloor(1) | comb) : state.level == 1 ? (state.getFloor(1) & ~comb) : state.getFloor(1);
                Floors floor0 = nextLevel == 0 ? (state.getFloor(0) | comb) : state.level == 0 ? (state.getFloor(0) & ~comb) : state.getFloor(0);

                Floors nextFloors = (floor3 << 42) | (floor2 << 28) | (floor1 << 14) | (floor0);

                State nextState = State(
                    nextFloors,
                    nextLevel,
                    state.step + 1
                );

                if(elCount(nextState) != elCount(state)) {
                    writeln(state.toString);
                    writeln(nextState.toString);
                    throw new Exception("New state has more elements than old state!");
                }

                if(stateIsValid(nextState)) {
                    nextStates ~= nextState;
                } else {
                    break;
                }

                break;
            }
    }

    auto states =  array(nextStates.sort!("a.floors > b.floors"));
    return states;
}

bool stateIsValid(State state) {
    for(Level level = 0; level < 3; level++) {                                           // iterate over all floors
        Floor floor = state.getFloor(level);    // shift floor to inspect to the right end of the long
        if((floor & ALL_RTG) != 0) {                                        // floors has RTGs -> every chip needs its corresponding RTG on this floor
            for(int isotope = 0; isotope < 7; isotope++) {                                    // iterate over all isotopes
                if( ((floor >> isotope) & 1) == 1) {                                    // chip detected
                    if( ((floor >> (isotope + 7)) & 1) == 0) {                         // corresponding RTG not(!) found
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

ubyte elCount(State state) {
    ubyte ones = 0;
    for(int i = 0; i < 56; i++) {
        if( (state.floors >> i) & 1)
            ones++;
    }

    return ones;
}

bool isElevatorValid(Elevator elevator) {
    if((elevator & ALL_RTG) != 0) { // elevator has RTG
        if((elevator & ALL_CHIP) != 0) { // elevator also has chip
            auto rtg = elevator & ALL_RTG;
            auto chip = elevator & ALL_CHIP;

            if(rtg >> 7 != chip) // rtg and chip must be of the same isotope
                return false;
        }
    }

    return true;
}

int main() {

    State finalState =  State(0b11111111111111_00000000000000_00000000000000_00000000000000, 0, 0);
    State rootState =   State(0b00000000000000_00000000000100_00111000011000_11000111100011, 0, 0);

    State[] qArr;
    auto queue = heapify!"a.floors < b.floors"(qArr);
    auto visited = redBlackTree!Floors();


    ulong count = 0;
    queue.insert(rootState);
    do {
        State state = queue.front;
        queue.removeFront();

        if(finalState.equals(state)) {
            writefln("Found after %d steps", state.step);
            return 0;
        }

        if(state.floors in visited) {
            continue;
        }
        else {
            visited.insert(state.floors);
        }


        auto nextStates = getNextStates(state);
        foreach(nextState; nextStates) {
            queue.insert(nextState);
        }

        count++;

    } while(!queue.empty());

    writefln("No result found. Inspected %d states", count);
    return -1;

}