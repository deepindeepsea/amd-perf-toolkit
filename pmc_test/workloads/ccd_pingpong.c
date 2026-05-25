/* ccd_pingpong.c — cross-thread cacheline ping-pong (false sharing).
   When threads run on different CCDs this generates cross-CCD L3 / coherence
   traffic that is invisible on a single-thread / single-CCD pin.
   Tags ls_dmnd_fills_from_sys (cross-CCD source), l2_cache_req_stat.ls_rd_blk_c,
        ls_wcb_close_flush, ls_st_commit_cancel2 (some), ls_mab_alloc.
   Compile: gcc -O2 -pthread ccd_pingpong.c -o ccd_pingpong                   */
#define _GNU_SOURCE
#include <pthread.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static atomic_long counter;
static long ITERS = 20000000L;
static int NTH    = 2;

static void* worker(void* arg) {
    long tid = (long)arg;
    for (long i = 0; i < ITERS; ++i) {
        atomic_fetch_add(&counter, 1);
        if ((i & 0xff) == 0) atomic_load(&counter);
    }
    (void)tid;
    return NULL;
}

int main(int argc, char** argv) {
    NTH   = (argc>1)? atoi(argv[1]) : 2;
    ITERS = (argc>2)? atol(argv[2]) : 5000000L;
    pthread_t* th = calloc(NTH, sizeof(*th));
    for (long i = 0; i < NTH; ++i) pthread_create(&th[i], NULL, worker, (void*)i);
    for (long i = 0; i < NTH; ++i) pthread_join(th[i], NULL);
    printf("ccd_pingpong done counter=%ld nth=%d\n", (long)counter, NTH);
    free(th);
    return 0;
}
