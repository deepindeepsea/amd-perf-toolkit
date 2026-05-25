/* tlb_thrash.c — touch many distinct 4K pages to exhaust DTLB.
   Tags ls_l1_d_tlb_miss, ls_tablewalker, bp_l1_tlb_miss_l2_tlb_*,
        bp_l1_tlb_miss_l2_tlb_miss.
   Compile: gcc -O2 tlb_thrash.c -o tlb_thrash                                */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv) {
    size_t pages = (argc>1)? (size_t)atol(argv[1]) : 65536UL;  /* 256 MB at 4K */
    long iters = (argc>2)? atol(argv[2]) : 20L;
    size_t PG = 4096UL;
    size_t N = pages * PG;
    volatile char* a = (volatile char*)malloc(N);
    if (!a) { perror("malloc"); return 1; }
    /* prime so pages are resident */
    for (size_t i = 0; i < N; i += PG) a[i] = 1;
    volatile long s = 0;
    for (long k = 0; k < iters; ++k)
        for (size_t i = 0; i < N; i += PG) s += a[i];
    printf("tlb_thrash done s=%ld pages=%zu\n", s, pages);
    return 0;
}
