#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#define DEFAULT_MB 256
typedef struct {double *a,*b,*c; size_t n; int iters;} arg_t;
void* worker(void* p){ arg_t* x=(arg_t*)p;
  for(int it=0;it<x->iters;it++){
    for(size_t i=0;i<x->n;i++) x->c[i]=x->a[i]+x->b[i]*2.5;
    for(size_t i=0;i<x->n;i++) x->a[i]=x->c[i];
  } return NULL; }
int main(int ac,char**av){
  int T=ac>1?atoi(av[1]):12;
  int IT=ac>2?atoi(av[2]):1;
  int MB=ac>3?atoi(av[3]):DEFAULT_MB;
  size_t bytes=(size_t)MB*1024*1024;
  size_t n=bytes/sizeof(double);
  pthread_t t[T]; arg_t a[T];
  for(int i=0;i<T;i++){
    a[i].a=aligned_alloc(64,n*8); a[i].b=aligned_alloc(64,n*8); a[i].c=aligned_alloc(64,n*8);
    for(size_t j=0;j<n;j++){a[i].a[j]=j*1.0; a[i].b[j]=j*2.0;}
    a[i].n=n; a[i].iters=IT; pthread_create(&t[i],NULL,worker,&a[i]);
  } for(int i=0;i<T;i++) pthread_join(t[i],NULL);
  printf("mhammer done: %d threads x %d iters x %d MB\n", T, IT, MB);
  return 0; }
