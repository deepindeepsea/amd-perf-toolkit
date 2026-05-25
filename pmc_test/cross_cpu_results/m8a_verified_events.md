# Events that VERIFY on AWS m8a (Zen5 Turin under Nitro)

Total: **78** distinct (event, umask) tuples returned non-zero counts on m8a in our long-collection sweep.

- **PerfSpect-Turin upstream** uses 14 of these
- **PPR-only** (untapped by PerfSpect) 64


## Load/Store (24)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x24` | `0x2` | `Bad_Status_STLI.StliOther` |   |
| `0x29` | `0x1` | `LS_Dispatch.PureLd` |   |
| `0x29` | `0x2` | `LS_Dispatch.PureSt` |   |
| `0x29` | `0x4` | `LS_Dispatch.LdOpSt` |   |
| `0x35` | `0x0` | `Store_to_Load_Forward` |   |
| `0x37` | `0x1` | `Store_Globally_Visible_Cancels_External.OlderStVisibleDepCancel` |   |
| `0x43` | `0x1` | `ls_dmnd_fills_from_sys.local_l2` | ✓ |
| `0x44` | `0x1` | `ls_any_fills_from_sys.local_l2` | ✓ |
| `0x45` | `0x1` | `ls_l2_d_tlb_hit.4k` | ✓ |
| `0x45` | `0x2` | `ls_l2_d_tlb_hit.coalesced` | ✓ |
| `0x45` | `0x4` | `ls_l2_d_tlb_hit.2M` | ✓ |
| `0x45` | `0x8` | `L1_DTLB_Reloads.TlbReload1GL2Hit` |   |
| `0x45` | `0x10` | `ls_l2_d_tlb_miss.4k` | ✓ |
| `0x45` | `0x20` | `ls_l2_d_tlb_miss.coalesced` | ✓ |
| `0x45` | `0x40` | `ls_l2_d_tlb_miss.2M` | ✓ |
| `0x45` | `0x80` | `L1_DTLB_Reloads.TlbReload1GL2Miss` |   |
| `0x47` | `0x1` | `Misaligned_Load_Flows.MA64` |   |
| `0x47` | `0x2` | `Misaligned_Load_Flows.MA4K` |   |
| `0x50` | `0x1` | `ls_64b_lines_written_wcb1` | ✓ |
| `0x85` | `0x1` | `ITLB_Reload_from_Page_Table_walk.walk_4K` |   |
| `0x85` | `0x8` | `ITLB_Reload_from_Page_Table_walk.Coalesced_4k` |   |
| `0xae` | `0x2` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.LoadQueueRsrcStall` |   |
| `0xae` | `0x4` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.StoreQueueRsrcStall` |   |
| `0x120` | `0x1` | `ls_not_halted_p0_cyc` | ✓ |

## Execute / Retire (17)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x3` | `0x8` | `Retired_SSE_AVX_FLOPs.MacFLOPs` |   |
| `0x8` | `0x1` | `Retired_FP_uOps.x87uOpsRetired` |   |
| `0x8` | `0x2` | `Retired_FP_uOps.MMXuOpsRetired` |   |
| `0x8` | `0x4` | `Retired_FP_uOps.ScalaruOpsRetired` |   |
| `0x8` | `0x8` | `Retired_FP_uOps.Pack128uOpsRetired` |   |
| `0x8` | `0x10` | `Retired_FP_uOps.Pack256uOpsRetired` |   |
| `0x8` | `0x20` | `Retired_FP_uOps.Pack512uOpsRetired` |   |
| `0xa` | `0x8` | `FP_Ops_Retired` |   |
| `0xc0` | `0x0` | `Retired_Instructions` |   |
| `0xc1` | `0x0` | `Retired_Macro_Ops` |   |
| `0xc6` | `0x0` | `Retired_Far_Control_Transfers` |   |
| `0xcb` | `0x4` | `Retired_MMX_FP_Instructions.SSE` |   |
| `0xd6` | `0x1` | `Cycles_With_No_Retire_INT.Empty` |   |
| `0xd6` | `0x2` | `ex_no_retire.not_complete` | ✓ |
| `0xd6` | `0x8` | `Cycles_With_No_Retire_INT.Other` |   |
| `0x1c1` | `0x0` | `Retired_Microcoded_Instructions` |   |
| `0x1c2` | `0x0` | `Retired_Microcode_Ops` |   |

## Branch / BPU (13)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x9f` | `0x2` | `BP_redirects.ExRedir` |   |
| `0xc2` | `0x0` | `Retired_Branch_Instructions` |   |
| `0xc3` | `0x0` | `Retired_Branch_Instructions_Mispredicted` |   |
| `0xc4` | `0x0` | `Retired_Taken_Branch_Instructions` |   |
| `0xc5` | `0x0` | `Retired_Taken_Branch_Instructions_Mispredicted` |   |
| `0xc8` | `0x0` | `Retired_Near_Return_Branch_Instructions` |   |
| `0xc9` | `0x0` | `Retired_Near_Return_Branch_Instructions_Mispredicted` |   |
| `0xca` | `0x0` | `Retired_Indirect_Branch_Instructions_Mispredicted` |   |
| `0xcc` | `0x0` | `Retired_Indirect_Branch_Instructions` |   |
| `0xd1` | `0x0` | `Retired_Conditional_Branch_Instructions` |   |
| `0x1c7` | `0x0` | `Retired_Conditional_Branch_Instructions_Mispredicted` |   |
| `0x1c8` | `0x0` | `Retired_Unconditional_Branch_Instructions_Mispredicted` |   |
| `0x1c9` | `0x0` | `Retired_Unconditional_Branch_Instructions` |   |

## Dispatch / Decode (11)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0xaa` | `0x1` | `Source_of_Op_Dispatched_From_Decoder.x86_decoder` |   |
| `0xaa` | `0x2` | `Source_of_Op_Dispatched_From_Decoder.Op_Cache` |   |
| `0xab` | `0x4` | `Types_of_Ops_Dispatched_From_Decoder_INT.floating_pointSIMD` |   |
| `0xab` | `0x8` | `Types_of_Ops_Dispatched_From_Decoder_INT.integer` |   |
| `0xae` | `0x1` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.IntPhyRegFileRsrcStall` |   |
| `0xae` | `0x40` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_1.FPSchRsrcStall` |   |
| `0xaf` | `0x1` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.ALTokens` |   |
| `0xaf` | `0x2` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.AGTokens` |   |
| `0xaf` | `0x4` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.EX_Flush_recovery` |   |
| `0xaf` | `0x20` | `Dispatch_Stall_Cycles_Dynamic_Tokens_Part_2.RetQ` |   |
| `0x1a0` | `0x1` | `de_no_dispatch_per_slot.no_ops_from_frontend` | ✓ |

## Other (5)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x82` | `0x0` | `Instruction_Cache_Refills_from_L2` |   |
| `0x8e` | `0x0` | `Variable_Target_Predictions` |   |
| `0x9f` | `0x1` | `resyncs_or_nc_redirects` | ✓ |
| `0xd4` | `0x0` | `Div_Op_Count` |   |
| `0x28f` | `0x4` | `op_cache_hit_miss.miss` | ✓ |

## TLB / Paging (3)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x84` | `0x0` | `L1_ITLB_Miss_L2_ITLB_Hit` |   |
| `0x94` | `0x1` | `ITLB_Hits.IF4K` |   |
| `0x94` | `0x2` | `ITLB_Hits.IF2M` |   |

## I-cache / Fetch (2)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x59` | `0x1` | `Software_Prefetch_Data_Cache_Fills.LocalL2` |   |
| `0x5a` | `0x1` | `Hardware_Prefetch_Data_Cache_Fills.LocalL2` |   |

## Cycles / Halted (2)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x76` | `0x0` | `Cycles_Not_in_Halt` |   |
| `0xd3` | `0x0` | `Div_Cycles_Busy_count` |   |

## FP / SIMD (1)

| Event | Umask | Name | In PerfSpect? |
|---|---|---|:-:|
| `0x5f` | `0x0` | `Allocated_DC_misses` |   |
