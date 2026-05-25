/* fp_avx.c — saturate the FP/SSE/AVX retire pipe.
   Tags FP retired-ops counters (fp_ret_sse_avx_ops, fp_pack_ops_retired,
   sse_avx_ops_retired, fp_ops_retired_by_width/type).
   Compile: gcc -O2 -mavx2 -mfma fp_avx.c -o fp_avx                          */
#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv) {
    long iters = (argc>1)? atol(argv[1]) : 200000000L;
    __m256 a = _mm256_set1_ps(1.0001f);
    __m256 b = _mm256_set1_ps(0.9999f);
    __m256 c = _mm256_setzero_ps();
    for (long i = 0; i < iters; ++i) {
        c = _mm256_fmadd_ps(a, b, c);
        c = _mm256_fmadd_ps(c, a, b);
    }
    float buf[8]; _mm256_storeu_ps(buf, c);
    printf("fp_avx done acc=%f\n", buf[0]);
    return 0;
}
