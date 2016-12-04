#include <iostream>
#include <fstream>
#include <vector>
#include "room.h"

int main(int argc, char** argv) {
    const char* fileName = argc > 1 ? argv[1] : "input.txt";
    std::ifstream fis(fileName);


    vector<Room> rooms;
    int sum = 0;
    string line;
    while(getline(fis, line)) {
        Room room(line);
        if(room.isReal()) {
            rooms.push_back(room);
        }
    }

    for(Room& room : rooms) {
        string text = room.getText();
        string np = "northpole";
        bool isNpRoom = text.find("north") != string::npos && text.find("pole") != string::npos;
        if(isNpRoom) {
            cout << "The room " << "'" << text << "'" << " has the Sector Id" << "\n\t" << room.getId() << "\n";
            return 0;
        }
    }
 
    cout << "There is no such thing as a 'norhtpole room'" << "\n";
    return 1;

}