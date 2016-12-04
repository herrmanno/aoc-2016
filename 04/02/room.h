#ifndef H_ROOM
#define H_ROOM

#include <string>
#include <vector>

using namespace std;

class Room {
    public:
        Room(std::string);
        virtual ~Room();

        bool isReal();
        int getId();
        string getText();

    private:
        string buildChecksum();
        vector<string> parts;
        int id;
        string checksum;
};
#endif