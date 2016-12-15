import std.stdio;
import std.container : DList;
import std.container.rbtree;

/*          RTG     Chip
Strontium    1       -1
Plutonium    2       -2
Thulium      3       -3
Ruthenium    4       -4
Curium       5       -5
*/

alias ushort Floor; //1111111111 10 bits - RTGS first, chips second
alias ulong Floors; //4 floors concatenated first last 10 bits are floor 0

Floors[] getNextState(Floors state) {
    return null;
}

bool stateIsValid(Floors state) {
    return false;
}

int main() {
    Floors finalState = 0;
    Floors rootState = 0;


    auto queue = DList!Floors();
    auto visited = redBlackTree!Floors();


    int steps = 0;
    queue.insertBack(rootState);
    while(!queue.empty) {
        Floors state = queue.front;
        queue.removeFront();
        
        if(state == finalState) {
            writeln(steps);
            return 0;
        }

        if(!state in visited) {
            visited.insert(state);

            auto nextStates = getNextState(state);
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