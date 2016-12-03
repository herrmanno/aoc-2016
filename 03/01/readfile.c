#include <stdio.h>
#include <string.h>
#include "readfile.h"

int readFile(char* fileName, LINE* line) {
    FILE* f = NULL;
    if((f = fopen(fileName, "r")) == NULL) {
        puts("Error opening file");
        return -1;
    }


    int read = 0;
    LINE* currLine = line;

    char buf[256];
    while(fgets(buf, sizeof buf, f) != NULL) {
        strtok(buf, "\n");
        line_append(currLine, buf, strlen(buf));
        currLine->next = line_new();
        currLine = currLine->next;
        read++;
    }

    return read;
}