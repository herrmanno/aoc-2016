#ifndef H_TRIANLGE
#include <stdlib.h>

typedef struct S_TRIANLGE {
    size_t a;
    size_t b;
    size_t c;
} TRIANGLE;

typedef enum {
    TRIANGLE_IS_VALID,
    TRIANGLE_IS_INVALID,
} TRIANGLE_VALIDITY;

TRIANGLE* triangle_new(size_t a, size_t b, size_t c);
void triangle_free(TRIANGLE* t);
TRIANGLE_VALIDITY triangle_isValid(TRIANGLE* t);
void triangle_reset(TRIANGLE* t);

#define H_TRIANLGE
#endif