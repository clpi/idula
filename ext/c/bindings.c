#include <stdio.h>

extern double putchard(double x) {
    putchar((char)x);
    return 0;
}

extern double printd(double x) {
    printf("%f\n", x);
    return 0;
}
