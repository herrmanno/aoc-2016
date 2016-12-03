// #include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "readfile.h"
#include "line.h"
#include "triangle.h"

int main(int argc, char** argv) {
    if(argc < 2) {
        puts("Usage:");
        printf("%s filename\n", argv[0]);
        return 1;
    }

    int validCount = 0;
    
    LINE* line = line_new();
    LINE* firstLine = line;
    readFile(argv[1], line);
    
    while(line != NULL) {
        
        if(line->len == 0) {
            line = line->next;
            continue;
        }

        char* aStr = strtok(line->text, " ");
        char* bStr = strtok(NULL, " ");
        char* cStr = strtok(NULL, " ");
        int a = atoi(aStr);
        int b = atoi(bStr);
        int c = atoi(cStr);

        TRIANGLE t = {a,b,c};
        if(triangle_isValid(&t) == TRIANGLE_IS_VALID)
            validCount++;

        line = line->next;
    }

    printf("Number of valid triangles is:\n\t%d", validCount);
    line_destroy(firstLine);

    return 0;
}