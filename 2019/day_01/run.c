#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE* f = fopen("in.txt", "r");
    char buf[8192], *c, tmp;
    int curr;
    long sum = 0;
    while ((c = fgets(buf, 8192, f)) && !(curr = 0)) {
        for (; (tmp = *c); c++) if (tmp > 47 && tmp < 58) curr = curr * 10 + tmp - 48;
        while ((curr = curr / 3 - 2) > 0) sum += curr;
    }
    printf("%ld\n", sum);
    fclose(f);
}