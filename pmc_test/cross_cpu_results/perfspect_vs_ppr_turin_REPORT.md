# PerfSpect-Turin vs PPR BRH — Cross-CPU Diff (2026-05-25)

**Source:**  PerfSpect upstream `cmd/metrics/resources/legacy/.../AuthenticAMD/turin.txt` + `turin.json` (intel/PerfSpect main)
**vs:**       AMD BRH PPR core PMC catalog (`pmc_datasets/BRH/BRH_pmc_core.json`, 310 raw events, 1302 umask combos)
**Matching:** raw (event, umask) hex codes — canonical, not symbolic names

## Headline

| Bucket | Count | Note |
|---|---:|---|
| In **BOTH** PerfSpect + PPR | 62 | Every PerfSpect Turin core event lives in the PPR — strict subset |
| **PerfSpect-only** (not in PPR) | 0 | Sanity-check zero |
| **PPR-only** (untapped by PerfSpect) | 1139 | Big unmet headroom |
| ↳ verified on **BM Turin** | **360** | Real, programmable events PerfSpect ignores |
| ↳ verified on **AWS m8a** | **26** | Nitro lets only this slice through |

## Takeaways

1. PerfSpect-Turin upstream uses **62** core PMC events. The BRH PPR catalog defines **1,302** (event, umask) combinations — PerfSpect covers ~4.8%.
2. On **BM Turin** another **360 PPR events** are programmable and return non-zero values but aren't surfaced by PerfSpect. Biggest untapped categories:
   - **Other / Uncategorized** — 77
   - **Load/Store** — 66
   - **Frontend / Decode** — 58
   - **FP/SIMD** — 44
   - **Branch / BPU** — 35
3. On **AWS m8a** Nitro filters most of that away — only **26** PPR-only events survive. Categories:
   - **Frontend / Decode** — 10
   - **FP/SIMD** — 8
   - **Load/Store** — 4
   - **Prefetch** — 2
   - **TLB / Paging** — 2

## PPR-only events that VERIFY on BM Turin (full list)


### Other / Uncategorized  (77)
- `BTB_Hit_Attributes.BtbHit`
- `BTB_Hit_Attributes.BtbHitOrLoop`
- `BTB_Hit_Attributes.Large`
- `BTB_Hit_Attributes.NPair`
- `BTB_Hit_Attributes.SB`
- `BTB_Hit_Attributes.Single`
- `BTB_Hit_Attributes.TPair`
- `Bad_Status_1.Iohc`
- `Bad_Status_1.NoData`
- `Bad_Status_1.OobFull`
- `Bad_Status_1.WayNotVal`
- `Bad_Status_3.Bank_Conflict`
- `Bad_Status_3.DcPortConflict`
- `Bad_Status_3.SpecGoodStatus`
- `Bad_Status_3.SpecLockGoodStatus`
- `Count_of_Broadcasts.Frn`
- `Count_of_Broadcasts.PrnAlu`
- `Count_of_Broadcasts.PrnLd`
- `DC_Victim_MOESI.E`
- `DC_Victim_MOESI.M`
- `DC_Victim_MOESI.S`
- `Fences.LFENCE`
- `Fences.SFENCE`
- `Fill_Response_MOESI.E_Alias`
- `Fill_Response_MOESI.E_Fill`
- `Fill_Response_MOESI.M_Alias`
- `Fill_Response_MOESI.S_Alias`
- `Fill_Response_MOESI.S_Fill`
- `Instruction_Cache_Lines_Invalidated.FillInvalidated`
- `Instruction_Cache_Lines_Invalidated.L2InvalidatingProbe`
- `Instruction_Cache_Pipe_Stall.IcStallAny`
- `Instruction_Cache_Pipe_Stall.IcStallBackPressure`
- `Instruction_Cache_Pipe_Stall.IcStallIcMiss`
- `Instruction_Cache_Pipe_Stall.IcStallPrqEmpty`
- `Interrupts_Taken.NumInterrupts`
- `L2_BTB_Hit_Miss_events.L2BtbHitTbl0`
- `L2_BTB_Hit_Miss_events.L2BtbHitTbl1`
- `L2_BTB_Hit_Miss_events.L2BtbMiss`
- `LiveLock_Widgets.SafetyNetWakeUp`
- `LiveLock_Widgets.StCommitFwdProgWidget`
- `Mask_register_usage.MaskWrite`
- `Mask_register_usage.MaskingRegUse`
- `Mask_register_usage.MergeMasking`
- `Micro_Op_Cache_Build_Build_Break_Reason.Other`
- `Micro_Op_Cache_Full_Tag_Match_Events.OC_full_tag_hit`
- `Micro_Op_Cache_Full_Tag_Match_Events.OC_full_tag_miss`
- `MovElim_Scalar_Optimization.OptPotential`
- `MovElim_Scalar_Optimization.Optimized`
- `NSQ_before_rename.Flush_token_stall`
- `NSQ_before_rename.SQ_token_stall`
- `NSQ_before_rename.Total_I2F`
- `Number_of_UopQ_writes.IcFetch`
- `Number_of_UopQ_writes.OcFetch`
- `Page_Table_Walk_Allocation.TableWalk_Dside`
- `Page_Table_Walk_Allocation.TableWalk_Iside`
- `Pipeline_Restart_Due_to_Various_Events.MemoryRenaming`
- `Pipeline_Restart_Due_to_Various_Events.ResyncLoq`
- `Pipeline_Restart_Due_to_Various_Events.ResyncOobThread`
- `Pipeline_Restart_Due_to_Various_Events.SpecGoodStatusDc`
- `Pipeline_Restart_Due_to_Various_Events.SpecLockMapAbort`
- `Resync_from_traps.Cmc`
- `Resync_from_traps.LsResync`
- `Resync_from_traps.RflagsRtTf`
- `SCB_Close_Flush_2.GloballyVisibleProbeHit`
- `SCB_Close_Flush_2.NewSameAddress`
- `SCB_Close_Flush_2.Threshold`
- `SMC_or_CMC_Pipeline_restart_requests.CMC`
- `SPEC_CTL_Modes.IBRS`
- `SPEC_CTL_Modes.STIBP`
- `SpecGoodStatus_Activity.SpecGoodStatusOOBFullDC`
- `SpecGoodStatus_Activity.SpecGoodStatusOOBFullSTLF`
- `SpecGoodStatus_Activity.SpecGoodStatusSTLFLhash`
- `Stack_Engine.FixupOpReq`
- `Victim_Nack.CBB`
- `Victim_Nack.ScbGloballyVisible`
- `resync_fault.SLM_resync`
- `resync_fault.faulttrap_on_fused_instruction_converted_to_resync_fault`

### Load/Store  (66)
- `Bad_Status_3.HintedStoreNotReady`
- `Bad_Status_STLI.StlfCandidateStartAddrMismatch`
- `Bad_Status_STLI.StlfNoData`
- `Bad_Status_STLI.StliAgen`
- `Bad_Status_STLI.StliBadPa`
- `Bad_Status_STLI.StliMultimatch`
- `Bad_Status_STLI.StliNoState`
- `Bad_Status_STLI.StliOther`
- `Bad_Status_STLI.StliScbNoState`
- `Count_of_bad_status_load_broadcasts.BadPartial`
- `Count_of_bad_status_load_broadcasts.Bad_Status`
- `Count_of_bad_status_load_broadcasts.EbsCancel`
- `LS_HwPf_Picks.HwPfL1Stride`
- `LS_HwPf_Picks.HwPfL2Stride`
- `LS_HwPf_Picks.HwPfRegion`
- `LS_HwPf_Picks.HwPfStream`
- `LS_MAB_Allocates_by_Type_INT.DataPipe`
- `LS_MAB_Allocates_by_Type_INT.HwPf`
- `LS_Non_HwPf_Picks.Ptw`
- `LS_Non_HwPf_Picks.PureLd`
- `LS_Non_HwPf_Picks.PureSt`
- `Load_hits_in_Memory_Dependency_Widgets.MdpHit`
- `Load_hits_in_Memory_Dependency_Widgets.MemfileHit`
- `Load_hits_in_Memory_Dependency_Widgets.StkTrackerHitRbp`
- `Load_hits_in_Memory_Dependency_Widgets.StkTrackerHitRsp`
- `Loads_that_hit_in_the_Resync_Predictor.IohcLoads`
- `Loads_that_hit_in_the_Resync_Predictor.MemRenDisable`
- `Memory_Renamed_Loads_Eliminated.MdpHit`
- `Memory_Renamed_Loads_Eliminated.MemfileHit`
- `Memory_Renamed_Loads_Eliminated.StkTrackerHitRbp`
- `Memory_Renamed_Loads_Eliminated.StkTrackerHitRsp`
- `Misaligned_Load_Flows.MA4K`
- `Misaligned_Load_Flows.MA64`
- `Misaligned_Store_Flows.MA4K`
- `Misaligned_Store_Flows.MA64`
- `NSQ_before_rename.Load_uses_LS_FIFO`
- `NSQ_before_rename.Total_loads`
- `Segment_Register_Loads.CS`
- `Segment_Register_Loads.DS`
- `Segment_Register_Loads.ES`
- `Segment_Register_Loads.FS`
- `Segment_Register_Loads.GS`
- `Segment_Register_Loads.SS`
- `Store_Commit_Activity.CommitPipeSwap`
- `Store_Commit_Activity.FillStCommitBankConflict`
- `Store_Commit_Activity.FillStCommitPortConflict`
- `Store_Commit_Activity.StCommitStCommitBankConflict`
- `Store_Commit_Activity.StillOpenForCombining`
- `Store_Commit_Stalls.Fence`
- `Store_Commit_Stalls.OldestScbNotExclState`
- `Store_Commit_Stalls.Other`
- `Store_Commit_Stalls.OtherThread`
- `Store_Commit_Stalls.ScbEmpty`
- `Store_Dealloc_Activity.NoDealloc`
- `Store_Dealloc_Activity.Other`
- `Store_Dealloc_Activity.ScbAlloc`
- `Store_Dealloc_Activity.ScbCombine`
- `Store_Dealloc_Activity.ScbFull`
- `Store_Dealloc_Stalls.ScbFull`
- `Store_Dealloc_Stalls.StoreDeallocCancel`
- `Store_Globally_Visible_Cancels_External.OlderStVisibleDepCancel`
- `Table_Walker_Data_Cache_Fills_by_Data_Source.DramIO_Far`
- `Table_Walker_Data_Cache_Fills_by_Data_Source.DramIO_Near`
- `Table_Walker_Data_Cache_Fills_by_Data_Source.LocalCcx`
- `Table_Walker_Data_Cache_Fills_by_Data_Source.LocalL2`
- `resync_fault.LS_resync`

### Frontend / Decode  (58)
- `Any_IC_Fills_by_Data_Source.LclCache`
- `Any_IC_Fills_by_Data_Source.LclDram`
- `Any_IC_Fills_by_Data_Source.LclL2`
- `Any_IC_Fills_by_Data_Source.RmtDram`
- `Dispatch_Conflict_Stall_Cycles_Dynamic_Tokens.Agsq`
- `Dispatch_Conflict_Stall_Cycles_Dynamic_Tokens.Alsq`
- `Dispatch_Conflict_Stall_Cycles_Dynamic_Tokens.ExtId`
- `Dispatch_Conflict_Stall_Cycles_Dynamic_Tokens.IntPrf`
- `Dispatch_Empty.Microcode_Stall`
- `Dispatch_Empty.UopQ_Empty`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.FPSchRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.IntPhyRegFileRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.LoadQueueRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.StoreQueueRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.AGTokens`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.ALTokens`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.ExStallReq`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.RetQ`
- `Dispatch_Stall_Cycles_Static_Restrictions_Part_1.MaxBpw`
- `Dispatch_Stall_Cycles_Static_Restrictions_Part_1.MaxIdrReads`
- `Dispatch_Stall_Cycles_Static_Restrictions_Part_2.BreakAfter`
- `Dispatch_Stall_Cycles_Static_Restrictions_Part_2.BreakBefore`
- `Dispatch_Stall_Cycles_Static_Restrictions_Part_2.Max8OpDispatch`
- `Dispatch_Thread_Arbitration.ArbReq`
- `Dispatch_Thread_Arbitration.Grant`
- `Dispatch_Thread_Arbitration.HasWork`
- `IC_Fill_Requests_instruction_prefetch.DemandFillPrefetch`
- `IC_Fill_Requests_instruction_prefetch.NonSeqFillPrefetch`
- `IC_Fill_Requests_instruction_prefetch.SeqFillPrefetch`
- `IC_L2_Fill_Requests.UtagMiss`
- `Microcode_Sequencer_Stall_Cycles.Serialize`
- `Microcode_Sequencer_Stall_Cycles.wait_for_count_or_wait_for_countl`
- `Microcode_Sequencer_Stall_Cycles.wait_for_quiet`
- `Microcode_Sequencer_Stall_Cycles.wait_for_segld`
- `Microcode_Sequencer_Stall_Cycles.wait_for_stq`
- `No_Dispatch.NoInstr`
- `No_Dispatch.Other`
- `No_Dispatch.TokenStall`
- `Number_of_Dispatched_op_per_cycle_histogram.eightOps`
- `Number_of_Dispatched_op_per_cycle_histogram.fiveOps`
- `Number_of_Dispatched_op_per_cycle_histogram.fourOps`
- `Number_of_Dispatched_op_per_cycle_histogram.oneOp`
- `Number_of_Dispatched_op_per_cycle_histogram.sevenOps`
- `Number_of_Dispatched_op_per_cycle_histogram.sixOps`
- `Number_of_Dispatched_op_per_cycle_histogram.threeOps`
- `Number_of_Dispatched_op_per_cycle_histogram.twoOps`
- `OC_Mode_Switch.IcOcModeSwitch`
- `OC_Mode_Switch.OcIcModeSwitch`
- `Software_Prefetch_Dispatched.PREFETCH`
- `Software_Prefetch_Dispatched.PREFETCHT0_to_L1`
- `Software_Prefetch_Dispatched.PREFETCHW`
- `Types_of_Ops_Dispatched_From_Decoder_INT.RetQ_compression_correction`
- `Types_of_Ops_Dispatched_From_Decoder_INT.fastpath`
- `Types_of_Ops_Dispatched_From_Decoder_INT.fastpath_sequencer`
- `Types_of_Ops_Dispatched_From_Decoder_INT.floating_pointSIMD`
- `Types_of_Ops_Dispatched_From_Decoder_INT.integer`
- `Types_of_Ops_Dispatched_From_Decoder_INT.microcode`
- `UOQ_Write_Stall_Cycles.decodeocfetch_interlock`

### FP/SIMD  (44)
- `Bad_Status_3.AVX512_load_pipe_conflict`
- `Changes_to_x87_SSE_control_words.SseAvxCntrlWrite`
- `Changes_to_x87_SSE_control_words.X87CntrlWrite`
- `Dispatched_128b_SSE_AVX_Instructions.Dis_128SseAvx`
- `Dispatched_128b_SSE_AVX_Instructions.Dis_256SseAvx`
- `Dispatched_128b_SSE_AVX_Instructions.Dis_512SseAvx`
- `FPU_Pipe_Assignment.Pipe5`
- `FPU_Pipe_Assignment.Pipe_0`
- `FPU_Pipe_Assignment.Pipe_1`
- `FPU_Pipe_Assignment.Pipe_2`
- `FPU_Pipe_Assignment.Pipe_3`
- `FPU_Pipe_Assignment.Pipe_4`
- `FPU_uOps_Tracking.FpSqEmpty`
- `FPU_uOps_Tracking.FpSqFull`
- `FPU_uOps_Tracking.uOpsDispatched2FpSq`
- `FPU_uOps_Tracking.uOpsInFpSq`
- `FPU_uOps_Tracking.uOpsNsq2Sq`
- `FPU_uOps_Tracking.uOpsSqIssued`
- `FP_Flush_State_Machine_Arcs_and_Cycles.FlushCrmSrm`
- `FP_Flush_State_Machine_Arcs_and_Cycles.FlushFastRecovery`
- `FP_Flush_State_Machine_Arcs_and_Cycles.FlushNoneFastRec`
- `FP_Flush_State_Machine_Arcs_and_Cycles.FlushNoneIgn`
- `FP_Flush_State_Machine_Arcs_and_Cycles.FlushPend`
- `FP_Flush_State_Machine_Arcs_and_Cycles.FlushSlowRecovery`
- `FP_Flush_State_Machine_Arcs_and_Cycles.ToFlushNone`
- `FP_Throttles.Pipe0Throttle`
- `FP_Throttles.Pipe1Throttle`
- `FP_Throttles.Pipe2Throttle`
- `FP_Throttles.Pipe3Throttle`
- `L1_BTB_Accesses.BpPipeActive`
- `L1_BTB_Accesses.BtbAccessed`
- `MovElim_Scalar_Optimization.SseMovOps`
- `MovElim_Scalar_Optimization.SseMovOpsElim`
- `Retired_FP_uOps.MMXuOpsRetired`
- `Retired_FP_uOps.Pack128uOpsRetired`
- `Retired_FP_uOps.Pack256uOpsRetired`
- `Retired_FP_uOps.Pack512uOpsRetired`
- `Retired_FP_uOps.ScalaruOpsRetired`
- `Retired_FP_uOps.x87uOpsRetired`
- `Retired_MMX_FP_Instructions.SSE`
- `Retired_MMX_FP_Instructions.X87`
- `Retired_SSE_AVX_FLOPs.MacFLOPs`
- `Retired_Serializing_Ops.SseCtrlRet`
- `Retired_Serializing_Ops.X87CtrlRet`

### Branch / BPU  (35)
- `BP_Correct.L1BtbError`
- `BP_Correct.L2BtbCancel`
- `BP_Correct.PrqFullLate`
- `BP_Correct.RmcHit`
- `BP_Correct.WakeupCancel`
- `BP_External_Stalls.BLQ_Full`
- `BP_External_Stalls.BPQ_Full`
- `BP_External_Stalls.FAQ_Full`
- `BP_External_Stalls.FetchStall`
- `BP_External_Stalls.PRQ_Full`
- `BP_External_Stalls.ParkStall`
- `BP_Internal_Stall.BtbUpdateRead`
- `BP_Internal_Stall.BtbUpdateWrite`
- `BP_Internal_Stall.L1BtbError`
- `BP_Internal_Stall.L2BtbCancelCycle`
- `BP_Internal_Stall.Reinterp`
- `BP_Internal_Stall.RmcHit`
- `BP_Internal_Stall.TageUpdateRead`
- `Decoder_Overrides_Existing_Branch_Prediction_Speculative.DispatchRedirect`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.TakenBrnchBufferRsrc`
- `Dispatch_Stall_Cycles_Static_Restrictions_Part_2.Max2TknBrn`
- `Micro_Op_Cache_Build_Build_Break_Reason.Taken_Branch`
- `Ops_Dispatched_Past_A_Branch.Past1stBranch`
- `Ops_Dispatched_Past_A_Branch.Past2ndBranch`
- `Ops_Dispatched_Past_A_Branch.Past3rdBranch`
- `Ops_Dispatched_Past_A_Branch.Past4thBranch`
- `Ops_Dispatched_Past_A_Branch.Past5thBranch`
- `Ops_Dispatched_Past_A_Branch.Past6thBranch`
- `Ops_Dispatched_Past_A_Branch.Past7thBranch`
- `Ops_Dispatched_Past_A_Branch.PastOneBranch`
- `Retire_Empty.Mispredict_to_BP`
- `Retired_fused_instructions.FusedBranch`
- `Retired_fused_instructions.FusedNonBranch`
- `uTag_Mispredicts.uTagHitDcMiss`
- `uTag_Mispredicts.uTagMissDCHit`

### Prefetch  (35)
- `Hardware_Prefetch_Data_Cache_Fills.DramIO_Far`
- `Hardware_Prefetch_Data_Cache_Fills.DramIO_Near`
- `Hardware_Prefetch_Data_Cache_Fills.LocalCcx`
- `Hardware_Prefetch_Data_Cache_Fills.LocalL2`
- `Hardware_Prefetch_Data_Cache_Fills.NearFarCache_Far`
- `Hardware_Prefetch_Data_Cache_Fills.NearFarCache_Near`
- `HwPf_Entries_Allocated.RegionAlloc`
- `HwPf_Entries_Allocated.StreamAlloc`
- `HwPf_Entries_Allocated.StrideAlloc`
- `HwPf_Entries_Hit.RegionHit`
- `HwPf_Entries_Hit.StreamHit`
- `HwPf_Entries_Hit.StrideHit`
- `HwPf_MAB_Alloc.L1Stride`
- `HwPf_MAB_Alloc.Region`
- `HwPf_MAB_Alloc.Stream`
- `HwPf_MAB_Match_HwPf_hit_MAB.L1Stride`
- `HwPf_MAB_Match_HwPf_hit_MAB.Region`
- `HwPf_MAB_Match_HwPf_hit_MAB.Stream`
- `HwPf_MAB_Matched.L1Stream`
- `HwPf_MAB_Matched.L1Stride`
- `HwPf_MAB_Matched.Region`
- `Hwpf_Generation.L1HwPfGen`
- `Hwpf_Generation.L1HwpfFilter`
- `Hwpf_Generation.L1HwpfMa`
- `Hwpf_Generation.L2HwPfGen`
- `Hwpf_Generation.L2HwpfFilter`
- `Hwpf_Generation.L2HwpfMa`
- `Hwpf_Ma_Flows.L1HwpfMaFlow`
- `Hwpf_Ma_Flows.L2HwpfMaFlow`
- `Ineffective_Software_Prefetches.DcHit`
- `Ineffective_Software_Prefetches.MabHit`
- `Software_Prefetch_Data_Cache_Fills.DramIO_Near`
- `Software_Prefetch_Data_Cache_Fills.LocalCcx`
- `Software_Prefetch_Data_Cache_Fills.LocalL2`
- `Software_Prefetch_Data_Cache_Fills.NearFarCache_Near`

### Retire / Backend  (22)
- `Int_Vector_Ops_Retired.AddSub_LANEs`
- `LS_Non_HwPf_Picks.LdOpSt`
- `LS_Non_HwPf_Picks.PureStPostRetireScb`
- `LS_Non_HwPf_Picks.PureStPostRetireStq`
- `LS_Non_HwPf_Picks.PureStPreRetire`
- `Micro_ops_Issued_Part0.Al0`
- `Micro_ops_Issued_Part0.Al1`
- `Micro_ops_Issued_Part0.Al2`
- `Micro_ops_Issued_Part0.Al4`
- `Micro_ops_Issued_Part0.Al5`
- `Micro_ops_Issued_Part1.Ag0`
- `Micro_ops_Issued_Part1.Ag1`
- `Micro_ops_Issued_Part1.Ag2`
- `Micro_ops_Issued_Part1.Ag3`
- `No_Retire.Empty`
- `No_Retire.NotCompleteOlder`
- `No_Retire.NotCompleteSelf`
- `No_Retire.Other`
- `Retire_Empty.MicroRedirect`
- `Retire_Empty.Resync`
- `Stack_Engine.FixupOps`
- `Store_Dealloc_Stalls.StqRetireEmpty`

### TLB / Paging  (17)
- `Bad_Status_1.TlbMiss`
- `ITLB_Hits.IF2M`
- `ITLB_Hits.IF4K`
- `ITLB_flow_stalls.Empty`
- `ITLB_flow_stalls.ItlbMiss`
- `ITLB_flow_stalls.ThreadNotSelected`
- `I_TLB_access_cacheable_vs_non_cacheable.cacheable`
- `L1DTLB_Hit_Miss.Hit1G`
- `L1DTLB_Hit_Miss.Hit2M`
- `L1DTLB_Hit_Miss.Hit4K`
- `L1DTLB_Hit_Miss.HitCoalesced`
- `L1DTLB_Hit_Miss.Miss`
- `L2_TLB_hit.hit_16K`
- `L2_TLB_hit.hit_2M`
- `L2_TLB_hit.hit_4K`
- `LS_MAB_Allocates_by_Type_INT.TlbPipeEarly`
- `LS_MAB_Allocates_by_Type_INT.TlbPipeLate`

### Cycles / Freq  (5)
- `UOQ_Write_Stall_Cycles.IDQ_full`
- `UOQ_Write_Stall_Cycles.Input_queue_empty`
- `UOQ_Write_Stall_Cycles.UOQ_full`
- `UOQ_write_stall_cycles_from_OC_fetch_pipe.IdqStall`
- `UOQ_write_stall_cycles_from_OC_fetch_pipe.UopqStall`

### Cache (L2/L3)  (1)
- `Micro_ops_Issued_Part0.Al3`

## PPR-only events that VERIFY on AWS m8a (Nitro) — full list


### Frontend / Decode  (10)
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.FPSchRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.IntPhyRegFileRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.LoadQueueRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.StoreQueueRsrcStall`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.AGTokens`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.ALTokens`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.EX_Flush_recovery`
- `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.RetQ`
- `Types_of_Ops_Dispatched_From_Decoder_INT.floating_pointSIMD`
- `Types_of_Ops_Dispatched_From_Decoder_INT.integer`

### FP/SIMD  (8)
- `Retired_FP_uOps.MMXuOpsRetired`
- `Retired_FP_uOps.Pack128uOpsRetired`
- `Retired_FP_uOps.Pack256uOpsRetired`
- `Retired_FP_uOps.Pack512uOpsRetired`
- `Retired_FP_uOps.ScalaruOpsRetired`
- `Retired_FP_uOps.x87uOpsRetired`
- `Retired_MMX_FP_Instructions.SSE`
- `Retired_SSE_AVX_FLOPs.MacFLOPs`

### Load/Store  (4)
- `Bad_Status_STLI.StliOther`
- `Misaligned_Load_Flows.MA4K`
- `Misaligned_Load_Flows.MA64`
- `Store_Globally_Visible_Cancels_External.OlderStVisibleDepCancel`

### Prefetch  (2)
- `Hardware_Prefetch_Data_Cache_Fills.LocalL2`
- `Software_Prefetch_Data_Cache_Fills.LocalL2`

### TLB / Paging  (2)
- `ITLB_Hits.IF2M`
- `ITLB_Hits.IF4K`
