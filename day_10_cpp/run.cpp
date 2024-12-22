#include <iostream>
#include <cstdio>
#include <string.h>

#define PACK(y, x) ((y) << 8) + (x)
#define BSIZE 3000
#define SSIZE 30000

int main() {
    int board[BSIZE], stack[SSIZE], found[SSIZE * 2] = {0}, trailheads[SSIZE / 6];
    int tscore = 0, paths = 0, head = 0, th = 0, len = 0, blen = 0, x = 0, y = 0, tmp, i, x1, y1, idx;
    FILE* f = fopen("in.txt", "r");
    while((tmp = fgetc(f)) != EOF && ++x)
        if (tmp > 34) (board[blen++] = tmp - 48) == 0 ? trailheads[th++] = PACK(y, x) - 1 :0;
        else if (!len) len = blen;
        else if (tmp == '\n') y += (x = 0) + 1;
    fclose(f);
    for (int i = 0; i < th; ++i && (memset(found, 0, SSIZE * 2))) {
        stack[head = 0] = trailheads[i];
        while (head >= 0 && ((tmp = stack[head--]) || 1)) {
            if (board[idx = (y = tmp >> 8) * len + (x = tmp & 255)] == 9 && (paths += 1)) {
                if (!found[tmp]) found[tmp] = (tscore += 1);
                continue;
            }
            if ((y1 = y - 1) >= 0 && y1 < len && board[y1 * len + x] == board[idx] + 1) stack[++head] = PACK(y1, x);
            if ((y1 = y + 1) >= 0 && y1 < len && board[y1 * len + x] == board[idx] + 1) stack[++head] = PACK(y1, x);
            if ((x1 = x - 1) >= 0 && x1 < len && board[y * len + x1] == board[idx] + 1) stack[++head] = PACK(y, x1);
            if ((x1 = x + 1) >= 0 && x1 < len && board[y * len + x1] == board[idx] + 1) stack[++head] = PACK(y, x1);
        }
    }
    std::cout << tscore << ' ' << paths << '\n';
}