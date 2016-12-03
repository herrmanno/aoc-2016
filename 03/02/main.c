// #include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "readfile.h"
#include "line.h"
#include "triangle.h"

int main(int argc, char** argv) {
    if(argc < 2) {
        argv[1] = "input.txt";
    }

    int validCount = 0;
    
    LINE* line = line_new();
    LINE* firstLine = line;
    readFile(argv[1], line);
    
    TRIANGLE* t1 = triangle_new(0, 0, 0);
    TRIANGLE* t2 = triangle_new(0, 0, 0);
    TRIANGLE* t3 = triangle_new(0, 0, 0);
        

    int i = 0;
    while(line != NULL) {
        
        if(line->len > 0) {
            char* s1 = strtok(line->text, " ");
            char* s2 = strtok(NULL, " ");
            char* s3 = strtok(NULL, " ");
            int n1 = atoi(s1);
            int n2 = atoi(s2);
            int n3 = atoi(s3);


            switch(i) {
                case 0:
                    t1->a = n1;
                    t2->a = n2;
                    t3->a = n3;
                    break;
                case 1:
                    t1->b = n1;
                    t2->b = n2;
                    t3->b = n3;
                    break;
                case 2:
                    t1->c = n1;
                    t2->c = n2;
                    t3->c = n3;
                    break;
            }

            if(i == 2) {
                if(triangle_isValid(t1) == TRIANGLE_IS_VALID) {
                    validCount++;
                }
                if(triangle_isValid(t2) == TRIANGLE_IS_VALID) {
                    validCount++;
                }
                if(triangle_isValid(t3) == TRIANGLE_IS_VALID) {
                    validCount++;
                }

                triangle_reset(t1);
                triangle_reset(t2);
                triangle_reset(t3);
            }

        }

        line = line->next;
        i++;
        i %= 3;
    }

    printf("Number of valid triangles is:\n\t%d\n", validCount);
    
    line_destroy(firstLine);
    triangle_free(t1);
    triangle_free(t2);
    triangle_free(t3);

    return 0;
}