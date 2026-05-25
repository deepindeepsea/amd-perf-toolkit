/* l2_pressure.c — working set ~512 KB fits L1 + spills to L2 (1 MB per core Zen4/5).
   Tags l2_request_g1, l2_cache_req_stat.dc_hit_in_l2, l2_pf_hit_l2.
   Compile: gcc -O2 l2_pressure.c -o l2_pressure                              */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv) {
    size_t N = (argc>1)? (size_t)atol(argv[1]) : (size_t)(768*1024);    /* bytes */
    long iters = (argc>2)? atol(argv[2]) : 40000L;
    volatile long* p = (volatile long*)malloc(N);
    memset((void*)p, 1, N);
    size_t nlong = N / sizeof(long);
    volatile long sum = 0;
    for (long k = 0; k < iters; ++k) {
        for (size_t i = 0; i < nlong; i += 8)  /* one access per cache line */
            sum += p[i];
    }
    printf("l2_pressure done sum=%ld bytes=%zu\n", sum, N);
    return 0;
}
