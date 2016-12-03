#include <stdlib.h>

#ifndef LINE_H
#define LINE_H

typedef struct S_LINE {
    char* text;
    size_t len;
    struct S_LINE* next;
} LINE;

typedef enum {
    OK,
    ERR_ALLOC
} LINE_STATE;


__attribute__ ((warn_unused_result))
LINE* line_new();

void line_destroy(LINE* line);

LINE_STATE line_append(LINE* line, char* text, size_t len);

void lines_print(LINE* line);

#endif