#include "room.h"
#include <sstream>
#include <iostream>
#include <map>

using namespace std;

Room::Room(std::string line) {
    stringstream ss(line);
    string item;
    while(getline(ss, item, '-')) {
        this->parts.push_back(item);
    }

    string idAndChecksum = this->parts.back();
    this->parts.pop_back();

    stringstream ss2(idAndChecksum);
    getline(ss2, item, '[');
    this->id = stoi(item);
    getline(ss2, item, '[');
    this->checksum = item.substr(0, item.find("]"));
}

Room::~Room() {
   
}

bool Room::isReal() {
    string cs = this->buildChecksum();
    // cout << "Real Cs: " << this->checksum << " - " << "Calculated Cs: " << cs << "\n";
    
    int minLength = min(cs.length(), this->checksum.length());
    return cs.substr(0, minLength).compare(this->checksum.substr(0, minLength)) == 0;
}

string Room::buildChecksum() {
    map<char,int> map;
    for(string part: this->parts) {
        for(string::iterator it = part.begin(); it < part.end(); it++) {
            if(map.count(*it) == 0)
                map[*it] = 1;
            else
                map[*it]++;
        }
    }

    string checkSum;
    while(map.size() > 0) {

        int max = 0;
        vector<char> chars;

        for(auto& entry : map) {
            if(entry.second > max)
                max = entry.second;
        }
        for(auto& entry : map) {
            if(entry.second == max) {
                chars.push_back(entry.first);
            }
        }
        for(char& c : chars)
            map.erase(c);

        sort(chars.begin(), chars.end());
        for(auto& c : chars) {
            checkSum += c;
        }
        chars.clear();

    }

    return checkSum;
}

int Room::getId() {
    return this->id;
}

string Room::getText() {
    int times = this->getId();

    string text;
    for(string& part : this->parts) {
        for(char c : part) {
            for(int i = 0; i < times; i++) {
                if(c == 'z')
                    c = 'a';
                else
                    c++;
            }
            text += c;
        }
        text += " ";
    }

    return text;
}