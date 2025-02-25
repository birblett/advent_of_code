#include <stdio.h>
#include <stdlib.h>
#include <string.h>

__global__ void get_res(int *locks, int *keys, int keyc, int *result) {
    int id = blockIdx.x * blockDim.x + threadIdx.x, out = 0, i;
    int lock = locks[id];
    for (i = 0; i < keyc; ++i) out += !((lock + keys[i]) & 559240);
    atomicAdd(result, out);
}

int main() {
    FILE *f = fopen("in.txt", "r");
    char buf[44];
    int lockc = 0, keyc = 0, locks[10000], keys[10000], *l_cu, *k_cu, *result, i, j, k;
    while (fread(buf, sizeof(char), 43, f)) {
        for (i = k = 0; i < 5; ++i) {
            j = (buf[i] == '#') + (buf[i + 6] == '#') + (buf[i + 12] == '#') + (buf[i + 18] == '#') + (buf[i + 24] == '#') + (buf[i + 30] == '#') + (buf[i + 36] == '#');
            k += j << (4 * i);
        }
        j = ((i = buf[0] == '#') ? lockc : keyc)++;
        (i ? locks : keys)[j] = k;
    }
    cudaMalloc(&l_cu, sizeof(int) * lockc);
    cudaMalloc(&k_cu, sizeof(int) * keyc);
    cudaMallocManaged(&result, sizeof(int));
    cudaMemcpy(l_cu, locks, sizeof(int) * lockc, cudaMemcpyHostToDevice);
    cudaMemcpy(k_cu, keys, sizeof(int) * keyc, cudaMemcpyHostToDevice);
    get_res<<<1, lockc>>>(l_cu, k_cu, keyc, result);
    cudaDeviceSynchronize();
    cudaFree(l_cu);
    cudaFree(k_cu);
    printf("%d\n", *result);
    cudaFree(result);
}