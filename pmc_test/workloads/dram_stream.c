/* dram_stream.c — large strided read/write, > L3, drives memory subsystem.
   Tags ls_dmnd_fills_from_sys, ls_any_fills_from_sys, ls_mab_alloc,
        l2_cache_req_stat.ls_rd_blk_c, ls_hw_pf_dc_fills.
   Compile: gcc -O2 dram_stream.c -o dram_stream                              */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv) {
    size_t MB = (argc>1)? (size_t)atol(argv[1]) : 512;   /* >> 96 MB L3 per CCD */
    long iters = (argc>2)? atol(argv[2]) : 5L;
    size_t N = MB * 1024UL * 1024UL;
    volatile long* a = (volatile long*)malloc(N);
    memset((void*)a, 0, N);
    size_t nlong = N / sizeof(long);
    volatile long s = 0;
    for (long k = 0; k < iters; ++k) {
        for (size_t i = 0; i < nlong; i += 8) s += a[i];
        for (size_t i = 0; i < nlong; i += 8) a[i] = (long)i;
    }
    printf("dram_stream done s=%ld MB=%zu\n", s, MB);
    return 0;
}
