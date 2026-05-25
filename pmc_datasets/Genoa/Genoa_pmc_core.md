# Genoa — Core PMC Events (FP / LS / IC+BP / DE / EX / L2)

_Source: AMD PPR #55901 Rev 0.50 (Family 19h Model 11h B2 - Storm Peak; Zen 4 core IP = Genoa EPYC). Vol 1 pp.314-341_

_Total events: 103_


Events are listed in document order. Per-event, the table lists the UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.


## PMCxFFF — Merge

**Symbolic:** `Core::X86::Pmc::Core::Merge`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. 2.1.20.5 Core Performance Monitor Counters This section provides the core performance counter events that may be selected through Core::X86::Msr::PERF_CTL0[EventSelect[11:8],EventSelect[7:0],UnitMask]. See Core::X86::Msr::PERF_CTR. See Core::X86::Msr::PERF_LEGACY_CTL0..3 and Core::X86::Msr::PERF_LEGACY_CTR. |


## PMCx002 — FP — Retired x87 FP Ops

**Symbolic:** `Core::X86::Pmc::Core::FpRetx87FpOps`  

The number of x87 floating-point Ops that have retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `DivSqrROps` | Divide and square root Ops. |
| 1 | `MulOps` | Multiply Ops. |
| 0 | `AddSubOps` | Add/subtract Ops. |


## PMCx003 — FP — Retired SSE/AVX FLOPs

**Symbolic:** `Core::X86::Pmc::Core::FpRetSseAvxOps`  

This is a retire-based event. The number of retired SSE/AVX FLOPs. The number of events logged per cycle can vary from 0 to 64. This event requires the use of the MergeEvent since it can count above 15 events per cycle. See 2.1.20.4 [Large Increment per Cycle Events]. It does not provide a useful count without the use of the MergeEvent.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 |  | Reserved. |
| 4 | `BfloatMacFLOPs` | bfloat Multiply-Accumulate FLOPs. Each bfloat MAC operation is counted as 2 FLOPS. |
| 3 | `MacFLOPs` | Multiply-Accumulate FLOPs. Each MAC operation is counted as 2 FLOPS. This event does not include bfloat MAC operations. |
| 2 | `DivFLOPs` | Divide/square root FLOPs. |
| 1 | `MultFLOPs` | Multiply FLOPs. |
| 0 | `AddSubFLOPs` | Add/subtract FLOPs. AMD Confidential - Advance Information |


## PMCx005 — FP — Retired Serializing Ops

**Symbolic:** `Core::X86::Pmc::Core::FpRetiredSerOps`  

The number of serializing Ops retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `SseBotRet` | SSE/AVX bottom-executing ops retired. |
| 2 | `SseCtrlRet` | SSE/AVX control word mispredict traps. |
| 1 | `X87BotRet` | x87 bottom-executing ops retired. |
| 0 | `X87CtrlRet` | x87 control word mispredict traps due to mispredictions in RC or PC, or changes in Exception Mask bits. |


## PMCx008 — FP — Retired FP Ops By Width

**Symbolic:** `Core::X86::Pmc::Core::FpOpsRetiredByWidth`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 |  | Reserved. |
| 5 | `Pack512uOpsRetired` | Number of packed 512-bit ops retired. |
| 4 | `Pack256uOpsRetired` | Number of packed 256-bit ops retired. |
| 3 | `Pack128uOpsRetired` | Number of packed 128-bit ops retired. |
| 2 | `ScalaruOpsRetired` | Number of scalar ops retired. |
| 1 | `MMXuOpsRetired` | Number of MMX ops retired. |
| 0 | `x87uOpsRetired` | Number of x87 ops retired. AMD Confidential - Advance Information |


## PMCx00A — FP — Retired FP Ops By Type

**Symbolic:** `Core::X86::Pmc::Core::FpOpsRetiredByType`  

Note: Shuffle op counts may count for instructions that are not necessarily thought of as including shuffles. For example, Horizontal Add, Dot Product, and certain MOV instructions may include or use only shuffle type ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `VectorFpOpType` | ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 5h Div 6h Sqrt 7h Cmp 8h Cvt 9h Blend Ah Reserved. Bh Shuffle Ch Reserved. Dh Logical Eh Other Fh All |
| 3:0 | `ScalarFpOpType` | ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 5h Div 6h Sqrt 7h Cmp 8h Cvt 9h Blend Dh-Ah Reserved. Eh Other Fh All AMD Confidential - Advance Information |


## PMCx00B — FP — INT Ops Retired

**Symbolic:** `Core::X86::Pmc::Core::SseAvxOpsRetired`  

Note: Shuffle op counts may count for instructions that are not necessarily thought of as including shuffles. For example, Horizontal Add, Dot Product, and certain MOV instructions may include or use only shuffle type ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `SseAvxOpType` | ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 5h AES 6h SHA 7h Cmp 8h CLM 9h Shift Ah Mov Bh Shuffle Ch Pack Dh Logical Eh Other Fh All |
| 3:0 | `MmxOpType` | ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 6h-5h Reserved. 7h Cmp 8h Reserved. 9h Shift Ah Mov Bh Shuffle Ch Pack Dh Logical Eh Other Fh All AMD Confidential - Advance Information |


## PMCx00C — FP — Packed FP Ops Retired

**Symbolic:** `Core::X86::Pmc::Core::FpPackOpsRetired`  

Note: Shuffle op counts may count for instructions that are not necessarily thought of as including shuffles. For example, Horizontal Add, Dot Product, and certain MOV instructions may include or use only shuffle type ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `Fp256OpType` | ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 5h Div 6h Sqrt 7h Cmp 8h Cvt 9h Blend Ah Reserved. Bh Shuffle Ch Reserved. Dh Logical Eh Other Fh All |
| 3:0 | `Fp128OpType` | ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 5h Div 6h Sqrt 7h Cmp 8h Cvt 9h Blend Ah Reserved. Bh Shuffle Ch Reserved. Dh Logical Eh Other Fh All AMD Confidential - Advance Information |


## PMCx00D — FP — Packed INT Ops Retired

**Symbolic:** `Core::X86::Pmc::Core::PackedIntOpType`  

Note: Shuffle op counts may count for instructions that are not necessarily thought of as including shuffles. For example, Horizontal Add, Dot Product, and certain MOV instructions may include or use only shuffle type ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `Int256OpType` | This event also counts FP data type packed and scalar MOV and shuffle operations. ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 6h-5h Reserved. 7h Cmp 8h Reserved. 9h Shift Ah Mov Bh Shuffle Ch Pack Dh Logical Eh Other Fh All |
| 3:0 | `Int128OpType` | This event also counts FP data type packed and scalar MOV and shuffle operations. ValidValues: Value Description 0h None 1h Add 2h Sub 3h Mul 4h Mac 5h AES 6h SHA 7h Cmp 8h CLM 9h Shift Ah Mov Bh Shuffle Ch Pack Dh Logical Eh Other Fh All AMD Confidential - Advance Information |


## PMCx00E — FP — FP Dispatch Faults

**Symbolic:** `Core::X86::Pmc::Core::FpDispFaults`  

Floating-point Dispatch Faults.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `YmmSpillFault` | YMM Spill fault. |
| 2 | `YmmFillFault` | YMM Fill fault. |
| 1 | `XmmFillFault` | XMM Fill fault. |
| 0 | `x87FillFault` | x87 Fill fault. |


## PMCx024 — LS — Bad Status 2

**Symbolic:** `Core::X86::Pmc::Core::LsBadStatus2`  

Store To Load Interlock (STLI) are loads that were unable to complete because of a possible match with an older store, and the older store could not do STLF for some reason. There are a number of reasons why this occurs, and this perfmon organizes them into three major groups. UnitMask events are ORed within same pipe and then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `StlfNoData` | The load is capable of forwarding from an older store (i.e. the address match/overlap between the load and the older store) was good and everything works from an address perspective, but the store's data has not been produced by the execution unit or floating point unit yet so it can't be forwarded. |
| 1 | `StliOther` | Store-to-load conflicts: A load was unable to complete due to a non-forwardable conflict with an older store. Most commonly, a load's address range partially but not completely overlaps with an uncompleted older store. Software can avoid this problem by using same-size and same-alignment loads and stores when accessing the same data. Vector/SIMD code is particularly susceptible to this problem; software should construct wide vector stores by manipulating vector elements in registers using shuffle/blend/swap instructions prior to storing to memory, instead of using narrow element-by-element stores. |
| 0 | `StliNoState` | The STLF candidate does not have a DC hit and a valid DC way for a successful STLF. |


## PMCx025 — LS — Retired Lock Instructions

**Symbolic:** `Core::X86::Pmc::Core::LsLocks`  

UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `SpecLockHiSpec` | High speculative cacheable lock speculation succeeded. |
| 2 | `SpecLockLoSpec` | Low speculative cacheable lock speculation succeeded. |
| 1 | `NonSpecLock` | Non speculative cacheable lock. |
| 0 | `BusLock` | Non-cacheable or cacheline-misaligned lock. Comparable to legacy bus lock. |


## PMCx026 — LS — Retired CLFLUSH Instructions

**Symbolic:** `Core::X86::Pmc::Core::LsRetClClush`  

The number of retired CLFLUSH instructions. This is a non-speculative event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx027 — LS — Retired CPUID Instructions

**Symbolic:** `Core::X86::Pmc::Core::LsRetCpuid`  

The number of CPUID instructions retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx029 — LS — LS Dispatch

**Symbolic:** `Core::X86::Pmc::Core::LsDispatch`  

Counts the number of operations dispatched to the LS unit. Unit Masks events are ADDed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `LdStDispatch` | Load-op-Store Dispatch. Dispatch of an op that performs a load from and store to the same memory address. |
| 1 | `StoreDispatch` | Dispatch of an op that performs a memory store. |
| 0 | `LdDispatch` | Dispatch of an op that performs a memory load. |


## PMCx02B — LS — SMIs Received

**Symbolic:** `Core::X86::Pmc::Core::LsSmiRx`  

Counts the number of SMIs received.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx02C — LS — Interrupts Taken

**Symbolic:** `Core::X86::Pmc::Core::LsIntTaken`  

Counts the number of interrupts taken.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:1 |  | Reserved. |
| 0 | `IntTaken` | Number of Interrupts taken. This event is also counted when UnitMask[7:0]=0. |


## PMCx02D — LS — Time Stamp Counter Reads

**Symbolic:** `Core::X86::Pmc::Core::LsRdTsc`  

Counts the number of reads of the TSC. The count is speculative.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx035 — LS — Store to Load Forward

**Symbolic:** `Core::X86::Pmc::Core::LsSTLF`  

Number of STLF hits.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx037 — LS — Store Commit Cancels 2

**Symbolic:** `Core::X86::Pmc::Core::LsStCommitCancel2`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:1 |  | Reserved. |
| 0 | `StCommitCancelWcbFull` | A non-cacheable store and the non-cacheable commit buffer is full. AMD Confidential - Advance Information |


## PMCx040 — LS — Data Cache Accesses

**Symbolic:** `Core::X86::Pmc::Core::LsDcAccesses`  

The number of accesses to the data cache for load and store references. This may include certain microcode scratchpad accesses, although these are generally rare. Each increment represents an up to 32-byte access. Misaligned loads and stores may cause two or three data cache accesses.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx041 — LS — LS MAB Allocates by Type

**Symbolic:** `Core::X86::Pmc::Core::LsMabAlloc`  

Counts when a LS pipe allocates a MAB entry.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 |  | Reserved. |
| 6:0 | `LsMabAllocation` | ValidValues: Value Description 3Eh- Reserved. 00h 3Fh Load Store Allocations. 40h Hardware Prefetcher Allocations. 7Eh- Reserved. 41h 7Fh All Allocations. |


## PMCx043 — LS — Demand Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::LsDmndFillsFromSys`  

Demand Data Cache Fills by Data Source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Extension Memory. |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM or MMIO. |
| 5 |  | Reserved. |
| 4 | `NearFarCache_Far` | Requests that target another NUMA node and return from another CCX's cache. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO. |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX. |
| 0 | `LocalL2` | Data returned from local L2. AMD Confidential - Advance Information |


## PMCx044 — LS — Any Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::LsAnyFillsFromSys`  

Any Data Cache Fills by Data Source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Extension Memory. |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM. |
| 5 |  | Reserved. |
| 4 | `NearFarCache_Far` | Requests that target another NUMA node and return from another CCX's cache. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO. |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX. |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx045 — LS — L1 DTLB Misses

**Symbolic:** `Core::X86::Pmc::Core::LsL1DTlbMiss`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `TlbReload1GL2Miss` | DTLB reload to a 1-G page that also missed in the L2 TLB. |
| 6 | `TlbReload2ML2Miss` | DTLB reload to a 2-M page that also missed in the L2 TLB. |
| 5 | `TlbReloadCoalescedPageMiss` | DTLB reload to a coalesced page that also missed in the L2 TLB. |
| 4 | `TlbReload4KL2Miss` | DTLB reload to a 4-K page that missed the L2 TLB. |
| 3 | `TlbReload1GL2Hit` | DTLB reload to a 1-G page that hit in the L2 TLB. |
| 2 | `TlbReload2ML2Hit` | DTLB reload to a 2-M page that hit in the L2 TLB. |
| 1 | `TlbReloadCoalescedPageHit` | DTLB reload to a coalesced page that hit in the L2 TLB. |
| 0 | `TlbReload4KL2Hit` | DTLB reload to a 4-K page that hit in the L2 TLB. |


## PMCx046 — LS — Total Page Table Walks

**Symbolic:** `Core::X86::Pmc::Core::LsTablewalker`  

UnitMask events are ADDed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `TlbMabAllocIside` | Allocation of an I-side Tablewalk MAB. |
| 2 | `TlbMabAllocDside` | Allocation of a D-side Tablewalk MAB. |
| 1 | `TableWalkIside` | Allocation of an I-side Tablewalker. |
| 0 | `TableWalkDside` | Allocation of a D-side Tablewalker. |


## PMCx047 — LS — Misaligned loads

**Symbolic:** `Core::X86::Pmc::Core::LsMisalLoads`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:2 |  | Reserved. |
| 1 | `MA4K` | The number of 4-KB misaligned (i.e., page crossing) loads. |
| 0 | `MA64` | The number of 64-B misaligned (i.e., cacheline crossing) loads. AMD Confidential - Advance Information |


## PMCx048 — LS — Any Data Cache Fills by Data Source 2

**Symbolic:** `Core::X86::Pmc::Core::LsAnyFillsFromSys2`  

Any SCM type Data Cache fills by detailed data source. This event provides a further break-down of PMCx044 (Core::X86::Pmc::Core::LsAnyFillsFromSys[AlternateMemories_NearFar]) events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 |  | Reserved. |
| 5 | `Peer_Far` | Requests that target another NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator). |
| 4 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL™). |
| 3 |  | Reserved. |
| 2 | `Peer_Near` | Requests that target the same NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator). |
| 1 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL). |
| 0 |  | Reserved. |


## PMCx04B — LS — Prefetch Instructions Dispatched

**Symbolic:** `Core::X86::Pmc::Core::LsPrefInstrDisp`  

Software Prefetch Instructions Dispatched (Speculative).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `PREFETCHNTA` | PrefetchNTA instruction. See docAPM3 PREFETCHlevel. |
| 1 | `PREFETCHW` | PrefetchW instruction. See docAPM3 PREFETCHW. |
| 0 | `PREFETCH` | PrefetchT0, T1 and T2 instructions. See docAPM3 PREFETCHlevel. |


## PMCx04C — LS — HwPf Entries Allocated

**Symbolic:** `Core::X86::Pmc::Core::LsHwPfAlocated`  

Counts when a new entry is allocated in one of the prefetchers selected by UnitMask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `RegionAlloc` | Region prefetcher. |
| 1 | `StrideAlloc` | Stride prefetcher. |
| 0 | `StreamAlloc` | Stream prefetcher. |


## PMCx04D — LS — HwPf Entries Hit

**Symbolic:** `Core::X86::Pmc::Core::LsHwPfHit`  

Counts when a prefetcher training op hits on an existing entry in one of the prefetchers selected by UnitMask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `RegionHit` |  |
| 1 | `StrideHit` |  |
| 0 | `StreamHit` | AMD Confidential - Advance Information |


## PMCx04E — LS — Tablewalk latency

**Symbolic:** `Core::X86::Pmc::Core::LsL1TlbRelLat`  

TLB MAB allocation is generally find first from 0 to 5. Counts one for each cycle that a selected TLB MAB is allocated and is performing a tablewalk (has seen a leaf-level miss). Masks[5:0] select the tablewalk MAB and Masks[6] and [7] select the source of the tablewalk (ITLB or DTLB)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountISideWalks` | Counts cycles when TLB-MAB I-side is performing a tablewalk. |
| 6 | `CountDSideWalks` | Counts cycles when TLB-MAB D-side is performing a tablewalk. |
| 5 | `TlbMab5` | Counts cycles when TLB-MAB 5 is allocated. |
| 4 | `TlbMab4` | Counts cycles when TLB-MAB 4 is allocated. |
| 3 | `TlbMab3` | Counts cycles when TLB-MAB 3 is allocated. |
| 2 | `TlbMab2` | Counts cycles when TLB-MAB 2 is allocated. |
| 1 | `TlbMab1` | Counts cycles when TLB-MAB 1 is allocated. |
| 0 | `TlbMab0` | Counts cycles when TLB-MAB 0 is allocated. |


## PMCx050 — LS — Write Combine Buffer Close Flush

**Symbolic:** `Core::X86::Pmc::Core::LsWcbCloseFlush`  

UnitMask events ADDed. Multible WCB can report events at the same time.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LdHit` | WCB hit by a younger load. |
| 6 | `SmcHit` | WCB hit by SMC probe. |
| 5 | `Timer` | WCB timer expired. |
| 4 | `WcbFull` | WCB full and a non-cacheable store needs to commit. |
| 3 | `Barrier` | Closed dure to barrier (a non-combinable, non-cacheable store committed). |
| 2 | `WfqVirtCrBuslock` |  |
| 1 | `NeedSbex` | LDQ requested WCB close due to SBEX op. |
| 0 | `FullLine64B` | All 64 bytes of the WCB entry have been written. |


## PMCx052 — LS — Ineffective Software Prefetches

**Symbolic:** `Core::X86::Pmc::Core::LsInefSwPref`  

The number of software prefetches that did not fetch data outside of the processor core.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:2 |  | Reserved. |
| 1 | `MabMchCnt` | Software PREFETCH instruction saw a match on an already-allocated miss request buffer. |
| 0 | `DataPipeSwPfDcHit` | Software PREFETCH instruction saw a DC hit. |


## PMCx055 — LS — MAB Match

**Symbolic:** `Core::X86::Pmc::Core::LsMabMchCnt`  

Counts load flows (no HW prefetches) that requested a MAB and hit on an existing MAB entry.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx057 — LS — Hw Prefetch MAB Allocation

**Symbolic:** `Core::X86::Pmc::Core::LsHwPfMabAlloc`  

Counts MAB allocations by various HW prefetchers. The UnitMask bits control the types of prefetchers that are considered for counting MAB allocations.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `L2Stride` |  |
| 2 | `Region` |  |
| 1 | `L1Stride` |  |
| 0 | `Stream` |  |


## PMCx058 — LS — Hw Prefetch MAB Match

**Symbolic:** `Core::X86::Pmc::Core::LsHwPfMabMatch`  

Counts MAB matches by various HW prefetchers. The UnitMask bits control the types of prefetchers that are considered for counting MAB allocations.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `L2Stride` |  |
| 2 | `Region` |  |
| 1 | `L1Stride` |  |
| 0 | `Stream` |  |


## PMCx059 — LS — Software Prefetch Data Cache Fills

**Symbolic:** `Core::X86::Pmc::Core::LsSwPfDcFills`  

Software Prefetch Data Cache Fills by Data Source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Extension Memory. |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM or MMIO. |
| 5 |  | Reserved. |
| 4 | `NearFarCache_Far` | Requests that target another NUMA node and return from another CCX's cache. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO. |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX. |
| 0 | `LocalL2` | Data returned from local L2. AMD Confidential - Advance Information |


## PMCx05A — LS — Hardware Prefetch Data Cache Fills

**Symbolic:** `Core::X86::Pmc::Core::LsHwPfDcFills`  

Hardware Prefetch Data Cache Fills by Data Source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Extension Memory. |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM or MMIO. |
| 5 |  | Reserved. |
| 4 | `NearFarCache_Far` | Requests that target another NUMA node and return from another CCX's cache. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO. |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX. |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx05B — LS — Table Walker Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::LsTwDcFills`  

Tablewalker Data Cache Fills by Data Source. Mask OR'd.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DFCache_LongLat_Peer_NearFar` | Requests that return from alternate memories (Extension Memory, Peer Agent Memory). |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM or MMIO. |
| 5 |  | Reserved. |
| 4 | `NearFarCache_Far` | Requests that target another NUMA node and return from another CCX's cache. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO. |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX. |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx05F — LS — Count of Allocated Mabs

**Symbolic:** `Core::X86::Pmc::Core::LsAllocMabCount`  

This event counts the in-flight L1 data cache misses (allocated Miss Address Buffers) each cycle.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx06E — LS — Tablewalker Init level

**Symbolic:** `Core::X86::Pmc::Core::LsTwInitLevel`  

Counts the level at which a tablewalk starts. If the tablewalk does not hit on a cached entry the walk starts from CR3. Otherwise it can start at intermediate page table entries.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountNested` |  |
| 6 | `CountGuestHost` |  |
| 5 | `RdPml5e` | Counts tablewalks that start at CR3 with 5-level paging (CR4.LA57 = 1). |
| 4 | `RdPml4e` | Counts tablewalks that start at CR3 with 4-level paging (CR4.LA57 = 0) and read a PLM4E or hit a cached PLM5E. |
| 3 | `RdPdpe` | Counts tablewalks that start at a cached PLM4E and read a PDPE. |
| 2 | `RdPde` | Counts tablewalks that start at a cached PDPE and read a PDE. |
| 1 | `RdPte` | Counts tablewalks that start at a cached PDE and read a PTE. |
| 0 | `HitLeaf` | Counts tablewalks that start at a cached PTE. |


## PMCx076 — LS — Cycles not in Halt

**Symbolic:** `Core::X86::Pmc::Core::LsNotHaltedCyc`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx078 — LS — All TLB Flushes

**Symbolic:** `Core::X86::Pmc::Core::LsTlbFlush`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `All` | ValidValues: Value Description FEh- Reserved. 00h FFh All TLB Flushes. |


## PMCx120 — LS — P0 Freq Cycles not in Halt

**Symbolic:** `Core::X86::Pmc::Core::LsNotHaltedP0Cyc`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:1 |  | Reserved. |
| 0 | `P0FreqCyc` | Counts at the P0 frequency (same as Core::X86::Msr::MPERF) when not in Halt. AMD Confidential - Advance Information |


## PMCx170 — LS — Tablewalker return types

**Symbolic:** `Core::X86::Pmc::Core::LsTwReturnTypes`  

Counts the type of table walk responses to the TLBs. UnitMask events 0-5 are ORed. UnitMasks 6 and 7 qualify the type of TLB (ITLB, DTLB or both) included in the count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountIside` | Include tablewalker returns to the ITLB. |
| 6 | `CountDside` | Include tablewalker returns to the DTLB. |
| 5 | `SbexFault` | A non-speculative (SBEX) tablewalk returned a page fault. |
| 4 | `SbexVal` | A non-speculative (SBEX) tablewalk returned a valid translation. |
| 3 | `SpecADbitNeeded` | A speculative tablewalk requires A/D bit update. |
| 2 | `SpecFault` | A speculative tablewalk returned a page fault. |
| 1 | `Retry` | Tablewalk is a retry. |
| 0 | `SpecVal` | A speculative tablewalk returned a valid translation. |


## PMCx080 — IC_BP — Total Number of 32B Instruction Fetches

**Symbolic:** `Core::X86::Pmc::Core::IcFw32`  

The number of 32-B instruction cache fetches transferred to the instruction decoder.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx081 — IC_BP — Number of 32B Instruction Fetches that Miss in Instruction Cache

**Symbolic:** `Core::X86::Pmc::Core::IcFw32Miss`  

The number of 32B fetches that tried to read the L1 instruction cache and missed. .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx082 — IC_BP — Instruction Cache Refills from L2

**Symbolic:** `Core::X86::Pmc::Core::IcCacheFillL2`  

The number of 64-byte instruction cache lines fulfilled from the L2 cache.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx083 — IC_BP — Instruction Cache Refills from System

**Symbolic:** `Core::X86::Pmc::Core::IcCacheFillSys`  

The number of 64-byte instruction cache line fulfilled from system memory or another cache.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx084 — IC_BP — L1 ITLB Miss, L2 ITLB Hit

**Symbolic:** `Core::X86::Pmc::Core::BpL1TlbMissL2TlbHit`  

The number of instruction fetches that miss in the L1 ITLB but hit in the L2 ITLB.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx085 — IC_BP — ITLB Reload from Page-Table walk

**Symbolic:** `Core::X86::Pmc::Core::BpL1TlbMissL2TlbMiss`  

The number of valid fills into the ITLB originating from the LS Page-Table Walker. Tablewalk requests are issued for L1-ITLB and L2-ITLB misses.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 |  | Reserved. |
| 3 | `Coalesced4K` | Walk for >4-K Coalesced page. |
| 2 | `IF1G` | Walk for 1-G page. |
| 1 | `IF2M` | Walk for 2-M page. |
| 0 | `IF4K` | Walk to 4-K page. |


## PMCx08A — IC_BP — L1 Branch Target Buffer Hit

**Symbolic:** `Core::X86::Pmc::Core::BpL1BtbHit`  

Counts hits in the L1 BTB.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx08B — IC_BP — L2 Branch Prediction Overrides Existing Prediction (speculative)

**Symbolic:** `Core::X86::Pmc::Core::BpL2BTBCorrect`  

Counts L2 branch prediction overrides by L2 BTB hits.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx08C — IC_BP — Instruction Cache Lines Invalidated

**Symbolic:** `Core::X86::Pmc::Core::IcCacheInval`  

The number of instruction cache lines invalidated. A non-SMC event is CMC (cross modifying code), either from the other thread of the same core or another core.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:2 |  | Reserved. |
| 1 | `L2InvalidatingProbe` | IC line invalidated due to an invalidating probe. |
| 0 | `FillInvalidated` | IC line invalidated due to overwriting fill response. |


## PMCx08E — IC_BP — Dynamic Indirect Predictions

**Symbolic:** `Core::X86::Pmc::Core::BpDynIndPred`  

The number of times a branch used the indirect predictor to make a prediction.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx091 — IC_BP — Decode Redirects

**Symbolic:** `Core::X86::Pmc::Core::BpDeReDirect`  

The number of times the instruction decoder overrides the predicted target.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx094 — IC_BP — L1 TLB Hits for Instruction Fetch

**Symbolic:** `Core::X86::Pmc::Core::BpL1TlbFetchHit`  

The number of instruction fetches that hit in the L1 ITLB.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `IF1G` | L1 Instruction TLB hit (1-G page size). |
| 1 | `IF2M` | L1 Instruction TLB hit (2-M page size). |
| 0 | `IF4K` | L1 Instruction TLB hit (4-K or 16-K page size). |


## PMCx096 — IC_BP — Resyncs

**Symbolic:** `Core::X86::Pmc::Core::ResyncsOrNcRedirects`  

Counts the number of HW resyncs (pipeline restarts) or NC redirects. NC redirects occur when the front-end transitions to fetching from UC (un-cacheable) memory.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx099 — IC_BP — L1 ITLB Reloads

**Symbolic:** `Core::X86::Pmc::Core::BpTlbRel`  

TLB Reloads and Invalidations (counts the number of L1 ITLB writes in total including invalidations). Note that Reload here means any fill to the L1 TLB.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:2 |  | Reserved. |
| 1:0 | `L1ITLB_Reload_Invalidations` | L1 ITLB Reloads and Invalidations. ValidValues: Value Description 0h L1 ITLB Fills; L1 ITLB Fills including those from L2 TLB. This event includes 11b,01b,00b encoding. 1h Reserved. 2h ITLB Invalidations; Counts the number of invalidation requests; The invalidation request may result in any number of TLB entry invalidations. 3h Reserved. |


## PMCx188 — IC_BP — Fetch IBS events

**Symbolic:** `Core::X86::Pmc::Core::IcFetchIbs`  

Counts Fetch IBS related events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 |  | Reserved. |
| 4 | `SampleVal` | Counts collected IBS samples. Each collected IBS sample signals an interrupt. |
| 3 | `SampleFiltered` | Counts the number of tagged fetches that were discarded due to IBS filtering (Core::X86::Msr::IBS_FETCH_CTL[IbsL3MissOnly] set). When a tagged fetch is discarded the Fetch IBS facility will automatically tag a new fetch. |
| 2 | `SampleDiscarded` | Counts when the Fetch IBS facility discards an IBS tagged fetch for reasons other than IBS filtering. When a tagged fetch is discarded the Fetch IBS facility will automatically tag a new fetch. |
| 1 | `FetchTagged` | Counts the number of fetches tagged for Fetch IBS. Not all tagged fetches create an IBS interrupt and valid fetch sample. |
| 0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx189 — IC_BP — Predictor Flush Events

**Symbolic:** `Core::X86::Pmc::Core::BpPredFlush`  

Counts branch predictor flush events associated with security mitigations.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `RasOnlyFlush` | Indirect Branch Predictor Barrier: Only RAS flush was initiated for this thread. |
| 1 | `IndirPredFlushOther` | Indirect Branch Predictor Barrier. Flush of BTB, ITTAGE and RAS. The Flush was initiated by the other thread. |
| 0 | `IndirPredFlushSelf` | Indirect Branch Predictor Barrier. Flush of BTB, ITTAGE and RAS. The Flush was initiated by this thread. |


## PMCx18E — IC_BP — IC Tag Hit/Miss Events

**Symbolic:** `Core::X86::Pmc::Core::IcTagHitMiss`  

Counts various IC tag related hit and miss events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 |  | Reserved. |
| 4:0 | `IcAccessTypes` | Instruction Cache accesses. ValidValues: Value Description 06h-00h Reserved. 07h Instruction Cache Hit. 17h-08h Reserved. 18h Instruction Cache Miss. 1Eh- Reserved. 19h 1Fh All Instruction Cache Accesses. |


## PMCx28A — IC_BP — Switches Between Instruction Fetch and Op Cache Fetch Modes

**Symbolic:** `Core::X86::Pmc::Core::IcOcModeSwitch`  

Counts transitions between IC and OC fetches.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:2 |  | Reserved. |
| 1 | `OcIcModeSwitch` | OC to IC mode switch. |
| 0 | `IcOcModeSwitch` | IC to OC mode switch. AMD Confidential - Advance Information |


## PMCx28F — IC_BP — Op Cache Hit/Miss

**Symbolic:** `Core::X86::Pmc::Core::OpCacheHitMiss`  

Counts Op Cache micro-tag hit/miss events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2:0 | `OpCacheAccesses` | ValidValues: Value Description 2h-0h Reserved. 3h Op Cache Hit. 4h Op Cache Miss. 6h-5h Reserved. 7h All Op Cache accesses. |


## PMCx29C — IC_BP — Any Instruction Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::IcAnyFillsFromSys`  

Any Instruction Cache Fills by Data Source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DFCache_LongLat_Peer_NearFar` | FRequests that return from alternate memories (Extension Memory, Peer Agent Memory). |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM or MMIO. |
| 5 |  | Reserved. |
| 4 | `NearFarCache_Far` | Requests that return from another CCX cache in a different NUMA node. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO. |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX. |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx29D — IC_BP — Any Instruction Cache Fills by Data Source 2

**Symbolic:** `Core::X86::Pmc::Core::IcAnyFillsFromSys2`  

Any SCM type Instruction Cache fills by detailed data source. This event provides a further break-down of PMCx29C (Core::X86::Pmc::Core::IcAnyFillsFromSys[DFCache_LongLat_Peer_NearFar]) events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 |  | Reserved. |
| 5 | `Peer_Far` | Requests that target another NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator). |
| 4 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL). |
| 3 |  | Reserved. |
| 2 | `Peer_Near` | Requests that target the same NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator). |
| 1 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL). |
| 0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx0A9 — DE — Op Queue Empty

**Symbolic:** `Core::X86::Pmc::Core::DeOpQueueEmpty`  

Cycles where the Op Queue is empty.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0AA — DE — Source of Op Dispatched From Decoder

**Symbolic:** `Core::X86::Pmc::Core::DeSrcOpDisp`  

Counts the number of ops dispatched from the decoder classified by op source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `LoopBuffer` | Count of ops dispatched from Loop Buffer. |
| 1 | `OpCache` | Count of ops fetched from Op Cache and dispatched. |
| 0 | `Decoder` | Count of ops fetched from Instruction Cache and dispatched. |


## PMCx0AB — DE — Types of Ops Dispatched From Decoder

**Symbolic:** `Core::X86::Pmc::Core::DeDisOpsFromDecoder`  

Counts the number of ops dispatched from the decoder classified by op type. The UnitMask value encodes which types of ops are counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 |  | Reserved. |
| 4:0 | `DispOpType` | ValidValues: Value Description 03h-00h Reserved. 04h Any FP dispatch. 07h-05h Reserved. 08h Any Integer dispatch. 1Fh-09h Reserved. AMD Confidential - Advance Information |


## PMCx0AE — DE — Dispatch Resource Stall Cycles 1

**Symbolic:** `Core::X86::Pmc::Core::DeDisDispatchTokenStalls1`  

Cycles where a dispatch group is valid but does not get dispatched due to a Token Stall. UnitMask bits select the stall types included in the count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `FpFlushRecoveryStall` | Counts FP Flush Recovery stall cycles. |
| 6 | `FPSchRsrcStall` | FP scheduler resource stall. Counts FP Scheduler token stall cycles. . |
| 5 | `FpRegFileRsrcStall` | floating-point register file resource stall. Counts FP Register File token stall cycles. This applies to all ops that have an FP or SIMD destination register. . |
| 4 | `TakenBrnchBufferRsrc` | taken branch buffer resource stall. Counts Taken Branch Buffer token stall cycles. |
| 3 |  | Reserved. |
| 2 | `StoreQueueRsrcStall` | Store Queue resource stall. Counts Store Queue token stall cycles. |
| 1 | `LoadQueueRsrcStall` | Load Queue resource stall. Counts Load Queue token stall cycles. |
| 0 | `IntPhyRegFileRsrcStall` | Integer Physical Register File resource stall. Counts Integer PRF token stall cycles. This applies to all ops that have an integer destination register. |


## PMCx0AF — DE — Dynamic Tokens Dispatch Stall Cycles 2

**Symbolic:** `Core::X86::Pmc::Core::DeDisDispatchTokenStalls2`  

Cycles where a dispatch group is valid but does not get dispatched due to a token stall. UnitMask bits select the stall types included in the count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 |  | Reserved. |
| 5 | `RetireTokenStall` | Counts Retire Queue token stall cycles. |
| 4 |  | Reserved. |
| 3 | `IntSch3TokenStall` | Counts Integer Scheduler Queue 3 token stall cycles. |
| 2 | `IntSch2TokenStall` | Counts Integer Scheduler Queue 2 token stall cycles. |
| 1 | `IntSch1TokenStall` | Counts Integer Scheduler Queue 1 token stall cycles. |
| 0 | `IntSch0TokenStall` | Counts Integer Scheduler Queue 0 token stall cycles. |


## PMCx1A0 — DE — Dispatch Stalls Per Slot

**Symbolic:** `Core::X86::Pmc::Core::DeNoDispatchPerSlot`  

Counts the number of dispatch slots (each cycle) that remained unused for reasons selected by StallReason.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `StallReason` | ValidValues: Value Description 00h Reserved. 01h Counts dispatch slots left empty because the front-end did not supply ops. 1Dh- Reserved. 02h 1Eh Counts ops unable to dispatch due to back-end stalls. 5Fh- Reserved. 1Fh 60h Counts ops unable to dispatch because the dispatch cycle was granted to the other SMT thread. FFh- Reserved. 61h AMD Confidential - Advance Information |


## PMCx1A2 — DE — Dispatch Additional Resource Stalls

**Symbolic:** `Core::X86::Pmc::Core::DeAdditionalResourceStalls`  

This PMC event counts additional resource stalls that are not captured by Core::X86::Pmc::Core::DeDisDispatchTokenStalls1 or Core::X86::Pmc::Core::DeDisDispatchTokenStalls2.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Stall` | ValidValues: Value Description 2Fh-00h Reserved. 30h Counts additional cycles dispatch is stalled due to the lack of dispatch resources FFh- Reserved. 31h |


## PMCx0C0 — EX — Retired Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetInstr`  

The number of instructions retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C1 — EX — Retired Ops

**Symbolic:** `Core::X86::Pmc::Core::ExRetOps`  

The number of macro-ops retired. This count includes all processor activity (instructions, exceptions, interrupts, microcode assists, etc.). The number of events logged per cycle can vary from 0 to 8.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C2 — EX — Retired Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetBrn`  

The number of branch instructions retired. This includes all types of architectural control flow changes, including exceptions and interrupts.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C3 — EX — Retired Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::ExRetBrnMisp`  

The number of retired branch instructions, that were mispredicted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C4 — EX — Retired Taken Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetBrnTkn`  

The number of taken branches that were retired. This includes all types of architectural control flow changes, including exceptions and interrupts.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx0C5 — EX — Retired Taken Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::ExRetBrnTknMisp`  

The number of retired taken branch instructions that were mispredicted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C6 — EX — Retired Far Control Transfers

**Symbolic:** `Core::X86::Pmc::Core::ExRetBrnFar`  

The number of far control transfers retired including far call/jump/return, IRET, SYSCALL and SYSRET, plus exceptions and interrupts. Far control transfers are not subject to branch prediction.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C8 — EX — Retired Near Returns

**Symbolic:** `Core::X86::Pmc::Core::ExRetNearRet`  

The number of near return instructions (RET or RET Iw) retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0C9 — EX — Retired Near Returns Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::ExRetNearRetMispred`  

The number of near returns retired that were not correctly predicted by the return address predictor. Each such mispredict incurs the same penalty as a mispredicted conditional branch instruction.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0CA — EX — Retired Indirect Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::ExRetBrnIndMisp`  

The number of indirect branches retired that were not correctly predicted. Each such mispredict incurs the same penalty as a mispredicted conditional branch instruction. Note that only EX mispredicts are counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0CB — EX — Retired MMX/FP Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetMmxFpInstr`  

The number of MMX, SSE or x87 instructions retired. The UnitMask allows the selection of the individual classes of instructions as given in the table. Each increment represents one complete instruction. Since this event includes non- numeric instructions it is not suitable for measuring MFLOPs.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `SseInstr` | SSE instructions (SSE, SSE2, SSE3, SSSE3, SSE4A, SSE41, SSE42, AVX). |
| 1 | `MmxInstr` | MMX instructions. |
| 0 | `X87Instr` | x87 instructions. |


## PMCx0CC — EX — Retired Indirect Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetIndBrchInstr`  

The number of indirect branches retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx0D1 — EX — Retired Conditional Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetCond`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0D3 — EX — Div Cycles Busy count

**Symbolic:** `Core::X86::Pmc::Core::ExDivBusy`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0D4 — EX — Div Op Count

**Symbolic:** `Core::X86::Pmc::Core::ExDivCount`  

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx0D6 — EX — Cycles With No Retire

**Symbolic:** `Core::X86::Pmc::Core::ExNoRetire`  

This event counts cycles when the hardware thread does not retire any ops for reasons selected by UnitMask[4:0]. UnitMask events [4:0] are mutually exclusive. If multiple reasons apply for a given cycle, the lowest numbered UnitMask event is counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `CompletionFilter` | ValidValues: Value Description 0h Load and ALU completion is considered for UnitMask[1]:NotComplete events. 4h-1h Reserved. 5h Only missing load completion is considered for UnitMask[1]:NotComplete events. 7h-6h Reserved. |
| 4 | `ThreadNotSelected` | The number cycles where ops could have retired (i.e. did not fall into UnitMask events [0]...[3]). but did not retire because thread arbitration did not select the thread for retire. |
| 3 | `Other` | The number of cycles where ops could have retired (self and older ops are complete), but were stopped from retirement for other reasons: retire breaks, traps, faults, etc. |
| 2 |  | Reserved. |
| 1 | `NotComplete` | The number of cycles where the oldest retire slot did not have its completion bits set. |
| 0 | `Empty` | The number of cycles when there were no valid ops in the retire queue. This may be caused by front-end bottlenecks or pipeline redirects. |


## PMCx1C1 — EX — Retired Microcoded Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetUcodeInstr`  

Retired Microcoded Instructions.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx1C2 — EX — Retired Microcode Ops

**Symbolic:** `Core::X86::Pmc::Core::ExRetUcodeOps`  

The number of microcode ops that have retired.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx1C7 — EX — Retired Mispredicted Branch Instructions due to Direction Mismatch

**Symbolic:** `Core::X86::Pmc::Core::ExRetMsprdBrnchInstrDirMsmtch`  

The number of retired conditional branch instructions that were not correctly predicted because of a branch direction mismatch.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx1C8 — EX — Retired Unconditional Indirect Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::ExRetUncondBrnchInstrMispred`  

The number of retired unconditional indirect branch instructions that were mispredicted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx1C9 — EX — Retired Unconditional Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetUncondBrnchInstr`  

The number of retired unconditional branch instructions.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. |


## PMCx1CF — EX — Tagged IBS Ops

**Symbolic:** `Core::X86::Pmc::Core::ExTaggedIbsOps`  

Counts Op IBS related events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:3 |  | Reserved. |
| 2 | `IbsCountRollover` | Number of times an op could not be tagged by IBS because of a previous tagged op that has not retired. |
| 1 | `IbsTaggedOpsRet` | Number of Ops tagged by IBS that retired. |
| 0 | `IbsTaggedOps` | Number of Ops tagged by IBS. |


## PMCx1D0 — EX — Retired Fused Instructions

**Symbolic:** `Core::X86::Pmc::Core::ExRetFusedInstr`  

Counts retired fused instructions.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx060 — L2 — Requests to L2 Group1

**Symbolic:** `Core::X86::Pmc::L2::L2RequestG1`  

All L2 Cache Requests (Breakdown 1 - Common)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RdBlkL` | Data Cache Reads (including hardware and software prefetch). |
| 6 | `RdBlkX` | Data Cache Stores |
| 5 | `LsRdBlkC_S` | Data Cache Shared Reads |
| 4 | `CacheableIcRead` | Instruction Cache Reads. |
| 3 | `ChangeToX` | Data Cache State Change Requests. Request change to writable, check L2 for current state. |
| 2 | `PrefetchL2Cmd` | Does not count prefetches from core initiated by non-PrefetchL2 Cmd. Assume core should also count all types of prefetches and allow the breakdown between hardware versus software and data versus instruction. |
| 1 | `L2HwPf` | L2 Prefetcher. All prefetches accepted by L2 pipeline, hit or miss. Types of PF and L2 hit/miss broken out in a separate perfmon event |
| 0 | `Group2` | Miscellaneous events covered in more detail by Core::X86::Pmc::L2::L2RequestG2 (PMCx061). |


## PMCx061 — L2 — Requests to L2 Group2

**Symbolic:** `Core::X86::Pmc::L2::L2RequestG2`  

All L2 Cache Requests (Breakdown 2 - Rare).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Group1` | Miscellaneous events covered in more detail by Core::X86::Pmc::L2::L2RequestG1 (PMCx060). |
| 6 | `LsRdSized` | LS sized read, coherent non-cacheable. |
| 5 | `LsRdSizedNC` | LS sized read, non-coherent, non-cacheable. |
| 4 | `IcRdSized` | Instruction cache read sized. |
| 3 | `IcRdSizedNC` | Instruction cache read sized non-cacheable. |
| 2 | `SmcInval` | Self-modifying code invalidates. |
| 1 | `BusLockTLBSyncOriginator` | BusLocks or TLBSyncs originator. Counts if there is a Bus lock or TLBSync originating from this thread |
| 0 | `BusLockTLBSyncResponse` | BusLock or TLBSync responses. Counts if there is a Bus lock response or TLBSync response from this thread |


## PMCx063 — L2 — Write Combining Buffer Requests

**Symbolic:** `Core::X86::Pmc::L2::L2WcbReq`  

Write Combining Buffer operations. For information on Write Combining see docAPM2 sections: Memory System, Memory Types, Buffering and Combining Memory Writes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 |  | Reserved. |
| 6 | `WcbWrite` | Write Combining Buffer write |
| 5 | `WcbClose` | Write Combining Buffer close |
| 4:0 |  | Reserved. AMD Confidential - Advance Information |


## PMCx064 — L2 — Core to L2 Cacheable Request Access Status

**Symbolic:** `Core::X86::Pmc::L2::L2CacheReqStat`  

L2 Cache Request Outcomes (not including L2 Prefetch).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LsRdBlkCS` | Data Cache Shared Read Hit in L2. LsRdBlkCS |
| 6 | `LsRdBlkLHitX` | Data Cache Read Hit in L2. Modifiable |
| 5 | `LsRdBlkLHitS` | Data Cache Read Hit Non-Modifiable Line in L2. |
| 4 | `LsRdBlkX` | Data Cache Store or State Change Hit in L2. |
| 3 | `LsRdBlkC` | Data Cache Req Miss in L2. |
| 2 | `IcFillHitX` | Instruction Cache Hit Modifiable Line in L2. IcFillHitX |
| 1 | `IcFillHitS` | Instruction Cache Hit Non-Modifiable Line in L2.. |
| 0 | `IcFillMiss` | Instruction Cache Req Miss in L2. IcFillMiss |


## PMCx070 — L2 — L2 Prefetch Hit in L2

**Symbolic:** `Core::X86::Pmc::L2::L2PfHitL2`  

Counts all L2 prefetches accepted by L2 pipeline which hit in the L2 cache.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Prefetches` | ValidValues: Value Description 1Eh- Reserved. 00h 1Fh Counts requests generated from L2 Hardware Prefetchers. DFh- Reserved. 20h E0h Counts requests generated from L1 DC Hardware Prefetchers. FEh- Reserved. E1h FFh Counts requests generated from L1 DC and L2 Hardware Prefetchers. |


## PMCx071 — L2 — L2 Prefetcher Hits in L3

**Symbolic:** `Core::X86::Pmc::L2::L2PfMissL2HitL3`  

Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Prefetches` | L2Stream ValidValues: Value Description 1Eh- Reserved. 00h 1Fh Counts requests generated from L2 Hardware Prefetchers. DFh- Reserved. 20h E0h Counts requests generated from L1 DC Hardware Prefetchers. FEh- Reserved. E1h FFh Counts requests generated from L1 DC and L2 Hardware Prefetchers. |

