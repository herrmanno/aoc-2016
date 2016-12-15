import std.stdio;
import std.array;
import std.container : DList;
import std.container.rbtree;
import std.algorithm.sorting;

alias ushort Floor; //1111111111 10 bits - RTGS first, chips second
alias ulong Floors; //4 floors concatenated - last 10 bits are floor 0
alias ushort Elevator;
alias ubyte Level;
alias uint Step;

const ushort ALL_RTG = 0b1111100000;
const ushort ALL_CHIP = 0b0000011111;

struct State {
    Floors floors;
    Level level;
    Step step;
}

Floor getFloor(State state, Level level) {
    return (state.floors >> level * 10) & (ALL_RTG | ALL_CHIP);
}

State[] getNextStates(State state) {
    Floor currFloor = (state.floors >> state.level * 10) & (ALL_RTG | ALL_CHIP);
    State[] nextStates;
    Floor[] combinations;

    //------- take single item

    for(int i = 0; i < 10; i++) {
        Floor take = currFloor & (1 << i);
        
        if(take == 0)
            continue;
        else
            combinations ~= take;
    }

    //------- take two items

    for(int i = 0; i < 10; i++) {
        for(int j = i + 1; i < 10; i++) {
            Floor take = currFloor & (1 << i | 1 << j);
       
            if(take == 0)
                continue;
            else
                combinations ~= take;
        }

    }


    foreach(comb; combinations) {
        for(Level nextLevel = 0; nextLevel < 4; nextLevel++) {
            if(nextLevel == state.level) {
                continue;
            }

            Floor floor3 = nextLevel == 3 ? getFloor(state, 3) | comb : state.level == 3 ? getFloor(state, 3) & ~comb : getFloor(state, 3);
            Floor floor2 = nextLevel == 2 ? getFloor(state, 2) | comb : state.level == 2 ? getFloor(state, 2) & ~comb : getFloor(state, 2);
            Floor floor1 = nextLevel == 1 ? getFloor(state, 1) | comb : state.level == 1 ? getFloor(state, 1) & ~comb : getFloor(state, 1);
            Floor floor0 = nextLevel == 0 ? getFloor(state, 0) | comb : state.level == 0 ? getFloor(state, 0) & ~comb : getFloor(state, 0);

            Floors nextFloors = floor3 << 30 | floor2 << 20 | floor1 << 10 | floor0;

            State nextState = State(
                nextFloors,
                nextLevel,
                state.step + 1
            );

            if(stateIsValid(nextState))
                nextStates ~= nextState;
        }
    }

    nextStates = array(nextStates.sort!("a.floors > b.floors"));

    // return sort!((a, b) => a.floors > b.floors)(nextStates);
    return nextStates;
}

bool stateIsValid(State state) {
    for(int i = 0; i < 3; i ++) {                                           // iterate over all floors
        Floor floor = (state.floors >> (i * 10)) & (ALL_RTG | ALL_CHIP);    // shift floor to inspect to the right end of the long
        if((floor & ALL_RTG) != 0) {                                        // floors has RTGs -> every chip needs its corresponding RTG on this floor
            for(int j = 0; i < 5; j++) {                                    // iterate over all isotopes
                if((floor >> j) & 0b1) {                                    // chip detected
                    if( !(floor >> (j+5) & 0b1) ) {                         // corresponding RTG not(!) found
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

bool isElevatorValid(Elevator elevator) {
    if((elevator & ALL_RTG) != 0) { // elevator has RTG
        if((elevator & ALL_CHIP) != 0) { // elevator also has chip
            auto rtg = elevator & ALL_RTG;
            auto chip = elevator & ALL_CHIP;

            if(rtg >> 5 != chip) // rtg and chip must be of the same isotope
                return false;
        }
    }

    return true;
}

int main() {

    State finalState = State(0b1111111111 << 30, 0, 0);
    State rootState = State(0b0000000000_0000000100_1110011000_0001100011, 0, 0);

    auto queue = DList!State();
    auto visited = redBlackTree!Floors();


    queue.insertBack(rootState);
    while(!queue.empty) {
        State state = queue.front;
        queue.removeFront();

        if(state.floors == finalState.floors) {
            writeln(state.step);
            return 0;
        }

        if(!(state.floors in visited)) {
            visited.insert(state.floors);

            auto nextStates = getNextStates(state);
            for (int i = 0; i < nextStates.length; i++) {
                if(!stateIsValid(nextStates[i]))
                    continue;
                else
                    queue.insertBack(state);
            }

        }

    }

    writeln("No result found");
    return -1;

}