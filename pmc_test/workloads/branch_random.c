/* branch_random.c — high branch misprediction workload.
   Tags ex_ret_brn_misp, ex_ret_brn_tkn_misp, ex_ret_near_ret_mispred,
        ex_ret_msprd_brnch_instr_dir_msmtch, bp_de_redirect, bp_pred_flush.
   Compile: gcc -O2 branch_random.c -o branch_random                         */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv) {
    long N = (argc>1)? atol(argv[1]) : 64*1024*1024L;
    long iters = (argc>2)? atol(argv[2]) : 4L;
    unsigned char* a = (unsigned char*)malloc(N);
    /* unseeded rand to be deterministic across runs */
    srand(0xC0FFEE);
    for (long i = 0; i < N; ++i) a[i] = (unsigned char)(rand() & 0xff);
    volatile long sum = 0;
    for (long k = 0; k < iters; ++k)
        for (long i = 0; i < N; ++i)
            if (a[i] & 1) sum += a[i]; else sum -= a[i];
    printf("branch_random done sum=%ld\n", sum);
    free(a);
    return 0;
}
