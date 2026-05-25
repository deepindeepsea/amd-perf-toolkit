/* Minimal STREAM (McCalpin) — adapted to fit alongside the other PMC workloads.
   Args: stream <MB> <ntimes>      defaults: 256 MB, 10 iters
   Reports MB/s for Copy, Scale, Add, Triad. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>

static double tnow(void){ struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec + t.tv_nsec/1e9; }

int main(int argc, char** argv){
    long mb     = (argc > 1) ? atol(argv[1]) : 256;
    int  ntimes = (argc > 2) ? atoi(argv[2]) : 10;
    size_t N = (mb * 1024L * 1024L) / sizeof(double);
    double *a = aligned_alloc(64, N*sizeof(double));
    double *b = aligned_alloc(64, N*sizeof(double));
    double *c = aligned_alloc(64, N*sizeof(double));
    if(!a||!b||!c){ perror("alloc"); return 1; }
    for(size_t i=0;i<N;i++){ a[i]=1.0; b[i]=2.0; c[i]=0.0; }
    double scalar = 3.0;
    double best[4] = {1e30,1e30,1e30,1e30};
    size_t bytes[4] = { 2*sizeof(double)*N, 2*sizeof(double)*N, 3*sizeof(double)*N, 3*sizeof(double)*N };
    for(int k=0;k<ntimes;k++){
        double t;
        t=tnow(); for(size_t i=0;i<N;i++) c[i]=a[i];                 t=tnow()-t; if(t<best[0]) best[0]=t;
        t=tnow(); for(size_t i=0;i<N;i++) b[i]=scalar*c[i];          t=tnow()-t; if(t<best[1]) best[1]=t;
        t=tnow(); for(size_t i=0;i<N;i++) c[i]=a[i]+b[i];            t=tnow()-t; if(t<best[2]) best[2]=t;
        t=tnow(); for(size_t i=0;i<N;i++) a[i]=b[i]+scalar*c[i];     t=tnow()-t; if(t<best[3]) best[3]=t;
    }
    const char* lbl[4]={"Copy","Scale","Add","Triad"};
    for(int i=0;i<4;i++) printf("%-6s %.1f MB/s\n", lbl[i], bytes[i]/best[i]/1e6);
    free(a); free(b); free(c);
    return 0;
}
