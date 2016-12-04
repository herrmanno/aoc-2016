#include <iostream>
#include <fstream>
#include <vector>
#include "room.h"

int main(int argc, char** argv) {
    const char* fileName = argc > 1 ? argv[1] : "input.txt";
    std::ifstream fis(fileName);

    int sum = 0;
    string line;
    while(getline(fis, line)) {
        Room room(line);
        if(room.isReal()) {
            sum += room.getId();
        }
    }

    std::cout << "The sum of the sector-Ids of the real rooms is: " << "\n" << "\t" << sum << "\n";
}