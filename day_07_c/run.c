#include <stdio.h>
#include <omp.h>
#include <stdlib.h>
#include <time.h>
#ifndef NTHREADS
#define NTHREADS 16
#endif
#define MIN(a,b) ((a)<(b)?(a):(b))

double wallclock() {
    struct timespec now;
    clock_gettime(CLOCK_REALTIME, &now);
    return now.tv_sec + now.tv_nsec * 1e-9;
}

int push(long* stack, long add, long ind, long pure, int head) {
    int idx = (head + 1) * 3;
    stack[idx] = add;
    stack[idx + 1] = ind;
    stack[idx + 2] = pure;
    return head + 1;
}

double test(){
    double time = wallclock();
    FILE *f = fopen("in.txt", "r");
    char buf[8192], *c, tmp;
    long res[1000][20], curr, target, last, sum1 = 0, sum2 = 0;
    int size[1000], i=0, idx;
    while ((c = fgets(buf, 8192, f)) && ++i && !(curr = idx = 0)) {
        for (; (tmp = *c); c++) if (tmp > 47 && tmp < 58) curr = curr * 10 + tmp - 48;
        else if (curr) curr = (res[i - 1][idx++] = curr) & 0;
        size[i - 1] = idx;
    }
    fclose(f);
    #if(NTHREADS > 1)
    omp_set_num_threads(NTHREADS);
    #pragma omp parallel reduction(+:sum1) reduction(+:sum2)
    {
    int tid = omp_get_thread_num();
    #else
    int tid = 0;
    #endif
    int ind = 0, head = 0, t, len = 0, offset = (i + NTHREADS) / NTHREADS, j, maxval = MIN(i, (tid + 1) * offset);
    long stack[2000] , rs = 0L;
    for (j = tid * offset; (target = res[j][0]) && !(head = push(stack, res[j][1], 2, 1, -1)) && j < maxval; j++) {
        long found1 = 0, found2 = 0, len = size[j];
        while (head > -1) {
            long pure = stack[(t = head * 3) + 2], add = (last = stack[t]) + (rs = res[j][(ind = stack[t + 1])]), mul = last * rs, cat = last * (10 > rs ? 10 : 100 > rs ? 100 : 1000 > rs ? 1000 : 10000) + rs;
            --head;
            if (ind + 1 < len) {
                if (add < target) head = push(stack, add, ind + 1, pure, head);
                if (mul < target) head = push(stack, mul, ind + 1, pure, head);
                if (cat < target) head = push(stack, cat, ind + 1, 0, head);
            }
            if (!found1 && pure && (add == target || mul == target)) found1 = (sum1 += target);
            if (!found2 && (add == target || mul == target || cat == target)) found2 = (sum2 += target);
            if (found1 && found2) break;
        }
    }
    #if(NTHREADS > 1)
    }
    #endif
    double fin = wallclock();
    return fin - time;
}

int main() {
    double res = 0;
    for (int i = 0; i < 1; i++) {
        res += test();
    }
    printf("1000 tests with %d thread(s) took %lfms on average\n", NTHREADS, res);
}