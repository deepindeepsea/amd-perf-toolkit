CC      ?= gcc
CFLAGS  ?= -O2 -Wall -Wno-unused-result
LDFLAGS ?=

BINS := fp_avx branch_random l2_pressure dram_stream tlb_thrash syscall_heavy ccd_pingpong stream

all: $(BINS)

fp_avx:        fp_avx.c        ; $(CC) $(CFLAGS) -mavx2 -mfma -o $@ $<
branch_random: branch_random.c ; $(CC) $(CFLAGS) -o $@ $<
l2_pressure:   l2_pressure.c   ; $(CC) $(CFLAGS) -o $@ $<
dram_stream:   dram_stream.c   ; $(CC) $(CFLAGS) -o $@ $<
tlb_thrash:    tlb_thrash.c    ; $(CC) $(CFLAGS) -o $@ $<
syscall_heavy: syscall_heavy.c ; $(CC) $(CFLAGS) -o $@ $<
ccd_pingpong:  ccd_pingpong.c  ; $(CC) $(CFLAGS) -pthread -o $@ $<
stream:        stream.c        ; $(CC) $(CFLAGS) -o $@ $<

clean: ; rm -f $(BINS)
.PHONY: all clean
