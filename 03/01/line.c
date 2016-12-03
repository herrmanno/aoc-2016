#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "line.h"

__attribute__ ((warn_unused_result))
LINE* line_new() {
    LINE* line = malloc(sizeof(LINE));
    
    if(line == NULL)
        return NULL;

    line->text = malloc(sizeof(char));
    *line->text = 0;
    line->len = 0;
    line->next = NULL;
    return line;
}

void line_destroy(LINE* line) {
    if(line->text != NULL)
        free(line->text);
    if(line->next != NULL)
        line_destroy(line->next);
    free(line);
}

LINE_STATE line_append(LINE* line, char* text, size_t len) {
    if(realloc(line->text, line->len + len) == NULL) {
        return ERR_ALLOC;
    }
    int l;
    strncat(line->text, text, len);
    line->len += len;
    return OK;    
}

void lines_print(LINE* line) {
    if(line->len > 0 && NULL != line->text)
        puts(line->text);
    if(NULL != line->next)
        lines_print(line->next);
}