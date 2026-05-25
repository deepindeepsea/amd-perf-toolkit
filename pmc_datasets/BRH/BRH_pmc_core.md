# BRH — Core PMC Events (FP / LS / IC+BP / DE / EX / L2)

_Source: AMD pprweb build at ppr_BRH_C1_int_050_pprweb_

_Total events: 310_


Events are listed in code order. Per-event, the table lists the UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.


## PMCx000 — FP — FP scheduler uop pipe assignment

**Symbolic:** `Core::X86::Pmc::Core::FPU_Pipe_Assignment`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx000`

Pipe assignment chooses the final pipe that a uop will be picked by the scheduler to execute on. Some uops can only execute on a small subset of pipes. This count is captured when a uop is written to the scheduler, so counts of uops pipe assigned may be larger than counts of uops retired due to flushes. This event may be useful when evaluating/debugging performance of FP pipe assignment algorithm and/or evaluating codes that may heavily load one pipe vs another.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Pipe5` | Counts when uop is assigned to pipe 5. |
| 4 | `Pipe_4` | Counts when uop is assigned to pipe 4. |
| 3 | `Pipe_3` | Counts when uop is assigned to pipe 3. |
| 2 | `Pipe_2` | Counts when uop is assigned to pipe 2. |
| 1 | `Pipe_1` | Counts when uop is assigned to pipe 1. |
| 0 | `Pipe_0` | Counts when uop is assigned to pipe 0. |


## PMCx001 — FP — FP scheduler uop counters

**Symbolic:** `Core::X86::Pmc::Core::FPU_uOps_Tracking`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx001`

The FP has an NSQ (non-scheduleable queue) and SQ (scheduler queue). These counters can be used to determine how full the SQ is and the rate that uops are transferred to / from the NSQ and SQ.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `FpSqFull` | Number of cycles when FP SQ signaling stall to the FP NSQ. |
| 4 | `FpSqEmpty` | Number of cycles when FP SQ is empty. |
| 3 | `uOpsInFpSq` | Number of uops in FP SQ divided by 4 and rounded down. The SQ size is larger than the max increment a performance counter can handle in a given cycle. Only report the MSBs of the actual SQ occupancy (divide by 4). |
| 2 | `uOpsSqIssued` | Number of uops issued/picked from FP SQ. |
| 1 | `uOpsNsq2Sq` | Number of uops moved from NSQ to SQ. |
| 0 | `uOpsDispatched2FpSq` | Number of dispatched FP uops from DE to FP. |


## PMCx002 — FP — FP retired x87 uops

**Symbolic:** `Core::X86::Pmc::Core::Retired_x87_FP_Ops`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx002`

Number of retired x87 arithmetic operations. Can be used to calculate x87 FLOPs.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `DivSqrROps` | x87 Divide or square root uops. |
| 1 | `MulOps` | x87 Multiply uops. |
| 0 | `AddSubOps` | x87 Add/subtract uops. |


## PMCx003 — FP — FP retired SSE and AVX FLOPs

**Symbolic:** `Core::X86::Pmc::Core::Retired_SSE_AVX_FLOPs`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx003`

Number of SSE and AVX floating point arithmetic operations retired. Number of arithmetic operations retired is dependent on number of uops retired, data size (scalar/128/256/512), data type (BF16/FP16/FP32/FP64) and type of operation (add/sub/mul/mac/...). Use MergeEvent feature for accurate results.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `FlopTypeSel` | Mask for specifying FLOP type. Value Name Description 0h all_types All types. 1h b_float_16 B Float 16. 2h scalar_single Scalar single. 3h packed_single Packed single. 4h scalar_double Scalar double. 5h packed_double Packed double. 7h-6h Reserved. |
| 3 | `MacFLOPs` | Each MAC operation count as 2 FLOPs. bfloat MAC operations are not included in this event. |
| 2 | `DivFLOPs` | Divide/square root FLOPs. Does not provide a useful count without use of the MergeEvent feature. |
| 1 | `MultFLOPs` | Multiply FLOPs. Does not provide a useful count without use of the MergeEvent feature. |
| 0 | `AddSubFLOPs` | Add/subtract FLOPs. Does not provide a useful count without use of the MergeEvent feature. |


## PMCx004 — FP — FP move eliminations and scalar optimizations

**Symbolic:** `Core::X86::Pmc::Core::MovElim_Scalar_Optimization`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx004`

Number of uops that perform an optimization that may improve performance by either eliminating use of physical register and scheduler queue resources (move elim) or dependencies on merging sources (scalar opt).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `Optimized` | Number of Scalar uops optimized. |
| 2 | `OptPotential` | Number of uops that are candidates for optimization (have Z-bit either set or pass). Z-bit indicates that merge source has data==0 above the scalar size (127:64 for FP64, 127:32 for FP32). |
| 1 | `SseMovOpsElim` | Number of SSE/AVX Move uops eliminated. |
| 0 | `SseMovOps` | Number of SSE/AVX Move uops. |


## PMCx005 — FP — FP retired serializing uops

**Symbolic:** `Core::X86::Pmc::Core::Retired_Serializing_Ops`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx005`

This counter tracks two different classes of control word modifying or retrieving uops. Number of control word changing uops that were predicted incorrectly or could not be predicted and trap. Control word mispredict traps will cause all younger uops to be flushed and re-dispatched. Number of control word retrieving uops that must bottom-execute. Bottom-execute uops must wait for retire of all older uops before being picked to execute by the FP scheduler.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `SseBotRet` | SSE/AVX bottom-executing uops retired. |
| 2 | `SseCtrlRet` | SSE/AVX control word mispredict traps due to mispredictions of rounding control ( RC ), denormal as zero (DAZ), flush to zero (FTZ), or changes in mask bits. |
| 1 | `X87BotRet` | x87 bottom-executing uops retired. |
| 0 | `X87CtrlRet` | x87 control word mispredict traps due to mispredictions in rounding control ( RC ) or precision control (PC), or changes in mask bits. |


## PMCx006 — FP — FP flush state machine tracking

**Symbolic:** `Core::X86::Pmc::Core::FP_Flush_State_Machine_Arcs_and_Cycles`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx006`

This event is useful for floating point team to track behavior of flush recovery state machine.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `FlushCrmSrm` | Cycles in flush crmsrm - copying committed register state to speculative register state. |
| 6 | `FlushSlowRecovery` | Cycles in slow recovery - recovering speculative state from committed state after retire has reached the flush pointer. |
| 5 | `FlushPend` | Cycles in flush pend - waiting for thread to retire to flush pointer before starting recovery. |
| 4 | `FlushFastRecovery` | Cycles in fast recovery - recovering speculative state from committed state before retire has reached the flush pointer. |
| 3 | `ToFlushNone` | Flush slow recovery done - completed slow flush recovery. |
| 2 | `FlushFastRecoveryToSlowRecover` | Flush fast recovery to slow recovery - fast recovery has transitioned to slow recovery due to retire catching up to flush pointer. |
| 1 | `FlushNoneFastRec` | Flush fast recovery done - completed fast flush recovery. |
| 0 | `FlushNoneIgn` | Flush ignored by FP - no FP uops older than the flush pointer need recovery. |


## PMCx007 — FP — FP control word modifications

**Symbolic:** `Core::X86::Pmc::Core::Changes_to_x87_SSE_control_words`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx007`

Number of times LDMXCSR, LDCW cause changes to SSE/AVX and x87 control words. Used with PMCx005 - FP retired serializing uops, it is possible to determine the performance of the control word prediction hardware in the FP.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `X87ExMaskChange` | Number of times x87 control word (exception mask bits) is changed |
| 4 | `X87CntrlChange` | Number of times x87 control word ( RC +PC) is changed. |
| 3 | `X87CntrlWrite` | Number of times x87 control word is written. |
| 2 | `SseAvxExMaskChange` | Number of times SSE/Avx control word (exception mask bits) is changed. |
| 1 | `SseAvxCntrlChange` | Number of times SSE/Avx control word ( RC +DAZ+FTZ) is changed. |
| 0 | `SseAvxCntrlWrite` | Number of times SSE/Avx control word is written. |


## PMCx008 — FP — FP uops retired by size

**Symbolic:** `Core::X86::Pmc::Core::Retired_FP_uOps`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx008`

Report number of FP uops retired by size. Can be used to determine how vectorized code is and how much MMX / x87 content is in the code.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Pack512uOpsRetired` | Packed 512-bit uops retired. |
| 4 | `Pack256uOpsRetired` | Packed 256-bit uops retired. |
| 3 | `Pack128uOpsRetired` | Packed 128-bit uops retired. |
| 2 | `ScalaruOpsRetired` | Scalar uops retired. |
| 1 | `MMXuOpsRetired` | MMX uops retired. |
| 0 | `x87uOpsRetired` | x87 uops retired. |


## PMCx009 — FP — FP throttle count

**Symbolic:** `Core::X86::Pmc::Core::FP_Throttles`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx009`

Number of cycles that FP scheduler picker is prevented from picking a uop due to throttling. Throttling may result from resource contention, power widgets, or forward progress widgets. Can be used to help determine why IPC is below expectations. A large number of throttles will reduce IPC.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `FpInt2Fp` | FP Int2Fp Throttle - EX told to stall int2fp transactions to free up pipe jammed by int2fp operations. |
| 6 | `Source_Steal` | FP Src Steal Throttle - Source stealing pipes stalled to free up pipe that requires register file read port. |
| 5 | `Pipe5Throttle` | Pipe 5 Throttle - Pipe 5 throttled by power widget. |
| 4 | `Pipe4Throttle` | Pipe 4 Throttle - Pipe 4 throttled by power widget. |
| 3 | `Pipe3Throttle` | Pipe 3 Throttle - Pipe 3 throttled by power widget. |
| 2 | `Pipe2Throttle` | Pipe 2 Throttle - Pipe 2 throttled by power widget. |
| 1 | `Pipe1Throttle` | Pipe 1 Throttle - Pipe 1 throttled by power widget. |
| 0 | `Pipe0Throttle` | Pipe 0 Throttle - Pipe 0 throttled by power widget. |


## PMCx00A — FP — FP uops retired sorted by vector or scalar

**Symbolic:** `Core::X86::Pmc::Core::FP_Ops_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx00A`

Number of FP uops retired of selected type sorted by vector (AVX/SSE packed) or scalar (x87, AVX/SSE scalar). Can be used to profile FP codes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `VectorFpOpType` | select a vector FP uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h divide Divide. 6h square_root Square root. 7h compare Compare. 8h convert Convert. 9h blend Blend. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily thought to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch bfloat BFloat. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all fp type uops. |
| 3:0 | `ScalarFpOpType` | select scalar FP uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h divide Divide. 6h square_root Square root. 7h compare Compare. 8h convert Convert. 9h blend Blend. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily thought to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch bfloat BFloat. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all fp type uops. |


## PMCx00B — FP — FP executed integer type uops sorted by vector or scalar

**Symbolic:** `Core::X86::Pmc::Core::INT_Ops_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx00B`

Number of integer uops executed in the FP retired of selected type sorted by vector (SSE/AVX) or scalar (MMX). Can be used to profile vector INT / MMX codes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `SseAvxOpType` | select SSE/AVX vector INT uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h AES AES. 6h SHA SHA. 7h compare Compare. 8h convert_or_pack Convert or pack. 9h shift_or_rotate Shift or rotate. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily though to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch VNNI VNNI. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all int type uops. |
| 3:0 | `MmxOpType` | select MMX INT scalar uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h AES AES. 6h SHA SHA. 7h compare Compare. 8h convert_or_pack Convert or pack. 9h shift_or_rotate Shift or rotate. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily though to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch VNNI VNNI. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all int type uops. |


## PMCx00C — FP — FP uops retired sorted by packed 128 or packed 256

**Symbolic:** `Core::X86::Pmc::Core::Packed_FP_Ops_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx00C`

Number of FP uops retired of selected type sorted by 128-bit packed dest (XMM) or 256-bit packed dest (YMM). Can be used to profile FP codes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `Fp256OpType` | select a 256-bit packed FP uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h divide Divide. 6h square_root Square root. 7h compare Compare. 8h convert Convert. 9h blend Blend. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily thought to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch bfloat BFloat. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all fp type uops. |
| 3:0 | `Fp128OpType` | select 128-bit packed FP uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h divide Divide. 6h square_root Square root. 7h compare Compare. 8h convert Convert. 9h blend Blend. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily thought to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch bfloat BFloat. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all fp type uops. |


## PMCx00D — FP — FP executed packed integer uops sorted by packed 128 or packed 256

**Symbolic:** `Core::X86::Pmc::Core::Packed_INT_Ops_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx00D`

Number of integer uops executed in FP retired of selected type sorted by 128-bit packed dest (XMM) or 256-bit packed dest (YMM). Can be used to profile FP codes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `Int256OpType` | select a 256-bit packed INT uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h AES AES. 6h SHA SHA. 7h compare Compare. 8h convert_or_pack Convert or pack. 9h shift_or_rotate Shift or rotate. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily though to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch VNNI VNNI. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all int type uops. |
| 3:0 | `Int128OpType` | select 128-bit packed INT uop type to count or 0 for none. Value Name Description 0h none None selected. 1h add Add. 2h subtract Subtract. 3h multiply Multiply. 4h multiply_accumulate Multiply accumulate. 5h AES AES. 6h SHA SHA. 7h compare Compare. 8h convert_or_pack Convert or pack. 9h shift_or_rotate Shift or rotate. Ah move Move. MOV* instructions will count as INT type, not FP type. In other words, FP data type op counting PMC events, such as PMCx00A and PMCx00C, will not count MOV ops. Bh shuffle Shuffle. Shuf uop counts may count for instructions that are not necessarily though to include shuffles. i.e. horizontal add, dot-product, and some MOV instructions. Ch VNNI VNNI. Dh logical Logical. Eh other Other uops not included in previous groups. Fh all Select all int type uops. |


## PMCx00E — FP — FP Dispatch Faults

**Symbolic:** `Core::X86::Pmc::Core::FP_Dispatch_Faults`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx00E`

Number of FP dispatch faults triggered by type. Dispatch fill/spill faults occur when FP either does not have the data needed to operate on in its local registers (fill), or FP needs to empty out upper register data for proper SSE merging behavior when executing AVX code (spill).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `YmmSpillFault` | YMM spill fault |
| 2 | `YmmFillFault` | YMM fill fault |
| 1 | `XmmFillFault` | XMM Fill fault |
| 0 | `x87FillFault` | x87 Fill fault |


## PMCx00F — FP — FP packed 512 uops retired by FP or INT type

**Symbolic:** `Core::X86::Pmc::Core::Packed_512_bit_Ops_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx00F`

Number of FP 512-bit packed dest (ZMM) uops retired of selected type sorted by FP or INT. Can be used to profile FP codes. Reference PMCx00B for INT uop encodings and PMCx00A for FP uop encodings.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `Int512OpType` | select a 512-bit packed INT uop type to count or 0 for none. |
| 3:0 | `Fp512OpType` | select a 512-bit packed FP uop type to count or 0 for none. |


## PMCx010 — FP — FP mask register usage

**Symbolic:** `Core::X86::Pmc::Core::Mask_register_usage`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx010`

Number of FP uops retired that consume a mask source (K register) or write a mask (K register). Mask sources either zero the dest of masked lanes (zeroing) or merge the dest of masked lanes (merging). Uops that have K0 as the mask source neither merge nor zero as K0 is treated as no masking. However mask operations can consume and write K0 w/o the assumed all 1's value of K0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `ZeroMasking` | Mask register used in zeroing mode uop retired. |
| 2 | `MergeMasking` | Mask register used in merging mode uop retired. |
| 1 | `MaskingRegUse` | Mask register consuming uop retired. This includes mask register operations and mask register use for masking. |
| 0 | `MaskWrite` | Mask register writing uop retired. |


## PMCx011 — FP — FP SSE merge

**Symbolic:** `Core::X86::Pmc::Core::SSE_Merge`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx011`

Number of SSE merge operations performed. SSE merge operations occur when executing SSE operations using XMM dests that have valid data in bits 511:128. In this case the upper bits of the register must be merged to the dest of the SSE operation. The software optimization guide highly suggests using VZEROUPPER prior to executing SSE instructions after having executed any AVX instructions. SSE merge behavior is controlled by DeCfg2.SseMergeCfg.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `MergeKilled` | SSE merge signaled from DE, and killed by FP |
| 3 | `MergeSignaled` | SSE merge signaled from DE, on a valid SSE uop |
| 2 | `MergeDouble` | SSE merge performed, double mode (512-bits) |
| 1 | `MergeSingle` | SSE merge performed, single mode (256-bits) |
| 0 | `NoMerge` | SSE op no merge performed |


## PMCx012 — FP — FP Debug Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::Core::FP_Debug_Raw_Local_Irritator`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx012`

Number of times that FP DBDT raw local irritator asserted (For DBDT IO Ports refer to http://twiki.amd.com/twiki/bin/view/CCDft/CCDftKitdbmu#DBDT_IO_Ports) . Thread0 counts DtIrritator[0], and Thread1 counts DtIrritator[1].

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `FpDbgRawLclIrr` | Cycles that the FP Ucode raw local irritator was active. Will not count anything unless FP_DBGCFG[DBG_IRR_PMC] is set |


## PMCx013 — FP — FP Non-scheduleable queue stats

**Symbolic:** `Core::X86::Pmc::Core::NSQ_before_rename`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx013`

Number of NSQ read stalls and tracking for int2fp and load transactions returned while uop was in the NSQ. NSQ has been moved before rename in the FP and acts as the place where token availability for scheduler queue entries, physical register file entries, and mask physical register file entries is evaluated. Loads and int2fp uops are allowed to return to FP while a uop is still in the NSQ as long as physical registers are available to assign to those returning uops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Total_I2F` | Total Int2Fp uops leaving NSQ. |
| 6 | `I2F_uses_EX_FIFO` | Int2Fp uses physical register before rename. |
| 5 | `Total_loads` | Total load uops leaving NSQ. |
| 4 | `Load_uses_LS_FIFO` | Load uses physical register before rename. |
| 3 | `SQ_token_stall` | NSQ read stalled due to insufficient scheduler tokens. |
| 2 | `KReg_token_stall` | NSQ read stall due to insufficient mask register file tokens. |
| 1 | `Reg_token_stall` | NSQ read stall due to insufficient regiter file tokens. |
| 0 | `Flush_token_stall` | NSQ read stalled due to FP flush recovery. |


## PMCx014 — FP — FP Packed Integer IOPs

**Symbolic:** `Core::X86::Pmc::Core::Int_Vector_Ops_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx014`

Number of packed integer IOPs retired by number of 128-bit lanes. i.e. 512-bit (ZMM) op is 4 lanes, 256-bit (YMM) op is 2 lanes, 128-bit (XMM) op is 1 lane. Post processing needed. Byte operations are 16 per lane, Word operations are 8 per lane, Doublword operations are 4 per lane, Quadword operations are 2 per lane.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `Input_Precision` | Specify input operand precision of int ops: 000-byte, 001-word, 010-dword, 011-qword, 1xx-ALL precisions |
| 3 | `VNNI_LANEs` | VNNI LANEs - Count returns 1 IOP per lane. |
| 2 | `Mac_LANEs` | Mac LANEs - Count returns 1 IOP per lane. |
| 1 | `Mul_LANEs` | Mul LANEs - Count returns 1 IOP per lane. |
| 0 | `AddSub_LANEs` | Add/Sub LANEs - Count returns 1 IOP per lane. |


## PMCx020 — LS — Segment Register Loads

**Symbolic:** `Core::X86::Pmc::Core::Segment_Register_Loads`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx020`

The number of segment register loads performed. UnitMask events ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `HS` | HS register load |
| 5 | `GS` | GS register load |
| 4 | `FS` | FS register load |
| 3 | `DS` | DS register load |
| 2 | `SS` | SS register load |
| 1 | `CS` | CS register load |
| 0 | `ES` | ES register load |


## PMCx021 — LS — SpecGoodStatus Activity

**Symbolic:** `Core::X86::Pmc::Core::SpecGoodStatus_Activity`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx021`

Usage of SpecGoodStatus to return load data to EX and dependents, while still needing further flows of the load to resolve load ordering hazards.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `SpecGoodStatusOOBFullDC` | A load sees Out-of-Order Buffer ( OOB ) full and SpecGoodStatuses, and does not get Store To Load Forwarding (STLF) from an older store. |
| 1 | `SpecGoodStatusOOBFullSTLF` | A load sees OOB-full and SpecGoodStatuses, and does get STLF from an older store. |
| 0 | `SpecGoodStatusSTLFLhash` | A load matches 11:0 and Virtual/Linear Address Hash (LHash) with an order store, but the older store doesn't have a physical address (PA) to confirm the STLF. |


## PMCx022 — LS — Pipeline Restart Due to Various Events

**Symbolic:** `Core::X86::Pmc::Core::Pipeline_Restart_Due_to_Various_Events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx022`

Pipeline Restart Requests Due to Various LS Events. These events are speculative and may not actually cause the pipeline to restart. Actual pipeline restart events are counted with PMCx096 or PMCx1D4/PMCx1D5. UnitMask events are ADDed. Known imprecission: counts a single event when multiple same-type events occur in the same cycle on different pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `SpecGoodStatusStlf` | SpecGoodStatus-STLF confirmation flow found a problem (PA mismatch, intervening store, original store overwritten). |
| 6 | `MemoryRenaming` |  |
| 5 | `DbitWr` | Page table Dirty (D) bit was set to 1 by hardware. |
| 4 | `SpecLockMapAbort` |  |
| 3 | `SpecLockResyncFault` |  |
| 2 | `ResyncOobThread` | Single-thread store/load ordering violation. |
| 1 | `ResyncLoq` | Load-load ordering violation. |
| 0 | `SpecGoodStatusDc` | SpecGoodStatus-DC confirmation flow found a problem (intervening store, oldest un-agened store overwritten) |


## PMCx023 — LS — Bad Status 1

**Symbolic:** `Core::X86::Pmc::Core::Bad_Status_1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx023`

Events that cause a load flow to return bad status (cancel). The load will be retried, and any dependents that were scheduled for execution will also be canceled and re-executed. UnitMask events are ORed within same pipe. UnitMask Events from different pipes are ADDed. Use PMCx02F UnitMask = 0x3 to count all picked loads. Note that a given load flow may match multiple Bad Status reasons.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NeedsSbex` | Load needs to wait to become non-speculative. |
| 6 | `LoqFull` |  |
| 5 | `OobFull` |  |
| 4 | `Iohc` | Count loads that returned bad status because they were marked IOHC (In-Order- Hazard-Check) and there was at least one older store that has not generated its address yet. |
| 2 | `WayNotVal` | DC way is invalid (utag miss). |
| 1 | `NoData` | DC way is valid (utag hit), but DC miss either due to false utag hit, or true utag hit but line not in correct state (Invalid-FillPending, or was Shared and the load needs it Exclusive). |
| 0 | `TlbMiss` | L1DTLB miss. |


## PMCx024 — LS — Bad Status STLI

**Symbolic:** `Core::X86::Pmc::Core::Bad_Status_STLI`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx024`

Store To Load Interlock (STLI) are loads that were unable to complete because of a possible match with an older store, and the older store could not do Store To Load Forwarding (STLF) for some reason. UnitMask events are ORed within same pipe and then ADDed across pipes. Use PMCx02F UnitMask = 0x3 to count all picked loads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `StliBadPa` | The load PA did not match the PA with the selected STLF candidate |
| 6 | `StliMultimatch` | Load matched 11:0 with multiple stores and did not prioritize one of them |
| 5 | `StlfCandidateStartAddrMismatch` | A load has an 11:0 overlap with a store, but the store was not seen as an STLF candidate due to mismatching the lo [5:0] bits. |
| 4 | `StliAgen` | The load flowed and an older store that overlaps 11:0 with the load agened in the same cycle or the cycle after the load flowed. The store can't participate in the normal STLI/STLF scheme but needs to do STLI with the load to cover these two cycles. |
| 3 | `StliScbNoState` | Load overlaps an SCB and the SCB doesn't know its way |
| 2 | `StlfNoData` | The load is capable of forwarding from an older store (i.e. the address match/overlap between the load and the older store) was good and everything works from an address perspective, but the store's data has not been produced by EX or FP yet so it can't be forwarded. |
| 1 | `StliOther` | Store-to-load conflicts: A load was unable to complete due to a non-forwardable conflict with an older store. Most commonly, a load's address range partially but not completely overlaps with an uncompleted older store. Software can avoid this problem by using same-size and same-alignment loads and stores when accessing the same data. Vector/SIMD code is particularly susceptible to this problem; software should construct wide vector stores by manipulating vector elements in registers using shuffle/blend/swap instructions prior to storing to memory, instead of using narrow element-by-element stores. |
| 0 | `StliNoState` | The STLF is validated using a physical address compare. The store that wants to STLF is required to have its PA. The STLF candidate store is chosen based on address bits 11:0. If the store does not have its PA, it cannot validate STLF. The load gets StliNoState and can't complete. |


## PMCx025 — LS — Retired Lock Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Lock_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx025`

Counts retired atomic read-modify-write instructions with a LOCK prefix. Any combination of UnitMask[4:0] events (UnitMask events ORed) may be used.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4:0 | `LockInstructions` | Specifies type of lock instructions counted Value Name Description 00h Reserved. 01h BusLock BusLock: Non-cacheable or cacheline-misaligned lock. 02h NonSpecLock NonSpecLock: Non speculative cacheable lock. 03h Reserved. 04h SpecLockLoSpec SpecLockLoSpec: Low speculative cacheable lock speculation succeeded. 07h-05h Reserved. 08h SpecLockHiSpec SpecLockHiSpec: High speculative cacheable lock speculation succeeded. 0Fh-09h Reserved. 10h AtomicGroup AtomicGroup: Lock completed speculatively by creating an atomic group and locking all older stores. 1Eh-11h Reserved. 1Fh Anylock AnyLock: Counts all lock instructions. |


## PMCx026 — LS — Retired CLFLUSH Instructions

**Symbolic:** `Core::X86::Pmc::Core::CLFLUSH`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx026`

The number of retired CLFLUSH instructions. This is a non-speculative event.


## PMCx027 — LS — Retired CPUID Instructions

**Symbolic:** `Core::X86::Pmc::Core::CPUID`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx027`

The number of CPUID instructions retired.


## PMCx028 — LS — Bad Status 3

**Symbolic:** `Core::X86::Pmc::Core::Bad_Status_3`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx028`

Miscellaneous other reasons that a load returns bad status. UnitMask events are ORed within same pipe and then ADDed across pipes. Use PMCx02F UnitMask = 0x3 to count all picked loads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `SpecLockGoodStatus` | The load flow returned good status, but did not deallocate due to it being a speculative lock. It will reflow when Sbex to confirm the speculative lock. |
| 5 | `SpecGoodStatus` | The load flow returned good status, but did not deallocate and must reflow againt to confirm the good-status later |
| 4 | `HintedStoreNotReady` | A load has an Store To Load Forwarding (STLF) hint to a store, but the hinted store does not have its address and/or store data |
| 3 | `NeedsFPPrn` | Bad status due to needing an FP load PRN token and one not being available |
| 2 | `AVX512_load_pipe_conflict` | Load on pipe2/3 conflicted with an AVX512 load on its paired pipe 0/1 |
| 1 | `DcPortConflict` | DC port conflict on same pipe with victim read (pipe 1/3). |
| 0 | `Bank_Conflict` | DC bank conflict |


## PMCx029 — LS — LS Dispatch

**Symbolic:** `Core::X86::Pmc::Core::LS_Dispatch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx029`

Counts the number of operations dispatched to the LS unit. Unit Masks events are ADDed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `LdOpSt` | Dispatch of a single op that performs a load from and store to the same memory address. |
| 1 | `PureSt` | Dispatch of a single op that performs a memory store. |
| 0 | `PureLd` | Dispatch of a single op that performs a memory load. |


## PMCx02A — LS — Store Coalescing Buffer (SCB) Close/Flush 2

**Symbolic:** `Core::X86::Pmc::Core::SCB_Close_Flush_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx02A`

Counts events that cause at least one Store Coalescing Buffer (SCB) to close.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `NewStronglyOrdered` | A new strongly-ordered SCB was allocated (any address) that caused an SCB to close. |
| 2 | `NewSameAddress` | A new SCB to the same address was allocated that caused an SCB to close. |
| 1 | `GloballyVisibleProbeHit` | Open and globally-visible SCB hit by a probe. |
| 0 | `Threshold` | Open SCBs reached the open-SCB threshold, causing one or more SCBs to close. |


## PMCx02B — LS — SMIs Received

**Symbolic:** `Core::X86::Pmc::Core::SMI`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx02B`

Counts the number of System Management Interrupts (SMIs) received. To enable SMI Legacy Unit Mask set field [7:0] to 0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `SmmCycles` | Counts cycles spent in System Management Mode ( SMM ) |
| 0 | `Smi` | Counts the number of SMIs received. This event is also counted when UnitMask[7:0] = 0. |


## PMCx02C — LS — Interrupts Taken

**Symbolic:** `Core::X86::Pmc::Core::Interrupts_Taken`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx02C`

Counts the number of interrupts taken.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `VirtCrPmcAction6` | Counts writes of 1 to VirtcrPmcAction[6]. |
| 6 | `VirtCrPmcAction5` | Counts writes of 1 to VirtcrPmcAction[5]. |
| 5 | `VirtCrPmcAction4` | Counts writes of 1 to VirtcrPmcAction[4]. |
| 4 | `VirtCrPmcAction3` | Counts writes of 1 to VirtcrPmcAction[3]. |
| 3 | `AvicIcrWrVmexit` | Counts VMEXITs that are the result of virtualized ICR writes. Counts writes of 1 to VIRTCR[29]. |
| 2 | `AvicDoorBellRcvd` | Counts AVIC doorbells received by the thread. Counts writes of 1 to VIRTCR[28]. |
| 1 | `AvicDoorBellRung` | Counts AVIC doorbells rung by the thread. Counts writes of 1 to VIRTCR[27]. |
| 0 | `NumInterrupts` | Number of interrupts taken. This event is also counted when UnitMask[7:0]=0. |


## PMCx02D — LS — Time Stamp Counter Reads

**Symbolic:** `Core::X86::Pmc::Core::Time_Stamp_Counter_Reads`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx02D`

Counts the number of reads of the TSC. The count is speculative.


## PMCx02E — LS — Store Dealloc Stalls

**Symbolic:** `Core::X86::Pmc::Core::Store_Dealloc_Stalls`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx02E`

Counts reasons why STQ dealloc was stalled.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `SlmAbort` | Store dealloc stalled due to a post dealloc SpecLockMap (SLM) abort. |
| 3 | `StoreDeallocCancel` | Store dealloc stalled due to a previous store dealloc cancel |
| 2 | `OtherThread` | Store dealloc has stores ready to dealloc but the other thread was selected. |
| 1 | `ScbFull` | Store dealloc stalled due to previous SCB-full condition and waiting for an SCB to deallocate. |
| 0 | `StqRetireEmpty` | No stores are retired. |


## PMCx02F — LS — LS Non-HwPf Picks

**Symbolic:** `Core::X86::Pmc::Core::LS_Non_HwPf_Picks`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx02F`

Picks/pipeline flows of non-HwPf ops. UnitMask events ORed together within each pipe and then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Ptw` | Page table walker flow. |
| 5 | `PureStPostRetireScb` | Pure store flow from post-retire SCB. |
| 4 | `PureStPostRetireStq` | Pure store flow from post-retire STQ. |
| 3 | `PureStPreRetire` | Pure store flow from agen-pick or pre-retire STQ. |
| 2 | `PureSt` | Pure store flow - counts all store flows (all of unit mask 3, 4, and 5). |
| 1 | `LdOpSt` | Load-op-store flow. |
| 0 | `PureLd` | Pure load flow. |


## PMCx030 — LS — LS HwPf Picks

**Symbolic:** `Core::X86::Pmc::Core::LS_HwPf_Picks`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx030`

Picks/pipeline flows of HwPf ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `HwPfTlbHist` | TLB history hardware prefectcher flow. |
| 3 | `HwPfL2Stride` | L2 stride hardware prefetcher flow. |
| 2 | `HwPfRegion` | Region prefetcher flow. |
| 1 | `HwPfL1Stride` | L1 stride hardware prefetcher flow. |
| 0 | `HwPfStream` | Stream hardware prefectcher flow. |


## PMCx031 — LS — Store Dealloc Activity

**Symbolic:** `Core::X86::Pmc::Core::Store_Dealloc_Activity`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx031`

Counts events on the store dealloc pipeline. UnitMask events ORed together within each pipe and then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `Other` | Any other store dealloc SD2 - SRB stores or NoWrite stores for example. |
| 5 | `NoDealloc` | No dealloc was active in SD2 cycle. |
| 3 | `StqParityError` | Store dealloc saw a STQ parity error. |
| 2 | `ScbFull` | Store dealloc cancel due to needing to allocate a new SCB but no free SCBs are available. |
| 1 | `ScbAlloc` | Store dealloc allocated a new SCB. |
| 0 | `ScbCombine` | Store dealloc combined into an SCB. |


## PMCx032 — LS — Misaligned Store Flows

**Symbolic:** `Core::X86::Pmc::Core::Misaligned_Store_Flows`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx032`

The number of misaligned store flows. Misaligned ops use 2 cycles on an LS pipe, instead of one cycle. UnitMask events are ORed within each pipe and then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `MA4K` | The number of 4KB misaligned (i.e., page crossing) stores. Does not count 4K-misaligned LdOpSt, they are counted in x047. |
| 0 | `MA64` | The number of 64B misaligned (i.e., cacheline crossing) stores. Does not count 64B-misaligned LdOpSt, they are counted in x047. |


## PMCx033 — LS — Store Commit Activity

**Symbolic:** `Core::X86::Pmc::Core::Store_Commit_Activity`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx033`

Counts events on the store commit pipeline. UnitMask events ORed together within each pipe and then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `StillOpenForCombining` | Store commit on pipe 0/1 is cancelled in order to keep the SCB entry open for combining. |
| 3 | `CommitPipeSwap` | Store commit on commit pipe 0 sees a DC bank conflict (two writes to same DC bank, to different locations in the bank) with fill, commit on commit pipe 1 sees no bank conflict with a fill but will see a port conflict with a fill (since pipe1 shares a DC write port with fills), pipes swapped to avoid commit pipe 1 port conflict. |
| 2 | `StCommitStCommitBankConflict` | Store commit on commit pipe 1 sees a DC bank conflict with a store commit on commit pipe 0. |
| 1 | `FillStCommitPortConflict` | Store commit on commit pipe 1 sees a port conflict with a fill. |
| 0 | `FillStCommitBankConflict` | Store commit on commit pipe 0/1 sees a bank conflict with a fill. |


## PMCx034 — LS — Store Commit Stalls

**Symbolic:** `Core::X86::Pmc::Core::Store_Commit_Stalls`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx034`

Counts reasons why SCB commit was stalled.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Other` | Any other reason why no SCBs are committing on this thread, not counted by the other unit masks. |
| 4 | `OtherThread` | This thread has ready-to-commit SCBs but none were selected due to the other thread getting chosed. |
| 3 | `BuslockInProgress` | Buslock (system-wide non-cacheable lock) in progress on another thread. |
| 2 | `Fence` | Waiting for all older Store Coalescing Buffers (SCBs) to drain. |
| 1 | `OldestScbNotExclState` | Oldest SCB is not in exclusive state and there are no younger weakly-ordered SCBs available to commit. |
| 0 | `ScbEmpty` | No SCBs are allocated. |


## PMCx035 — LS — Store to Load Forward

**Symbolic:** `Core::X86::Pmc::Core::Store_to_Load_Forward`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx035`

Number of STLF hits.


## PMCx036 — LS — Store Globally Visible Cancels 1

**Symbolic:** `Core::X86::Pmc::Core::Store_Globally_Visible_Cancels_1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx036`

Counts reasons why a Store Coalescing Buffer (SCB) commit is canceled. UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `E2MCan` | Deprecated, does not count |
| 5 | `NCGV` | Non-cacheable store was pending |
| 4 | `PtyErr` | SCB state and address parity error ( RAS event). |
| 3 | `SlmAbort` | Lock speculation SpecLockMap (SLM) abort |
| 2 | `RmwHzd` | Store was a read-modify-write commit and its commit occurs too soon following an earlier commit to the same word. Always counts 0 since there are no read-modify-write commits. |
| 1 | `Merge` | SCB started on the commit pipe but commit canceled since still open for combining. Always counts 0 since the SCB is now allowed to become globally visible even if it is open for combining. |
| 0 | `Probes` | Probe/DC eviction is taking away the store's cacheline, or store cacheline state not exclusive. |


## PMCx037 — LS — Store Globally Visible Cancels Due To External Conditions

**Symbolic:** `Core::X86::Pmc::Core::Store_Globally_Visible_Cancels_External`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx037`

Counts reasons why a store commit is canceled. UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `BuslockInProg` | Buslock in progress just before this commit pipe flow occurred. |
| 1 | `OlderStDeallocCancel` | Older SCB we are waiting on to dealloc was still allocated. |
| 0 | `OlderStVisibleDepCancel` | An older store, that the thread was waiting on to become globally visible, was unable to become globally visible. |


## PMCx038 — LS — Livelock Widgets

**Symbolic:** `Core::X86::Pmc::Core::LiveLock_Widgets`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx038`

Counts cycles various forward-progress widgets (livelock, deadlock, sleep safety net) are active. UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `StCommitFwdProgWidget` | This counts the cycles the SCB forward progress widget is active. |
| 5 | `SafetyNetWakeUp` | This would count when the load sleep safety-net kicks in. Counts safety-net events per cycle (TLB/TLB MAB/store-related sleep) |
| 4 | `DeadLock` | Number of cycles the Deadlock widget was active |
| 3 | `LiveLock_L2` | Number of cycles the LiveLock widget Level 2 was active |
| 2 | `LiveLock_L1` | Number of cycles the LiveLock widget Level 1 was active |
| 1 | `LiveLock_L0` | Number of cycles the LiveLock widget Level 0 was active |
| 0 | `AnyLiveLock` | Number of cycles any Livelock widget level was active |


## PMCx039 — LS — ECC RMW Store Commits

**Symbolic:** `Core::X86::Pmc::Core::ECC_RMW_Store_Commits`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx039`

Counts only SCB merge.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `AnyMerge` | Counts only SCB merge. |


## PMCx03A — LS — TSX HLE Status

**Symbolic:** `Core::X86::Pmc::Core::TSX_HLE_Status`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx03A`

Counts events associated with transactional memory Hardware Lock Elision. TSX is deprecated on NV and thus this event does not count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `HLE_Abort_All_Other_Aborts` | See UnitMask[2] |
| 6 | `HLE_Abort_LEB_Conflict` | See UnitMask[2] |
| 5 | `HLE_Abort_Bad_Memory_Access` | See UnitMask[2] |
| 4 | `HLE_Abort_TSX_Data_Conflict` | See UnitMask[2] |
| 3 | `HLE_Abort_Exception` | See UnitMask[2] |
| 2 | `HLE_Abort_Unfriendly_Instruction` | HLE Abort, see RTM/HLE Abort Reasons for a detailed mapping between abort reasons and UnitMask bits of this event |
| 1 | `HLE_Commit` | Outer XRELEASE commit |
| 0 | `HLE_Start` | Outer XACQURE completion |


## PMCx03B — LS — TSX RTM Status

**Symbolic:** `Core::X86::Pmc::Core::TSX_RTM_Status`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx03B`

Counts events associated with transactional memory Restricted Transactional Memory. TSX is deprecated on NV and thus this event does not count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RTM_Abort_All_Other_Aborts` | See UnitMask[2] |
| 5 | `RTM_Abort_Bad_Memory_Access` | See UnitMask[2] |
| 4 | `RTM_Abort_TSX_Data_Conflict` | See UnitMask[2] |
| 3 | `RTM_Abort_Exception` | See UnitMask[2] |
| 2 | `RTM_Abort_Unfriendly_Instruction` | See UnitMask[2] |
| 1 | `RTM_Commit` | Outer XEND commit |
| 0 | `RTM_Start` | Outer XBEGIN completion |


## PMCx03C — LS — Breakpoint Match DR0

**Symbolic:** `Core::X86::Pmc::Core::Breakpoint_Match_DR0`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx03C`

The number of matches on the address in breakpoint register DR0, per the breakpoint type specified in DR7. Matches occur if the access becomes non-speculative, but not necessarily retired. Each instruction breakpoint match incurs an overhead of about 120 cycles; load/store breakpoint matches do not incur any overhead.


## PMCx03D — LS — Breakpoint Match DR1

**Symbolic:** `Core::X86::Pmc::Core::Breakpoint_Match_DR1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx03D`

The number of matches on the address in breakpoint register DR1, per the breakpoint type specified in DR7. Matches occur if the access becomes non-speculative, but not necessarily retired. Each instruction breakpoint match incurs an overhead of about 120 cycles; load/store breakpoint matches do not incur any overhead.


## PMCx03E — LS — Breakpoint Match DR2

**Symbolic:** `Core::X86::Pmc::Core::Breakpoint_Match_DR2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx03E`

The number of matches on the address in breakpoint register DR2, per the breakpoint type specified in DR7. Matches occur if the access becomes non-speculative, but not necessarily retired. Each instruction breakpoint match incurs an overhead of about 120 cycles; load/store breakpoint matches do not incur any overhead.


## PMCx03F — LS — Breakpoint Match DR3

**Symbolic:** `Core::X86::Pmc::Core::Breakpoint_Match_DR3`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx03F`

The number of matches on the address in breakpoint register DR3, per the breakpoint type specified in DR7. Matches occur if the access becomes non-speculative, but not necessarily retired. Each instruction breakpoint match incurs an overhead of about 120 cycles; load/store breakpoint matches do not incur any overhead.


## PMCx040 — LS — Data Cache Accesses

**Symbolic:** `Core::X86::Pmc::Core::Data_Cache_Accesses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx040`

The number of accesses to the data cache for load and store references. This may include certain microcode scratchpad accesses, although these are generally rare. Each increment represents an up to 32-byte access. Misaligned loads and stores may cause two data cache accesses. This event is a speculative event.


## PMCx041 — LS — LS MAB Allocates by Type

**Symbolic:** `Core::X86::Pmc::Core::LS_MAB_Allocates_by_Type`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx041`

Counts when an LS pipe allocates a Miss Address Buffer ( MAB ) entry to make a miss request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `LsMabAllocation` | Value Name Description 06h-00h Reserved. 07h ls_alloc Load Store Allocations 08h hwpf_alloc Hardware Prefetcher Allocations 0Eh-09h Reserved. 0Fh all_alloc All Allocations 7Fh-10h Reserved. |


## PMCx041 — LS — LS MAB Allocates by Type

**Symbolic:** `Core::X86::Pmc::Core::LS_MAB_Allocates_by_Type_INT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx041`

Counts when an LS pipe allocates a Miss Address Buffer (MAB) entry to make a miss request. UnitMasks ORed within a pipe, then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `HwPf` | HwPf allocation (always from TlbPipe). |
| 2 | `TlbPipeEarly` | Allocation from TlbPipeEarly, excluding HwPf |
| 1 | `TlbPipeLate` | Allocation from TlbPipeLate, excluding HwPf |
| 0 | `DataPipe` | Allocation from DataPipe. |


## PMCx042 — LS — DC Micro-Tag Mispredicts

**Symbolic:** `Core::X86::Pmc::Core::uTag_Mispredicts`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx042`

UnitMask events are ADDed within and across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `uTagMissDCHit` | Micro-tag miss that would have been a DC hit. |
| 1 | `uTagMultiHit` | DataPipe flow with micro-tag multi-hit |
| 0 | `uTagHitDcMiss` | DataPipe flow with micro-tag hit and DC miss |


## PMCx043 — LS — Demand Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::Demand_DC_Fills_by_Data_Source`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx043`

Counts fills into the DC that were initiated by demand ops, per data source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Alternate Memories, a group of less commonly available memory types including CXL™(TM) (see section "Definitions" for details). No further breakdown like PMCx048 for PMCx043[7] is available. |
| 6 | `DramIO_Far` | Data returned from different node's DRAM/ MMIO . |
| 5 | `L4Cache` | From L4Cache |
| 4 | `NearFarCache_Far` | Data belonging to a different NUMA node returned from cache of a different CCX . |
| 3 | `DramIO_Near` | Data returned from local node's DRAM/ MMIO . |
| 2 | `NearFarCache_Near` | Data belonging to the local NUMA node returned from cache of a different CCX . |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX . |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx044 — LS — Any Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::Any_DC_Fills_by_Data_Source`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx044`

Counts all fills into the DC, per data source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return fom Alternate Memories, a group of less commonly available memory types including CXL™(TM) (see section "Definitions" for details). No further breakdown like PMCx048 for PMCx044[7] is available. |
| 6 | `DramIO_Far` | Data returned from different node's DRAM/ MMIO . |
| 5 | `L4Cache` | From L4Cache |
| 4 | `NearFarCache_Far` | Data belonging to a different NUMA node returned from cache of a different CCX . |
| 3 | `DramIO_Near` | Data returned from local node's DRAM/ MMIO . |
| 2 | `NearFarCache_Near` | Data belonging to the local NUMA node returned from cache of a different CCX . |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX . |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx045 — LS — L1 DTLB Reloads

**Symbolic:** `Core::X86::Pmc::Core::L1_DTLB_Reloads`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx045`

Counts L1DTLB reloads

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `TlbReload1GL2Miss` | DTLB reload to a 1G page that missed in the L2DTLB. |
| 6 | `TlbReload2ML2Miss` | DTLB reload to a 2M page that missed in the L2DTLB. |
| 5 | `TlbReloadCoalescedPageMiss` | DTLB reload to a coalesced page that missed in the L2DTLB. |
| 4 | `TlbReload4KL2Miss` | DTLB reload to a 4K page that missed in the L2DTLB. |
| 3 | `TlbReload1GL2Hit` | DTLB reload to a 1G page that hit in the L2DTLB. |
| 2 | `TlbReload2ML2Hit` | DTLB reload to a 2M page that hit in the L2DTLB. |
| 1 | `TlbReloadCoalescedPageHit` | DTLB reload to a coalesced page that hit in the L2DTLB. |
| 0 | `TlbReload4KL2Hit` | DTLB reload to a 4K page that hit in the L2DTLB. |


## PMCx046 — LS — Total Page Table Walks

**Symbolic:** `Core::X86::Pmc::Core::Page_Table_Walk_Allocation`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx046`

Counts page table walker allocation. UnitMask events are ORed. Use this event with PMCx04E ( Core::X86::Pmc::Core::Tablewalk_Latency ) to determine the average table walk latency.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `TableWalk_Iside` | Allocation of an I-side Tablewalker |
| 0 | `TableWalk_Dside` | Allocation of a D-side Tablewalker |


## PMCx047 — LS — Misaligned Load Flows

**Symbolic:** `Core::X86::Pmc::Core::Misaligned_Load_Flows`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx047`

The number of misaligned load flows. Misaligned ops use 2 cycles on an LS pipe, instead of one cycle. UnitMask events are ORed within each pipe and then ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `MA4K` | The number of 4KB misaligned (i.e., page crossing) loads or LdOpSt. |
| 0 | `MA64` | The number of 64B misaligned (i.e., cacheline crossing) loads or LdOpSt. |


## PMCx048 — LS — Any Data Cache Fills by Data Source 2

**Symbolic:** `Core::X86::Pmc::Core::Any_DC_Fills_by_Data_Source_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx048`

Any Data Cache fills from Alternate Memories, detailed by source. Alternate Memories are a group of less commonly available memory types including CXL™(TM) (see section "Definitions" for details). This event provides a further breakdown PMCx044 ( Core::X86::Pmc::Core::Any_DC_Fills_by_Data_Source ) events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Peer_Far` | Requests that target another NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator). |
| 4 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL). |
| 3 | `LongLat_Far` | Requests that target another NUMA node and return from a long-latency DIMM. |
| 2 | `Peer_Near` | Requests that target the same NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator). |
| 1 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL). |
| 0 | `LongLat_Near` | Requests that target the same NUMA node and return from a long-latency DIMM. |


## PMCx049 — LS — L1DTLB Hit/Miss

**Symbolic:** `Core::X86::Pmc::Core::L1DTLB_Hit_Miss`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx049`

Counts flows L1DTLB hit/miss status. Events ADDed across pipes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `Miss` | Missed L1DTLB |
| 3 | `Hit1G` | Hit a 1G page. |
| 2 | `Hit2M` | Hit a 2M page. |
| 1 | `HitCoalesced` | Hit a coalesced page. |
| 0 | `Hit4K` | Hit a 4K page. |


## PMCx04A — LS — DC Index Full

**Symbolic:** `Core::X86::Pmc::Core::DC_Index_Full`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx04A`

Counts DC index-full conditions where a fill was unable to allocate a location in the DC due to that DC index having too many fill-pending (FillP) cachelines.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `HwPfOther` | HwPf L2 response flow saw DcIndexFull while within FillP threshold |
| 2 | `HwPfThreshold` | HwPf L2 response flow saw DcIndexFull with FillP threshold exceeded |
| 1 | `NonHwPfOther` | Non-HwPf L2 response flow saw DcIndexFull while within FillP threshold |
| 0 | `NonHwPfThreshold` | Non-HwPf TD flows saw DcIndexFull with FillP threshold exceeded |


## PMCx04B — LS — Prefetch Instructions Dispatched

**Symbolic:** `Core::X86::Pmc::Core::Software_Prefetch_Dispatched`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx04B`

Software Prefetch Instructions Dispatched (speculative)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `PREFETCHT1_to_L2` | PREFETCH [0F 0D /0, /2, /4-/7] PREFETCH [0F 18 /1-/7] prefetching to L2 when DcPfCfg.DisSwPfToL1 is set. Or PREFETCHT1/2 [0F 18 /2-/3] when DcPfCfg.DisSwPfToL2Hint is cleared. |
| 3 | `PREFETCHT0_to_L1` | PREFETCH [0F 0D /0, /2, /4-/7] PREFETCH [0F 18 /1-/7] prefetching to L1 when DcPfCfg.DisSwPfToL1 is cleared. |
| 2 | `PREFETCHNTA` | PrefetchNTA instruction. See docAPM3 PREFETCHlevel. |
| 1 | `PREFETCHW` | PrefetchW instruction. See docAPM3 PREFETCHlevel. |
| 0 | `PREFETCH` | PrefetchT0, T1, and T2 instructions. See docAPM3 PREFETCHlevel. |


## PMCx04C — LS — HwPf Entries Allocated

**Symbolic:** `Core::X86::Pmc::Core::HwPf_Entries_Allocated`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx04C`

Counts when a new entry is allocated in one of the prefetchers selected by UnitMask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `RegionAlloc` | Region prefetcher |
| 1 | `StrideAlloc` | Stride prefetcher |
| 0 | `StreamAlloc` | Stream prefetcher |


## PMCx04D — LS — HwPf Entries Hit

**Symbolic:** `Core::X86::Pmc::Core::HwPf_Entries_Hit`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx04D`

Counts when a prefetcher training op hits on an existing entry in one of the prefetchers selected by UnitMask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `RegionHit` | Region prefetcher. |
| 1 | `StrideHit` | Stride prefetcher. |
| 0 | `StreamHit` | Stream prefetcher. |


## PMCx04E — LS — Tablewalk latency

**Symbolic:** `Core::X86::Pmc::Core::Tablewalk_Latency`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx04E`

Counts how many tablewalkers are allocated each cycle. Masks[6] and [7] select the source of the tablewalk (ITLB or DTLB). Use PMCx046 ( Core::X86::Pmc::Core::Page_Table_Walk_Allocation ) to count Tablewalker allocations and calculate the average Tablewalk latency as: (count of active tablewalks each cycle) / (number of table walker allocations)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 | `Tablewalks` | Sets which tablewalks to count. Value Name Description 0h None No tablewalks. 1h DSideWalks Counts D-side walks. 2h ISideWalks Counts I-side walks. 3h AllTablewalks Counts all tablewalks. |


## PMCx04F — LS — HwPf Stride Mismatch

**Symbolic:** `Core::X86::Pmc::Core::HwPf_Stride_Mismatch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx04F`

The stride prefetcher structure tracks 92 rIPs and for each one records a stride (memory address minus previous address) at that given RIP. When a new training op hits in the structure (rIP match) but the newly calculated stride doesn't match what's in the structure, a Stride Mismatch is counted.


## PMCx050 — LS — Write Combining Buffer Close

**Symbolic:** `Core::X86::Pmc::Core::WCB_Close`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx050`

Counts events that cause a Write Combining Buffer (WCB) entry to close. UnitMask events ADDed. Multiple WCBs can report events at the same time.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LdHit` | Non-cacheable WCB hit by a younger load. |
| 6 | `SmcHit` | WCB hit by SMC probe. |
| 5 | `Timer` | WCB timer expired. |
| 4 | `WcbFull` | WCB full and a store dealloc needs to allocate. |
| 3 | `Barrier` | Closed due to barrier (e.g. a non-combinable non-cacheable store, an SFENCE, or a lock). |
| 2 | `WfqVirtCrBuslock` |  |
| 1 | `NeedSbex` | LDQ requested WCB close due to SBEX op. |
| 0 | `FullLine64B` | All 64 bytes of the WCB entry have been written. |


## PMCx051 — LS — HwPf MAB matched

**Symbolic:** `Core::X86::Pmc::Core::HwPf_MAB_Matched`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx051`

A load or store op hit on a Miss Address Buffer (MAB) that was allocated by HW prefetch. UnitMask bits select which type of HW prefetch will be counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Region` | Counts hits on MABs allocated by Region prefetcher. |
| 1 | `L1Stride` | Counts hits on MABs allocated by Stride prefetcher. |
| 0 | `L1Stream` | Counts hits on MABs allocated by Stream prefetcher. |


## PMCx052 — LS — Ineffective Software Prefetches

**Symbolic:** `Core::X86::Pmc::Core::Ineffective_Software_Prefetches`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx052`

The number of software prefetches that did not fetch data outside of the processor core.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `MabHit` | Software PREFETCH instruction saw a match on an already-allocated miss request. |
| 0 | `DcHit` | Software PREFETCH instruction saw a DC hit. |


## PMCx053 — LS — Stalled MAB Allocation Requests Due to MAB Full

**Symbolic:** `Core::X86::Pmc::Core::MAB_Full`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx053`

Counts load/store flows (no HW prefetches) that requested a Miss Address Buffer (MAB) but were not able to allocate one because all MABs were in use.


## PMCx054 — LS — MAB Allocation or MAB Match

**Symbolic:** `Core::X86::Pmc::Core::MAB_Alloc_or_MAB_Match_No_HwPf`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx054`

Counts load/store flows (no HW prefetches) that requested a Miss Address Buffer (MAB) and were able to allocate one or hit on an existing MAB entry.


## PMCx055 — LS — MAB Match

**Symbolic:** `Core::X86::Pmc::Core::MAB_Match_No_HwPf`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx055`

Counts load/store flows (no HW prefetches) that requested a Miss Address Buffer (MAB) and hit on an existing MAB entry.


## PMCx056 — LS — MAB Index Block

**Symbolic:** `Core::X86::Pmc::Core::MAB_Index_Block`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx056`

Counts when a load or store is blocked from allocating a Miss Address Buffer (MAB) entry due to an index/VA-hash match with an existing MAB entry.


## PMCx057 — LS — Hw Prefetch MAB Allocation

**Symbolic:** `Core::X86::Pmc::Core::HwPf_MAB_Alloc`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx057`

Counts MAB allocations by various HW prefetchers. The UnitMask bits control the types of prefetchers that are considered for counting MAB allocations.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Region` | Region |
| 1 | `L1Stride` | L1 Stride |
| 0 | `Stream` | Stream |


## PMCx058 — LS — Hw Prefetch MAB Match

**Symbolic:** `Core::X86::Pmc::Core::HwPf_MAB_Match_HwPf_hit_MAB`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx058`

Counts MAB matches by various HW prefetchers. The UnitMask bits control the types of prefetchers that are considered for counting MAB allocations.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Region` | Region |
| 1 | `L1Stride` | L1 Stride |
| 0 | `Stream` | Stream |


## PMCx059 — LS — Software Prefetch Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::Software_Prefetch_Data_Cache_Fills`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx059`

Counts fills into the DC that were initiated by software prefetch instructions, per data source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Alternate Memories, a group of less commonly available memory types including CXL™(TM) (see section "Definitions" for details). No further breakdown like PMCx048 for PMCx044[7] is available. |
| 6 | `DramIO_Far` | Data returned from different node's DRAM/ MMIO . |
| 5 | `L4Cache` | From L4Cache |
| 4 | `NearFarCache_Far` | Data belonging to a different NUMA node returned from cache of a different CCX . |
| 3 | `DramIO_Near` | Data returned from local node's DRAM/ MMIO . |
| 2 | `NearFarCache_Near` | Data belonging to the local NUMA node returned from cache of a different CCX . |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX . |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx05A — LS — Hardware Prefetch Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::Hardware_Prefetch_Data_Cache_Fills`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx05A`

Counts fills into the DC that were initiated by hardware prefetches, per data source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Alternate Memories, a group of less commonly available memory types including CXL™(TM) (see section "Definitions" for details). No further breakdown like PMCx048 for PMCx044[7] is available. |
| 6 | `DramIO_Far` | Data returned from different node's DRAM/ MMIO . |
| 5 | `L4Cache` | From L4Cache |
| 4 | `NearFarCache_Far` | Data belonging to a different NUMA node returned from cache of a different CCX . |
| 3 | `DramIO_Near` | Data returned from local node's DRAM/ MMIO . |
| 2 | `NearFarCache_Near` | Data belonging to the local NUMA node returned from cache of a different CCX . |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX . |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx05B — LS — Tablewalker Data Cache Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::Table_Walker_Data_Cache_Fills_by_Data_Source`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx05B`

Counts fills into the DC that were initiated by tablewalks, per data source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | Requests that return from Alternate Memories, a group of less commonly available memory types including CXL™(TM) (see section "Definitions" for details). No further breakdown like PMCx048 for PMCx044[7] is available. |
| 6 | `DramIO_Far` | Requests that target another NUMA node and return from DRAM or MMIO . |
| 5 | `L4Cache` | From L4Cache |
| 4 | `NearFarCache_Far` | Requests that target another NUMA node and return from another CCX 's cache. |
| 3 | `DramIO_Near` | Requests that target the same NUMA node and return from DRAM or MMIO . |
| 2 | `NearFarCache_Near` | Requests that target the same NUMA node and return from another CCX 's cache. |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX . |
| 0 | `LocalL2` | Data returned from local L2. |


## PMCx05C — LS — Fill Response MOESI

**Symbolic:** `Core::X86::Pmc::Core::Fill_Response_MOESI`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx05C`

Cache coherence state of a fill response.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `M_Alias` | M (Alias) |
| 6 | `D_Alias` | D (Alias) |
| 5 | `E_Alias` | E (Alias) |
| 4 | `S_Alias` | S (Alias) |
| 2 | `D_Fill` | D (Fill) |
| 1 | `E_Fill` | E (Fill) |
| 0 | `S_Fill` | S (Fill) |


## PMCx05D — LS — DC Victim MOESI

**Symbolic:** `Core::X86::Pmc::Core::DC_Victim_MOESI`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx05D`

Cache coherence state of a DC victim.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `M` | M |
| 2 | `D` | D |
| 1 | `E` | E |
| 0 | `S` | S |


## PMCx05E — LS — Victim Nack

**Symbolic:** `Core::X86::Pmc::Core::Victim_Nack`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx05E`

Reasons why the core nacks an L2 response or probe. UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `TagErr` | Tag error on the victim/probe flow. |
| 6 | `CBB` | Probe or victim matches a recently-filled cacheline. |
| 5 | `InFlightFillVic` | A newly-filled line cannot be chosen as a victim if the fill is still in-flight. |
| 4 | `DcIndexFull` | The number of ways at this index in a fill-pending state exceeds a threshold. See PMCx04A. |
| 3 | `TSX` | Transactional memory related nacks. |
| 2 | `ScbGloballyVisible` | An SCB to the victim cacheline is globally visible but hasn't committed yet. |
| 1 | `ScbCommitInFlight` | A store is committing to the cacheline being probed or victimized. |
| 0 | `CacheLock` | Probe or DC victim matches an in-progress cacheable lock's cacheline. |


## PMCx05F — LS — Allocated DC misses

**Symbolic:** `Core::X86::Pmc::Core::Allocated_DC_misses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx05F`

Counts the number of in-flight DC misses each cycle.


## PMCx060 — L2 — Requests to L2 Group1

**Symbolic:** `Core::X86::Pmc::L2::L2RequestG1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx060`

All L2 Cache Requests (Breakdown 1 - Common)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RdBlkL` | Data Cache Reads (including hardware and software prefetch). |
| 6 | `RdBlkX` | Data Cache Stores |
| 5 | `LsRdBlkC_S` | Data Cache Shared Reads |
| 4 | `CacheableIcRead` | Instruction Cache Reads. |
| 2 | `LsPrefetchL2Cmd` | Does not count prefetches from core initiated by non-PrefetchL2 Cmd. Assume core should also count all types of prefetches and allow the breakdown between hardware versus software and data versus instruction. |
| 1 | `L2HwPf` | : L2 Prefetcher. Counting of CDMA read requests in this event can be disabled by the &apos. All prefetches accepted by L2 pipeline, hit or miss. Types of PF and L2 hit/miss broken out in a separate perfmon event |
| 0 | `Group2` | Miscellaneous events covered in more detail by Core::X86::Pmc::L2::L2RequestG2 (PMCx061). |


## PMCx061 — L2 — Requests to L2 Group2

**Symbolic:** `Core::X86::Pmc::L2::L2RequestG2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx061`

All L2 Cache Requests (Breakdown 2 - Rare). Multi-events in that LS and IF requests can be received simultaneously.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Group1` | Miscellaneous events covered in more detail by Core::X86::Pmc::L2::L2RequestG1 (PMCx060). All Group 1 commands not in unit0 |
| 6 | `LsRdSized` | LS sized read, coherent non-cacheable. |
| 5 | `LsRdSizedNC` | LS sized read, non-coherent, non-cacheable. |
| 4 | `IcRdSized` | Instruction cache read sized. |
| 3 | `IcRdSizedNC` | Instruction cache read sized non-cacheable. |
| 2 | `ICPrefetchL2Cmd` | Instruction cache prefetchL2 request. |
| 1 | `BusLockTLBSyncOriginator` | : BusLocks or TLBSyncs originator. Counts if there is a Bus lock or TLBSync originating from this thread |
| 0 | `BusLockTLBSyncResponse` | : BusLock or TLBSync responses. Counts if there is a Bus lock response or TLBSync response from this thread |


## PMCx062 — L2 — L2 Latency

**Symbolic:** `Core::X86::Pmc::L2::L2Latency`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx062`

Number of L2 fills waiting to complete from L3 or memory, divided by eight. Incremented by one periodically to correct for remainder. Value may be used to calculate average latency by summing over an interval of time, multiplying by eight, and then dividing by the total number of L2 fills in that same interval of time (unit mask Core::X86::Pmc::L2::L2RequestG1 == FEh). Event counts are for both threads. To calculate average latency, the number of fills from both threads must be used. Only one UserMask should be set at a time.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `L2CyclesWaitingOnFillsAndRdBlkA` | L2 cycles waiting on fills and RdBlkA* |
| 1 | `L2CyclesWaitingOnRdBlkA` | L2 cycles waiting on RdBlkA* |
| 0 | `L2CyclesWaitingOnFills` | L2 cycles waiting on fills (RdBlkA* not included) |


## PMCx063 — L2 — Write Combining Buffer Requests

**Symbolic:** `Core::X86::Pmc::L2::L2WcbReq`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx063`

Write Combining Buffer operations. For information on Write Combining see docAPM2 sections: Memory System, Memory Types, Buffering and Combining Memory Writes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CleanseL2Way` | Core action that: * Moves a dirty L2 way to the L3 or memory and the L2 way is invalidated. * Moves a clean L2 way to the L3 or discards it and the L2 way is invalidated. |
| 6 | `ErmsbStore` | ERMSB store |
| 5 | `WcbClose` | Write Combining Buffer close |
| 4 | `CacheLineFlush` | Cache Line Flush |
| 3 | `I_LineFlush` | Any of the following cache manipulation actions from the core: FlushL2L3Way, ClearL2L3Way, CleanseL2L3Way. * FlushL2L3Way: Equivalent of WBINVD to only one cache way. * ClearL2L3Way: Equivalent of INVD to only one cache way. * CleanseL2L3Way: Equivalent of WBIOINVD to only one cache way. |
| 2 | `ZeroByteStore` | This becomes WriteNoData at SDP (Scalable Datafabric Port); this count does not include TLB Sync Ops and bus locks which are counted in Core::X86::Pmc::L2::L2RequestG2 . |
| 1 | `CachelineCleanse` | Core action that: * Moves a dirty L2 line to the L3 or memory and the L2 line is invalidated. * Moves a clean L2 line to the L3 or discards it and the L2 line is invalidated. |
| 0 | `CLZero` | : Cache Line Zero. Count zeroing data of a cache line. See docAPM3 CLZERO. |


## PMCx064 — L2 — Core to L2 Cacheable Request Access Status

**Symbolic:** `Core::X86::Pmc::L2::L2CacheReqStat`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx064`

This event does not count accesses to the L2 cache by the L2 prefetcher, but it does count accesses by the L1 prefetcher. RdBlkWeakX has a mode where it will return S back to LS if L2 state is non-X, instead of sending an upgrade request to L3: DisableSharedOnRdBlkWeakXNonExclusive. RdBlkWeakX behaves the same as RdBlkX in PMC 0x64 except for the case where L2 hits S and is in this config mode. In this situation, the RdBlkWeakX hitting 'S' will report a hit since the request will not go out to L3. L2 Cache Request Outcomes (not including L2 Prefetch).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LsRdBlkCS` | : Data Cache Shared Read Hit in L2. LsRdBlkCS |
| 6 | `LsRdBlkLHitX` | : Data Cache Read Hit in L2. Modifiable |
| 5 | `LsRdBlkLHitS` | : Data Cache Read Hit Non-Modifiable Line in L2. Counts LS RdBlkL hitting a line in L2 in the following states: S, F, O. |
| 4 | `LsRdBlkX` | : Data Cache Store Hit in L2. Count RdBlkX finding Shared as a Miss If RdBlkWeakX will return S on a non-exclusive line (via chicken bit) and finds "S," this will count as a hit. Otherwise RdBlkWeakX behaves like RdBlkX for this PMC |
| 3 | `LsRdBlkC` | : Data Cache Req Miss in L2. Counts misses for the following LS request types: RdBlkC, RdBlkS, RdBlkL, RdBlkX. |
| 2 | `IcFillHitX` | : Instruction Cache Hit Modifiable Line in L2. IcFillHitX |
| 1 | `IcFillHitS` | : Instruction Cache Hit Non-Modifiable Line in L2.. Counts IC Fill hitting a line in L2 in the following states: S, F, O. |
| 0 | `IcFillMiss` | : Instruction Cache Req Miss in L2. IcFillMiss |


## PMCx065 — L2 — L2 Victim State

**Symbolic:** `Core::X86::Pmc::L2::L2VictimState`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx065`

State of an L2 victim, including information from DC, if the line was pulled out of the DC.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Invalid` | Invalid |
| 4 | `Dirty` | Dirty |
| 3 | `Owned` | Owned |
| 2 | `Modified` | Modified |
| 1 | `Exclusive` | Exclusive |
| 0 | `Shared` | Shared |


## PMCx066 — L2 — L2 Victim Merit

**Symbolic:** `Core::X86::Pmc::L2::L2VictimMerit`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx066`

The unit masks allow for counting various combinations of victim merit information. ICVal indicates the line may have been removed from the IC, DCVal indicates is was removed from the L1DC and UnusedPf indicates that the line was brought by a prefetch and was never brought into the L1. Note that the L2 is not notified when a line is removed from the IC, so ICVal is conservative; that is, if it is true, it meansthe line may be in the IC, but when it is false, the line is certainly not in the IC.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `ICValDCValUnusedPf` | L2 victim was used by L1 Instruction Cache and was resident in L1 Data Cache and was an unused prefetch. |
| 6 | `ICValDCVal` | L2 victim was used by L1 Instruction Cache and was resident in L1 Data Cache. |
| 5 | `ICValUnusedPf` | L2 victim was used by L1 Instruction Cache and was an unused prefetch. |
| 4 | `ICVal` | L2 victim was used by L1 Instruction Cache. |
| 3 | `DCValUnusedPf` | L2 victim was resident in L1 Data Cache and was an unused prefetch. |
| 2 | `DCVal` | L2 victim was resident in L1 Data Cache. |
| 1 | `OnlyUnusedPf` | L2 victim was a Prefetch never accessed by the Core. |
| 0 | `NoExtra` | L2 victim was not used by L1 Instruction Cache and was not resident in L1 Data Cache. |


## PMCx067 — L2 — L2 SMC Events

**Symbolic:** `Core::X86::Pmc::L2::L2SmcEvents`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx067`

I-fetch hit L2, DCVal == 1.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `IcFetchhitL2DcVal` | I-fetch hit L2, DCVal == 1. |
| 5 | `IcFetchhitL2` | I-fetch hit L2, DCVal == 0. |
| 2 | `LsRdBlkLSCHitL2IcVal` | LS RdBlkL/S/C hit L2, ICVal == 0. |
| 1 | `RdBlkXHitL2IcVal` | RdBlkX hit L2, ICVal == 0 |


## PMCx068 — L2 — L2CD Fail Reason

**Symbolic:** `Core::X86::Pmc::L2::L2CdFailReason`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx068`

Sub-event 0 increments once for each time that an operation flows down the L2 pipeline and CdFails for any reason. A single Op can cause this count to increment more than once if it CdFails on multiple flows. The other sub-events count various reasons which caused an Op to CdFail. Since an operation may CdFail for multiple reasons, the sum of all the events measured by events 1-7 generally exceeds the number counted in sub-event 0. Note that the CdFail events may happen on different pipestages and the timing is generally not be aligned. Unmasking multiple sub-events from among 1-7 only gives an approximate count of the combination of those two sub-events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Reason6` | Misc flows: Range-lock, Buslock, Tag error, Chained probe not ready, Smc reflow needed, LsNack |
| 6 | `Reason5` | WrSized / RdSized. |
| 5 | `Reason4` | L1 IdxMatch TD5. |
| 4 | `Reason3` | L1 and L2 IdxMatch TD4. |
| 3 | `Reason2` | L2M TWQ / DWP. |
| 2 | `Reason1` | Protection versus other L2 flows and forward progress logic. |
| 1 | `Reason0` | Vb / Mib / Line Miss Pending |
| 0 | `TotalCdFail` | : Total CD Fails. Total CD Fails |


## PMCx069 — L2 — L2 Tag Pick Stalls Reasons

**Symbolic:** `Core::X86::Pmc::L2::L2TagPickStall`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx069`

This event counts stalls for either thread. Sub-event 0 is the total number of cycles that tag pick was stalled, and sum of the reasons counted by sub-events Sub-events 1-7 generally exceed the count of sub-event 0. Note: this event counts stalls for either thread. Does not include stalls due to interlocks or external blocks such as LS.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Reason6` | Vab stall. |
| 6 | `Reason5` | Lob stall. |
| 5 | `Reason4` | Mib stall. |
| 4 | `Reason3` | L3 stall. |
| 3 | `Reason2` | Twq stall. |
| 2 | `Reason1` | Stall for forward progress. |
| 1 | `Reason0` | Stall if for DwpDwq stall. |
| 0 | `TotalTagPickStalls` | : Total Tag Pick Stall Cycles. Cycles when an Op wanted to flow but was stalled, and no other Op flowed. |


## PMCx06A — L2 — L2 Bypasses

**Symbolic:** `Core::X86::Pmc::L2::L2Bypasses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx06A`

The sum of Unit Masks 0-2 is the total number of cacheable Ops serviced by the L2, including prefetches.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `NormalL2Pick` | NormalL2Pick |
| 1 | `LateL2Bypass` | LateL2Bypass |
| 0 | `L2Bypass` | L2Bypass |


## PMCx06B — L2 — L2 Resource Pick Stall

**Symbolic:** `Core::X86::Pmc::L2::L2ResourcePickStall`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx06B`

This multi-event counts both threads. The total wait time increments by the number of Ops div 4 (rounded down) waiting to be picked on a given cycle unless the MergeEvent feature is used. When the MergeEvent feature is used, this event counts the full number of Ops waiting to be picked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `NoTdPick` | : No TD Pick. No TD Pick |
| 2 | `WaitTime` | : Total wait time (Up to 15). Total wait time |


## PMCx06C — L2 — L2 Cycles Under Quiesce

**Symbolic:** `Core::X86::Pmc::L2::L2QuiesceCyc`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx06C`

This multi-event counts both threads. Total cycles spent between receiving a quiesce request and a release for a bus lock or TLB Sync operations. Note: this event counts both threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `DvmSync` | DvmSync Quiesce cycles |
| 0 | `Buslock` | Buslock Quiesce cycles |


## PMCx06D — L2 — Cycles with fill pending from L2

**Symbolic:** `Core::X86::Pmc::L2::L2FillPending`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx06D`

Total cycles spent with one or more fill requests in flight from L2.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `L2FillBusy` | L2FillBusy |


## PMCx06E — LS — Tablewalker Init Level

**Symbolic:** `Core::X86::Pmc::Core::Tablewalker_Init_Level`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx06E`

Counts the level at which a tablewalk starts. If the tablewalk does not hit on a cached entry the walk starts from CR3. Otherwise it can start at intermediate page table entries.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountNested` | Mask bit that specifies to count nested tablewalks. |
| 6 | `CountGuestHost` | Mask bit that specifies to count guest/host/native tablewalks. |
| 5 | `RdPml5e` | Counts tablewalks that start at CR3 with 5-level paging (CR4.LA57 = 1). |
| 4 | `RdPml4e` | Counts tablewalks that start at CR3 with 4-level paging (CR4.LA57 = 0) and read a PLM4E, or hit a cached PLM5E (CR4.LA57 = 1). |
| 3 | `RdPdpe` | Counts tablewalks that start at a cached PLM4E and read a PDPE. |
| 2 | `RdPde` | Counts tablewalks that start at a cached PDPE and read a PDE . |
| 1 | `RdPte` | Counts tablewalks that start at a cached PDE and read a PTE . |
| 0 | `HitLeaf` | Counts tablewalks that hit a cached leaf-level entry at any level. (1G leaf = PDPE, 2M leaf = PDE , 4K leaf = PTE ) |


## PMCx06F — L2 — Prefetch to L2 Promotion Events

**Symbolic:** `Core::X86::Pmc::L2::L2Prefetch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx06F`

LS prefetches may be generated by hardware or software. Also note that each prefetch will increment exactly one of sub-events 1-7; however, a prefetch which increments sub-event 0 will also increment sub-event 1.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `LsL2PrefetchHitL2` | LsL2PrefetchHitL2 |
| 5 | `L2GeneratedPrefetchHitL2` | L2GeneratedPrefetchHitL2 |
| 4 | `IcPrefetchPromoted` | A request from IC->L2 matched a pending prefetch and the prefetch was promoted to a demand fill. |
| 3 | `LsPrefetchPromoted` | A request (Demand, Tlb, or Software Prefetch) from LS->L2 matched a pending prefetch and the prefetch was promoted to a demand fill. |
| 2 | `L1DataPrefetchPromotedInL2` | A request generated by the L1 data prefetcher hit a pending prefetch generated by the L2 prefetcher or generated by an LS PREFETCH to L2 request. |
| 1 | `PrefetchCompletedNotPromoted` | : Prefetch completed without promotion. Prefetch completed without promotion |
| 0 | `RdBlkX_MatchedPrefetch` | These prefetches will not be promoted. |


## PMCx070 — L2 — L2 Prefetch Hit in L2

**Symbolic:** `Core::X86::Pmc::L2::L2PfHitL2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx070`

Counts all L2 prefetches accepted by L2 pipeline which hit in the L2 cache. Please look at PMC L2PfHitL2_Internal below for AMD internal use.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Prefetches` | Value Description 1Eh-00h Reserved. 1Fh Counts requests generated from L2 Hardware Prefetchers. DFh-20h Reserved. E0h Counts requests generated from L1 DC Hardware Prefetchers. FEh-E1h Reserved. FFh Counts requests generated from L1 DC and L2 Hardware Prefetchers. |


## PMCx070 — L2 — L2 Prefetch Hit in L2

**Symbolic:** `Core::X86::Pmc::L2::L2PfHitL2_Internal`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx070`

Counts all L2 prefetches accepted by L2 pipeline which hit in the L2 cache.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L1Region` | L1Region |
| 6 | `L1Stride` | L1Stride |
| 5 | `L1Stream` | L1Stream |
| 4 | `L2Stride` | L2Stride |
| 3 | `L2Burst` | L2Burst |
| 2 | `L2Up_Down` | L2 Up/Down |
| 1 | `L2NextLine` | L2NextLine |
| 0 | `L2Stream` | L2Stream |


## PMCx071 — L2 — L2 Prefetcher Hits in L3

**Symbolic:** `Core::X86::Pmc::L2::L2PfMissL2HitL3`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx071`

Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3. Please look at PMC L2PfMissL2HitL3_Internal below for internal use at AMD.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Prefetches` | L2Stream Value Description 1Eh-00h Reserved. 1Fh Counts requests generated from L2 Hardware Prefetchers. DFh-20h Reserved. E0h Counts requests generated from L1 DC Hardware Prefetchers. FEh-E1h Reserved. FFh Counts requests generated from L1 DC and L2 Hardware Prefetchers. |


## PMCx071 — L2 — L2 Prefetcher Hits in L3

**Symbolic:** `Core::X86::Pmc::L2::L2PfMissL2HitL3_Internal`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx071`

Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3. Note that this event does not count prefetches that get promoted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L1Region` | L1Region |
| 6 | `L1Stride` | L1Stride |
| 5 | `L1Stream` | L1Stream |
| 4 | `L2Stride` | L2Stride |
| 3 | `L2Burst` | L2Burst |
| 2 | `L2Up_Down` | L2 Up/Down |
| 1 | `L2NextLine` | L2NextLine |
| 0 | `L2Stream` | L2Stream |


## PMCx072 — L2 — L2 Prefetcher Misses in L3

**Symbolic:** `Core::X86::Pmc::L2::L2PfMissL2L3`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx072`

Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 and the L3 caches Please look at PMC L2PfMissL2L3_Internal below for internal use at AMD.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Prefetches` | L2Stream Value Description 1Eh-00h Reserved. 1Fh Counts requests generated from L2 Hardware Prefetchers. DFh-20h Reserved. E0h Counts requests generated from L1 DC Hardware Prefetchers. FEh-E1h Reserved. FFh Counts requests generated from L1 DC and L2 Hardware Prefetchers. |


## PMCx072 — L2 — L2 Prefetcher Misses in L3

**Symbolic:** `Core::X86::Pmc::L2::L2PfMissL2L3_Internal`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx072`

Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 and the L3 caches Note that this event does not count prefetches that get promoted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L1Region` | L1Region |
| 6 | `L1Stride` | L1Stride |
| 5 | `L1Stream` | L1Stream |
| 4 | `L2Stride` | L2Stride |
| 3 | `L2Burst` | L2Burst |
| 2 | `L2Up_Down` | L2 Up/Down |
| 1 | `L2NextLine` | L2NextLine |
| 0 | `L2Stream` | L2Stream |


## PMCx073 — L2 — MIB 0 Fill Requests

**Symbolic:** `Core::X86::Pmc::L2::L2Mib0FillReq`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx073`

Counts number of fill requests serviced by MIB slot 0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L2Prefetches` | L2Prefetches |
| 6 | `IcFillRequests` | IcFillRequests |
| 5 | `LsPrefetches` | LsPrefetches |
| 4 | `LsRdBlkA` | LsRdBlkA |
| 3 | `LsRdBlkX` | LsRdBlkX or LsRdBlkWeakX |
| 2 | `LsRdBlkC` | LsRdBlkC |
| 1 | `LsRdBlkS` | LsRdBlkS |
| 0 | `LsRdBlkL` | LsRdBlkL |


## PMCx074 — L2 — L2 MIB 0 Fill Cycles

**Symbolic:** `Core::X86::Pmc::L2::L2Mib0FillCyc`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx074`

Counts the number of cycles spent servicing the fill requests from MIB slot 0. NOTE: By setting the same unit mask for MIB 0 fill requests and MIB 0 fill cycles, it is possible to determine the average latency of a sample of those operations (the ones which happen to be serviced by slot 0).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L2Prefetches` | L2Prefetches |
| 6 | `IcFillRequests` | IcFillRequests |
| 5 | `LsPrefetches` | LsPrefetches |
| 4 | `LsRdBlkA` | LsRdBlkA |
| 3 | `LsRdBlkX` | LsRdBlkX or LsRdBlkWeakX |
| 2 | `LsRdBlkC` | LsRdBlkC |
| 1 | `LsRdBlkS` | LsRdBlkS |
| 0 | `LsRdBlkL` | LsRdBlkL |


## PMCx075 — L2 — L2 Interface Exceptions

**Symbolic:** `Core::X86::Pmc::L2::L2InterfaceExcep`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx075`

Counts unusual events on the Load Store L2 cache interface. NOTE: These events are unrelated and counting the sum of them (by setting more than one unit mask bit) is of marginal value. However, counting the sum of these events could be auseful way to determine that none of these unusual events is happening while using only one counter.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `RinseAndReturnFlow` | LS Rinse And Return Flow. |
| 5 | `LsStallTd` | LS stall TD pipe. |
| 4 | `LsStallRs` | LS stall RS pipe. |
| 3 | `LsNackTd` | LS refused to take a TD response. |
| 2 | `LsRespCdFail` | : LS response CD Fail. LS response CD Fail |
| 1 | `LsFalseMiss` | : LS False Miss. LS False Miss |
| 0 | `LsNackRs` | LS refused to take a RS response. |


## PMCx076 — LS — Cycles Not in Halt

**Symbolic:** `Core::X86::Pmc::Core::Cycles_Not_in_Halt`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx076`

Counts cycles when the thread is not in a HALTed state


## PMCx077 — L2 — L2 Probes from L3

**Symbolic:** `Core::X86::Pmc::L2::L2ProbesFromL3`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx077`

NOTE: A probe cannot miss the L2; the L3 shadow tags allow the L3 to only send probes which will hit (except for store probes). Also note that system management operations are communicated over the probe channel. This event counts all system management operations in their own umask NOTE: CDMA store probes are treated as invalidating probes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `HitMissPend` | Hit MissPending in L2M |
| 6 | `HitNoChange` | This is most likely a sharing event, sending a copy of the line to another core. This will also count Clean probes which hit. |
| 5 | `HitDwnGrd0` | : Hit Downgrade 0. Hit Downgrade with ICVal=0 or DCVal=0. |
| 4 | `HitDwnGrd1` | : Hit Downgrade 1. Hit Downgrade with ICVal=1 or DCVal=1. |
| 3 | `HitInvalidate0` | : Hit Invalidate 0. Hit Invalidate with ICVal=0 and DCVal=0. |
| 2 | `SysMgmt` | This umask is broken and should not be used. It cannot reliably detect probes of any kind. See DECHEL-7813. |
| 1 | `HitInvalidateDCVal` | Hit Invalidate with DCVal=1. |
| 0 | `HitInvalidateICVal` | Hit Invalidate with ICVal=1. |


## PMCx078 — LS — All TLB Flushes

**Symbolic:** `Core::X86::Pmc::Core::TLB_Flush_Events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx078`

TLB flush events. Please look at PMC TLB_Flush_Event_Internal below for AMD internal use.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `All` | All TLB Flushes Value Name Description FEh-00h Reserved. FFh All_TLB_Flushes Counts all TLB Flushes |


## PMCx078 — LS — All TLB Flushes

**Symbolic:** `Core::X86::Pmc::Core::TLB_Flush_Events_Internal`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx078`

Various TLB flush events. The following UnitMask event groups are ORed before the result is ADDed: 0-3, 4-6, 7.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Invl_Pg_PgA_Pcid` | TLB invalidate caused by INVLPG and INVLPGA instructons. |
| 6 | `Tlbi` | The number of flushes received from L2/ DF after expansion & filtering, from InvlPgB or SNP instructions, etc. |
| 5 | `PcidRemap` | Flush due to reclaiming a hardware PCID to use for a new process/CR3. |
| 4 | `AsidRemap` | Flush due to reclaiming a hardware ASID to use for a new guest. |
| 3 | `VirtCr3` | VmidPcidMainAll/VmidPcidMainLocal. Microcode TLB flush command to flush all main entries for the current ASID and PCID, affecting local or global entries. |
| 2 | `VirtCr2` | VmidMainAll/VmidMainLocal. Microcode TLB flush command to flush all main entries for the current ASID affecting local or global entries. |
| 1 | `VirtCr1` | VmidAll. Microcode TLB flush command to flush all local/global main and nested entries for the current ASID. |
| 0 | `VirtCr0` | All/BothAll. Microcode TLB flush command to flush all local/global main and nested entries for all ASIDs affecting its own or both threads. |


## PMCx079 — L2 — L1 Stream Prefetch Accuracy

**Symbolic:** `Core::X86::Pmc::L2::L1StreamPrefetchAccuracy`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx079`

The level of accuracy of the L1 Stream Prefetcher (Higher is more accurate). Bits are one-hot every cycle.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `PfAccuracyGreaterthan80` | PF Accuracy greater than 80%. |
| 2 | `PfAccuracyGreaterthan80_60` | PF Accuracy 60%-80%. |
| 1 | `PfAccuracyGreaterthan60_40` | PF Accuracy 40%-60%. |
| 0 | `PfAccuracyLessthan40` | PF Accuracy Less than 40%. |


## PMCx07A — L2 — L2 Stream Prefetch Throttle State

**Symbolic:** `Core::X86::Pmc::L2::L2StrmPrftchThrtlState`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx07A`

Stream PF is Enabled and not throttled.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `PfEnabled` | Stream PF is Enabled and not throttled. |
| 1 | `PfDisabled` | Stream PF is Disabled. |
| 0 | `PfThrottled` | Stream PF is less aggressive. |


## PMCx07B — L2 — L2CD Fail Reason Group 2

**Symbolic:** `Core::X86::Pmc::L2::L2CdFailReasonG2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx07B`

Rinse flow L2IDX match to IF flow

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `RinseIfL2IdxMatch` | Rinse flow L2IDX match to IF flow |
| 4 | `SecondHalfChain` | CdFail Second half of chain probe before first |
| 3 | `LsNack` | Ls Nack TD flow |
| 2 | `MigPrbL1DReflow` | Reflow Migratory probe to L1D |
| 1 | `L1VicVsL2Vic` | L1 victim matches L2 victim |


## PMCx07C — L2 — L2 Mib Throttle Level Low

**Symbolic:** `Core::X86::Pmc::L2::L2MibThrtlLevelLow`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx07C`

Cycles spent at different lower Mib throttle levels.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Cycles16_31` | Cycles16_31 |
| 6 | `Cycles6_15` | Cycles6_15 |
| 5 | `Cycles5` | Cycles5 |
| 4 | `Cycles4` | Cycles4 |
| 3 | `Cycles3` | Cycles3 |
| 2 | `Cycles2` | Cycles2 |
| 1 | `Cycles1` | Cycles1 |
| 0 | `Cycles0` | Cycles0 |


## PMCx07D — L2 — L2 Mib token return delayed

**Symbolic:** `Core::X86::Pmc::L2::L2MibTokenRtrnDlyd`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx07D`

Mib token return being delayed due to high Mib throttle level.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `AnyMib` | : Any Mib Token return being delayed.. Any Mib Token return being delayed. |
| 2 | `MibToken2` | : Mib Token 2 being delayed.. Mib Token 2 being delayed. |
| 1 | `MibToken1` | : Mib Token 1 being delayed.. Mib Token 1 being delayed. |
| 0 | `MibToken0` | : Mib Token 0 being delayed.. Mib Token 0 being delayed. |


## PMCx07E — L2 — L2 Op blocked due to Mib throttle

**Symbolic:** `Core::X86::Pmc::L2::L2OpBlockedDue2Mibthrottle`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx07E`

Dispatch is being throttled

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `DispatchThrottle` | Dispatch is being throttled |
| 1 | `MibAndDispatchThrottle` | Mib is available, but op can't flow, and Dispatch is being throttled |
| 0 | `Throttle` | Mib is available, but op can't flow. |


## PMCx080 — IC_BP — 32 Byte Instruction Cache Fetch

**Symbolic:** `Core::X86::Pmc::Core::Byte_Instruction_Cache_Fetch_16_32`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx080`

The number of 32 byte instruction fetch windows transferred from IC pipe to DE instruction decoder (includes non-cacheable and cacheable fill responses). 32B fetches are counted when UnitMask = 0x00.


## PMCx081 — IC_BP — 32 Byte Instruction Cache Misses

**Symbolic:** `Core::X86::Pmc::Core::Instruction_Cache_Full_Tag_Misses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx081`

The number of fetch windows tried to read the L1 IC and missed in the full tag.


## PMCx082 — IC_BP — Instruction Cache Refills From L2

**Symbolic:** `Core::X86::Pmc::Core::Instruction_Cache_Refills_from_L2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx082`

The number of 64 byte instruction cache lines fulfilled from the L2 cache.


## PMCx083 — IC_BP — Instruction Cache Refills from System

**Symbolic:** `Core::X86::Pmc::Core::Instruction_Cache_Refills_from_System`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx083`

The number of 64 byte instruction cache line fulfilled from system memory or another cache.


## PMCx084 — IC_BP — L1 ITLB Miss, L2ITLB Hit

**Symbolic:** `Core::X86::Pmc::Core::L1_ITLB_Miss_L2_ITLB_Hit`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx084`

The number of instruction fetches that miss in the L1 ITLB but hit in the L2 ITLB.


## PMCx085 — IC_BP — L1 ITLB Miss, L2 ITLB Miss

**Symbolic:** `Core::X86::Pmc::Core::ITLB_Reload_from_Page_Table_walk`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx085`

The number of instruction fetches that miss in both the L1 ITLB and L2 ITLB.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `Coalesced_4k` | Walk for >4k Coalesced page (implemented as 16k) |
| 2 | `walk_1G` | Walk for 1G page |
| 1 | `walk_2M` | Walk for 2M page |
| 0 | `walk_4K` | Walk to 4k page |


## PMCx086 — IC_BP — SMC/CMC Pipeline Restart Requests

**Symbolic:** `Core::X86::Pmc::Core::SMC_or_CMC_Pipeline_restart_requests`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx086`

Counts the number of times that an invalidating probe hits in the window of all in-flight instructions. A pipeline flush and restart will prevent outdated instructions from being retired. The instruction cache will refetch necessary cache lines from the cache hierarchy after the restart.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `CMC` | CMC (Cross Modifying Code, from another thread) probe hit. |
| 0 | `SMC` | SMC (Self Modifying Code, from the same thread) probe hit. |


## PMCx087 — IC_BP — Instruction Pipe Stall

**Symbolic:** `Core::X86::Pmc::Core::Instruction_Cache_Pipe_Stall`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx087`

Instruction fetching did not make forward progress.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `ThreadNotSelected` | This thread was not selected to do an OC or IC fetch |
| 3 | `IcStallIcMiss` | IC pipe stalled due to an IC miss. This covers uTag and full tag misses. |
| 2 | `IcStallAny` | IC Pipe Stalled during this clock cycle for any reason (nothing valid in IC pipe stage ICM1) |
| 1 | `IcStallPrqEmpty` | IC Pipe Stalled during this clock cycle (including IC to OC fetches) due to PRQ empty. The PRQ is the decoupling queue that holds fetch requests. |
| 0 | `IcStallBackPressure` | IC Pipe Stalled during this clock cycle (including IC to OC fetches) due to back-pressure coming from decode unit. |


## PMCx088 — IC_BP — Return Stack Hits.

**Symbolic:** `Core::X86::Pmc::Core::Return_Stack_Hits`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx088`

The number of near return instructions (RET or RET Iw) that get their return address from the return address stack (i.e., where the stack has not gone empty) for the core. This may include cases where the address is incorrect (return mispredicts). This may also include speculatively executed false-path returns. Return mispredicts are typically caused by the return address stack underflowing, however they may also be caused by an imbalance in calls vs. returns, such as doing a call but then popping the return address off the stack. This event cannot be reliably compared with events PMCx0C9 and PMCx0CA (such as to calculate percentage of return. mispredicts due to an empty return address stack), since it may include speculatively executed false-path returns that are not included in those retire-time events.


## PMCx089 — IC_BP — Return Stack Overflows

**Symbolic:** `Core::X86::Pmc::Core::Return_Stack_Overflows`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx089`

The number of (near) call instructions that cause the return address stack to overflow. When this happens, the oldest entry is discarded. This count may include speculatively executed calls.


## PMCx08A — IC_BP — BTB Hit Attributes

**Symbolic:** `Core::X86::Pmc::Core::BTB_Hit_Attributes`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx08A`

During prediction, there was a hit in L1BTB. To support legacy software, counts both BtbHit and LoopMode when unit_mask[7:0] is set 0

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `SB` | Subcategory of [0]: Btb Hit had SequentialBefore attribute. SequentialBefore means that there were no branches before the end of the cache line, and the first branch is in a subsequent cache line |
| 5 | `TPair` | Subcategory of [0]: Btb Hit is an TPair Btb entry. TPair means the second branch is at the target of the first branch of this BTB entry. |
| 4 | `NPair` | Subcategory of [0]: Btb Hit is an NPair Btb entry. NPair means that the second branch is sequentially after the first branch (on the not-taken path) of this BTB entry. |
| 3 | `Large` | Subcategory of [0]: Btb Hit is a single large target Btb entry. This means that the target does not fit in the small target size, so the entire BTB entry is dedicated to a single branch with a large taget. |
| 2 | `Single` | Subcategory of [0]: Btb Hit is a single branch Btb entry. This means that we have only discovered one branch for this BTB entry. |
| 1 | `BtbHitOrLoop` | Either Btb Hit or In Loop Mode. To calculate BtbHit percentage, divide this count by PMCx09B UnitMask[1] |
| 0 | `BtbHit` | Btb Hit, does not count during BpLoop Mode |


## PMCx08B — IC_BP — BP Pipe Correction or Cancel

**Symbolic:** `Core::X86::Pmc::Core::BP_Correct`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx08B`

The Branch Predictor flushed its own pipeline due to internal conditions such as a second level prediction structure. Does not count the number of bubbles caused by these internal flushes. To support legacy software, counts BP pipe flush for any reason when unit_mask[7:0] is set to 0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `SameAgoIrr` | BP widget to detect SameAgo glass jaw triggered and invalidated an L1BTB entry |
| 5 | `PrqFullLate` | BP pipe flowed based on a speculative PRQ token return, but a final token return did not happen and no room is available in PRQ. |
| 4 | `RasOverflowPrevented` | RasOvflWidget prevented Return Stack from overflowing by causing a cancel |
| 3 | `L1BtbError` | Either L1BtbMultiHit or there was a BTB alias type that BP was able to detect before sending to IC |
| 2 | `L2BtbCancel` | There was an L2BTB Hit |
| 1 | `WakeupCancel` | A L1BTB way was previously put to sleep to save power and needs to be awoken due to a tag hit |
| 0 | `RmcHit` | There was an RecentMispredictCache hit which needs to be written into L1BTB |


## PMCx08C — IC_BP — Instruction Cache Lines Invalidated

**Symbolic:** `Core::X86::Pmc::Core::Instruction_Cache_Lines_Invalidated`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx08C`

The number of instruction cache lines invalidated.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `L2InvalidatingProbe` | L2 invalidating probes (SMC or CMC). A CMC (cross-modifying code) is an external event, either from the other thread of the same core or another core. A SMC (self-modifying code) event is generated by the same thread. |
| 0 | `FillInvalidated` | Instruction Cache Line Invalidated due to overwriting fill response. |


## PMCx08D — IC_BP — Predicted Window Count

**Symbolic:** `Core::X86::Pmc::Core::Predicted_Window_Count`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx08D`

Number of total windows predicted. To calculate number of windows predicted per non-stalled cycle, take this count and divide by PMCx09B UnitMask[1] count. To calculate the number of windows predicted per cycle, divide by the cycle counter


## PMCx08E — IC_BP — Variable Target Predictions

**Symbolic:** `Core::X86::Pmc::Core::Variable_Target_Predictions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx08E`

The number of times a branch used the indirect predictor to make a prediction.


## PMCx08F — IC_BP — IC Fetch Window Length

**Symbolic:** `Core::X86::Pmc::Core::IC_Fetch_Window_Length`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx08F`

Number of bytes presented to DE in a single cycle. Maximum bytes per fetch window is 32. Multiple fetch windows in a cycle may allow this value to exceed 32.


## PMCx090 — IC_BP — BP External Stall

**Symbolic:** `Core::X86::Pmc::Core::BP_External_Stalls`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx090`

Number of cycles that Branch Predictor is stalled and unable to flow its pipe due to conditions outside of the Branch Predictor logic.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `FetchStall` | Thread is stalled due to FetchStall, which most likely means microcode is running special operations to quiet the machine down. |
| 6 | `MabStall` | Thread is stalled due to MabStall. This means IcMab received too many sequential windows from BP that missed in IC, which probably means we are already on a badpath |
| 5 | `ParkStall` | Thread is stalled due to ParkStall, which most likely means microcode is running special operations to quiet the machine down |
| 4 | `BLQ_Full` | Thread is stalled due to the BLQ being full |
| 3 | `PRQ_Full` | Thread is stalled due to the PRQ being full |
| 2 | `FAQ_Full` | Thread is stalled due to the FAQ being full |
| 1 | `BPQ_Full` | Thread is stalled due to the BPQ being full |
| 0 | `ThreadNotSel` | A different thread is using the pipeline for any reason and this thread could have otherwise predicted. |


## PMCx091 — IC_BP — Early Redirects

**Symbolic:** `Core::X86::Pmc::Core::Decoder_Overrides_Existing_Branch_Prediction_Speculative`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx091`

Number of times that an Early Redirect is sent to Branch Predictor. This happens when either the decoder or dispatch logic is able to detect that the Branch Predictor needs to be redirected. To support legacy software, counts both decode and dispatch redirects when unit_mask[1:0] set to 0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `DecodeRedirect` | The Decoder logic sent the Early Redirect to Branch Predictor |
| 0 | `DispatchRedirect` | The Dispatch logic sent the Early Redirect to Branch Predictor |


## PMCx092 — IC_BP — MAB Delayed Fill Request

**Symbolic:** `Core::X86::Pmc::Core::MAB_entries_not_available`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx092`

MAB could not make a request in a given cycle. There is an issue with this counter on NV: please see DENVRTVF-40987 for more details.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `MabDly` | Total number of requests that require MAB but no MAB entries or L2 request tokens were available. |


## PMCx093 — IC_BP — Variable Target Mispredictions

**Symbolic:** `Core::X86::Pmc::Core::Variable_Target_Mispredictions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx093`

Dynamic Indirect Mispredictions counted at retire. These are indirect branches which have been detected to have more than one possible target.


## PMCx094 — IC_BP — ITLB Instruction Fetch Hits

**Symbolic:** `Core::X86::Pmc::Core::ITLB_Hits`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx094`

The number of instruction fetches that hit in the L1ITLB.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `IF1G` | L1 Instruction TLB Hit (1G page size) DENVRTVF-31233: MAY UNDERCOUNT DUE TO CPFR HIT EVENT MISSING. |
| 1 | `IF2M` | L1 Instruction TLB Hit (2M page size) DENVRTVF-31233: MAY UNDERCOUNT DUE TO CPFR HIT EVENT MISSING. |
| 0 | `IF4K` | L1 Instruction TLB Hit (4k or 16k coalesced page size) DENVRTVF-31233: MAY UNDERCOUNT DUE TO CPFR HIT EVENT MISSING. |


## PMCx095 — IC_BP — ITLB Reload Stall

**Symbolic:** `Core::X86::Pmc::Core::ITLB_Reload_Stall`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx095`

Table walk request sent out and is waiting on a response.


## PMCx096 — IC_BP — BP Pipe Stall

**Symbolic:** `Core::X86::Pmc::Core::BP_Stalled`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx096`

Number of cycles that Branch Predictor is stalled and unable to flow its pipe. See Other PMCs for more detailed breakdowns

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Internal` | Thread is stalled due to something internal to BP. See PMCx098 |
| 1 | `External` | Thread is stalled due to backpressure or something else outside of BP. See PMCx090 |
| 0 | `ThreadNotSel` | A different thread is using the pipeline for any reason and this thread could have otherwise predicted. |


## PMCx097 — IC_BP — IC Fill Requests

**Symbolic:** `Core::X86::Pmc::Core::IC_Fill_Requests_instruction_prefetch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx097`

The number of fill requests triggered by instruction prefetching.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `DemandFillPrefetch` | Number of fill requests triggered by prediction-directed instruction prefetch |
| 1 | `NonSeqFillPrefetch` | IC Fill Request (Non-Sequential Prefetch Fill Request, i.e., is a branch target) |
| 0 | `SeqFillPrefetch` | Number of fill requests triggered by sequential instruction prefetch (not a branch target and falls through into next 64B cache line) |


## PMCx098 — IC_BP — BP Internal Stall

**Symbolic:** `Core::X86::Pmc::Core::BP_Internal_Stall`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx098`

Number of cycles that Branch Predictor is stalled and unable to flow its pipe due to conditions inside of the Branch Predictor logic.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `BtbUpdateRead` | BtbUpdate Read Cycle. Read banking was not implemented or there was a bank conflict between prediction and update |
| 6 | `TageUpdateRead` | Tage Update Read Cycle. Read banking was not implemented or there was a bank conflict between prediction and update |
| 5 | `BtbUpdateWrite` | BtbUpdate Write Cycle. Some structures cannot read and write at the same time, so prediction must be stalled during write |
| 4 | `RmcHit` | There was a RecentMispredictCache Hit and BP is waiting for a new entry to be written into L1BTB |
| 3 | `Reinterp` | BP Aliasing was discovered and BP stalls to clear the bad entry from L1BTB. Happens due to not having full targets in BTB as well as CMC/SMC without flushing BTB |
| 2 | `RasOvflStall` | RasOvflWidget kicked in and we are waiting on a return to retire or FAQ to drain |
| 1 | `L1BtbError` | There was an L1BTB MultiHit or L1BTB detected an alias and BP is waiting for the L1BTB to clear the bad entries |
| 0 | `L2BtbCancelCycle` | There was an L2BTB Hit and BP is still waiting for the response data from L2BTB |


## PMCx099 — IC_BP — ITLB L2 reload requests.

**Symbolic:** `Core::X86::Pmc::Core::L2_ITLB_Reloads`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx099`

Counts the number of L2 ITLB reloads or invalidation requests.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `L2_ITLB_Reloads_or_Ivalidations` | When != 2, it counts L2 ITLB reloads. When == 2, it counts L2 ITLB invalidation requests. |


## PMCx09B — IC_BP — L1BTB Access

**Symbolic:** `Core::X86::Pmc::Core::L1_BTB_Accesses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx09B`

Number of times that L1BTB is read during prediction cycles

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `BpPipeActive` | BP pipeline is active |
| 0 | `BtbAccessed` | Subcategory of [1]: Btb is accessed, does not count in BpLoopMode |


## PMCx09C — IC_BP — L1 BTB Miss

**Symbolic:** `Core::X86::Pmc::Core::L1_BTB_Miss`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx09C`

L1 BTB Misses. (Prediction time event)


## PMCx09D — IC_BP — L2BTB Hit/Miss

**Symbolic:** `Core::X86::Pmc::Core::L2_BTB_Hit_Miss_events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx09D`

Number of times that L1BTB did not hit during prediction, and therefore and L2BTB is consulted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `L2BtbHitTbl1` | Hit in L2BTB Table1 (compressed single BTB entries) |
| 1 | `L2BtbHitTbl0` | Hit in L2BTB Table0 (full BTB entries) |
| 0 | `L2BtbMiss` | Miss in all L2BTB tables |


## PMCx09E — IC_BP — L2 BTB Accesses

**Symbolic:** `Core::X86::Pmc::Core::L2_BTB_Accesses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx09E`

L2 BTB Accesses. (Prediction time event)


## PMCx09F — IC_BP — BP Redirects

**Symbolic:** `Core::X86::Pmc::Core::BP_redirects`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx09F`

Counts redirects of the branch predictor. To support legacy software, counts both EX mispredict and resyncs when unit_mask[7:0] is set to 0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `BpL2Redir` | Redirect from second level predictor (prediction-time) |
| 4 | `NonAheadRedir` | BP L1/L2/L3 redirect for non-ahead prediction (prediction-time) |
| 3 | `DecRedir` | Redirect from Decode pipeline (decode-time) |
| 2 | `DispRedir` | Redirect from Dispatch pipeline (dispatch-time) |
| 1 | `ExRedir` | Mispredict redirect from EX (execution-time) |
| 0 | `Resync` | Resync redirect (Retire-time) from RT |


## PMCx0A0 — DE — UOQ write stall cycles from OC fetch pipe

**Symbolic:** `Core::X86::Pmc::Core::UOQ_write_stall_cycles_from_OC_fetch_pipe`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A0`

Counts cycles when no ops are written into the UOQ from the oc-fetch pipe for various reasons. Cycles are only counted when the thread's OCQ has fetches and is not stalled waiting on the decode pipe. Only counts when the thread is not in HALT state. This event is superseded by Core::X86::Pmc::Core::UOQ_Write_Stall_Cycles (PMCx0A7) and only kept for backward compatibility to ZV/VH.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `EaqStall` | OC fetch stalled due to lack of EAQ tokens. |
| 1 | `IdqStall` | OC fetch stalled due to lack of IDQ tokens. |
| 0 | `UopqStall` | OC fetch stalled due to lack of UOQ tokens. |


## PMCx0A1 — DE — Micro Op Cache Full Tag Match Events

**Symbolic:** `Core::X86::Pmc::Core::Micro_Op_Cache_Full_Tag_Match_Events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A1`

Performance events related to the full Micro Op Cache tag match in DE

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `OC_full_tag_miss` | Counts the number of predicted blocks for which at least one OC fetch missed in the full tags and a OC redirect was sent to IC. |
| 0 | `OC_full_tag_hit` | Counts the number of predicted blocks for which all OC fetches hit in the OC full tags. No OC redirect was sent to IC. |


## PMCx0A2 — DE — Micro-Op Cache Build: Number of Ops

**Symbolic:** `Core::X86::Pmc::Core::Micro_Op_Cache_Build_Number_of_Ops`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A2`

The number of unified ops built into the OC. This event counts across both OC write ports. Combined with PMCx0A5 (Umask = 0x3), this event can be used to determine the average number of unified ops per OC entry built. The number of ops built are counted across 2 OC write ports. If a given cycle builds 8 unified ops on both write ports, which is considered rare, the counter will increment by only 15.


## PMCx0A3 — DE — Micro-Op Cache Build: Number of immediate/displacement data

**Symbolic:** `Core::X86::Pmc::Core::Micro_Op_Cache_Build_Number_of_immediate_displacement_data`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A3`

The number of immediates and displacements built into the OC. This event counts across both OC write ports. Combined with PMCx0A5 (Umask = 0x3), this event can be used to determine the average number of immediate/displacement entries per OC entry. If a given cycle builds 8 immediate/displacements on both write ports, which is considered rare, the counter will only increment by only 15.


## PMCx0A4 — DE — Micro-Op Cache Build: Number of Microcoded Instructions

**Symbolic:** `Core::X86::Pmc::Core::Micro_Op_Cache_Build_Number_of_Microcoded_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A4`

The number of microcoded instructions built into the OC. This event counts across both OC write ports. Combined with PMCx0A5 (Umask = 0x3), this event can be used to determine the average number of microcoded instructions per OC entry.


## PMCx0A5 — DE — Op Cache Build Completion Reason

**Symbolic:** `Core::X86::Pmc::Core::Micro_Op_Cache_Build_Build_Break_Reason`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A5`

Counts if an OC (Op Cache) entry was completed due to a taken branch or reaching its capacity limits. Counting all reasons (setting all UnitMask bits) counts the number of OC builds.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `Other` | The OC entry that was built, was terminated because of a reason other than a taken branch - entry capacity for ops, IDQ and Microcoded instructions reached. - max 6 UOPQ writes reached |
| 0 | `Taken_Branch` | A taken branch terminated the OC entry that was built |


## PMCx0A6 — DE — UopCache Build Kill Build Reason

**Symbolic:** `Core::X86::Pmc::Core::Micro_Op_Cache_Build_Build_Kill_Reason`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A6`

There are cases when the OC (Op Cache) cannot build a completed entry because it isn't safe to build for various reasons. When this happens OC builds will be shut down until the next opportunity to start again. This event counts the number of builds that were dropped due to the selected reason(s). Use PMCx0A5 to count the number of builds that succeeded. (PMCx0A5, Umask=0x3)+(PMCx0A6, Umask=0xF) counts all OC build opportunity.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `LoopSizeLimit` | Reset: 0. Number of builds since a taken branch exceeds cfgOcLoopSizeLimit -- configured by Core::X86::Msr::DE_CFG [ OcLoopSzLimit ]. |
| 2 | `Other` | Other build kill reasons |
| 1 | `OC_build_dropped` | Entries are dropped if they are neither written into the build queue nor bypassed. The two build pipes may offer up to 4 entries but only two entries can be written into the build queue per cycle. Also, the build queue may be full. |
| 0 | `ProbeHit` | Invalidating probe hit in the BPQ |


## PMCx0A7 — DE — UOQ write stall cycles

**Symbolic:** `Core::X86::Pmc::Core::UOQ_Write_Stall_Cycles`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A7`

Counts cycles when no ops are written into the UOQ for various reasons. This event covers the decode and oc-fetch pipes. Note: Only counts when a thread is not in HALT state.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Thread_not_selected` | Not supported on NV due to two pipe implementation - DENVRTVF-42921 |
| 6 | `Count_ocfetch_pipe_events` | Enables counting of oc-fetch pipe events |
| 5 | `Count_decode_pipe_events` | Enables counting of decode pipe events for backward compatibility only decode events are also counted when UnitMask[6:5]=00 UnitMask[6:5] = 11 counts both decode pipe and OC-fetch pipe events |
| 4 | `decodeocfetch_interlock` | Decode or OC-fecth pipe stalled because the other pipe has the oldest fetch or the entry (or the complete set of ways at the same index, in bypass case) that wants to be read is currently built (build conflict). This event only counts when Umask[6:5] is configured to count only the decode or the OC pipe but not both. |
| 3 | `Input_queue_empty` | The thread has no fetches in either the IBB or OCQ. Also counts for x86-pick stall irritation. |
| 2 | `EAQ_full` | The thread has valid ops in IBB or OCQ but is out of EAQ tokens. |
| 1 | `IDQ_full` | The thread has valid ops in IBB or OCQ but is out of IDQ tokens. |
| 0 | `UOQ_full` | The thread has valid ops in IBB or OCQ but is out of UOQ tokens. |


## PMCx0A8 — DE — Microcode Sequencer Stalls

**Symbolic:** `Core::X86::Pmc::Core::Microcode_Sequencer_Stall_Cycles`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A8`

Counts cycles when the Microcode sequencer is stalled for serialization.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `wait_for_count_or_wait_for_countl` | wait_for_count or wait_for_countl stall |
| 6 | `mutex_stall` | A thread wants to enter a mutex region and is waiting on the other thread(s) to do so |
| 5 | `wait_for_both_quiet_other_threads` | Another thread initiated a wait_for_all_quiet stall and is waiting for all threads to stall or that other thread is dispatching wait_for_all_quiet protected microcode. This counts between start if the WFAQ stall and the redirect from the JRESYNC at the end of the ep_restart microcode sequence. |
| 4 | `wait_for_both_quiet_this_thread` | This thread initiated a wait_for_all_quiet stall and is waiting for all threads to stall |
| 3 | `wait_for_stq` | wait_for_stq stall |
| 2 | `wait_for_segld` | wait_for_segld stall |
| 1 | `wait_for_quiet` | wait_for_quiet stall |
| 0 | `Serialize` | serialize stall |


## PMCx0A9 — DE — Op Queue Empty

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Empty`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0A9`

Cycles where the Op Queue is empty.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `Microcode_Stall` | cycles when dispatch is empty and the dispatch logic expects ops to come from microcode or fastpath sequencer. This means there is some stall in the microcode pipeline. |
| 0 | `UopQ_Empty` | cycles when dispatch is empty when the dispatch logic expects ops to come from the UopQ |


## PMCx0AA — DE — Source of Op Dispatched From Decoder

**Symbolic:** `Core::X86::Pmc::Core::Source_of_Op_Dispatched_From_Decoder`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AA`

Counts the number of ops dispatched from the decoder classified by op source.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RetQ_compression_correction` | This unit mask has no effect in Nirvana because Nirvana does not support RetQ compression. In architectures that support RetQ compression, when this unit mask set, this event only counts ops that write the RetQ. This aligns this event with what's counted for PMCx0C1. Note that this only modifies how UnitMask[2:0] events are counted. At least one bit in UnitMask[2:0] needs to be set as well for this event to count anything. |
| 2 | `Loop_Buffer` | In Nirvana, this always count zero since Nirvana does not have a loop buffer. In architectures that have a loop buffer, this is a count of ops dispatched from Loop Buffer |
| 1 | `Op_Cache` | Count of ops dispatched from OpCache |
| 0 | `x86_decoder` | Count of ops dispatched from x86 decoder |


## PMCx0AB — DE — Types of Ops Dispatched From Decoder

**Symbolic:** `Core::X86::Pmc::Core::Types_of_Ops_Dispatched_From_Decoder`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AB`

Counts the number of ops dispatched from the decoder classified by op type. The UnitMask value encodes which types of ops are counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4:0 | `DispOpType` | DispOpType. Value Name Description 03h-00h Reserved. 04h any_fp_dispatch Any FP dispatch. 07h-05h Reserved. 08h any_int_dispatch Any Integer dispatch. 1Fh-09h Reserved. |


## PMCx0AB — DE — Types of Ops Dispatched From Decoder

**Symbolic:** `Core::X86::Pmc::Core::Types_of_Ops_Dispatched_From_Decoder_INT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AB`

Counts the number of ops dispatched from the decoder classified by op type. The UnitMask value encodes which types of ops are counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RetQ_compression_correction` | This unit mask has no effect in NV, which does not support RetQ compression. In architectures that support RetQ compression, when this unit mask is set, this event only counts ops that actually write the RetQ. This aligns this event with what's counted for PMCx0C1. Note that this only modifies how UnitMask[5:0] events are counted. A valid encoding for UnitMask[4:0] has to be supplied for this event to count anything. |
| 4 | `fastpath_sequencer` | when set, fastpath sequencer ops are counted. |
| 3 | `integer` | when set, integer ops are counted |
| 2 | `floating_pointSIMD` | when set floating point or SIMD ops are counted |
| 1 | `microcode` | when set, microcode ops are counted. |
| 0 | `fastpath` | when set, fastpath ops are counted. |


## PMCx0AC — DE — Dispatch Stall Cycles Static Restrictions1

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Stall_Cycles_Static_Restrictions_Part_1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AC`

Counts cycles in which a valid Uopq entry was prevented from being loaded into _DI1 due to one of the selected static restrictions. This only counts when the thread has been selected to read the Uopq and _DI1 can be loaded with ops from the Uopq.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `MaxIdrReads` | A max of 6 IDR dispatch slots |
| 0 | `MaxBpw` | A max of 4 BPWs per dispatch group. |


## PMCx0AD — DE — Dispatch Stall Cycles Static Restrictions 2

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Stall_Cycles_Static_Restrictions_Part_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AD`

Counts cycles in which a valid Uopq entry was prevented from being loaded into _DI1 due to one of the selected static restrictions. This only counts when the thread has been selected to read the Uopq and _DI1 can be loaded with ops from the Uopq.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `Max2TknBrn` | max 2 taken branches in 1 dispatch group |
| 2 | `Max8OpDispatch` | max 8 ops in 1 dispatch group |
| 1 | `BreakAfter` | op requires a dispatch break |
| 0 | `BreakBefore` | next op needs to be in slot 0. (Note: this is also how we prevent microcode or fastpath-sequencer ops from dispatching with fastpath.) |


## PMCx0AE — DE — Dynamic Tokens Dispatch Stall Cycles 1

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AE`

Cycles where a dispatch group is valid but does not get dispatched due to a Token Stall. UnitMask bits select the stall types included in the count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `FPSchRsrcStall` | FP NSQ token stall |
| 4 | `TakenBrnchBufferRsrc` | taken branch buffer resource stall. (a.k.a BBQ stall ) |
| 3 | `IntPhyFlagRegFileRsrcStall` | Integer Physical Flag Register File resource stall |
| 2 | `StoreQueueRsrcStall` | STQ Tokens unavailable |
| 1 | `LoadQueueRsrcStall` | Load Queue Token Stall. |
| 0 | `IntPhyRegFileRsrcStall` | Integer Physical Register File resource stall. |


## PMCx0AF — DE — Dynamic Tokens Dispatch Stall Cycles 2

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0AF`

Cycles where a dispatch group is valid but does not get dispatched due to a token stall. UnitMask bits select the stall types included in the count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `RetQ` | Retire queue tokens unavailable |
| 4 | `ExStallReq` | Ex requested a dispatch stall. this is used for a variety of reasons: - MAP state flush recovery - Dispatch Stall debug irritator controlled by EX - pending fault or trap |
| 2 | `EX_Flush_recovery` | Integer Execution flush recovery pending |
| 1 | `AGTokens` | Agen tokens unavailable |
| 0 | `ALTokens` | ALU tokens unavailable |


## PMCx0B0 — DE — Resync Predictor Hits

**Symbolic:** `Core::X86::Pmc::Core::Loads_that_hit_in_the_Resync_Predictor`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B0`

To count number of dispatched loads that hit in the Resync Predictor and force IOHC , set unit_mask[2:0]=0. Must program an additional PMC eventSelect to 0xB1 or 0xB3 to have 0xB0 count properly

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `RpHitBelowThreshold` | Counts number of dispatched loads that hit in the Resync Predictor and do not force IOHC or disable memory renaming |
| 1 | `MemRenDisable` | Counts number of dispatched loads that hit in the Resync Predictor and disable memory renaming |
| 0 | `IohcLoads` | Counts number of dispatched loads that hit in the Resync Predictor and force IOHC Count includes ucode loads, which is not the original intent (DENVRTVF-41086) |


## PMCx0B1 — DE — Load_hits_in_Memory_Dependency_Widgets

**Symbolic:** `Core::X86::Pmc::Core::Load_hits_in_Memory_Dependency_Widgets`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B1`

To count Number of dispatched loads that hit in MDP or Stack tracker or Memfile, set unit_mask[7:0]=0

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `MemfileHit` | Number of dispatched loads that hit in the Memfile |
| 2 | `StkTrackerHitRbp` | Number of dispatched rSP-aliased rBP based loads that hit in Stack tracker |
| 1 | `StkTrackerHitRsp` | Number of dispatched rSP based loads that hit in Stack tracker |
| 0 | `MdpHit` | Number of dispatched loads that hit in MDP |


## PMCx0B3 — DE — Memory_Renamed_Loads_Eliminated

**Symbolic:** `Core::X86::Pmc::Core::Memory_Renamed_Loads_Eliminated`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B3`

To count number of dispatched memory renamed loads that hit in MDP or Stack tracker or Memfile (Backward compatibility with VH), set unit_mask[7:0]=0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `MemfileHit` | Number of memory renamed dispatched loads that hit in the Memfile |
| 2 | `StkTrackerHitRbp` | Number of move eliminated rSP-aliased loads dispatched that hit in Stack tracker. Number of dispatched memory renamed loads that are rBP based, aliased to rBP and hit in the Stack Tracker |
| 1 | `StkTrackerHitRsp` | Number of dispatched memory renamed loads that are rSP based and hit in the Stack Tracker |
| 0 | `MdpHit` | Number of dispatched memory renamed loads that hit in MDP |


## PMCx0B4 — DE — Number_of_Dispatched_op_per_cycle_histogram

**Symbolic:** `Core::X86::Pmc::Core::Number_of_Dispatched_op_per_cycle_histogram`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B4`

Number of dispatched ops per cycle histogram. Counts cycles in which the number of ops selected by the UnitMask are dispatching.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `eightOps` | 8 Ops Dispatched |
| 6 | `sevenOps` | 7 Ops Dispatched |
| 5 | `sixOps` | 6 Ops Dispatched |
| 4 | `fiveOps` | 5 Ops Dispatched |
| 3 | `fourOps` | 4 Ops Dispatched |
| 2 | `threeOps` | 3 Ops Dispatched |
| 1 | `twoOps` | 2 Ops Dispatched |
| 0 | `oneOp` | 1 Op Dispatched |


## PMCx0B5 — DE — No_Dispatch

**Symbolic:** `Core::X86::Pmc::Core::No_Dispatch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B5`

Counts cycles with no dispatch. UnitMask bits select the reason(s) why there is no dispatch. This event does not count when the thread is in a HALT sate.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `QoS_stall` | Qos induced stall |
| 6 | `Other` | Other stall reasons: - stall after PAUSE instruction - stall for completed flush recovery of the integer execution unit |
| 4 | `CacThrottle` | CAC Throttle Stall |
| 3 | `DbgStall` | DE Debug Irritator Stall |
| 2 | `OtherThread` | Other Thread Selected |
| 1 | `TokenStall` | Dispatch Token Stall |
| 0 | `NoInstr` | No Valid Instructions |


## PMCx0B6 — DE — Ops Dispatched Past A Branch

**Symbolic:** `Core::X86::Pmc::Core::Ops_Dispatched_Past_A_Branch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B6`

Number of ops dispatched after a branch instruction.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Past7thBranch` | Count of ops dispatched after seventh branch - can be predicted taken or not-taken. |
| 6 | `Past6thBranch` | Count of ops dispatched after sixth branch - can be predicted taken or not-taken. |
| 5 | `Past5thBranch` | Count of ops dispatched after fifth branch - can be predicted taken or not-taken. |
| 4 | `Past4thBranch` | Count of ops dispatched after fourth branch - can be predicted taken or not-taken. |
| 3 | `Past3rdBranch` | Count of ops dispatched after third branch - can be predicted taken or not-taken. |
| 2 | `Past2ndBranch` | Count of ops dispatched after second branch - can be predicted taken or not-taken. |
| 1 | `Past1stBranch` | Count of ops dispatched after the first branch - can be predicted taken or not-taken and dispatch group may or may not include a second branch |
| 0 | `PastOneBranch` | Count of ops dispatched after a branch in a dispatch group with only one branch - the branch can be predicted taken or not-taken |


## PMCx0B7 — DE — Loop Buffer

**Symbolic:** `Core::X86::Pmc::Core::Loop_Buffer`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B7`

Nirvana does not have a loop buffer so this always counts zero for Nirvana. In architectures with a loop buffer, this is a count of ops dispatched from Loop Buffer.


## PMCx0B8 — DE — Stack_Engine

**Symbolic:** `Core::X86::Pmc::Core::Stack_Engine`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B8`

Counts Stack Engine related events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `OverflowFixupOpRequests` | Counts requests for Fixup-Ops to prevent an overflow of the stack pointer delta. In most cases each request should lead to one Fixup-Op being inserted. The inserted Fixup-Ops are also counted for UnitMask[1]. Use UnitMask[3] to determine the magnitude of Fixup-Op requests. |
| 2 | `FixupOpsAfterFlush` | Reserved - Not supported by NV |
| 1 | `FixupOps` | Counts all Stack Engine Fixup-Ops dispatched to EX. This includes Fixup-Ops for instructions as well as Fixup-Ops requested for Sp-Delta overflow. |
| 0 | `FixupOpReq` | Counts Stack Engine Fixup-Ops requested for instructions that use rSP in an unsupported manner. |


## PMCx0B9 — DE — Op Queue Writes

**Symbolic:** `Core::X86::Pmc::Core::Number_of_UopQ_writes`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0B9`

Counts the number of ops that are written into the Op Queue (UopQ) from either an OC (Op Cache) or IC (I-Cache) fetch.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `IcFetch` | UopQ writes from the IC-fetch and decode pipe |
| 0 | `OcFetch` | UopQ writes from OC |


## PMCx0BA — DE — Dynamic Tokens Dispatch Conflict Stall

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Conflict_Stall_Cycles_Dynamic_Tokens`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0BA`

This event counts cycles when a thread has valid ops to dispatch and these ops are stalled due to the resource selected by UnitMask and the other thread has priority on the shared tokens for that particular resource.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `IntPrf` | PRF tokens unavailable |
| 5 | `ExtId` | External ID tokens unavailable |
| 1 | `Agsq` | AGSQ tokens unavailable |
| 0 | `Alsq` | ALSQ tokens unavailable |


## PMCx0BB — DE — Microcode ROM Thread Contention Cycles

**Symbolic:** `Core::X86::Pmc::Core::Microcode_ROM_Thread_Contention_Cycles`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0BB`

Counts cycles when the Microcode ROM could not be read because another thread was granted this cycle of access. This indicates that both threads are sequencing micro-code at the same time.


## PMCx0BC — DE — SSE and AVX Instructions Dispatched

**Symbolic:** `Core::X86::Pmc::Core::Dispatched_128b_SSE_AVX_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0BC`

To count legacy unit mask: 128b SSE/AVX instructions dispatched, set unit_mask[7:0]=0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Dis_512SseAvx` | 512b SSE/AVX instruction dispatched |
| 1 | `Dis_256SseAvx` | 256b SSE/AVX instructions dispatched |
| 0 | `Dis_128SseAvx` | 128b SSE/AVX instructions dispatched |


## PMCx0BD — DE — 256b SSE/AVX instrs dispatched

**Symbolic:** `Core::X86::Pmc::Core::Dispatched_256b_SSE_AVX_instrs`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0BD`

256b SSE/AVX instructions dispatched. With the extension of Core::X86::Pmc::Core::Dispatched_128b_SSE_AVX_Instructions (PMCx0BC) this PMC event has become obsolete. It is an alias of PMCx0BC, UnitMask[7:0] = 2h Scalar SSE instructions are included - this counter is basically SSE/AVX and 256b.


## PMCx0BE — DE — Stack Engine RspDelta uses

**Symbolic:** `Core::X86::Pmc::Core::Stack_Engine_RspDelta_uses`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0BE`

Counts all uops dispatched that request RspDelta to be used in an ALU or AGU operation


## PMCx0BF — DE — rIP relative ops dispatched

**Symbolic:** `Core::X86::Pmc::Core::rIP_relative_ops_dispatched`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0BF`

Counts dispatched ops that use rip-relative addressing mode. This includes rIP-relative ld/st ops as well as ops that use rIP-relative values (LEA or mov).


## PMCx0C0 — EX — Retired Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C0`

The number of instructions retired (execution completed and architectural state updated). This count includes exceptions and interrupts - each exception or interrupt is counted as one instruction .


## PMCx0C1 — EX — Retired Macro-Ops

**Symbolic:** `Core::X86::Pmc::Core::Retired_Macro_Ops`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C1`

The number of macro-ops retired. Macro-ops are the ops which are dispatched by the processors decode logic. This count includes all processor activity (instructions, exceptions, interrupts, microcode assists, etc.).


## PMCx0C2 — EX — Retired Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Branch_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C2`

The number of branch instructions retired. This includes all types of architectural control flow changes, including exceptions and interrupts.


## PMCx0C3 — EX — Retired Branch Instructions Mispredicted.

**Symbolic:** `Core::X86::Pmc::Core::Retired_Branch_Instructions_Mispredicted`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C3`

The number of retired branch instructions, that were mispredicted. Note that only EX mispredicts (direction mispredicts and indirect target mispredicts) are counted. DE mispredicts (direct target correction misprediected unconditional direct branches) are not counted.


## PMCx0C4 — EX — Retired Taken Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Taken_Branch_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C4`

The number of taken branches that were retired. This includes all types of architectural control flow changes, including exceptions and interrupts.


## PMCx0C5 — EX — Retired Taken Branch Instructions Mispredicted.

**Symbolic:** `Core::X86::Pmc::Core::Retired_Taken_Branch_Instructions_Mispredicted`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C5`

The number of retired taken branch instructions that were mispredicted. Note that only EX mispredicts are counted (and not DE mispredicts) .


## PMCx0C6 — EX — Retired Far Control Transfers

**Symbolic:** `Core::X86::Pmc::Core::Retired_Far_Control_Transfers`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C6`

The number of far control transfers retired including far call/jump/return, IRET, SYSCALL and SYSRET, plus exceptions and interrupts. Far control transfers are not subject to branch prediction.


## PMCx0C7 — EX — Retired Branch Resyncs

**Symbolic:** `Core::X86::Pmc::Core::Retired_Branch_Resyncs`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C7`

The number of resync branches. These reflect pipeline restarts due to certain microcode assists and events such as writes to the active instruction stream, among other things. Each occurrence reflects a restart penalty similar to a branch mispredict. This is relatively rare. Only counts JRESYNCs and not hardware resyncs


## PMCx0C8 — EX — Retired Near Return Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Near_Return_Branch_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C8`

The number of near return instructions (RET [C3] or RET Iw [C2]) retired.


## PMCx0C9 — EX — Retired Near Return Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::Retired_Near_Return_Branch_Instructions_Mispredicted`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0C9`

The number of near returns retired that were not correctly predicted by the return address predictor. Each such mispredict incurs the same penalty as a mispredicted conditional branch instruction. Note that only EX mispredicts are counted (and not DE mispredicts) .


## PMCx0CA — EX — Retired Indirect Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::Retired_Indirect_Branch_Instructions_Mispredicted`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0CA`

The number of indirect branches retired that were not correctly predicted. Each such mispredict incurs the same penalty as a mispredicted conditional branch instruction. Note that only EX mispredicts are counted (and not DE mispredicts) .


## PMCx0CB — EX — Retired MMX FP Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_MMX_FP_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0CB`

The number of MMX, SSE or x87 instructions retired. The UnitMask allows the selection of the individual classes of instructions as given in the table. Each increment represents one complete instruction. Since this event includes non-numeric instructions it is not suitable for measuring MFLOPs

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `SSE` | SSE instructions (SSE, SSE2, SSE3, SSSE3, SSE4A, SSE41, SSE42, AVX). Also See implementation notes. |
| 1 | `MMX` | MMX instructions |
| 0 | `X87` | x87 instructions |


## PMCx0CC — EX — Retired Indirect Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Indirect_Branch_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0CC`

The number of indirect branches retired.


## PMCx0CD — EX — Interrupts-Masked Cycles

**Symbolic:** `Core::X86::Pmc::Core::Interrupts_Masked_Cycles`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0CD`

The number of cycles where interrupts are masked (EFLAGS.IF == 0). Using edge-counting with this event gives the number of times IF is cleared; dividing the cycle-count value by this value gives the average length of time that interrupts are disabled on each instance.


## PMCx0CE — EX — Interrupts-Masked Cycles with Interrupt Pending

**Symbolic:** `Core::X86::Pmc::Core::Interrupts_Masked_Cycles_with_Interrupt_Pending`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0CE`

The number of cycles where interrupts are masked (EFLAGS.IF == 0) and an interrupt is pending.


## PMCx0CF — EX — FPU Exceptions

**Symbolic:** `Core::X86::Pmc::Core::FPU_Exceptions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0CF`

The number of floating point unit exceptions for microcode assists. The UnitMask may be used to isolate specific types of exceptions.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `nonX87_Arch_traps` | nonX87 Arch traps |
| 3 | `X87_Arch_traps` | X87 Arch traps |
| 2 | `nonX87_Uarch_traps` | nonX87 Uarch traps |
| 1 | `X87_Uarch_traps` | X87 Uarch traps |
| 0 | `Total_microfaults` | X87FILL/XMMFILL/YMMHISPILL/YMMHIFILL/FPERRSENS/ TSXFPSPILL |


## PMCx0D0 — EX — Bad Status Issues

**Symbolic:** `Core::X86::Pmc::Core::Bad_Status_Issues`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D0`

Count of ops issued with bad status that must be replayed


## PMCx0D1 — EX — Retired Conditional Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Conditional_Branch_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D1`

Count of conditional branch instructions that retired


## PMCx0D2 — EX — Retire Stalls Per Slot

**Symbolic:** `Core::X86::Pmc::Core::No_Retire`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D2`

Counts the number of retire slots (each cycle), within the 8 oldest retire slots, that remained unused for reasons selected by UnitMask[4:0]. UnitMask events [4:0] are mutually exclusive. If multiple reasons apply for a given slot, the lowest numbered UnitMask event is counted. UnitMask[7:5] act as a qualifier to UnitMask[1] and UnitMask[2] events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `IgnoreFpCompletion` | When set, missing FP completion will not be counted. Use only when UnitMask[1] or UnitMask[2] is set |
| 6 | `IgnoreLsCompletion` | When set, missing LS completion will not be counted. Use only when UnitMask[1] or UnitMask[2] is set |
| 5 | `IgnoreAlCompletion` | When set, missing AL completion will not be counted. Use only when UnitMask[1] or UnitMask[2] is set |
| 4 | `ThreadNotSelected` | The number of ops that could have retired (i.e. did not fall into the sub-events [0]...[3]) but did not retire because the thread was not selected. Only possible in SMT . |
| 3 | `Other` | The number of ops would be able to retire (self and older ops are complete) but were stopped from retirement for other reasons: retire breaks, traps, faults, Spec Lock Map, etc. |
| 2 | `NotCompleteOlder` | The number of ops in the 8 oldest retire slots that have their own completion bits set but are still waiting on older op(s) to complete. Use UnitMask[7:5] to ignore the completion signaling of specific functional units. |
| 1 | `NotCompleteSelf` | The number of ops in the top 8 slots which don't have all their completion bits set. Use UnitMask[7:5] to ignore the completion signaling of specific functional units. |
| 0 | `Empty` | The number of retire slots which do not contain valid op(s). Use PMCx0D9 for a more detailed break-down of the reasons for all retire slots to be empty. |


## PMCx0D3 — EX — Div Cycles Busy count

**Symbolic:** `Core::X86::Pmc::Core::Div_Cycles_Busy_count`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D3`

Counts cycles when the divider is busy


## PMCx0D4 — EX — Div Op Count

**Symbolic:** `Core::X86::Pmc::Core::Div_Op_Count`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D4`

Counts number of divide ops


## PMCx0D5 — EX — Count of Broadcasts

**Symbolic:** `Core::X86::Pmc::Core::Count_of_Broadcasts`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D5`

Count of Flag Register Number (FRN) / Physical Register Number (PRN) broadcasts

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Frn` | FRN broadcast |
| 1 | `PrnLd` | PRN load broadcast |
| 0 | `PrnAlu` | PRN ALU broadcast |


## PMCx0D6 — EX — Cycles with no retire

**Symbolic:** `Core::X86::Pmc::Core::Cycles_With_No_Retire`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D6`

This event counts cycles when the hardware thread does not retire any ops for reasons selected by UnitMask[4:0]. UnitMask events [4:0] are mutually exclusive. If multiple reasons apply for a given cycle, the lowest numbered UnitMask event is counted. UnitMask[7:5] act as a qualifier to UnitMask[1] and UnitMask[2] events. This event is similar to PMCx0D2.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `CompletionFilter` | Value Name Description 0h load_alu_completion Load and ALU completion is considered for UnitMask[1]: NotComplete events. 4h-1h Reserved. 5h only_load_completion Only missing Load completion is considered for UnitMask[1]: NotComplete events. 7h-6h Reserved. |
| 4 | `ThreadNotSelected` | The number cycles where ops could have retired (i.e. did not fall into the sub-events [0]...[3]) but did not retire because the thread arbitration did not select the thread for retire. |
| 3 | `Other` | The number of cycles where ops could have retired (self and older ops are complete), but were stopped from retirement for other reasons: retire breaks, traps, faults, Spec Lock Map, etc. |
| 2 | `NotCompleteOlder` | This UnitMask event does not count anything since the oldest retire slot does not need to wait on older slots. |
| 1 | `NotCompleteSelf` | The number of cycles where the oldest retire slot did not have its completion bits set. Use UnitMask[7:5] to ignore the completion signaling of specific functional units. |
| 0 | `Empty` | The number of cycles when there were no valid ops in the retire queue. This may be caused by front-end bottlenecks or pipeline redirects. Use PMCx0D9 for a more detailed break-down of the reasons for all retire slots to be empty. |


## PMCx0D6 — EX — Cycles with no retire

**Symbolic:** `Core::X86::Pmc::Core::Cycles_With_No_Retire_INT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D6`

This event counts cycles when the hardware thread does not retire any ops for reasons selected by UnitMask[4:0]. UnitMask events [4:0] are mutually exclusive. If multiple reasons apply for a given cycle, the lowest numbered UnitMask event is counted. UnitMask[7:5] act as a qualifier to UnitMask[1] and UnitMask[2] events. This event is similar to PMCx0D2.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `IgnoreFpCompletion` | When set, missing FP completion will not be counted. Use only when UnitMask[1] or UnitMask[2] is set |
| 6 | `IgnoreLsCompletion` | When set, missing LS completion will not be counted. Use only when UnitMask[1] or UnitMask[2] is set |
| 5 | `IgnoreAlCompletion` | When set, missing AL completion will not be counted. Use only when UnitMask[1] or UnitMask[2] is set |
| 4 | `ThreadNotSelected` | The number cycles where ops could have retired (i.e. did not fall into the sub-events [0]...[3]) but did not retire because the thread arbitration did not select the thread for retire. |
| 3 | `Other` | The number of cycles where ops could have retired (self and older ops are complete), but were stopped from retirement for other reasons: retire breaks, traps, faults, Spec Lock Map, etc. |
| 2 | `NotCompleteOlder` | This UnitMask event does not count anything since the oldest retire slot does not need to wait on older slots. |
| 1 | `NotCompleteSelf` | The number of cycles where the oldest retire slot did not have its completion bits set. Use UnitMask[7:5] to ignore the completion signaling of specific functional units. |
| 0 | `Empty` | The number of cycles when there were no valid ops in the retire queue. This may be caused by front-end bottlenecks or pipeline redirects. Use PMCx0D9 for a more detailed break-down of the reasons for all retire slots to be empty. |


## PMCx0D8 — EX — EX Fairness stall

**Symbolic:** `Core::X86::Pmc::Core::Fairness_stall`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D8`

"Count of stalls introduced for picker fairness." This event is only available when Core::X86::Msr::LS_CTL2 [ LSMSC_SecureDebEn ] is set or for the two debug Performance Monitor Counters Core::X86::Msr::DBG_PERF_CTR [1:0]

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Int2FpStall` | Int2FpStall |
| 6 | `EXLS_fairness_widget_Tx_scheduler_pick_stall` | Count of stalls introduced for picker fairness. |
| 5 | `NoPick_TimeOut_Widget` | No-Pick Time-Out Widget (Main Fwd Progress Widget) Tx |
| 4 | `Div_Fwd_Progress_Widget_Tx` | Div Fwd Progress Widget Tx |
| 3 | `Mul_Hi` | Count of stalls introduced for picker fairness. |
| 2 | `Mul` | Count of stalls introduced for picker fairness. |
| 1 | `Fp2Int1` | Count of stalls introduced for picker fairness. |
| 0 | `Fp2Int0` | Count of stalls introduced for picker fairness. |


## PMCx0D9 — EX — Retire Empty

**Symbolic:** `Core::X86::Pmc::Core::Retire_Empty`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx0D9`

To count cycles when the Retire Queue emptied fetch and dispatch were delayed beyond just the redirect penalty. Lowest priority for counting. Set unit_mask[7:3]=5'b11111

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `MicroRedirect` | A MicroRedirect flushed all or some ops from the pipeline and the Retire Queue emptied before the new ops could arrive at retire. 3rd highest priority for counting |
| 1 | `Mispredict_to_BP` | the BP was redirected and the Retire Queue emptied before the redirect target would be able to reach retire in the best case pipeline. 2nd highest priority for counting |
| 0 | `Resync` | Pipeline restart and the re-fetched ops have not yet made it into the Retire Queue. Highest priority for counting. |


## PMCx120 — LS — P0 Freq Cycles not in Halt

**Symbolic:** `Core::X86::Pmc::Core::P0_frequency_Cycles_Not_in_Halt`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx120`

Counts cycles not in Halt, at the P0 P-state frequency, regardless of the current Pstate.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `P0_frequency_Cycles_Not_in_Halt` | Counts at the P0 frequency (same as Core::X86::Msr::MPERF ) when not in Halt. |


## PMCx121 — LS — SPEC_CTL Modes

**Symbolic:** `Core::X86::Pmc::Core::SPEC_CTL_Modes`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx121`

Counts cycles when certain SPEC_CTL controlled security mitigation are active. UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `PSFD` | Counts number of cycles that SPEC_CTL.PSFD is active. |
| 2 | `SSBD` | Counts number of cycles that SPEC_CTL.SSBD is active. |
| 1 | `IBRS` | Counts number of cycles that SPEC_CTL.IBRS is active. This counts the effective IBRS seen by the hardware and includes the effects of EFER.AutomaticIBRS. The PERF_CTL.U/S bits can be used to isolate user vs. supervisor cycles. |
| 0 | `STIBP` | Counts number of cycles that SPEC_CTL.STIBP is active. |


## PMCx122 — LS — L2 Response Nacks 2

**Symbolic:** `Core::X86::Pmc::Core::L2_Response_Nacks_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx122`

Reasons why the core nacks an L2 response or probe. UnitMask events are ORed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `LiveLockWidget` | LiveLock widget nacks probes |
| 2 | `LockAddressContention` | Lock address contention widget nacks a probe following a spinning load |
| 1 | `SrbArrayAccess` | SRB array access to tag or DC data array |
| 0 | `ScbEvictionNack` | SCB commit forward progress widget nacks a fill/probe. |


## PMCx123 — LS — Tablewalker Init Level for GAAT

**Symbolic:** `Core::X86::Pmc::Core::Tablewalker_Init_Level_for_GAAT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx123`

Counts the level at which a GAAT tablewalk starts. If the tablewalk does not hit on a cached entry the walk starts from GAAT CR3. Otherwise it can start at intermediate page table entries.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountNested` | Mask bit that specifies to count nested tablewalks. |
| 6 | `CountGuestHost` | Mask bit that specifies to count guest/host/native tablewalks. |
| 5 | `RdPml5e` | Counts tablewalks that start at CR3 with 5-level paging (CR4.LA57 = 1). |
| 4 | `RdPml4e` | Counts tablewalks that start at CR3 with 4-level paging (CR4.LA57 = 0) and read a PLM4E, or hit a cached PLM5E (CR4.LA57 = 1). |
| 3 | `RdPdpe` | Counts tablewalks that start at a cached PLM4E and read a PDPE. |
| 2 | `RdPde` | Counts tablewalks that start at a cached PDPE and read a PDE . |
| 1 | `RdPte` | Counts tablewalks that start at a cached PDE and read a PTE . |
| 0 | `HitLeaf` | Counts tablewalks that hit a cached leaf-level entry at any level. (1G leaf = PDPE, 2M leaf = PDE , 4K leaf = PTE ) |


## PMCx124 — LS — Tablewalker return types for GAAT

**Symbolic:** `Core::X86::Pmc::Core::Tablewalker_Return_Types_for_GAAT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx124`

Counts the type of table walk responses to the TLBs for a GAAT tablewalk. UnitMask events 0-5 are ORed. UnitMasks 6 and 7 qualify the type of TLB (ITLB, DTLB or both) included in the count.

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


## PMCx125 — LS — Tablewalker GAAT Activity

**Symbolic:** `Core::X86::Pmc::Core::Tablewalker_GAAT_Activity`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx125`

Counts GAAT tablewalk activity. UnitMask events 0-5 are ORed. UnitMasks 6 and 7 qualify the type of TLB (ITLB, DTLB or both) included in the count.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountIside` | Count only I-side returns |
| 6 | `CountDside` | Count only D-side returns |
| 1 | `GaatRestart` | GAAT-mode tablewalk hit a restart entry and restarted in non-GAAT mode |
| 0 | `GaatComplete` | GAAT-mode tablewalk completed in GAAT mode |


## PMCx126 — LS — LS Debug Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::Core::LS_Debug_Raw_Local_Irritator`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx126`

Number of times that LS DBDT raw local irritator asserted (For DBDT IO Ports refer to http://twiki.amd.com/twiki/bin/view/CCDft/CCDftKitdbmu#DBDT_IO_Ports) . Thread0 counts DtIrritator[0], and Thread1 counts DtIrritator[1].

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `Ls1DbgRawLclIrr` | Cycles that the LS1 raw local irritator was active. Will not count anything unless LS1_DbgCfg[Ls1RawLclIrrToPmcIrrPmc] is set |
| 0 | `Ls2DbgRawLclIrr` | Cycles that the LS2 raw local irritator was active. Will not count anything unless LS1_DbgCfg[Ls2RawLclIrrToPmcIrrPmc] is set |


## PMCx127 — LS — Fences

**Symbolic:** `Core::X86::Pmc::Core::Fences`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx127`

Counts executions of LFENCE and SFENCE instructions.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `SFENCE` | SFENCE was executed (non-speculative count). |
| 0 | `LFENCE` | LFENCE was executed (non-speculative count). |


## PMCx128 — LS — RMP Lookups

**Symbolic:** `Core::X86::Pmc::Core::RMP_Lookups`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx128`

Counts the number of times an RMP check must be performed during tablewalks.


## PMCx129 — LS — RMP Skips

**Symbolic:** `Core::X86::Pmc::Core::RMP_Skips`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx129`

Counts the number of times an RMP check can skip its memory lookup because it can use a cached PWC result.


## PMCx130 — LS — Hwpf Generation

**Symbolic:** `Core::X86::Pmc::Core::Hwpf_Generation`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx130`

Counts various stats for prefetch generation

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `L2HwpfMa` | Counts the number of L2 Mis-Aligned Prefetches generated |
| 4 | `L2HwpfFilter` | Counts the number of L2 prefetches which are filtered |
| 3 | `L2HwPfGen` | Counts the number of L2 prefetches generated |
| 2 | `L1HwpfMa` | Counts the number of L1 Mis-Aligned Prefetches generated |
| 1 | `L1HwpfFilter` | Counts the number of L1 prefetches which are filtered |
| 0 | `L1HwPfGen` | Counts the number of L1 prefetches generated |


## PMCx131 — LS — Hwpf Ma Flows

**Symbolic:** `Core::X86::Pmc::Core::Hwpf_Ma_Flows`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx131`

Counts HWPF MA flows and Dropped MA prefetches

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `L2HwpfMaTokenDrop` | Counts the number of L2 MA prefetches dropped due to L2 token not availabled |
| 4 | `L2HwpfMaTlbDrop` | Counts the L2 MA prefetches dropped due to MA1 TLB hit and MA2 TLB miss |
| 3 | `L2HwpfMaFlow` | Counts the L2 flows which resulted in MA prefetch |
| 2 | `L1HwpfMaTokenDrop` | Counts the number of L1 MA prefetches dropped due to L2 token not availabled |
| 1 | `L1HwpfMaTlbDrop` | Counts the L1 MA prefetches dropped due to MA1 TLB hit and MA2 TLB miss |
| 0 | `L1HwpfMaFlow` | Counts the L1 flows which resulted in MA prefetch |


## PMCx160 — L2 — Policy Pair Changes Which Policy Is Winning

**Symbolic:** `Core::X86::Pmc::L2::L2PolcyChgPolcyWin`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx160`

Cycle when policy pair changes which policy is winning. Cfg0 to Cfg1 or vice versa. Intention is to see how "locked" on a policy winner is. If it changes often, no strong signal is being seen.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Policy8_9` | AddNta / SuppressSwPf |
| 6 | `Policy10` | SuppressNta |
| 5 | `Policy6_11` | RripLvlB4L1v / L2VictTlbL3 |
| 4 | `Policy5_12` | L2VictUsedPfL3 / L2VictIcL3 |
| 3 | `Policy4_13` | L2VictUnusedPfL3 / L2VictStoreL3 |
| 2 | `Policy3_14` | PfL2hitRrip / L2VictL1dPfL3 |
| 1 | `Policy2_15` | DemandHitPfRrip / L2VictOtherL3 |
| 0 | `Policy1` | PfInsertRrip |


## PMCx161 — L2 — Cfg0 Default Policy Is Winning

**Symbolic:** `Core::X86::Pmc::L2::L2PolcyDefaultWin`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx161`

Cycle when Cfg0 (default) policy is winning.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Policy8_9` | AddNta / SuppressSwPf |
| 6 | `Policy10` | SuppressNta |
| 5 | `Policy6_11` | RripLvlB4L1v / L2VictTlbL3 |
| 4 | `Policy5_12` | L2VictUsedPfL3 / L2VictIcL3 |
| 3 | `Policy4_13` | L2VictUnusedPfL3 / L2VictStoreL3 |
| 2 | `Policy3_14` | PfL2hitRrip / L2VictL1dPfL3 |
| 1 | `Policy2_15` | DemandHitPfRrip / L2VictOtherL3 |
| 0 | `Policy1` | PfInsertRrip |


## PMCx162 — L2 — CDMA PrbStore from L3

**Symbolic:** `Core::X86::Pmc::L2::CdmaPrbStore`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx162`

Probe Store can miss L2 Consistency check between 0x162 and 0x163: PMC_0x162_Count[5:0] == PMC_0x163_Count[3:0] Count PMC_0x163[1:0] from both threads

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `HitMissPend` | PrbStore Hit, MissPending in L2M; |
| 4 | `HitNoL1` | PrbStore Hit, L2 (ICVal=0, DCVal=0) |
| 3 | `HitDCVal` | PrbStore Hit, L2 (ICVal=0, DCVal=1) |
| 2 | `HitICVal` | PrbStore Hit, L2 (ICVal=1, DCVal=0) |
| 1 | `HitICValDCVal` | PrbStore Hit, L2 (ICVal=1, DCVal=1) |
| 0 | `Miss` | PrbStore Miss |


## PMCx163 — L2 — CDMA Misc Events

**Symbolic:** `Core::X86::Pmc::L2::CdmaMisc`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx163`

Consistency check: PMC_0x163_Count[0] == PMC_x163_Count[5:4] CDMA reads issued by L2 equal CDMA responses (nacked and non-nacked) PMC_x163_Count may undercount if multiple bits are set in unit mask. Only PMC_x163_Count[5:4] are guaranteed to be onehot.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `CdmaReadNotNacked` | Cdma Read Not Nacked |
| 4 | `CdmaReadNacked` | Cdma Read Nacked |
| 3 | `NotConvertedTDPipe` | PrbStore not converted to Cdma Read on TD pipe Thread agnostic |
| 0 | `CdmaReadIssued` | Cdma Read issued by L2 |


## PMCx164 — L2 — L2 Fill Response Source 2

**Symbolic:** `Core::X86::Pmc::L2::L2FillRspSrc_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx164`

Counts fill responses based on their source. This will count all L3 responses to fill requests for the respective sources. This event is similar to LS PMC 0x48

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `PeerAgentFarCs` | Peer Agent Memory, far CS |
| 4 | `ExtnMemoryFarCs` | Extension Memory (S-Link, GenZ, etc. - identified by the CS target and/or address map at DF 's choice), far CS |
| 3 | `LongLatMemFarCs` | DRAM address map with 'long latency' bit set, far CS |
| 2 | `PeerAgentFarNearCs` | Peer Agent Memory, near CS |
| 1 | `ExtnMemoryNearCs` | Extension Memory (S-Link, GenZ, etc. - identified by the CS target and/or address map at DF 's choice), near CS |
| 0 | `LongLatMemNearCs` | DRAM address map with 'long latency' bit set, near CS |


## PMCx165 — L2 — L2 Fill Response Source

**Symbolic:** `Core::X86::Pmc::L2::L2FillRspSrc`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx165`

Counts fill responses based on their source. Selecting an event mask of 0xfe will count all L3 responses. This will count all L3 responses to fill requests. This event is similar to LS PMC 0x44

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AlternateMemories_NearFar` | "Requests that return from Extension Memory" |
| 6 | `DramIO_Far` | Data returned from different node's DRAM/ MMIO . |
| 5 | `L4Cache` | From L4Cache |
| 4 | `NearFarCache_Far` | Data belonging to a different NUMA node returned from cache of a different CCX . |
| 3 | `DramIO_Near` | Data returned from local node's DRAM/ MMIO . |
| 2 | `NearFarCache_Near` | Data belonging to the local NUMA node returned from cache of a different CCX . |
| 1 | `LocalCcx` | Data returned from L3 or different L2 in the same CCX . |


## PMCx166 — L2 — L2 System Management Activity

**Symbolic:** `Core::X86::Pmc::L2::L2SysMgmtActivity`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx166`

Counts various system management activity in L2 that is not captured in other PMC 's. Note that this thread agnostic except for PrbIntrClr and PrbIntr

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `SysMgmtPrb` | System Management probe types from L3. This does not count System Management With Response types |
| 6 | `LclThrottle` | Local throttle probe types from L3. Note that these will always be issued in pairs and the PMC counts each beat of the probe. |
| 5 | `BuslockRequests` | Counts the start of a new buslock quiesce request |
| 4 | `PrbIntrOtherCore` | Probe interrupt that do not match our system core ID |
| 3 | `PrbIntrClr` | Probe interrupt clear vector request that matches our system core ID |
| 2 | `PrbIntr` | Probe interrupt that matches our system core ID |
| 1 | `TLBI` | TLBI requests |
| 0 | `DVMSync` | DVM Sync requests |


## PMCx167 — L2 — L2 Mib Throttle Level High

**Symbolic:** `Core::X86::Pmc::L2::L2MibThrtlLevelHigh`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx167`

Cycles spent at different higher Mib throttle levels.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Cycles31` | Cycles31 |
| 6 | `Cycles25_30` | Cycles25_30 |
| 5 | `Cycles20_24` | Cycles20_24 |
| 4 | `Cycles16_19` | Cycles16_19 |
| 3 | `Cycles12_15` | Cycles12_15 |
| 2 | `Cycles10_11` | Cycles10_11 |
| 1 | `Cycles8_9` | Cycles8_9 |
| 0 | `Cycles0_7` | Cycles0_7 |


## PMCx168 — L2 — L2 Queue Full Cycles

**Symbolic:** `Core::X86::Pmc::L2::L2QueueFull`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx168`

Number of cycles that a queue is Full. Queues are thread agnostic unless otherwise noted

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DWP` | L2M Dedicated Write Port |
| 6 | `DWQ` | L2M Data Write Queue |
| 5 | `TWQ` | L2M Tag Write Queue |
| 4 | `LOB` | L2 Output Buffer |
| 3 | `VB` | Victim Buffer - Per Thread |
| 2 | `XRQ_PRB` | XRQ Probe Occupancy |
| 1 | `L3RQ` | L3 RQ Occupancy - Per Thread |
| 0 | `LSRQ` | LS RQ Occupancy - Per Thread |


## PMCx169 — L2 — L2 Queue 3/4 Full Cycles

**Symbolic:** `Core::X86::Pmc::L2::L2Queue3_4Full`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx169`

Number of cycles that a queue is 3/4 Full. Queues are thread agnostic unless otherwise noted

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DWP` | L2M Dedicated Write Port |
| 6 | `DWQ` | L2M Data Write Queue |
| 5 | `TWQ` | L2M Tag Write Queue |
| 4 | `LOB` | L2 Output Buffer |
| 3 | `VB` | Victim Buffer - Per Thread |
| 2 | `XRQ_PRB` | XRQ Probe Occupancy |
| 1 | `L3RQ` | L3 RQ Occupancy - Per Thread |
| 0 | `LSRQ` | LS RQ Occupancy - Per Thread |


## PMCx16A — L2 — L2 Queue Half Full Cycles

**Symbolic:** `Core::X86::Pmc::L2::L2QueueHalfFull`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx16A`

Number of cycles that a queue is Half Full. Queues are thread agnostic unless otherwise noted

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DWP` | L2M Dedicated Write Port |
| 6 | `DWQ` | L2M Data Write Queue |
| 5 | `TWQ` | L2M Tag Write Queue |
| 4 | `LOB` | L2 Output Buffer |
| 3 | `VB` | Victim Buffer - Per Thread |
| 2 | `XRQ_PRB` | XRQ Probe Occupancy |
| 1 | `L3RQ` | L3 RQ Occupancy - Per Thread |
| 0 | `LSRQ` | LS RQ Occupancy - Per Thread |


## PMCx16B — L2 — L2 Mib Count

**Symbolic:** `Core::X86::Pmc::L2::L2MibCnt`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx16B`

Number of MIB's in use, per thread

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Cnt81_100` | 81-100 |
| 6 | `Cnt61_80` | 61-80 |
| 5 | `Cnt51_60` | 51-60 |
| 4 | `Cnt41_50` | 41-50 |
| 3 | `Cnt31_40` | 31-40 |
| 2 | `Cnt21_30` | 21-30 |
| 1 | `Cnt11_20` | 11-20 |
| 0 | `Cnt1_10` | 1-10 |


## PMCx16C — L2 — L2 RAS Events

**Symbolic:** `Core::X86::Pmc::L2::L2Ras`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx16C`

Per-thread RAS events

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `XiParityError` | XI Parity Error. NOTE that this will not count masked errors. |
| 6 | `L3ResponseRetransmit` | L3 Response Retransmit |
| 5 | `L3ResponsePoison` | L3 Response Poison |
| 4 | `L3ResponseUncorrectable` | L3 Response Uncorrectable Error. NOTE that this will not count masked errors. |
| 3 | `LsVictimPoison` | LS Victim Poison |
| 2 | `L2MPoisonRead` | L2M Poison Read |
| 1 | `L2MUncorrectable` | L2M Uncorrectable (tag/data). NOTE that this will not count masked errors. |
| 0 | `L2MCorrectable` | L2M Correctable (tag/data) NOTE that this will not count masked errors. |


## PMCx16D — L2 — L1 Prefetch Aggressiveness Level

**Symbolic:** `Core::X86::Pmc::L2::L1PfAggLvl`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx16D`

Cycles spent at different L1 prefetch aggressiveness levels (0 is least aggressive, 7 is most aggressive)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Cycles7` | Cycles7 |
| 6 | `Cycles6` | Cycles6 |
| 5 | `Cycles5` | Cycles5 |
| 4 | `Cycles4` | Cycles4 |
| 3 | `Cycles3` | Cycles3 |
| 2 | `Cycles2` | Cycles2 |
| 1 | `Cycles1` | Cycles1 |
| 0 | `Cycles0` | Cycles0 |


## PMCx16E — L2 — L2 Prefetch Aggressiveness Level

**Symbolic:** `Core::X86::Pmc::L2::L2PfAggLvl`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx16E`

Cycles spent at different L2 prefetch aggressiveness levels (0 is least aggressive, 7 is most aggressive)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Cycles7` | Cycles7 |
| 6 | `Cycles6` | Cycles6 |
| 5 | `Cycles5` | Cycles5 |
| 4 | `Cycles4` | Cycles4 |
| 3 | `Cycles3` | Cycles3 |
| 2 | `Cycles2` | Cycles2 |
| 1 | `Cycles1` | Cycles1 |
| 0 | `Cycles0` | Cycles0 |


## PMCx16F — L2 — L2 ERMSB

**Symbolic:** `Core::X86::Pmc::L2::L2Ermsb`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx16F`

ERMSB events

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `ErmsbL2HitM_D_E` | Ermsb L2Hit M/D/E State |
| 1 | `ErmsbL2Hit_S_O` | Ermsb L2Hit S/O State |
| 0 | `ErmsbL2Miss` | Ermsb L2Miss |


## PMCx170 — LS — Tablewalker return types

**Symbolic:** `Core::X86::Pmc::Core::Tablewalker_Return_Types`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx170`

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


## PMCx172 — L2 — L2 Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::L2::L2RawLclIrr`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx172`

L2 Raw Local Irritator

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `L2RawLclIrr` | L2 Raw Local Irritator |


## PMCx180 — IC_BP — MisPredicted Returns

**Symbolic:** `Core::X86::Pmc::Core::MisPredicted_Returns`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx180`

Return address mispredict.


## PMCx182 — IC_BP — ITLB Flow Stalls

**Symbolic:** `Core::X86::Pmc::Core::ITLB_flow_stalls`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx182`

Reason why ITLB was not performing a translation.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `ThreadNotSelected` | The thread was not selected to flow into the ITLB pipeline but it had something to translate |
| 1 | `ItlbMiss` | A translation is not done because of an ITLB miss. That includes the cycle of the miss and when TLB look-up is stalled due to a previous TLB miss |
| 0 | `Empty` | There are no fetches that need a translation |


## PMCx183 — IC_BP — BP Debug Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::Core::BP_Debug_Raw_Local_Irritator`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx183`

Number of times that BP DBDT raw local irritator asserted (For DBDT IO Ports refer to http://twiki.amd.com/twiki/bin/view/CCDft/CCDftKitdbmu#DBDT_IO_Ports) . Thread0 counts DtIrritator[0], and Thread1 counts DtIrritator[1]. Will not count anything unless BP_DbgCfg[IrrToPMC] is set


## PMCx184 — IC_BP — Debug State Machine Actions

**Symbolic:** `Core::X86::Pmc::Core::DsmPmc`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx184`

Actions from core level Debug State Machine

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `DsmPmcAction2` | DsmPmcAction2 from core level Debug State Machine |
| 1 | `DsmPmcAction1` | DsmPmcAction1 from core level Debug State Machine |
| 0 | `DsmPmcAction0` | DsmPmcAction0 from core level Debug State Machine |


## PMCx185 — IC_BP — L2 ITLB Hit Page Size

**Symbolic:** `Core::X86::Pmc::Core::L2_TLB_hit`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx185`

Indicates page size encounted by an L2 ITLB hit.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `hit_1G` | 1G page size |
| 2 | `hit_2M` | 2M page size |
| 1 | `hit_16K` | 16k coalesced page size |
| 0 | `hit_4K` | 4k or 16k page size |


## PMCx186 — IC_BP — Redirects due to Aliased BTBs

**Symbolic:** `Core::X86::Pmc::Core::Redirects_due_to_Aliased_BTBs`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx186`

Aliased BTB resulting in DE or DI redirect. (Decode or Dispatch time event)


## PMCx187 — IC_BP — IC Debug Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::Core::IC_Debug_Raw_Local_Irritator`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx187`

Number of times that IC DBDT raw local irritator asserted (For DBDT IO Ports refer to http://twiki.amd.com/twiki/bin/view/CCDft/CCDftKitdbmu#DBDT_IO_Ports) . Thread0 counts DtIrritator[0], and Thread1 counts DtIrritator[1].

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `IcDbgRawLclIrr` | Cycles that the IC raw local irritator was active. Will not count anything unless IC_DbgCfg[IrrPmc] is set |


## PMCx188 — IC_BP — Fetch IBS events

**Symbolic:** `Core::X86::Pmc::Core::Fetch_IBS_events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx188`

Counts significant Fetch IBS State transitions.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `SampleVal` | Counts the number of valid Fetch Instruction Based Sampling (fetch IBS ) samples that were collected. Each valid sample also created an IBS interrupt. |
| 3 | `SampleFiltered` | Counts the number of Fetch IBS tagged fetches that were discarded due to IBS filtering. When a tagged fetch is discarded the Fetch IBS facility will automatically tag a new fetch. |
| 2 | `SampleDiscarded` | Counts when the Fetch IBS facility discards an IBS tagged fetch for reasons other than IBS filtering. When a tagged fetch is discarded the Fetch IBS facility will automatically tag a new fetch. |
| 1 | `FetchTagged` | Counts the number of fetches tagged for Fetch IBS . Not all tagged fetches create an IBS interrupt and valid fetch sample. |
| 0 | `SampleCandidates` | Counts one for each fetch that could be a candidate for IBS . |


## PMCx189 — IC_BP — Predictor Flush Events

**Symbolic:** `Core::X86::Pmc::Core::Predictor_Flush_Events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx189`

Counts branch predictor flush events associated with security mitigations.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `GHistFlushOnly` | GHist flush was initiated by a direct register write to BP_FLUSH_CTL, but BTB/TAGE/ITTAGE was not initiated |
| 2 | `RasFlushOnly` | RAS flush was initiated by a direct register write to BP_FLUSH_CTL, but BTB/TAGE/ITTAGE was not initiated |
| 1 | `BpFlushOtherT` | Flush of BTB, direction predictor, or indirect target predictor by write to PRED_CMD[0]=1 or by direct register write to BP_FLUSH_CTL , initiated by other thread. |
| 0 | `BpFlushThisT` | Flush of BTB, direction predictor, or indirect target predictor by write to PRED_CMD[0]=1 or by direct register write to BP_FLUSH_CTL , initiated by this thread. |


## PMCx18D — IC_BP — PrqFullLate

**Symbolic:** `Core::X86::Pmc::Core::L1_and_L2_TLB_miss_raw_count`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx18D`

Counts the total number of flows that miss in L1 and L2 ITLBs. Note that this will typically be equal to or larger than than the number of ITLB reloads from LS (fills), PMC0x085


## PMCx18E — IC_BP — IC Tag Hit and Miss Events

**Symbolic:** `Core::X86::Pmc::Core::IC_Tag_Hit_Miss_events`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx18E`

Counts the number of microtag and full tag events as selected by unit mask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4:0 | `IcAccessTypes` | Instruction Cache accesses. Value Name Description 06h-00h Reserved. 07h ic_hit Instruction Cache Hit. 17h-08h Reserved. 18h ic_miss Instruction Cache Miss. 1Eh-19h Reserved. 1Fh ic_all All Instruction Cache Accesses. |


## PMCx18E — IC_BP — IC Tag Hit and Miss Events

**Symbolic:** `Core::X86::Pmc::Core::IC_Tag_Hit_Miss_events_INT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx18E`

Internal view for PMCx18E. Counts the number of microtag and full tag events as selected by unit mask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `IC_Microtag_Miss` | together with UnitMask[3] this allows counting of IC Miss |
| 3 | `IC_Microtag_Hit_But_Tag_Miss` | together with UnitMask[4] this allows counting of IC Miss |
| 2 | `IC_Microtag_Multihit` | IC Microtag Multihit |
| 1 | `IC_Tag_MultiHit` | IC Tag Multi-Hit |
| 0 | `IC_Microtag_Hit` | IC Microtag Hit |


## PMCx1A0 — DE — No_Dispatch_per_Slot

**Symbolic:** `Core::X86::Pmc::Core::No_Dispatch_per_Slot`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1A0`

Counts the number of dispatch slots (each cycle) that remained unused for reasons selected by UnitMask. UnitMask events are mutually exclusive. If multiple reasons apply for a given slot, the lowest numbered UnitMask event is counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `StallReason` | Value Name Description 00h Reserved. 01h count_no_dispatch_frontend_empty Counts dispatch slots left empty because the front-end did not supply ops. 1Dh-02h Reserved. 1Eh count_ops_backend_stalled Counts ops unable to dispatch due to back-end stalls. 5Fh-1Fh Reserved. 60h count_ops_thread_stalled Counts ops unable to dispatch because the dispatch cycle was granted to the other SMT thread. 7Eh-61h Reserved. 7Fh count_no_dispatch Counts all dispatch slots left empty for a given cycle. FFh-80h Reserved. |


## PMCx1A0 — DE — No_Dispatch_per_Slot

**Symbolic:** `Core::X86::Pmc::Core::No_Dispatch_per_Slot_INT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1A0`

Internal view of PMCx1A0. Counts the number of dispatch slots (each cycle) that remained unused for reasons selected by UnitMask. UnitMask events are mutually exclusive. If multiple reasons apply for a given slot, the lowest numbered UnitMask event is counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `ThreadSelBad` | The op could have dispatched, the thread was not selected and the other thread did not dispatch something |
| 5 | `ThreadSelGood` | The op could have dispatched, the thread was not selected and the other thread did dispatch something |
| 4 | `QoS_Throttle` | The thread is throttled by L2's QOS throttle |
| 3 | `OtherStall` | The op was held back by a stall other than the dispatch tokens. |
| 2 | `DispToken` | The op was held back by dispatch token unavailability |
| 1 | `StaticRestr` | There was an op from UOQ for this slot, but it was held back by static restriction(s) |
| 0 | `Empty` | There was no op from UOQ or MWQ for this slot. |


## PMCx1A1 — DE — Dispatch_Stall_Other

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Stall_Other`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1A1`

Counts cycles when the thread is not dispatching due to PMCx1A0 ( Core::X86::Pmc::Core::No_Dispatch _per_Slot) UnitMask[3]. UnitMask events are not mutually exclusive and may overlap. UnitMask events are ORed when multiple are selected. NOTE that for this PMC to count, one of the PMC Events must be set to 0xB5 - DENVRTVF-42829. This PMC counter has a bug for NV: see DENVRTVF-44361 for details.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `PAUSE` | dispatch stalled after a PAUSE instruction was dispatched |
| 2 | `IBRS` | Stall due to SPEC_CTL.IBRS |
| 1 | `WFAQ` | WFAQ initiated on another thread on the same core caused a dispatch stall for fastpath or fastpath sequencer for this thread. Note that if microcode is stalled because of a WFAQ on another thread PMCx1A0 will show dispatch as empty. For more precise counting of stall cycles imposed by another thread's wait_for_all_quiet use PMCx0A8[5]. |
| 0 | `JFAR` | JFAR stall |


## PMCx1A2 — DE — Dispatch Additional Resource Stalls

**Symbolic:** `Core::X86::Pmc::Core::Additional_Resource_Stalls`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1A2`

Public view of PMCx1A2. This PMC event counts additional resource stalls that are not captured by Dispatch_Stall_Cycle_Dynamic_Tokens_Part_1 or Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Stall` | Value Name Description 2Fh-00h Reserved. 30h count_lack_dispatch_resources Counts additional cycles dispatch is stalled due to the lack of dispatch resources. FFh-31h Reserved. |


## PMCx1A2 — DE — Dispatch_Thread_Arbitration

**Symbolic:** `Core::X86::Pmc::Core::Dispatch_Thread_Arbitration`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1A2`

Internal view of PMCx1A2. This PMC event allows for evaluation of dispatch thread arbitration. All UnitMask events count cycles during which the respective condition is true.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `Grant` | The thread was granted dispatch |
| 5 | `AboveIntSchLmt` | The thread is excluded from arbitration because it is above the current integer scheduler queue limit for any of the 4 queues |
| 4 | `AboveLdqLmt` | The thread is excluded from arbitration because it is above the current LDQ limit |
| 3 | `IntSched` | Poor use for any integer scheduler has been detected |
| 2 | `LdqPoorUse` | Poor use for LDQ has been detected |
| 1 | `HasWork` | The thread is seen as having work (UOQ or MWQ not empty) |
| 0 | `ArbReq` | The thread is making an arbitration request |


## PMCx1A3 — DE — DE Debug Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::Core::DE_Debug_Raw_Local_Irritator`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1A3`

Number of times that DE DBDT raw local irritator asserted (For DBDT IO Ports refer to http://twiki.amd.com/twiki/bin/view/CCDft/CCDftKitdbmu#DBDT_IO_Ports) . Thread0 counts DtIrritator[0], and Thread1 counts DtIrritator[1].

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `DeUcDbgRawLclIrr` | Cycles that the DE Ucode raw local irritator was active. Will not count anything unless DEUC_DbgCfg[IrrPmc] is set |
| 0 | `Defe0DbgRawLclIrr` | Cycles that the DEFE0 raw local irritator was active. Will not count anything unless DEFE0_DbgCfg[IrrPmc] is set |


## PMCx1C1 — EX — Retired Microcoded Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Microcoded_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C1`

The number of retired microcoded instructions. Note that exception handlers are counted as a microcoded instruction since the Jresync ending the sequence has .exit. Includes fastpath sequenced instructions.


## PMCx1C2 — EX — Retired Microcode Ops

**Symbolic:** `Core::X86::Pmc::Core::Retired_Microcode_Ops`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C2`

The number of microcode ops that have retired. Includes Fastpath Sequencer ops.


## PMCx1C3 — EX — Interrupt Checks

**Symbolic:** `Core::X86::Pmc::Core::Interrupt_Checks`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C3`

Only counting intchk that are not fastpath (i.e. intchk that are microcode or fastpath sequencer)


## PMCx1C5 — EX — Retired Mispredicted Branch Instructions Predicted Taken

**Symbolic:** `Core::X86::Pmc::Core::Retired_Mispredicted_Branch_Instructions_Predicted_Taken`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C5`

The number of retired branch instructions that were predicted taken, but mispredicted. This counter was implemented exactly like ExRetBrnTknMisp in the RTL. Note that only EX mispredicts are counted (and not DE mispredicts) PMC Counter has a bug in it, use caution. See DEKLARTVF-6779 for more details.


## PMCx1C6 — EX — Retired PAUSE Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_PAUSE_instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C6`

The number of retired PAUSE instructions


## PMCx1C7 — EX — Retired Conditional Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::Retired_Conditional_Branch_Instructions_Mispredicted`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C7`

The number of retired conditional branch instructions that were not correctly predicted because of a branch direction mismatch. Note that only EX mispredicts are counted (and not DE mispredicts)


## PMCx1C8 — EX — Retired Unconditional Branch Instructions Mispredicted

**Symbolic:** `Core::X86::Pmc::Core::Retired_Unconditional_Branch_Instructions_Mispredicted`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C8`

The number of retired unconditional indirect branch instructions that were mispredicted. Note that only EX mispredicts are counted (and not DE mispredicts) which is why this only counts mispredicts of indirect branches.


## PMCx1C9 — EX — Retired Unconditional Branch Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_Unconditional_Branch_Instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1C9`

Reserved.


## PMCx1CA — EX — Retired op is a PMatch

**Symbolic:** `Core::X86::Pmc::Core::Retired_op_is_a_PMatch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1CA`

Count of the number of times the 1st op of an uline which hits any of the PMatch registers retired.


## PMCx1CB — EX — Small (8/16/32b operand size) Single Multiplies Executed

**Symbolic:** `Core::X86::Pmc::Core::Small_8_16_32b_operand_size_Single_Multiplies_Executed`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1CB`

Single means there is only one destination register


## PMCx1CC — EX — Small (8/16/32b operant size) Double Multiplies Executed

**Symbolic:** `Core::X86::Pmc::Core::Small_8_16_32b_operant_size_Double_Multiplies_Executed`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1CC`

Double means there are two destination registers


## PMCx1CD — EX — Large (64b operand size) Single Multiplies Executed

**Symbolic:** `Core::X86::Pmc::Core::Large_64b_operand_size_Single_Multiplies_Executed`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1CD`

Single means there is only one destination register


## PMCx1CE — EX — Large (64b operand size) Double Multiplies Executed

**Symbolic:** `Core::X86::Pmc::Core::Large_64b_operand_size_Double_Multiplies_Executed`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1CE`

Double means there are two destination registers


## PMCx1CF — EX — Tagged IBS Ops

**Symbolic:** `Core::X86::Pmc::Core::Tagged_IBS_Ops`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1CF`

Counts Op IBS related events

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `IbsTaggedOpsL3MissFiltered` | Counts the number of ops tagged by IBS that are dropped due to L3MissOnly filtering. Erratum: In NV, this counter includes ops that are flushed. |
| 2 | `IbsCountRollover` | Number of times an op could not be tagged by IBS because of a previous tagged op that has not yet signaled interrupt. The actual implementation waits for a tagged op to signal an interrupt or be flushed before a new op can be tagged. |
| 1 | `IbsTaggedOpsRet` | Number of Ops tagged by IBS that retired |
| 0 | `IbsTaggedOps` | Number of Ops tagged by IBS |


## PMCx1D0 — EX — Retired Fused Instructions

**Symbolic:** `Core::X86::Pmc::Core::Retired_fused_instructions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D0`

Counts retired fused instructions. To count legacy unit mask (Fused branches. Includes CMP +Jcc, TEST+Jcc and ALU+Jcc fusion), set unit_mask[7:0]=0.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `FusedNonBranch` | Fused non branches. Includes Div fusion and load + op fusion. |
| 0 | `FusedBranch` | Fused branches. Includes CMP +Jcc, TEST+Jcc and ALU+Jcc fusion |


## PMCx1D1 — EX — EDC events 0

**Symbolic:** `Core::X86::Pmc::Core::EDC_events_0`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D1`

Count of events used by EDC throttler.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DNE` | SecureDbgEn DNE |
| 3 | `FpOverThresh` | SecureDbgEn FpOverThresh[0] |
| 0 | `CoreOverThresh` | SecureDbgEn CoreOverThresh[0] |


## PMCx1D2 — EX — EDC events 1

**Symbolic:** `Core::X86::Pmc::Core::EDC_events_1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D2`

Count of events used by EDC throttler.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L3CorePCC` | SecureDbgEn L3CorePCC |
| 6 | `ScCacThrottle` | SecureDbgEn ScCacThrottle |
| 3 | `PCCLevels` | SecureDbgEn PCCLevels[0] |
| 0 | `CcxOverThresh` | SecureDbgEn CcxOverThresh[0] |


## PMCx1D4 — EX — Resyncs Caused by Faults

**Symbolic:** `Core::X86::Pmc::Core::resync_fault`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D4`

In case a resync is caused by multiple faults, only the cause associated with highest UnitMask bit is counted. If UnitMask[7:0] = 0h, the total number of resyncs (from both faults and traps) are counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Fetch_SMC_resync_fault` | Resyncs caused by Self Modifying Code fault |
| 6 | `SLM_resync` | SpecLockMap fault |
| 5 | `faulttrap_on_fused_instruction_converted_to_resync_fault` | Fault/Trap on fused instruction converted to resync fault |
| 4 | `source_SBZ_poisoned_flag` | SBZ poisoned flag fault |
| 3 | `FEDE_resync` | Front end or Decode resync |
| 2 | `LS_VmaskMov_plus_AVX512_KMM_resync` | LS VmaskMov + KmaskMov resync |
| 1 | `LS_resync` | LS resync |
| 0 | `FP_denomreissue` | FP denom/reissue resync. |


## PMCx1D5 — EX — Resync from traps

**Symbolic:** `Core::X86::Pmc::Core::Resync_from_traps`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D5`

Count of resyncs caused by traps. In case a resync is caused by multiple traps, only the cause associated with the highest UnitMask bit is counted. If UnitMask = 0h, the total number of resyncs (from both faults and traps) are counted

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `Store_SMC` | Store hits in-flight instruction fetch |
| 5 | `LsResync` | LS resync |
| 4 | `FpSseUarch` | FP SSE Uarch resync |
| 3 | `RflagsRtTf` | RFLAGS RT/TF resync |
| 2 | `SetClrTrap` | SetClrTrap resync |
| 1 | `IllegalVipVif` | RFLAGS illegal vip/vif resync |
| 0 | `Cmc` | IC CMC probe hit resync |


## PMCx1D6 — EX — Micro ops Issued Part0

**Symbolic:** `Core::X86::Pmc::Core::Micro_ops_Issued_Part0`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D6`

Counts the issue of micro-ops to various integer execution units. Includes issues due to bad-status replay of ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Al5` | ALU pick on ALU5 |
| 4 | `Al4` | ALU pick on ALU4 |
| 3 | `Al3` | ALU pick on ALU3 |
| 2 | `Al2` | ALU pick on ALU2 |
| 1 | `Al1` | ALU pick on ALU1 |
| 0 | `Al0` | ALU pick on ALU0 |


## PMCx1D7 — EX — Micro ops Issued Part1

**Symbolic:** `Core::X86::Pmc::Core::Micro_ops_Issued_Part1`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D7`

Counts the issue of micro-ops to various integer execution units. Includes issues due to bad-status replay of ops.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `Ag3` | AGU pick on AG3 |
| 2 | `Ag2` | AGU pick on AG2 |
| 1 | `Ag1` | AGU pick on AG1 |
| 0 | `Ag0` | AGU pick on AG0 |


## PMCx1D8 — EX — Speculative picks

**Symbolic:** `Core::X86::Pmc::Core::Speculative_picks`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1D8`

Counts the number of pick bypass ops or early ready ops. Thread agnostic.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `AgPickByp` | SecureDbgEn AG pick bypass |
| 4 | `AlGrp2PickByp` | SecureDbgEn ALU53 pick bypass |
| 3 | `AlGrp1PickByp` | SecureDbgEn ALU20 pick bypass |
| 2 | `AgEarlyRdy` | SecureDbgEn AG early ready |
| 1 | `AlGrp2EarlyRdy` | SecureDbgEn ALU53 early ready |
| 0 | `AlGrp1EarlyRdy` | SecureDbgEn ALU20 early ready |


## PMCx1DB — EX — Moves eliminated

**Symbolic:** `Core::X86::Pmc::Core::Moves_eliminated`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1DB`

Number of retired move eliminations in the register mapper. Includes MOV, memory renamed loads and stores, and zeroing idioms. A bug exists which wrongly counts an op which does not write an integer PRF as move eliminated by reading stale values from the corresponding entry of the RETQ. See DENVRTVF-46863


## PMCx1DC — EX — Count of bad status load broadcasts

**Symbolic:** `Core::X86::Pmc::Core::Count_of_bad_status_load_broadcasts`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1DC`

Count of bad status load broadcasts

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `BadPartial` | Bad partial status load broadcast not cancelled by Early Bad Status (causes replays) |
| 1 | `Bad_Status` | Bad status load broadcast not cancelled by Early Bad Status (causes replays) |
| 0 | `EbsCancel` | Bad status load broadcasts cancelled by Early Bad Status (does not cause replays) |


## PMCx1DD — EX — EX Debug Raw Local Irritator

**Symbolic:** `Core::X86::Pmc::Core::EX_Debug_Raw_local_irritator`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx1DD`

Number of times that EX DBDT raw local irritator asserted (For DBDT IO Ports refer to http://twiki.amd.com/twiki/bin/view/CCDft/CCDftKitdbmu#DBDT_IO_Ports) . Thread0 counts DtIrritator[0], and Thread1 counts DtIrritator[1].

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `Sc2DbgRawLclIrr` | Cycles that the SC2 raw local irritator was active. Will not count anything unless SC_SCH_DbgCfg[IRR_PMC] is set |
| 0 | `Sc1DbgRawLclIrr` | Cycles that the SC1 raw local irritator was active. Will not count anything unless SC_RT_DBGCFG[IRR_PMC] is set |


## PMCx280 — IC_BP — IC MAB Requests

**Symbolic:** `Core::X86::Pmc::Core::IC_MAB_Requests`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx280`

Total number of requests that require the IC Miss Address Buffer (MAB) for subsequent request to the L2.


## PMCx281 — IC_BP — Allocated MABs

**Symbolic:** `Core::X86::Pmc::Core::Allocated_MABs`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx281`

Counts the number of IC Miss Address Buffer (MAB) entries that have outstanding requests every cycle. There can be up to 24 entries.


## PMCx282 — IC_BP — Prefetch Requests for IC Misses

**Symbolic:** `Core::X86::Pmc::Core::IC_Prefetch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx282`

Counts the number of MABs valid for prefetch requests issued by Instruction Cache Unit for IC Misses.


## PMCx286 — IC_BP — IC L2 Fill Requests

**Symbolic:** `Core::X86::Pmc::Core::IC_L2_Fill_Requests`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx286`

Counts fill requests to L2 based on whether the microtag or full tag missed.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `TagMissUtagHit` | IC Fill Requests to L2 (due to Tag miss with microtag Hit) |
| 0 | `UtagMiss` | IC Fill Requests to L2 (due to microtag miss) |


## PMCx287 — IC_BP — 64B Branch Predictor Window Transferred to DE

**Symbolic:** `Core::X86::Pmc::Core::Branch_Predictor_Window_Transferred_64B_to_DE`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx287`

Number of 64B BP windows transferred from IC pipe to DE instruction decoder (includes non-cacheable and cacheable fill responses).


## PMCx288 — IC_BP — 64B Branch Predictor Window Transferred to OC

**Symbolic:** `Core::X86::Pmc::Core::Branch_Predictor_Window_Transferred_64B_to_OC`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx288`

Number of 64 byte BP windows transferred from IC pipe to OC


## PMCx289 — IC_BP — IC IBQ Full

**Symbolic:** `Core::X86::Pmc::Core::IC_IBQ_Full`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx289`

IC fetch is stalled due to missing IBQ tokens.


## PMCx28A — IC_BP — OC Mode Switch

**Symbolic:** `Core::X86::Pmc::Core::OC_Mode_Switch`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx28A`

Counts number of events where instruction fetching shifts in either direction between IC and OC fetch modes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `OcIcModeSwitch` | OC fetch to IC fetch transition. |
| 0 | `IcOcModeSwitch` | IC fetch to OC fetch transition. |


## PMCx28C — IC_BP — OcFetchVal

**Symbolic:** `Core::X86::Pmc::Core::OcFetchVal`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx28C`

Counts OC fetches differs from PMCx28F, which counts 64B BP prediction blocks and take disposition of the block into account. This counts the number of OcFetchVal=1 assertions where IC sends either a packet of OC fetch data or OC signaling data to OCQ.


## PMCx28E — IC_BP — L2 TLB Multi-Hit

**Symbolic:** `Core::X86::Pmc::Core::L2_TLB_Multi_Hit`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx28E`

L2 TLB multi-hit (multi-way hit RAS condition) for a I-side translation request


## PMCx28F — IC_BP — Op Cache Hit or Miss

**Symbolic:** `Core::X86::Pmc::Core::Op_Cache_hit_miss`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx28F`

Counts Op Cache micro-tag hit/miss events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2:0 | `OpCacheAccesses` | OpCacheAccesses Value Name Description 2h-0h Reserved. 3h op_cache_hit Op Cache Hit. 4h op_cache_miss Op Cache Miss. 6h-5h Reserved. 7h op_cache_all All Op Cache accesses. |


## PMCx28F — IC_BP — Op Cache Hit or Miss

**Symbolic:** `Core::X86::Pmc::Core::Op_Cache_hit_miss_INT`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx28F`

Counts Op Cache hit or miss information for fetches based on micro-tag matches.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `Full_Miss` | Counts fetches which completely missed the Op Cache. All instruction bytes were fetched from the I-Cache or higher levels. |
| 1 | `Partial_Hit` | Counts fetches which were partially satisfied by the Op Cache. Some instruction bytes were fetched from the I-Cache or higher levels. |
| 0 | `Full_Hit` | Counts fetches which were fully satisfied by the Op Cache. No instruction bytes were fetched from the I-Cache or higher levels. |


## PMCx290 — IC_BP — DynJcc Mispredicts

**Symbolic:** `Core::X86::Pmc::Core::DynJcc_Mispredicts`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx290`

Number of dynamic jccs mispredicted. (Retire time event)


## PMCx291 — IC_BP — DynJcc Mispredicted Taken

**Symbolic:** `Core::X86::Pmc::Core::DynJcc_Mispredicted_Taken`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx291`

Number of dynamic jccs mispredicted as taken. (Retire time event)


## PMCx292 — IC_BP — DynJcc Retired

**Symbolic:** `Core::X86::Pmc::Core::DynJcc_Retired`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx292`

Number of dynamic jcc retired. (Retire time event)


## PMCx293 — IC_BP — DyncJcc Retired which are predicted Taken

**Symbolic:** `Core::X86::Pmc::Core::DyncJcc_Retired_which_are_predicted_Taken`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx293`

Number of retired dynamic predicted taken jccs. (Retire time event)


## PMCx294 — IC_BP — Indirect Jmp Mispredicts

**Symbolic:** `Core::X86::Pmc::Core::Indirect_Jmp_Mispredicts`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx294`

Number of mispredicted indirect jmp mispredicts. (Retire time event)


## PMCx295 — IC_BP — Indirect Call Mispredicts

**Symbolic:** `Core::X86::Pmc::Core::Indirect_Call_Mispredicts`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx295`

Number of mispredicted indirect calls. (Retire time event)


## PMCx296 — IC_BP — DirJmp/StaticJcc Preds

**Symbolic:** `Core::X86::Pmc::Core::DirJmp_StaticJcc_Preds`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx296`

Number of direct jmp/jcc prediction. (Prediction time event)


## PMCx297 — IC_BP — DirCall Predictions

**Symbolic:** `Core::X86::Pmc::Core::DirCall_Predictions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx297`

Number of Direct Call predictions. (Prediction time event)


## PMCx298 — IC_BP — IndJmp Predictions

**Symbolic:** `Core::X86::Pmc::Core::IndJmp_Predictions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx298`

Number of Indirect Jump predictions. (Prediction time event)


## PMCx299 — IC_BP — IndCall Predictions

**Symbolic:** `Core::X86::Pmc::Core::IndCall_Predictions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx299`

Number of indirect call predictions. (Prediction time event)


## PMCx29A — IC_BP — BP Loop Mode predictions

**Symbolic:** `Core::X86::Pmc::Core::BP_Loop_Mode_predictions`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx29A`

Number of predictions made in loop mode. (Prediction time event)


## PMCx29B — IC_BP — ITLB Access Cacheable vs Noncacheable

**Symbolic:** `Core::X86::Pmc::Core::I_TLB_access_cacheable_vs_non_cacheable`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx29B`

Counts L1 ITLB hits based on cacheability as selected from its unit mask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `noncacheable` | Number of non-cacheable accesses. Counted in IT pipe. |
| 0 | `cacheable` | Number of cacheable accesses. Counted in IT pipe. |


## PMCx29C — IC_BP — Any IC Fills by Data Source

**Symbolic:** `Core::X86::Pmc::Core::Any_IC_Fills_by_Data_Source`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx29C`

Counts where data were sourced from to complete an IC to L2 request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Scm` | SCM memory from a far and near CS |
| 6 | `RmtDram` | from DRAM or IO connected to different die, same or different socket |
| 5 | `L4Cache` | from L4Cache |
| 4 | `RmtCacheFarCs` | L1/L2/L3 hit on other CCX of same die through CS on different die. L1/L2/L3 hit on CCX of different die through CS on different die |
| 3 | `LclDram` | from DRAM or IO connected to same die |
| 2 | `RmtCacheNearCs` | L1/L2/L3 hit on other CCX of same die through CS on same die. L1/L2/L3 hit on CCX of different die through CS on same die |
| 1 | `LclCache` | local L3 hit or hit in different L1/L2 of same CCX |
| 0 | `LclL2` | from Local L2 |


## PMCx29D — IC_BP — Any IC Fills by Data Source 2

**Symbolic:** `Core::X86::Pmc::Core::Any_IC_Fills_by_Data_Source_2`  
**Instance:** `_ccd0_lthree0_core[7:0]; PMCx29D`

Counts where data were sourced from to complete an IC to L2 request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `RmtPeerAgentMem` | Peer Agent Memory, far CS |
| 4 | `RmtExtMem` | Extension Memory (S-Link, GenZ, etc - identified by the CS target and/or address map at DF 's choice), far CS |
| 3 | `RmtNvDIMM_P` | NVDIMM-P (DRAM address map with 'long latency' bit set), far CS |
| 2 | `LclPeerAgentMem` | Peer Agent Memory, near CS |
| 1 | `LclExtMem` | Extension Memory (S-Link, GenZ, etc - identified by the CS target and/or address map at DF 's choice), near CS |
| 0 | `LclNvDIMM_P` | NVDIMM-P (DRAM address map with 'long latency' bit set), near CS |


## PMCxFFF — Core — Merge

**Symbolic:** `Core::X86::Pmc::Core::Merge`  

See 2.1.21.4 [Large Increment per Cycle Events] .

