# BRH — L3 PMC Events

_Source: AMD pprweb build at ppr_BRH_C1_int_050_pprweb_

_Total events: 71_


Events are listed in code order. Per-event, the table lists the UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.


## L3PMCx01 — L3 — L3 Cache Accesses

**Symbolic:** `Core::X86::Pmc::L3::L3RequestG1`  
**Instance:** `_ccd0_lthree0; L3PMCx01`

Types of requests entering l3s.RQ (3 groups total). Group 1

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Group3` | Command from Group 3 (count details in event 0x3) |
| 6 | `RdSized` | . uncacheable coherent reads. |
| 5 | `RdSizedNC` | . uncacheable non-coherent reads. |
| 4 | `RdSizedLock` | RdSizedUnderLock command |
| 3 | `WrSized` | . uncacheable coherent writes. |
| 2 | `WrSizedNC` | . uncacheable non-coherent writes. |
| 1 | `WrNoData` | WrNoDataNC command |
| 0 | `Group2` | Command from Group 2 (count details in event 0x2) |


## L3PMCx02 — L3 — Requests to L3 Group2

**Symbolic:** `Core::X86::Pmc::L3::L3RequestG2`  
**Instance:** `_ccd0_lthree0; L3PMCx02`

Types of requests entering l3s.RQ (3 groups total). Group 2

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RdBlkA_Vic` | L2 non-spec ERMSB store miss with victim. |
| 6 | `FlushL2L3Way` | FlushL2L3Way - used by uCode during execution of WBINVD X86 instruction to flush one way of L2 and two ways of L3 cache. |
| 5 | `ClearL2L3Way` | ClearL2L3Way - used by uCode during execution of INVD X86 instruction to invalidate one way of L2 and two ways of L3 cache. |
| 4 | `CleanseL2Way` | CleanseL2Way - used by uCode during CC6 entry to evict lines out of L2 cache. |
| 3 | `CleanseL2L3Way` | CleanseL2L3Way - used by uCode during execution of WBNOINVD X86 instruction to cleanse one way of L2 and two ways of L3 cache. |
| 2 | `ClnBlkAll` | ClnBlkAll - used for CLWB X86 instruction. |
| 1 | `WbInvBlkAll` | WbInvBlkAll - used for CLFLUSH X86 instruction. |
| 0 | `RdBlkA` | L2 non-spec ERMSB store miss. |


## L3PMCx03 — L3 — L3 cache access types

**Symbolic:** `Core::X86::Pmc::L3::L3FillVicReq`  
**Instance:** `_ccd0_lthree0; L3PMCx03`

Types of requests entering l3s.RQ (3 groups total). Group 3

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RdBlkL` | L2 load or non-spec store miss. |
| 6 | `RdBlkL_Vic` | L2 load or non-spec store miss with victim. |
| 5 | `RdBlkX` | L2 non-spec store miss. |
| 4 | `RdBlkX_Vic` | L2 non-spec store miss with victim. |
| 3 | `RdBlkC_S` | L2 miss request for instruction line or shared copy of line. |
| 2 | `RdBlkC_S_Vic` | L2 miss request for instruction line or shared copy of line with victim. |
| 1 | `ChgToX` | L2 request to make line writeable. |
| 0 | `VicBlk` | L2 victim. |


## L3PMCx04 — L3 — L3 tag lookup state

**Symbolic:** `Core::X86::Pmc::L3::L3LookupState_Internal`  
**Instance:** `_ccd0_lthree0; L3PMCx04`

State of cacheline returned when looking up the L3 tags on a coherent L2 fill request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Fe_Od` | Externally exclusive, internally shared. |
| 6 | `D` | Line brought into CCX in a modified state, not yet modified by this CCX . |
| 5 | `M` | Line has been modified by this CCX . |
| 4 | `E` | Exclusive; writeable, clean. |
| 3 | `O` | Owned; not writeable, modified data. |
| 2 | `F` | Forwarding state; not writeable. |
| 1 | `S` | Shared. |
| 0 | `I` | L2 fill missed in L3. |


## L3PMCx05 — L3 — L3 Lookup L2 Shadow State

**Symbolic:** `Core::X86::Pmc::L3::L3LookupL2Shadow`  
**Instance:** `_ccd0_lthree0; L3PMCx05`

Line state returned when looking up the L2 shadow tags (maintained by the L3 cache) on a coherent L2 fill request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `S_multiple` | A shared copy of the line is present in one or more other L2 caches. None of the L2s have a unique copy (F/Fe/O/Od/X). |
| 6 | `F_S_multiple` | One of the L2 caches has the line in ‘F’ state and one or more L2s has the line as well (assumed to be in ‘S’ state). |
| 5 | `O_S_multiple` | One of the L2 caches has the line in ‘O’ state and one or more L2s has the line as well (assumed to be in ‘S’ state). |
| 4 | `X_Fe_Od` | One of the L2 caches has the line in X, Fe or Od states. |
| 3 | `O` | One of the L2 caches has the line in ‘O’ state and no other L2 cache has the line. |
| 2 | `F` | One of the L2 caches has the line in ‘F’ state and no other L2 cache has the line. |
| 1 | `I_late` | No L2 cache has a copy of line, but one or more of the L2 shadow tags had a partial hit (Early hit in stage-1 of STM ) |
| 0 | `I` | No L2 cache has a copy of the line and none of the L2 shadow tags had a partial hit (Early hit in stage-1 of STM ) |


## L3PMCx06 — L3 — CCX State

**Symbolic:** `Core::X86::Pmc::L3::CCXState`  
**Instance:** `_ccd0_lthree0; L3PMCx06`

Overall line state in the CCX for a coherent L2 fill request to L3. NOTE: setting all the Unit Masks for the Combined CCX state event will count all coherent L3 accesses. Selecting the appropriate mask bits can count L3 hits or L2 hits so that the L3 hit rate or "neighbor" L2 hit rate can be calculated. A hit on a line in both the L3 and a neighbor L2 will be counted as an L3 hit

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RdBlkL_L3Hit` | RdBlkL hit in L3 cache. Never set in HyperTracer. |
| 6 | `RdBlkL_L2Hit` | RdBlkL missed in L3 cache and hit in another L2 in the CCX . Never set in HyperTracer. |
| 5 | `RdBlkC_S_L3Hit` | RdBlkC/S hit in L3 cache. Never set in HyperTracer. |
| 4 | `RdBlkC_S_L2_Hit` | RdBlkC/S missed in L3 cache and hit in another L2 in the CCX . Never set in HyperTracer. |
| 3 | `RdBlkX_ChgToX_HitL3_Usable` | RdBlkX/ChgToX/RdBlkA hit in L3 in E, M, D, Fe or Od state. Hit can be satisfied inside the CCX . Never set in HyperTracer. |
| 2 | `RdBlkX_ChgToX_HitStm_Usable` | RdBlkX/ChgToX/RdBlkA hit in STM in X, Fe or Od state. Hit can be satisfied inside the CCX . Never set in HyperTracer. |
| 1 | `RdBlkX_ChgToX_Hit_Unusable` | RdBlkX/ChgToX/RdBlkA hit in complex (L3 or STM ), but could not be satisfied in CCX . (i.e. did not get permission to write line). A miss request will be issued to system. Never set in HyperTracer. |
| 0 | `RdBlkL_C_S_X_ChgToX_Miss` | RdBlkL/C/S/A/X/ChgToX missed CCX (did not hit in L3 or L2 shadow tags). All of these requests will be counted here in HyperTracer |


## L3PMCx07 — L3 — L2 victim L3 tag state

**Symbolic:** `Core::X86::Pmc::L3::L3StateL2Victim`  
**Instance:** `_ccd0_lthree0; L3PMCx07`

L2 victim L3 tag state: The L3 state of an L2 victim line 1. This event is only counted for coupled L2-victims. Non-coupled L2-victims tag lookup state is not counted by this event. 2. If a couple L2-victim tag lookup response comes back with Retry=1, then the event will not increment any count for that coupled L2-victim transaction.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `Fe` | Exclusive from CCX external view, shared in the CCX |
| 5 | `Od` | Modified from CCX external view, shared in the CCX |
| 3 | `O` | Modified without exclusive rights for CCX , shared in CCX and shared potentially outside CCX . |
| 2 | `F` | Forwarding state. |
| 1 | `S` | Shared |
| 0 | `I` | Invalid |


## L3PMCx08 — L3 — L2 Victim state - Shadow tag view

**Symbolic:** `Core::X86::Pmc::L3::L3ShadowL2VicState`  
**Instance:** `_ccd0_lthree0; L3PMCx08`

L2 Victim State, shadow tag view: The state an L2 victim line, accounting for the extra information the L3 maintains in the shadow tags

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `Fe` | Forwarding and CCX-E. Exclusive from CCX external view, shared inside CCX . |
| 5 | `Od` | Owned and CCX-D. Modified from CCX external view, shared inside CCX . |
| 4 | `E` | Exclusive. Clean copy. |
| 3 | `O` | Owned. Modified without exclusive rights for CCX , shared in CCX and shared potentially outside CCX |
| 2 | `F` | Forwarding state. |
| 1 | `S` | Shared. |
| 0 | `I` | Invalid. |


## L3PMCx09 — L3 — L3 Victim State

**Symbolic:** `Core::X86::Pmc::L3::L3VictimState`  
**Instance:** `_ccd0_lthree0; L3PMCx09`

L3 victim lines. The state of a line evicted from the L3 on a lookup of L3 tags by L2 victim. NOTE: To count all Modified lines, set bits 3, 5-7 simultaneously. 1. This event is only counted for coupled L2-victims. Non-coupled L2-victims tag lookup that produces any L3-victims is not counted by this event. 2. If a couple L2-victim tag lookup response comes back with Retry=1, then the event will not increment any count for that coupled L2-victim transaction. 3. The perf event counting is blindly connected to the tag lookup response done for the coupled L2-victim. The following cases where the ultimate L3-victim is different are not counted correctly: a. L2-victim STM read state is INVALID (due to an earlier Cd-passed transaction taking away the line from the STM ). In this case, there is no real L3-victim, but the event will count blindly based on the tag lookup response state results. b. L2-victim is converted to L3-victim due to L3 no alloc case. For these cases, the real L3-victim is the L2-victim cacheline. However, the perfmon event will count based on the tag lookup response results only. The sub-cases which indicate not to install the coupled L2-victim into L3 cache are: i. STM indicates no L3-alloc. ii. WaysInUse collision indicates no L3-alloc. iii. L2 request indicates no L3-alloc.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Od` | Modified data written back to memory from CCX . |
| 6 | `D` | Modified data written back to memory from CCX . |
| 5 | `M` | Modified data written back to memory from CCX . |
| 4 | `E_Fe` | Clean L3 victim line in E or Fe state. No data written back to memory from CCX . |
| 3 | `O` | Modified data written back to memory from CCX . |
| 2 | `F_S` | Clean L3 victim line in E or Fe state. No data written back to memory from CCX . |
| 0 | `I` | No L3 victim generated. |


## L3PMCx0A — L3 — System Probe Results

**Symbolic:** `Core::X86::Pmc::L3::L3SysProbeResult`  
**Instance:** `_ccd0_lthree0; L3PMCx0A`

Ignores ThreadMask. Actions taken by the CCX in response to probes from SDF. To count "Data Move" and "No Data Move" events, you must use 2 performance monitor counters. Note: For PMC events 0xa and 0xb the following categories apply 1.) Probe Result = "Invalidate": Probe hit in CCX and final state after the probe is ‘I’ or invalid - !{I} -> {I} 2.) Probe Result = "Downgrade": Probe hit an "exclusive writeable" line in CCX and the final state after the probe is "valid, but not exclusive and writeable" {M,D,E,Od,Fe} -> !{M,D,E,Od,Fe,I} 3.) Probe Result = "No Change/Other": Probe hit in CCX and is not in the above categories of "Invalidate" or "Downgrade" 4.) Probe Result = "Miss": Probe missed in CCX

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `Inv_Dm` | Invalidate, data move. |
| 5 | `Inv_NoDm` | Invalidate, no data move. |
| 4 | `Dwn_Dm` | Downgrade, data move. |
| 3 | `Dwn_NoDm` | Downgrade, no data move. |
| 2 | `NoChgOther_Dm` | No change/other, data move. |
| 1 | `NoChgOther_NoDm` | No change/other, no data move. |
| 0 | `Miss` | Probe missed in CCX . |


## L3PMCx0B — L3 — System Probe Location

**Symbolic:** `Core::X86::Pmc::L3::L3SysProbeLocation`  
**Instance:** `_ccd0_lthree0; L3PMCx0B`

Ignores ThreadMask. Categories of where a probe hit/missed and what the probe result was. Note: For definitions of invalidate, downgrade, no change/other, miss, see Core::X86::Pmc::L3::L3SysProbeResult above. Note: For PMC event 0xb 1.) Hitting in the L3 Victim Queues counts towards an ‘L3’ hit 2.) Hitting in the L3 Miss Queue counts towards an ‘L2’ hit 3.) Each unit (row) is mutually exclusive - Hitting in shared states in L3 and L2(s) will be reported as "one L2" or "multiple L2" not "hit L3…"

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `HitL3Inv` | hit L3 and no L2, invalidate. |
| 6 | `HitOneL2Inv` | hit one L2, invalidate. |
| 5 | `HitMultL2Inv` | hit multiple L2, invalidate (any combination of L2). |
| 4 | `HitL3Dwn` | hit L3 and no L2, downgrade. |
| 3 | `HitOneL2Dwn` | hit one L2, downgrade. |
| 2 | `HitMultL2Dwn` | hit multiple L2, downgrade (any combination of L2). |
| 1 | `HitNoChg_Other` | hit, no change/other. |
| 0 | `Miss` | Probe missed in CCX . |


## L3PMCx0C — L3 — L3 RQ CD Fail Reasons

**Symbolic:** `Core::X86::Pmc::L3::L3RqCdFailReasons`  
**Instance:** `_ccd0_lthree0; L3PMCx0C`

L3 RQ Collision Detect fail reasons

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Index` | Collision based on cache index match. |
| 6 | `Address` | Collision based on request address match. |
| 5 | `Resource_MQ` | No MQ resource is available. |
| 4 | `Resource_L2VQ` | No L2VQ resource is available. |
| 3 | `Resource_L3VWB` | No L3VWB resource is available. |
| 2 | `TAPipe_type1` | Forced Cd-fail on MQ tokens due to forward progress reasons. |
| 1 | `TAPipe_type2` | Back to back ops to the same L2-index that Cd-fail the new one. |
| 0 | `TAPipe_type3` | Back to back ops to the same address that Cd-fail the new one. |


## L3PMCx0D — L3 — L3 Bank Conflicts

**Symbolic:** `Core::X86::Pmc::L3::L3RQBankConflict`  
**Instance:** `_ccd0_lthree0; L3PMCx0D`

Ignores ThreadMask. L3 RQ bank conflicts Note: RQ LkUp conflict vs. DR has been a port conflict, not a tag bank conflict.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `FqLkVsDwBankConf` | FQ Lk vs DW data bank conflict: L3s_pipe. |
| 3 | `FqLkVsTagWrBankConf` | FQ Lk vs TagWr tag bank conflict: L3s_pipe. |
| 1 | `FqTagLookupBlocked` | FQ Tag lookup blocked: Trying to avoid banks or other for forward progress reasons. |
| 0 | `WqTagLookupBlocked` | WQ Tag lookup blocked: Trying to avoid banks or other for forward progress reasons. |


## L3PMCx0E — L3 — L3 Queue Full Cycles

**Symbolic:** `Core::X86::Pmc::L3::L3QueueFullCycles`  
**Instance:** `_ccd0_lthree0; L3PMCx0E`

Ignores ThreadMask. Number of cycles the selected queue is full.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L2VB` | L2 Victim Data Buffer |
| 6 | `RQ` | Request Queue |
| 5 | `L2VQ` | L2 Victim Queue |
| 4 | `L3VWB` | L3 Victim Write Data Buffer |
| 3 | `PQ` | Probe Queue |
| 2 | `MissQueue` | Miss Queue |
| 1 | `BPQ` | Back Probe Queue |
| 0 | `L3VQ` | L3 Victim Queue |


## L3PMCx0F — L3 — L3 Queue 3/4 Full Cycles

**Symbolic:** `Core::X86::Pmc::L3::L3Queue3_4FullCycles`  
**Instance:** `_ccd0_lthree0; L3PMCx0F`

Ignores ThreadMask. Number of cycles the selected queue is more than 3/4 full.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L2VB` | L2 Victim Data Buffer |
| 6 | `RQ` | Request Queue |
| 5 | `L2VQ` | L2 Victim Queue |
| 4 | `L3VWB` | L3 Victim Write Data Buffer |
| 3 | `PQ` | Probe Queue |
| 2 | `MissQueue` | Miss Queue |
| 1 | `BPQ` | Back Probe Queue |
| 0 | `L3VQ` | L3 Victim Queue |


## L3PMCx10 — L3 — L3 Queue Half Full Cycles

**Symbolic:** `Core::X86::Pmc::L3::L3QueueHalfFullCycles`  
**Instance:** `_ccd0_lthree0; L3PMCx10`

Ignores ThreadMask. Number of cycles the selected queue is more than half full.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `L2VB` | L2 Victim Data Buffer |
| 6 | `RQ` | Request Queue |
| 5 | `L2VQ` | L2 Victim Queue |
| 4 | `L3VWB` | L3 Victim Write Data Buffer |
| 3 | `PQ` | Probe Queue |
| 2 | `MissQueue` | Miss Queue |
| 1 | `BPQ` | Back Probe Queue |
| 0 | `L3VQ` | L3 Victim Queue |


## L3PMCx11 — L3 — L3 Internal Fabric On-Ramp Stalls

**Symbolic:** `Core::X86::Pmc::L3::L3L3FOnRampStalls`  
**Instance:** `_ccd0_lthree0; L3PMCx11`

Ignores ThreadMask. L3s: L3 internal fabric on-ramp stalls Cycles when a transaction could not enter the L3 fabric due to backpressure * Traffic types starting with ‘s’ or ‘c’ are trying to get on here. * Traffic starting with ‘x’ enters at xi * csData = core to slice data (L2 victim, probe, wr data) * sxData = slice to xi data (L3 victim, probe, wr data) * scRdRsp = slice to core fill l3 hit data * xcRdRsp = xi to core fill l3 miss data * scPrb = slice to core probe * scPull = slice to core pull * xsPull = xi to slice pull * xsRdRsp = xi to slice, fill ended ctrl packet * csPrbRsp = core to slice probe response * xsSysAck = xi to slice SysAck or done message * sxPrbRsp = slice to xi probe response * sxReq = slice to xi request * cxReq = core to xi request (Spec Dram Rd) * xsPrb = xi to slice system probe * xcPrb = xi to core system probe (broadcast system/local_mgmt) * csReq = core to slice request

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `V` | V: csData, sxData |
| 5 | `D` | D: scRdRsp (xcRdRsp) |
| 4 | `P` | P: scPrb, scPull |
| 3 | `H` | H: (xsPull, xsRdRsp), csPrbRsp |
| 2 | `A` | A: (xsSysAck), sxPrbRsp |
| 1 | `X` | X: sxReq, cxReq, (xsPrb, xcPrb) |
| 0 | `R` | R: csReq |


## L3PMCx12 — L3 — L3 L3FOnRampSatStall

**Symbolic:** `Core::X86::Pmc::L3::L3_L3FOnRampSatStall`  
**Instance:** `_ccd0_lthree0; L3PMCx12`

Ignores ThreadMask. L3 internal fabric SAT stalls on-ramp Cycles when a transaction could not enter the L3 fabric due to SAT Stall (SAT Stall is part of the SATisfied fainess anti-livelock protocol) * Traffic types starting with ‘s’ or ‘c’ are trying to get on here. * Traffic starting with ‘x’ enters at xi * csData = core to slice data (L2 victim, probe, wr data) * sxData = slice to xi data (L3 victim, probe, wr data) * scRdRsp = slice to core fill l3 hit data * xcRdRsp = xi to core fill l3 miss data * scPrb = slice to core probe * scPull = slice to core pull * xsPull = xi to slice pull * xsRdRsp = xi to slice, fill ended ctrl packet * csPrbRsp = core to slice probe response * xsSysAck = xi to slice SysAck or done message * sxPrbRsp = slice to xi probe response * sxReq = slice to xi request * cxReq = core to xi request (Spec Dram Rd) * xsPrb = xi to slice system probe * xcPrb = xi to core system probe (broadcast system/local_mgmt) * csReq = core to slice request

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `DV` | V: csData, sxData |
| 5 | `DF` | D: scRdRsp (xcRdRsp) |
| 4 | `PC` | P: scPrb, scPull |
| 3 | `HC` | H: (xsPull, xsRdRsp), csPrbRsp |
| 2 | `AC` | A: (xsSysAck), sxPrbRsp |
| 1 | `XC` | X: sxReq, cxReq, (xsPrb, xcPrb) |
| 0 | `RC` | R: csReq |


## L3PMCx13 — L3 — Coherence state to L2 on L3-miss

**Symbolic:** `Core::X86::Pmc::L3::CoherStateFillResp`  
**Instance:** `_ccd0_lthree0; L3PMCx13`

Coherence state sent on fill response to L2 on L3-miss. Counts fill responses states sent to L2 on L3-miss (response from system).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `NC` | Response for sized reads. Sized read data are uncacheable. Counted for RdSized, RdSizedNC, RdSizedUnderLock commands. Counted regardless of whether they request was sent to DRAM or IO. |
| 3 | `S` | Count Shared responses. Counted for any RdBlk* or ChgToX commands. |
| 2 | `O` | Count Owned responses. Counted for any RdBlk* or ChgToX commands. |
| 1 | `D` | Count Dirty responses. Counted for any RdBlk* or ChgToX commands. |
| 0 | `E` | Count clean Exclusive responses. Counted for any RdBlk* or ChgToX commands. |


## L3PMCx15 — L3 — L3 ChgToXSuccess

**Symbolic:** `Core::X86::Pmc::L3::ChgToXSuccess`  
**Instance:** `_ccd0_lthree0; L3PMCx15`

Counts number of fill response returns to core (of selected core/thread based on PmcCfg settings) of ChgToXSuccess (no data returned to core on final system response. See Core::X86::Pmc::L3::XiCcxSdpReq1 perfmon to count system ChgToX).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `ChgToXSuccess` | Count ChgToXSuccess responses |


## L3PMCx16 — L3 — PC6 L3 Way Flush

**Symbolic:** `Core::X86::Pmc::L3::Pc6L3WayFlush`  
**Instance:** `_ccd0_lthree0; L3PMCx16`

Ignores ThreadMask. PC6 L3 Way Flush. Counts L3 ways that are flushed (not skipped due to WayValid optimization), when entering PC6. Each bit tracks two ways.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Way15_14` | Ways 15 and/or 14 flushed. |
| 6 | `Way13_12` | Ways 13 and/or 12 flushed. |
| 5 | `Way11_10` | Ways 11 and/or 10 flushed. |
| 4 | `Way9_8` | Ways 9 and/or 8 flushed. |
| 3 | `Way7_6` | Ways 7 and/or 6 flushed. |
| 2 | `Way5_4` | Ways 5 and/or 4 flushed. |
| 1 | `Way3_2` | Ways 3 and/or 2 flushed. |
| 0 | `Way1_0` | Ways 1 and/or 0 flushed. |


## L3PMCx18 — L3 — L3 CoreCc1Events

**Symbolic:** `Core::X86::Pmc::L3::L3_CoreCc1Events`  
**Instance:** `_ccd0_lthree0; L3PMCx18`

Core CC1 Entry events On a per-core basis count of the number of CC1 entry events. This counter is does not work properly in Zen5. Refer to PLAT-141302 L3PMCx19 and L3PMCx18 [umask 2] count incorrectly

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Cc1CommitTransition` | CC1 Commit Transition Count |
| 6 | `Cc1Transition` | CC1 L3CLK Transition Count |
| 5 | `Cc1ExitTransition` | CC1 Exit Transition Count |
| 4 | `OperationalTransition` | Not in CC1 Transition Count |
| 3 | `Cc1Commit` | CC1 Commit Count |
| 2 | `Cc1L3Clk` | CC1 L3CLK Count |
| 1 | `Cc1Exit` | CC1 Exit Count |
| 0 | `Operational` | Not in CC1 Count |


## L3PMCx19 — L3 — L3 CoreCc6Event

**Symbolic:** `Core::X86::Pmc::L3::L3_CoreCc6Event`  
**Instance:** `_ccd0_lthree0; L3PMCx19`

Core CC6 Entry events On a per-core basis count of the number of CC6 entry events. This counter is does not work properly in Zen5. Refer to PLAT-141302 L3PMCx19 and L3PMCx18 [umask 2] count incorrectly

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Cc6PwrMgtIntr` | CC6 Power Management Interrupt Count |
| 4 | `Cc6CacheFlush` | CC6 Cache Flush Count |
| 3 | `Cc6Commit` | CC6 Commit Count |
| 2 | `Cc6L3Clk` | CC6 L3CLK Count |
| 1 | `Cc6Exit` | CC6 Exit Count |
| 0 | `Operational` | Not in CC6 Count |


## L3PMCx1A — L3 — L3 CoreCc6TransitionEvent

**Symbolic:** `Core::X86::Pmc::L3::L3_CoreCc6TransitionEvent`  
**Instance:** `_ccd0_lthree0; L3PMCx1A`

Core CC6 Entry/Exit Transition events On a per-core basis count of the number of CC6 entry transition events. (count when the state transitions)

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Cc6PwrMgtIntrTransition` | CC6 Power Management Interrupt Transition |
| 4 | `Cc6CacheFlushTransition` | CC6 Cache Flush Transition |
| 3 | `Cc6CommitTransition` | CC6 Commit Transition |
| 2 | `Cc6Transition` | CC6 L3CLK Transition |
| 1 | `Cc6ExitTransition` | CC6 Exit Transition |
| 0 | `OperationalTransition` | Not in CC6 Transition |


## L3PMCx1C — L3 — L3 AllCorePowerStateEvent

**Symbolic:** `Core::X86::Pmc::L3::L3_AllCorePowerStateEvent`  
**Instance:** `_ccd0_lthree0; L3PMCx1C`

Count of the number of L3CLK cycles that all cores are in the various states. ChL3SDebugBusCtl3[2] must be 0 (the default). Due to the design of the data capture this counter is approximate.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `AllCoresInCc6` | All Cores in CC6 Cycle Count |
| 2 | `AllCoresInCc1` | All Cores in CC1 Cycle Count |
| 1 | `AllCoresCc6Entry` | All Cores CC6 Entry Count |
| 0 | `AllCoresCc1Entry` | All Cores CC1 Entry Count |


## L3PMCx1F — L3 — L3 Allocation

**Symbolic:** `Core::X86::Pmc::L3::L3Allocation`  
**Instance:** `_ccd0_lthree0; L3PMCx1F`

Age and other information for allocation of a cacheline into L3. Please note that the following are cycle aligned within a group but not across groups. Groups are: * Group 1 - UnitMask[7] * Group 2 - UnitMask[6:4] * Group 3 - UnitMask[3:0]

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `AaInfo_NoL3AllocCase` | Adaptive Allocation logic from L2 sent NoL3Alloc=1 to L3. |
| 6 | `UsedExtendedL2Age` | Age set from STM extended L2 information. |
| 5 | `UsedExtendedStmL3Age` | Age set from STM extended L3 information. |
| 4 | `UsedAaInfo_Age` | Age set from L2 to L3 information. |
| 3 | `InsertAge3` | Cacheline inserted with age=3 into L3. |
| 2 | `InsertAge2` | Cacheline inserted with age=2 into L3. |
| 1 | `InsertAge1` | Cacheline inserted with age=1 into L3. |
| 0 | `InsertAge0` | Cacheline inserted with age=0 into L3. |


## L3PMCx20 — L3 — CDMA PrbStore

**Symbolic:** `Core::X86::Pmc::L3::L3CDMAPrbStore`  
**Instance:** `_ccd0_lthree0; L3PMCx20`

CDMA Feature tracking PrbStore sent to an L2 within the CCX . NOTE: "Focus state" refers to the cache state hit and not whether the probe was marked as "focus only". NOTE: "Focus only" includes ChL3Cfg2[CdmaForceFocus]==1.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `CCX_FocusState_L2Hit` | PrbStore sent to an L2 - CCX focus state: L2 Hit |
| 5 | `CCX_FocusState_L3Hit` | PrbStore sent to an L2 - CCX focus state: L3 Hit |
| 4 | `CCX_NonFocusState_L2Hit` | PrbStore sent to an L2 - CCX non-focus state: L2 Hit |
| 3 | `CCX_NonFocusState_L3Hit` | PrbStore sent to an L2 - CCX non-focus state: L3 only Hit |
| 2 | `CCX_Miss` | PrbStore sent to an L2 - CCX miss. |
| 1 | `Dropped_FocusOnly` | PrbStore not sent to an L2 - focus only. |
| 0 | `Dropped_NotFocusOnly` | PrbStore not sent to an L2 - not focus only. |


## L3PMCx21 — L3 — CDMA Read Response

**Symbolic:** `Core::X86::Pmc::L3::L3CDMAReadResponse`  
**Instance:** `_ccd0_lthree0; L3PMCx21`

This event tracks read response sent to a CDMA read. Bandwidth ( CDMA data placed into Cache/sec) = Successful_ CDMA _Reads*L3_frequency*64/1000 where The L3 Frequency is calculated as shown below using the value from Core::X86::Pmc::L3::XiClocks L3 Frequency in MHz = (L3 Clock Cycles)/ (TSC ticks) * (cpu frequency).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `NackedCDMARdResponse` | CDMA read response was Nacked. |
| 0 | `NonNackedCDMARdResponse` | CDMA read response was not Nacked. |


## L3PMCx22 — L3 — Distributed Triggers

**Symbolic:** `Core::X86::Pmc::L3::L3DistributedTriggers`  
**Instance:** `_ccd0_lthree0; L3PMCx22`

This event tracks distributed triggers generated by the DBMU_DT. Setting EnAllSources == 1 will count the events from Xi.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `LocalTrigger1` | Local Trigger 1. |
| 0 | `LocalTrigger0` | Local Trigger 0. |


## L3PMCx23 — L3 — Alloc

**Symbolic:** `Core::X86::Pmc::L3::Alloc`  
**Instance:** `_ccd0_lthree0; L3PMCx23`

Events relating to Alloc/RdBlkA/ValBlk commands

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RdBlkA_Backprobe_Core` | RdBlkA issued a backprobe to one core. |
| 6 | `RdBlkA_D2C` | RdBlkA sent a backprobe requesting a core-to-core data transfer. |
| 5 | `RdBlkA_Backprobe` | RdBlkA Hit in Complex, but needs to probe core(s). |
| 4 | `RQ_RdBlkA` | Request installed in ReqQ is RdBlkA. |
| 3 | `MQ_L3WaysInUse` | ValBlk in MissQ blocked an L2 victim, converting it to L3 victim. |
| 2 | `MQ_ValBlkCCXHit` | ValBlk Request installed in MissQ had Complex Hit. |
| 1 | `MQ_ValBlkL3Hit` | ValBlk Request installed in MissQ had L3 Hit. |
| 0 | `MQ_ValBlk` | Request installed in MissQ is ValBlk. |


## L3PMCx24 — L3 — Contended Events

**Symbolic:** `Core::X86::Pmc::L3::ContendedEvents`  
**Instance:** `_ccd0_lthree0; L3PMCx24`

Events relating to special handling in contended line cases, e.g. contended lock Various config bits may be used to tune Contended behavior, including but not limited to the following: PQStarvedTrig - PrbQ Anti-Starve logic is the primary mechanism to ensure Probes are able to aqcuire a hotly-contested lock. Tune this value to adjust how quickly Probes gain the line. Default setting intended to hold off Probe 2 * (num_cores) times to allow each core to prefetch & then demand load. PqCdVsRqFastWake - Usually, when ReqQ and PrbQ are waiting for the same line, ReqQ Wakes first & grabs it. Setting this Wakes PrbQ first, such that PrbQ will always win. RQOnlyPrivilegeOldest - By default, the Oldest -unordered- Request is allowed to CdFail other requests for an Address reason to maintain better ordering. Setting this bit only allows the Oldest Request these privileges, which risks degraded ordering & consequent unfairness. RdBlkLConvertToRdBlkXDis - RdBlkL that misses in the Complex and found a RdBlkX ordered behind it upgrades to RdBlkX. This bit disables the behavior.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `RQVsRQAddrFail` | Request CdFailed against Request for Address reason. |
| 5 | `RQVsPQAddrFail` | Request CdFailed against Probe for Address reason. |
| 4 | `PQVsRQAddrFail` | Probe CdFailed against Request for Address reason. |
| 3 | `OldestAddrFailed` | Oldest Request CdFailed for Address reason. |
| 2 | `PrbTagLkStarved` | TagLk Picked from PrbQ was Starved. |
| 1 | `ReqTagLkStarved` | TagLk Picked from ReqQ was Starved. |
| 0 | `RdBlkLConvertToRdBlkX` | RdBlkL Request installed in MissQ upgraded to RdBlkX. |


## L3PMCx25 — L3 — L3 Victimization

**Symbolic:** `Core::X86::Pmc::L3::L3Victimization`  
**Instance:** `_ccd0_lthree0; L3PMCx25`

Events relating to L3 Victim choices

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `CoreActiveReset` | CoreActive tracking structure reset. |
| 1 | `CoreActiveRollover` | CoreActive tracking structure rolled over. |
| 0 | `PlruTakenAndDiffers` | Plru information was used to select the L3 victim, and the selection was different from regular RRIP. |


## L3PMCx26 — L3 — L3 Internal Fabric Off-Ramp Stalls

**Symbolic:** `Core::X86::Pmc::L3::L3L3FOffRampStalls`  
**Instance:** `_ccd0_lthree0; L3PMCx26`

Ignores ThreadMask. L3s: L3 internal fabric off-ramp stalls Cycles when a transaction could not leave the L3 fabric due to backpressure * Traffic types starting with ‘s’ or ‘c’ are trying to get on here. * Traffic starting with ‘x’ enters at xi * csData = core to slice data (L2 victim, probe, wr data) * sxData = slice to xi data (L3 victim, probe, wr data) * scRdRsp = slice to core fill l3 hit data * xcRdRsp = xi to core fill l3 miss data * scPrb = slice to core probe * scPull = slice to core pull * xsPull = xi to slice pull * xsRdRsp = xi to slice, fill ended ctrl packet * csPrbRsp = core to slice probe response * xsSysAck = xi to slice SysAck or done message * sxPrbRsp = slice to xi probe response * sxReq = slice to xi request * cxReq = core to xi request (Spec Dram Rd) * xsPrb = xi to slice system probe * xcPrb = xi to core system probe (broadcast system/local_mgmt) * csReq = core to slice request

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `V` | V: csData, sxData |
| 5 | `D` | D: scRdRsp (xcRdRsp) |
| 4 | `P` | P: scPrb, scPull |
| 3 | `H` | H: (xsPull, xsRdRsp), csPrbRsp |
| 1 | `Y` | Y: xsPrb, xcPrb |
| 0 | `R` | R: csReq |


## L3PMCx90 — L3 — L3 Cache Miss Latency

**Symbolic:** `Core::X86::Pmc::L3::XiSysFillLatency`  
**Instance:** `_ccd0_lthree0; L3PMCx90`

Ignores CoreID, EnAllCores, and ThreadMask. Each cycle, this event increments by the total number of read requests outstanding from the CCX divided by XiSysFillLatencyDivider. The user can calculate the average system fill latency in cycles by multiplying by XiSysFillLatencyDivider and dividing by the total number of fill requests over the same period (counted by event 0x9A UserMask 0x1F). XiSysFillLatencyDivider is 16 for this product, but may change for future products. XI keeps the counter precise by adjusting for the remainder when appropriate. This provides the average latency from when each request is sent across SDP until the response returns. Event 0x9A UserMask 0x1F counts only cacheable transactions (RdBlkL, RdBlkX, ChgToX, RdBlkC, RdBlkS, ValBlk). Use Event 0x91 to count ALL transactions tracked by 0x90. Mixing different types of read transactions and/or different types of memory can cause inconsistent results. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.


## L3PMCx91 — L3 — System Fill Events

**Symbolic:** `Core::X86::Pmc::L3::XiSysFillEvt`  
**Instance:** `_ccd0_lthree0; L3PMCx91`

Ignores CoreID, EnAllCores, and ThreadMask. Total number of fill requests considered by the System Fill Latency PMC (0x90). (RdBlkL, RdBlkS, RdBlkX, RdBlkC, ChgToX, RdSized, RdSizedNc, RdSizedDW, RdSizedNoWriter, ValBlk) Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.


## L3PMCx92 — L3 — System Write Victim Latency

**Symbolic:** `Core::X86::Pmc::L3::XiSysWriteVicLatency`  
**Instance:** `_ccd0_lthree0; L3PMCx92`

Ignores CoreID, EnAllCores, and ThreadMask. Each L3 cycle, this event increments by the total number of write and victim requests outstanding from XI divided by 16. XI keeps the counter precise by adjusting for the remainder when appropriate. This latency is measured at XI from the time the request is sent across SDP until the write response returns. Average latency may be measured by dividing this count times 16 by the total number of write/victim requests. Note: Mixing different types of read transactions and/or different types of memory can cause inconsistent results. Additionally, L3 reporting clean victims may skew the latency as well. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.


## L3PMCx93 — L3 — Write/Victim Latency

**Symbolic:** `Core::X86::Pmc::L3::XiSysWrtVictim`  
**Instance:** `_ccd0_lthree0; L3PMCx93`

Ignores CoreID, EnAllCores, and ThreadMask. Total number of fill requests considered by the System for the System Write Victim Latency PMC (0x92) (VicBlkFull, VicBlkCln, VicBlkClnD, VicBlkFullZero, VicBlkFullComp, WrSized, WrSizedNc, WrSizedFull, WrSizedFullNc, WrNoDataNc, WrSizedFullZero, WrSizedFullComp, ClnBlkAll, WbInvBlkAll, InvBlkAll). Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.


## L3PMCx94 — L3 — Canceled SDP Ops

**Symbolic:** `Core::X86::Pmc::L3::XiCanceledSdpOps`  
**Instance:** `_ccd0_lthree0; L3PMCx94`

Ignores CoreID, EnAllCores, and ThreadMask. Number of times the Cancel bit is set on an Ack packet. This occurs when a probe collides with a transaction inside the complex. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.


## L3PMCx95 — L3 — SDP Credit Stall Cycles

**Symbolic:** `Core::X86::Pmc::L3::XiSdpCreditStall`  
**Instance:** `_ccd0_lthree0; L3PMCx95`

Ignores CoreID, EnAllCores, and ThreadMask. The number of FCLK cycles the CPU complex was stalled from sending a transaction across the SDP interface due to lack of credits, by channel. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `ProbeResp` | Out of credits for Probe Response |
| 2 | `ResponseAck` | Out of credits for Response Ack |
| 1 | `OriginatorData` | Out of credits for Originator Data |
| 0 | `Request` | Out of credits for Request |


## L3PMCx96 — L3 — XI Queue Full

**Symbolic:** `Core::X86::Pmc::L3::XiQueueFull`  
**Instance:** `_ccd0_lthree0; L3PMCx96`

Ignores CoreID, EnAllCores, and ThreadMask. Number of cycles the selected queue is full. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `PRspDQ` | XI Probe Responde Data Q |
| 2 | `SRespDQ` | XI System Responde Data Q |
| 1 | `RespDQ` | XI RespDQ |
| 0 | `Request` | XI Request queue |


## L3PMCx97 — L3 — XI Queue 3/4 Full

**Symbolic:** `Core::X86::Pmc::L3::XiQueue3_4Full`  
**Instance:** `_ccd0_lthree0; L3PMCx97`

Ignores CoreID, EnAllCores, and ThreadMask. Number of cycles the selected queue is 3/4 full or more. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `PRspDQ` | XI Probe Responde Data Q |
| 2 | `SRespDQ` | XI System Responde Data Q |
| 1 | `RespDQ` | XI RespDQ |
| 0 | `Request` | XI Request queue |


## L3PMCx98 — L3 — XI Queue Half Full

**Symbolic:** `Core::X86::Pmc::L3::XiQueueHalfFull`  
**Instance:** `_ccd0_lthree0; L3PMCx98`

Ignores CoreID, EnAllCores, and ThreadMask. Number of cycles the selected queue is half full or more. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `PRspDQ` | XI Probe Responde Data Q |
| 2 | `SRespDQ` | XI System Responde Data Q |
| 1 | `RespDQ` | XI RespDQ |
| 0 | `Request` | XI Request queue |


## L3PMCx99 — L3 — System Probe types

**Symbolic:** `Core::X86::Pmc::L3::XiSysProbeTypes`  
**Instance:** `_ccd0_lthree0; L3PMCx99`

Ignores CoreID, EnAllCores, and ThreadMask. Number and type of coherent probes observed by XI. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CleanShare` | CleanShare probe |
| 6 | `Store` | Store probe |
| 5 | `Clean` | Clean probe |
| 4 | `Invalidate` | Invalidate probe |
| 3 | `Migrate` | Migrate probe |
| 2 | `Fetch` | Fetch probe |
| 1 | `Share` | share probe |
| 0 | `Nop` | No change probe |


## L3PMCx9A — L3 — L3 Misses by Request Type

**Symbolic:** `Core::X86::Pmc::L3::XiCcxSdpReq1`  
**Instance:** `_ccd0_lthree0; L3PMCx9A`

Requests from the core complex to SDP. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `SpecDramRd` | Speculative DRAM Read |
| 4 | `RdBlkS` | Miss request to get copy of cacheline in shared state. |
| 3 | `RdBlkC` | Miss request for instruction cacheline. |
| 2 | `ChgToX` | Request to make cacheline writeable. |
| 1 | `RdBlkX` | Miss request to obtain cacheline in writeable state. |
| 0 | `RdBlkL` | Miss request from load. |


## L3PMCx9B — L3 — SDP Requests Group 2

**Symbolic:** `Core::X86::Pmc::L3::XiCcxSdpReq2`  
**Instance:** `_ccd0_lthree0; L3PMCx9B`

Requests from the core complex to SDP. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `InvBlkAll` | Command to invalidate all copies of a cacheline from all caching agents. |
| 5 | `WbInvBlkAll` | Command to write dirty data back of cacheline from any caching agent and to invalidate all copies. |
| 4 | `ClnBlkAll` | Command to write dirty data back of cacheline from any caching agent while allowing a clean copy to be retained. |
| 3 | `RdSizedNoWriter` | Note that internal to CCX this is called RdSizedUnderLock |
| 1 | `RdSizedNC` | Uncacheable non-coherent reads. |
| 0 | `RdSized` | Uncacheable coherent reads. |


## L3PMCx9C — L3 — SDP Requests Group 3

**Symbolic:** `Core::X86::Pmc::L3::XiCcxSdpReq3`  
**Instance:** `_ccd0_lthree0; L3PMCx9C`

Requests from the core complex to SDP. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `WrSizedFullComp` | Uncacheable coherent writes with compressed data. |
| 6 | `WrSizedFullZero` | Uncacheable coherent writes with all zero data. |
| 5 | `WrNoDataNC` | Uncacheable non-coherent writes with no data. |
| 4 | `WrSizedFullNC` | Uncacheable non-coherent writes to entire cacheline. |
| 3 | `WrSizedFull` | Uncacheable coherent writes to entire cacheline. |
| 2 | `WrSizedNC` | Uncacheable non-coherent writes. |
| 1 | `WrSizedInvalid` | Indicates that the complex does not have the address cached and does not need to be probed by the system. |
| 0 | `WrSizedUnknown` | Indicates that the complex could have a copy. The system must probe the complex if it does not know (via a probe filter, for example) that the complex has no copy of the line. |


## L3PMCx9D — L3 — SDP Requests Group 4

**Symbolic:** `Core::X86::Pmc::L3::XiCcxSdpReq4`  
**Instance:** `_ccd0_lthree0; L3PMCx9D`

Requests from the core complex to SDP. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the slice indicated by EnAllCores and CoreId in ChL3PmcCfg*. Set EnAllCores == 1 to count events from all slices.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `VicblkFullComp` | Dirty victim with compressed data. |
| 3 | `VicBlkFullZero` | Dirty victim with all zero data. |
| 2 | `VicBlkClnD` | Clean victim with data. There are no known case of SoCs that use this command. |
| 1 | `VicBlkCln` | Clean victim without data. |
| 0 | `VicBlkFull` | Dirty victim with data. |


## L3PMCx9E — L3 — Count of L3 Clock Cycles While Perfmons Are Enabled

**Symbolic:** `Core::X86::Pmc::L3::XiClocks`  
**Instance:** `_ccd0_lthree0; L3PMCx9E`

Ignores CoreID, EnAllCores, ThreadMask, EnAlSlices, and SourceID. Count of L3 clock cycles while perfmons are enabled. L3 Frequency in MHz = (L3 Clock Cycles)/ (TSC ticks) * (cpu frequency). Count of L3 clock cycles while perfmons are enabled.


## L3PMCx9F — L3 — System Probe Returned Data

**Symbolic:** `Core::X86::Pmc::L3::SysProbeReturnData`  
**Instance:** `_ccd0_lthree0; L3PMCx9F`

Ignores CoreID, EnAllCores, and ThreadMask. The number of probes which actually moved data. Note that this is not the same as the number of probes which requested a data move if hit. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `ProbeDataReturned` | Probe returned data |


## L3PMCxA0 — L3 — Speculative DRAM Read

**Symbolic:** `Core::X86::Pmc::L3::XiSpecDramRd`  
**Instance:** `_ccd0_lthree0; L3PMCxA0`

Ignores CoreID, EnAllCores and ThreadMask. Count Statistics about speculative DRAM reads. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count for UM(s) UM[2:0]. All other UM(s) ignore SourceID and EnAllSources.. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Shutoff` | Number of L3 cycles the XI unit was commanding the cores not to issue any SpecDramRd (Ignores EnAllSources and SourceID configuration) |
| 6 | `DropWasteThresh` | Ignores EnAllSources and SourceID configuration |
| 5 | `DropRateThresh` | Ignores EnAllSources and SourceID configuration |
| 2 | `SdrReceivedByXi` | Spec DRAM read received by XI. |
| 1 | `SdrIssuedByXi` | Spec DRAM read issued by XI. |
| 0 | `SdrHits` | Spec DRAM read hits. |


## L3PMCxA1 — L3 — VmGuard Statistics

**Symbolic:** `Core::X86::Pmc::L3::VmGuard`  
**Instance:** `_ccd0_lthree0; L3PMCxA1`

Ignores SourceID, EnAllSources, CoreID, EnAllCores,and ThreadMask. Statistics related to VmGuard

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `VmgFlushProbes` | Number of VmgFlush probes issued (For Key Reclaim). Note: There are two probes (and therefore two counts) for every Key Reclaim event. |
| 5 | `VmgFlushCycles` | Number of L3 cycles that VmgFlush is active. |
| 4 | `UnsuccessfulPgFlushReads` | Encrypted Page flush is no longer supported by the CH. Therefore, will always count 0. |
| 3 | `SuccessfulPgFlushReads` | Encrypted Page flush is no longer supported by the CH. Therefore, will always count 0. |
| 2 | `UnsuccessfulRemapReads` | Counts the number of unsuccessful Remap read requests serviced by XI. |
| 1 | `SuccessfulRempReadsOldKey` | Counts the number of successful Remap read requests serviced by XI that return a key already used by the thread. |
| 0 | `SuccessfulRemapReadsNewKey` | Counts the number of successful Remap read requests serviced by XI that return a new key for the calling thread. Note: This does not indicate it is a newly allocated key, only that it is the first time the mapping has been used by the thread. |


## L3PMCxA2 — L3 — Statistics Related to GMI Retransmits

**Symbolic:** `Core::X86::Pmc::L3::GmiRetransmit`  
**Instance:** `_ccd0_lthree0; L3PMCxA2`

Ignores CoreID, EnAllCores and ThreadMask. Statistics Related GMI Link Interruptions which cause Manufactured GMI Retransmits. A "GMI Link Interruption" is any GMI link event that can cause more than three cycles between a RdRsp header and the corresponding RdRsp data beat. An "Observed GMI Link Interruption" is a GMI Link Interruption that triggers a Forced Retransmit Event. Observed GMI Link Interruptions are a subset of all GMI Link Interruptions. During each "Forced Retransmit Event", zero or more transactions will be marked as "Retransmit," and re-issued when the GMI Link Interruption is resolved. A Forced Retransmit event will result in zero retransmitted transactions iff the GMI Link Interruption only interrupted responses with RdRspStatus == DF Error. In systems that do not use a GMI link, both of UM’s in this PMC are expected to be zero. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `SdpRdRspSeparationViolationInFClk` | Counts the number of times the SdpRdRsp was not following by SdpRdRspData with the proper cycle separation on the FCLK side of VDCI. |
| 1 | `ForcedRetransmitTransactions` | Counts the number of transactions that Xi will retransmit due to GMI Link Interruptions. This does NOT include Sdp RdRsp messages with DataStatus == RETRANSMIT unless such a response is impacted by an Observed GMI Link Interruption. |
| 0 | `ObservedGmiLinkInterruption` | Counts the number of Observed GMI Link Interruptions. See the PMC description for a full definition. |


## L3PMCxA3 — L3 — Bandwidth Events observed by Bandwidth Monitoring Debug CLOS

**Symbolic:** `Core::X86::Pmc::L3::QosBwMon`  
**Instance:** `_ccd0_lthree0; L3PMCxA3`

Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask. Identifies Bandwidth Events that are counted for the CLOS identified by ChL3QosCfg2.DebugClos and ChL3QosCfg2.DebugClosUseSlow. DebugClosUseSlow indicates whether to report BW events from the "Slow Memory Bandwidth" or the "Total Memory Bandwidth" trackers. Each UM will increment when the specified CLOS is incremented due to the specified bandwidth source. Only one bit of the UM should be set at a time to achieve accurate results. Victim Events must be scaled by the current value of ChL3QosCfg2.VictimQosThreshold to identify the actual number of CL's identified by the event The combined number of Bandwidth Events observed by a given CLOS can be identified by using the Bandwidth Monitoring ABMC feature, and dedicating tracking resources there.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `VicQosInsensitive1` | Number of VicQos1 "Insensitive" Events counted for the Debug CLOS. Actual number of CL's identified by this event is based on ChL3QosCfg2.VictimQosThreshold. Could be a value from the "Sensitive" value to 2. ( http://adcweb03.amd.com/el/asciidoc/p4/spec/el/qos/qos.html#VictimQosThreshold_Definition) |
| 4 | `VicQosSensitive1` | Number of VicQos1 "Sensitive" Events counted for the Debug CLOS. Actual number of CL's identified by this event is based on ChL3QosCfg2.VictimQosThreshold. ( http://adcweb03.amd.com/el/asciidoc/p4/spec/el/qos/qos.html#VictimQosThreshold_Definition) |
| 3 | `VicQosInsensitive0` | Number of VicQos0 "Insensitive" Events counted for the Debug CLOS. Actual number of CL's identified by this event is based on ChL3QosCfg2.VictimQosThreshold. Could be a value from the "Sensitive" value to 2. ( http://adcweb03.amd.com/el/asciidoc/p4/spec/el/qos/qos.html#VictimQosThreshold_Definition) |
| 2 | `VicQosSensitive0` | Number of VicQos0 "Sensitive" Events counted for the Debug CLOS. Actual number of CL's identified by this event is based on ChL3QosCfg2.VictimQosThreshold. ( http://adcweb03.amd.com/el/asciidoc/p4/spec/el/qos/qos.html#VictimQosThreshold_Definition) |
| 1 | `SdpEvent1` | Number of Sdp1 Events Observed for the Debug CLOS. Each count corresponds to a single Cacheline. |
| 0 | `SdpEvent0` | Number of Sdp0 Events Observed for the Debug CLOS. Each count corresponds to a single Cacheline. |


## L3PMCxA4 — L3 — Track the CCX Throttle Level generated by the Xi.

**Symbolic:** `Core::X86::Pmc::L3::XiCcxThrottleLevel`  
**Instance:** `_ccd0_lthree0; L3PMCxA4`

Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask. Used to identify the average CCX throttle level generated by Xi. The User-Masks allow the target level of each source to be identified, along with the combined value sent to L2. Only one User-Mask should be set at a time. Each source comes in pairs: An "Event" mask and a "Level" mask. The average throttle level can be identified by dividing the "Level" value by the "Event" value when measured over the same time period. Note: The final value generated from Xi is not necessarily the level observed by each L2. Refer to http://adcweb03.amd.com/el/asciidoc/p4/spec/el/qos/qos.html#_l2_throttling_mechanisms . Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `QosMbmLevel` | Qos Memory Bandwidth Control: Level. CLOS to report is identified with ChL3QosCfg.DebugClos and ChL3Cfg.DebugClosUseSlow. |
| 6 | `QosMbmEvent` | Qos Memory Bandwith Control: Event. CLOS to report is identified with ChL3QosCfg.DebugClos and ChL3Cfg.DebugClosUseSlow. |
| 5 | `LulLevel` | Latency Under Load: Level |
| 4 | `LulEvent` | Latency Under Load: Event |
| 3 | `CptLevel` | Core Prefetch Throttling: Level |
| 2 | `CptEvent` | Core Prefetch Throttling: Event |
| 1 | `CombinedLevel` | Combined Level sent to the CCX for the CLOS identified by ChL3QosCfg.DebugClos. |
| 0 | `CombinedEvent` | Combined Message sent to the CCX for the CLOS identified by ChL3QosCfg.DebugClos. |


## L3PMCxA5 — L3 — L3 Internal Fabric On-Ramp Stalls

**Symbolic:** `Core::X86::Pmc::L3::XiL3FOnrampStalls`  
**Instance:** `_ccd0_lthree0; L3PMCxA5`

Ignores CoreID, EnAllCores, and ThreadMask Cycles when a transaction could not be sent out on the L3 fabric due to backpressure (Traffic types starting with ‘x' are getting on here. Types with the 2nd letter ‘x' are getting off). See above the L3 0x11 event to see the traffic decoder. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `V_Offramp` | V channel: sxData |
| 5 | `D` | D channel: xcRdRsp |
| 3 | `H` | H channel: xsPull, xsRdRsp |
| 1 | `Y` | Y channel: xsPrb, xcPrb |


## L3PMCxA8 — L3 — System Probe Types - Non-Coherent

**Symbolic:** `Core::X86::Pmc::L3::XiSysProbeTypesNonCoh`  
**Instance:** `_ccd0_lthree0; L3PMCxA8`

Ignores CoreID, EnAllCores, and ThreadMask. Number and type of coherent probes observed by XI. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `SysMgmt` | System management probe with response |
| 1 | `SysMgmtNoResp` | System management probe without response |
| 0 | `DVM` | DVM probe |


## L3PMCxA9 — L3 — L3 DataFabricPriority

**Symbolic:** `Core::X86::Pmc::L3::L3_DataFabricPriority`  
**Instance:** `_ccd0_lthree0; L3PMCxA9`

For DfPri Feature. Note: EnAllSources and SourceID configurations are ignored for this event

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `SetB_ReqHigherPri` | SetB Request: Higher Priority |
| 1 | `SetB_ReqNormPriAndElig` | SetB Request: Normal Priority & L2/L3 eligible for Higher Priority. Sent to XI as eligible for higher priority, but changed Higher->Normal due to limits in XI. |
| 0 | `SetB_ReqNormPriNotElig` | SetB Request: Normal Priority & Not L2/L3 eligible for Higher Priority |


## L3PMCxAA — L3 — L3 XiSampledSlowLatency

**Symbolic:** `Core::X86::Pmc::L3::L3_XiSampledSlowLatency`  
**Instance:** `_ccd0_lthree0; L3PMCxAA`

Sampled average memory latency (in 10ns increments) for a variety of Slow IBS sources of data from the system. Use L3_XiSampledSlowLatencyRequests with the same UM to identify the number of requests sampled and calculate the actual sampled latency using the equation below: Average Sampled Latency = L3_XiSampledSlowLatency/L3_XiSampledSlowLatencyRequests * 10ns The sampled latency includes the time queued in XSI. Used in conjunction with L3_XiSampledLatency/L3_XiSampledLatencyRequests, one can sample the latency of each Non-MMIO IBS identified source individually. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NearCache_Far` | Requests that target another NUMA node and return from another CCX 's cache in the same NUMA node. |
| 6 | `NearCache_Near` | Requests that target the same NUMA node and return from another CCX 's cache in the same NUMA node. |
| 5 | `Peer_Far` | Requests that target another NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator) --> Past/future processors. |
| 4 | `Peer_Near` | Requests that target the same NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator) --> Past/future processors. |
| 3 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL™). |
| 2 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL). |
| 1 | `LongLat_Ext_Peer_Far` | Requests that target another NUMA node and return from alternate memories. |
| 0 | `LongLat_Ext_Peer_Near` | Requests that target the same NUMA node and return from alternate memories. |


## L3PMCxAB — L3 — L3 XiSampledSlowLatencyRequests

**Symbolic:** `Core::X86::Pmc::L3::L3_XiSampledSlowLatencyRequests`  
**Instance:** `_ccd0_lthree0; L3PMCxAB`

Number of fill requests sampled from a variety of IBS identified Slow data sources throughout the system. Use with L3_XiSampledSlowLatency to measure a sampled, average memory latency to the specified memory source(s). Average Sampled Latency = L3_XiSampledSlowLatency/L3_XiSampledSlowLatencyRequests * 10ns Used in conjunction with L3_XiSampledLatency/L3_XiSampledLatencyRequests, one can sample the latency of each Non-MMIO IBS identified source individually. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NearCache_Far` | Requests that target another NUMA node and return from another CCX 's cache in the same NUMA node. |
| 6 | `NearCache_Near` | Requests that target the same NUMA node and return from another CCX 's cache in the same NUMA node. |
| 5 | `Peer_Far` | Requests that target another NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator) --> Past/future processors. |
| 4 | `Peer_Near` | Requests that target the same NUMA node and return from coherent memory of a different processor type (e.g. GPU, accelerator) --> Past/future processors. |
| 3 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL™). |
| 2 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL). |
| 1 | `LongLat_Ext_Peer_Far` | Requests that target another NUMA node and return from alternate memories. |
| 0 | `LongLat_Ext_Peer_Near` | Requests that target the same NUMA node and return from alternate memories. |


## L3PMCxAC — L3 — L3 XiSampledLatency

**Symbolic:** `Core::X86::Pmc::L3::L3_XiSampledLatency`  
**Instance:** `_ccd0_lthree0; L3PMCxAC`

When used in conjunction with L3_XiSampledLatencyRequests, this PMC Event will measure the average memory latency (excluding MMIO ) observed by this CCX . Configure two PMCs with the L3_XiSampledLatency and L3_XiSampledLatencyRequests events and use the following equation to identify the observed latency. Average Sampled Latency = L3_XiSampledLatency/L3_XiSampledLatencyRequests * 10ns Some ChL3PmcCfg fields must be programmed as follows to ensure that these events accurately measure latency: ChL3PmcCfg[EnAllSources]=0x1. Other ChL3PmcCfg fields can be used to filter the measured latency based on originating thread (EnAllCores, CoreID) and Data Source (UnitMask). To measure average latency from all threads to all Data Sources, use the following configuration: ChL3PmcCfg[EnAllCores]=0x1, ChL3PmcCfg[ThreadMask]=0x3, and ChL3PmcCfg[UnitMask]=0xFF. The sampled latency includes the time queued in XSI. The sample begins 2 cycles after the axReq enters XSI. The sample ends 1 cycle after the xcRdRsp header exits XSI. This PMC only measures RdBlk* and ChgToX requests (WT, WP, and WB Memory Types) Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LongLat_Ext_Peer_Far` | Requests that target another NUMA node and return from alternate memories |
| 6 | `LongLat_Ext_Peer_Near` | Requests that target the same NUMA node and return from alternate memories |
| 5 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL™) |
| 4 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL) |
| 3 | `NearCache_FarCache_Far` | Requests that target another NUMA node and return from another CCX 's cache. |
| 2 | `NearCache_FarCache_Near` | Requests that target the same NUMA node and return from another CCX 's cache. |
| 1 | `Dram_Far` | Requests that target another NUMA node and return from DRAM |
| 0 | `Dram_Near` | Requests that target the same NUMA node and return from DRAM |


## L3PMCxAD — L3 — L3 XiSampledLatencyRequests

**Symbolic:** `Core::X86::Pmc::L3::L3_XiSampledLatencyRequests`  
**Instance:** `_ccd0_lthree0; L3PMCxAD`

When used in conjunction with L3_XiSampledLatency, this PMC Event will measure the average memory latency (excluding MMIO ) observed by this CCX . Configure two PMCs with the L3_XiSampledLatency and L3_XiSampledLatencyRequests events and use the following equation to identify the observed latency. Average Sampled Latency = L3_XiSampledLatency/L3_XiSampledLatencyRequests * 10ns Some ChL3PmcCfg fields must be programmed as follows to ensure that these events accurately measure latency: ChL3PmcCfg[EnAllSources]=0x1. Other ChL3PmcCfg fields can be used to filter the measured latency based on originating thread (EnAllCores, CoreID) and Data Source (UnitMask). To measure average latency from all threads to all Data Sources, use the following configuration: ChL3PmcCfg[EnAllCores]=0x1, ChL3PmcCfg[ThreadMask]=0x3, and ChL3PmcCfg[UnitMask]=0xFF. This PMC only measures RdBlk* and ChgToX requests (WT, WP, and WB Memory Types) Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LongLat_Ext_Peer_Far` | Requests that target another NUMA node and return from alternate memories |
| 6 | `LongLat_Ext_Peer_Near` | Requests that target the same NUMA node and return from alternate memories |
| 5 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL™) |
| 4 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL) |
| 3 | `NearCache_FarCache_Far` | Requests that target another NUMA node and return from another CCX 's cache. |
| 2 | `NearCache_FarCache_Near` | Requests that target the same NUMA node and return from another CCX 's cache. |
| 1 | `Dram_Far` | Requests that target another NUMA node and return from DRAM |
| 0 | `Dram_Near` | Requests that target the same NUMA node and return from DRAM |


## L3PMCxAE — L3 — L3 XiIoRequests

**Symbolic:** `Core::X86::Pmc::L3::L3_XiIoRequests`  
**Instance:** `_ccd0_lthree0; L3PMCxAE`

Counts the number of Sdp Requests targetting IO Memory. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `WeaklyOrderedReadsToIO` | RdSized* and RdBlk* Sdp Ops that have the Sdp_ReqIO bit set and Sdp_ReqBlockLevel == BLOCK_LEVEL_ADDRESS. (Caused by CD, WC, WC+, WP, WT Memory Types) |
| 2 | `StronglyOrderedReadsToIO` | RdSized* and RdBlk* Sdp Ops that have the Sdp_ReqIO bit set and Sdp_ReqBlockLevel == BLOCK_LEVEL_UNIT (Caused by UC Memory Type) |
| 1 | `WeaklyOrderedWritesToIO` | WrSized* Sdp Ops that have the Sdp_ReqIO bit set and Sdp_ReqBlockLevel == BLOCK_LEVEL_ADDRESS. (Caused by CD, WC, WC+, WP, WT Memory Types) |
| 0 | `StronglyOrderedWritesToIO` | WrSized* Sdp Ops that have the Sdp_ReqIO bit set and Sdp_ReqBlockLevel == BLOCK_LEVEL_UNIT. (Caused by UC Memory Type) |


## L3PMCxAF — L3 — L3 XiPcC2xCancel

**Symbolic:** `Core::X86::Pmc::L3::L3_XiPcC2xCancel`  
**Instance:** `_ccd0_lthree0; L3PMCxAF`

UM[1:0] - Counts the number of ChgToX requests canceled by a Probe Collision. Note: This PMC only counts events originating from the thread indicated by EnAllCores, CoreId, and ThreadMask in ChL3PmcCfg*. Set EnAllCores == 1 and ThreadMask == 3 to count events from all threads. This qualification only applies to UM[1:0]. UM[7:4] - Count the number of probes that collided with an outstanding transaction from the CCX . If bits in both UM[1:0] and UM[7:4] are set in the same PMC config, it may lead to inaccurate results. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `PrbCollisionVicOtherXi` | Probe Collision for a Victim on other Xi |
| 6 | `PrbCollisionVicThisXi` | Probe Collision for a Victim on this Xi |
| 5 | `PrbCollisionC2xOtherXi` | Probe Collision for a ChgToX on other Xi |
| 4 | `PrbCollisionC2xThisXi` | Probe Collision for a ChgToX on this Xi |
| 1 | `C2xCancelNoRetry` | ChgToX Collieded with a Probe but did not need to retry as a RdBlkX |
| 0 | `C2xCancelRetry` | ChgToX Collided with a Probe and issued a RdBlkX to complete the transaction. |


## L3PMCxB0 — L3 — L3 XiVmgPrbMiss

**Symbolic:** `Core::X86::Pmc::L3::L3_XiVmgPrbMiss`  
**Instance:** `_ccd0_lthree0; L3PMCxB0`

Counts the number of probes that the Complex receives that are targeted to a VmGuard Key not present in the CCX . Xi responds to these probes with a "Miss" without passing them into the complex, so these probes don't show up in the L3 perfmons. Note: ChL3PmcCfg*.SourceID and ChL3PmcCfg*.EnAllSources identifies the Sdp interface from which to count. Setting ChL3PmcCfg.EnAllSources to 1 will enable counting for all CCX Interfaces. For products with multiple Sdp links enabled and connected on CCD (i.e. wide mode products), use the SourceID and EnAllSources to control which Sdp port the selected PME will count for. Setting EnAllSources will enable counting from all Sdp ports in the system. Clearing EnAllSources will only count events from the Sdp port specified by SourceID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 0 | `VmgPrbMiss` | Xi received a probe to a VmGuard key not used in the Complex and responded with a Miss. |


## L3PMCxC0 — L3 — L3 DsmActionGrp0

**Symbolic:** `Core::X86::Pmc::L3::L3_DsmActionGrp0`  
**Instance:** `_ccd0_lthree0; L3PMCxC0`

Counts when DSM actions is high. Unit mask select DSM actions 0 thru 7.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DsmAction7` | DSM Action 7. |
| 6 | `DsmAction6` | DSM Action 6. |
| 5 | `DsmAction5` | DSM Action 5. |
| 4 | `DsmAction4` | DSM Action 4. |
| 3 | `DsmAction3` | DSM Action 3. |
| 2 | `DsmAction2` | DSM Action 2. |
| 1 | `DsmAction1` | DSM Action 1. |
| 0 | `DsmAction0` | DSM Action 0. |


## L3PMCxC1 — L3 — L3 DsmActionGrp1

**Symbolic:** `Core::X86::Pmc::L3::L3_DsmActionGrp1`  
**Instance:** `_ccd0_lthree0; L3PMCxC1`

Counts when DSM actions is high. Unit mask select DSM actions 8 thru 15.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DsmAction15` | DSM Action 15. |
| 6 | `DsmAction14` | DSM Action 14. |
| 5 | `DsmAction13` | DSM Action 13. |
| 4 | `DsmAction12` | DSM Action 12. |
| 3 | `DsmAction11` | DSM Action 11. |
| 2 | `DsmAction10` | DSM Action 10. |
| 1 | `DsmAction9` | DSM Action 9. |
| 0 | `DsmAction8` | DSM Action 8. |


## L3PMCxC2 — L3 — Stretch events

**Symbolic:** `Core::X86::Pmc::L3::L3XCapStretch`  
**Instance:** `_ccd0_lthree0; L3PMCxC2`

Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask. Statistics related to Stretch

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `OtherForceStretch` | increment the count each time other force stretch events happen |
| 1 | `DroopStretch` | increment the count each time the Droop stretch happens |
| 0 | `EdcStretch` | increment the count each time the EDC stretch happens |


## L3PMCxC3 — L3 — EDC set1 events

**Symbolic:** `Core::X86::Pmc::L3::l3xcap_edc_set1`  
**Instance:** `_ccd0_lthree0; L3PMCxC3`

Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask. Statistics related to EDC

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CCXViolation` | increment the count each time the CCXViolation happens |
| 6 | `CCXOverThreshold_2` | CCXOverThreshold bit 2 |
| 5 | `CCXOverThreshold_1` | CCXOverThreshold bit 1 |
| 4 | `CCXOverThreshold_0` | CCXOverThreshold bit 0 |
| 3 | `L3Violation` | increment the count each time l3 violation happens |
| 2 | `L3OverThreshold_2` | L3OverThreshold bit 2 |
| 1 | `L3OverThreshold_1` | L3OverThreshold bit 1 |
| 0 | `L3OverThreshold_0` | L3OverThreshold bit 0 |


## L3PMCxC4 — L3 — EDC set2 events

**Symbolic:** `Core::X86::Pmc::L3::l3xcap_edc_set2`  
**Instance:** `_ccd0_lthree0; L3PMCxC4`

Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask. Statistics related to EDC

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `Pcc` | increment the count each time the Pcc happens |
| 0 | `EdcThrottle` | increment the count each time the EdcThrottle happens |


## L3PMCxC5 — L3 — freqstat events

**Symbolic:** `Core::X86::Pmc::L3::l3xcap_freqstat`  
**Instance:** `_ccd0_lthree0; L3PMCxC5`

Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask. Statistics related to Freq Stat

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `TargetDidBusy_rise` | TargetDidBusy count |
| 4 | `TargetVidBusy_rise` | TargetVidBusy count |
| 3 | `TargetFidBusy_rise` | TargetFidBusy count |
| 2 | `TargetDidBusy` | TargetDidBusy |
| 1 | `TargetVidBusy` | TargetVidBusy |
| 0 | `TargetFidBusy` | TargetFidBusy |


## L3PMCxC6 — L3 — Distributed Triggers

**Symbolic:** `Core::X86::Pmc::L3::L3l3xcap_distributed_triggers`  
**Instance:** `_ccd0_lthree0; L3PMCxC6`

This event tracks distributed triggers generated by the DBMU_DT. Ignores SourceID, EnAllSources, CoreID, EnAllCores and ThreadMask.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `LocalTrigger1` | Local Trigger 1. |
| 0 | `LocalTrigger0` | Local Trigger 0. |

