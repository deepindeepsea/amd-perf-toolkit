/* syscall_heavy.c — drives kernel-side stalls, interrupts, mode switches.
   Tags ls_int_taken, ls_rd_tsc, ls_tlb_flush, ic_oc_mode_switch.
   Compile: gcc -O2 syscall_heavy.c -o syscall_heavy                          */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
int main(int argc, char** argv) {
    long iters = (argc>1)? atol(argv[1]) : 5000000L;
    struct timespec ts;
    volatile long s = 0;
    for (long i = 0; i < iters; ++i) {
        clock_gettime(CLOCK_MONOTONIC, &ts);
        s += ts.tv_nsec;
        if ((i & 0xffff) == 0) (void)getpid();
    }
    printf("syscall_heavy done s=%ld\n", s);
    return 0;
}
