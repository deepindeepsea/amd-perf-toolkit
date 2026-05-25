#!/bin/bash
# L2-PF composite umask sweep — events 0x70/0x71/0x72 across umasks
set -u
OUT=/tmp/l2pf_out.txt; : > $OUT
exec >>$OUT 2>&1
echo "host=$(hostname) kernel=$(uname -r) date=$(date -u +%FT%TZ)"

# Build mhammer if needed
if [ ! -x /tmp/mhammer ]; then
  which gcc >/dev/null 2>&1 || sudo apt-get install -y -q gcc 2>&1 | tail -2
  cat > /tmp/mhammer.c <<'C'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#define N (256ULL*1024*1024)
typedef struct {double *a,*b,*c; size_t n; int iters;} arg_t;
void* worker(void* p){ arg_t* x=(arg_t*)p;
  for(int it=0;it<x->iters;it++){
    for(size_t i=0;i<x->n;i++) x->c[i]=x->a[i]+x->b[i]*2.5;
    for(size_t i=0;i<x->n;i++) x->a[i]=x->c[i];
  } return NULL; }
int main(int ac,char**av){ int T=ac>1?atoi(av[1]):12, IT=ac>2?atoi(av[2]):1;
  pthread_t t[T]; arg_t a[T]; size_t n=N/sizeof(double);
  for(int i=0;i<T;i++){
    a[i].a=aligned_alloc(64,n*8); a[i].b=aligned_alloc(64,n*8); a[i].c=aligned_alloc(64,n*8);
    for(size_t j=0;j<n;j++){a[i].a[j]=j*1.0; a[i].b[j]=j*2.0;}
    a[i].n=n; a[i].iters=IT; pthread_create(&t[i],NULL,worker,&a[i]);
  } for(int i=0;i<T;i++) pthread_join(t[i],NULL); return 0; }
C
  gcc -O2 -pthread -o /tmp/mhammer /tmp/mhammer.c
fi

EVENTS="0x70 0x71 0x72"
UMASKS="0x01 0x02 0x04 0x08 0x10 0x1f 0xff"

echo "--- L2 PF sweep ---"
printf "%-6s %-6s %-15s %-10s\n" "EVT" "UMASK" "COUNT" "STATUS"
for E in $EVENTS; do
  for U in $UMASKS; do
    O=$(sudo timeout 12 perf stat -x, -e "cpu/event=$E,umask=$U/" -- /tmp/mhammer 8 1 2>&1)
    L=$(echo "$O" | grep -E "^[0-9<]" | head -1)
    C=$(echo "$L" | cut -d, -f1)
    S=OK
    [ "$C" = "<not supported>" ] && S=NOT_SUPP
    [ "$C" = "0" ] && S=ZERO
    [ -z "$C" ] && { C="-"; S=NO_OUT; }
    printf "%-6s %-6s %-15s %-10s\n" "$E" "$U" "$C" "$S"
  done
done

# Also try named events for comparison
echo "--- named L2 PF events ---"
for NE in l2_pf_hit_l2 l2_pf_miss_l2_hit_l3 l2_pf_miss_l2_l3; do
  O=$(sudo timeout 12 perf stat -x, -e "$NE" -- /tmp/mhammer 8 1 2>&1)
  L=$(echo "$O" | grep -E "^[0-9<]" | head -1)
  echo "$NE => $L"
done

echo "--- done ---"
