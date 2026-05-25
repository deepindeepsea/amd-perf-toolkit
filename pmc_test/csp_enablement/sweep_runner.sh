#!/bin/bash
set -u
sudo sysctl -w kernel.perf_event_paranoid=-1 >/dev/null 2>&1

echo "=== Install gcc ==="
if ! command -v gcc >/dev/null; then
  sudo apt-get update -qq >/dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq gcc >/dev/null 2>&1
fi
gcc --version | head -1

echo ""
echo "=== Build mhammer (STREAM-style) ==="
cat > /tmp/mhammer.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#define N (256ULL*1024*1024)
typedef struct { double *a,*b,*c; size_t n; int iters; } arg_t;
void* worker(void* p){
    arg_t* x=(arg_t*)p;
    for(int it=0; it<x->iters; it++){
        for(size_t i=0;i<x->n;i++) x->c[i]=x->a[i]+x->b[i]*2.5;
        for(size_t i=0;i<x->n;i++) x->a[i]=x->c[i];
    }
    return NULL;
}
int main(int argc, char**argv){
    int nthreads = argc>1 ? atoi(argv[1]) : 24;
    int iters    = argc>2 ? atoi(argv[2]) : 2;
    size_t per = N/sizeof(double);
    pthread_t* tids = calloc(nthreads, sizeof(pthread_t));
    arg_t* args = calloc(nthreads, sizeof(arg_t));
    for(int t=0;t<nthreads;t++){
        args[t].a=aligned_alloc(64, per*sizeof(double));
        args[t].b=aligned_alloc(64, per*sizeof(double));
        args[t].c=aligned_alloc(64, per*sizeof(double));
        for(size_t i=0;i<per;i++){args[t].a[i]=i*1.0; args[t].b[i]=i*2.0;}
        args[t].n=per; args[t].iters=iters;
    }
    for(int t=0;t<nthreads;t++) pthread_create(&tids[t],NULL,worker,&args[t]);
    for(int t=0;t<nthreads;t++) pthread_join(tids[t],NULL);
    return 0;
}
CEOF
gcc -O2 -pthread /tmp/mhammer.c -o /tmp/mhammer && echo "built OK"
echo "warmup time:"; time /tmp/mhammer 12 1 2>&1

echo ""
echo "=== ALL-EVENT SWEEP (CSV mode) ==="
EVENTS="
ls_not_halted_cyc
cpu-cycles
instructions
ex_ret_instr
ex_ret_ops
ex_ret_brn
ex_ret_brn_misp
ex_ret_brn_far
ex_ret_brn_tkn
ex_ret_near_ret
de_no_dispatch_per_slot.no_ops_from_frontend
de_no_dispatch_per_slot.backend_stalls
de_no_dispatch_per_slot.smt_contention
de_src_op_disp.op_cache
ex_no_retire.load_not_complete
ex_no_retire.not_complete
op_cache_hit_miss.op_cache_hit
op_cache_hit_miss.op_cache_miss
op_cache_hit_miss.all_op_cache_accesses
ic_tag_hit_miss.instruction_cache_hit
ic_tag_hit_miss.instruction_cache_miss
ic_tag_hit_miss.all_instruction_cache_accesses
ls_any_fills_from_sys.local_l2
ls_any_fills_from_sys.local_ccx
ls_any_fills_from_sys.near_cache
ls_any_fills_from_sys.dram_io_near
ls_any_fills_from_sys.far_cache
ls_any_fills_from_sys.dram_io_far
ls_any_fills_from_sys.all
ls_dmnd_fills_from_sys.local_l2
ls_dmnd_fills_from_sys.local_ccx
ls_dmnd_fills_from_sys.near_cache
ls_dmnd_fills_from_sys.dram_io_near
ls_dmnd_fills_from_sys.far_cache
ls_dmnd_fills_from_sys.all
bp_l1_tlb_miss_l2_tlb_hit
bp_l1_tlb_miss_l2_tlb_miss.all
bp_l1_tlb_miss_l2_tlb_miss.if4k
bp_l1_tlb_miss_l2_tlb_miss.if2m
bp_l1_tlb_miss_l2_tlb_miss.if1g
l2_cache_req_stat.dc_hit_in_l2
l2_cache_req_stat.ls_rd_blk_c
l2_cache_req_stat.ic_fill_miss
l2_cache_req_stat.ic_hit_in_l2
ls_l1_d_tlb_miss.all
ls_l1_d_tlb_miss.all_l2_miss
iTLB-loads
iTLB-load-misses
dTLB-loads
dTLB-load-misses
"

printf '%-55s %-14s %s\n' EVENT STATUS COUNT
echo "------------------------------------------------------------------------------"
for E in $EVENTS; do
  [ -z "$E" ] && continue
  OUT=$(sudo timeout 15 perf stat -x, -e "$E" -- /tmp/mhammer 12 1 2>&1)
  L=$(echo "$OUT" | grep -E "^[0-9<]" | head -1)
  if echo "$L" | grep -q "not supported"; then
    printf '%-55s %-14s %s\n' "$E" "NOT_SUPP" "-"
  elif echo "$L" | grep -q "not counted"; then
    printf '%-55s %-14s %s\n' "$E" "NOT_CNT" "-"
  else
    CNT=$(echo "$L" | cut -d, -f1)
    if [ -z "$CNT" ] || [ "$CNT" = "0" ]; then
      printf '%-55s %-14s %s\n' "$E" "ZERO" "${CNT:-0}"
    else
      printf '%-55s %-14s %s\n' "$E" "OK" "$CNT"
    fi
  fi
done

echo ""
echo "=== IBS check ==="
sudo timeout 5 perf stat -e ibs_op// -- sleep 1 2>&1 | tail -5 || echo "ibs unavail"
