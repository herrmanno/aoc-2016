#include "triangle.h"

TRIANGLE* triangle_new(size_t a, size_t b, size_t c) {
    TRIANGLE* t = malloc(sizeof(TRIANGLE));
    t->a = a;
    t->b = b;
    t->c = c;

    return t;
}

void triangle_free(TRIANGLE* t) {
    free(t);
}

TRIANGLE_VALIDITY triangle_isValid(TRIANGLE* t) {
    if(t->a + t->b <= t->c)
        return TRIANGLE_IS_INVALID;
    if(t->a + t->c <= t->b)
        return TRIANGLE_IS_INVALID;
    if(t->b + t->c <= t->a)
        return TRIANGLE_IS_INVALID;

    return TRIANGLE_IS_VALID;
}

void triangle_reset(TRIANGLE* t) {
    t->a = 0;
    t->b = 0;
    t->c = 0;
}