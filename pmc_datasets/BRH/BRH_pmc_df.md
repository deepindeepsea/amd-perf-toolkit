# BRH — Data Fabric PMC Events

_Source: AMD pprweb build at ppr_BRH_C1_int_050_pprweb_

_Total events: 315_


Events are listed in code order. Per-event, the table lists the UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.


## DFPMCx000006[0...C]D — DF/CCM — CCM REQC Request Type (PIE Requests)

**Symbolic:** `DF::PMC::CCM::ACM_REQC`  
**Instance:** `_instACM0; DFPMCx0000060D _instACM1; DFPMCx0000064D _instACM2; DFPMCx0000068D _instACM3; DFPMCx000006CD`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 3:0 | `Type` | Reset: 0h. Select type of request. Value Description 0h APIC access. 1h APIC ucode access. 2h Fast TPR write. 3h Bus Lock Request. 4h Bus Lock Grant. 5h Bus Lock Release. 6h Join System Management request. 7h Leave System Management request. 8h Interrupt Request. 9h APIC ISR Request. Ah MCA Request. Bh SKINIT Request. Ch System Management Request. Fh-Dh Reserved. |


## DFPMCx000006[0...C]E — DF/CCM — CCM PROBES Memory Probes and Probe Responses for FTI0 channel

**Symbolic:** `DF::PMC::CCM::ACM_PROBES`  
**Instance:** `_instACM0; DFPMCx0000060E _instACM1; DFPMCx0000064E _instACM2; DFPMCx0000068E _instACM3; DFPMCx000006CE`

Sent 3-hop PrbRspD for a multi-cast probe.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8 | `McastPrbRspSrcD` | Reset: 0. Sent 3-hop PrbRspD for a multi-cast probe. |
| 7 | `PrbRspDataXferSel` | Reset: 0. Data Transfer selector for probe response count. |
| 6:4 | `PrbRspStatePDSel` | Reset: 0h. {State[1:0],PassDirty} selector for probe response count. |
| 3:2 | `PrbRspSel` | Reset: 0h. Probe Response Selector. Value Description 0h Disabled, no SDP probe response counted. 1h Count SDP probe responses matching PrbRspStatePDSel field. 2h Count SDP probe responses matching PrbRspDataXferSel field. 3h Count all SDP probe responses. |
| 1:0 | `PrbReqSel` | Reset: 0h. Probe Request Selector. Value Description 0h Disabled, no FTI probe requests counted. 1h Count FTI Probe Request with Rsp2Tgt=0 (3-hop probe request). 2h Count FTI Probe Request with Rsp2Tgt=1 (4-hop probe request). 3h Count all FTI probe requests. |


## DFPMCx000006[1...D]D — DF/CCM — CCM PROBES1 Memory Probes and Probe Responses for FTI1 channel

**Symbolic:** `DF::PMC::CCM::ACM_PROBES1`  
**Instance:** `_instACM0; DFPMCx0000061D _instACM1; DFPMCx0000065D _instACM2; DFPMCx0000069D _instACM3; DFPMCx000006DD`

Sent 3-hop PrbRspD for a multi-cast probe.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8 | `McastPrbRspSrcD` | Reset: 0. Sent 3-hop PrbRspD for a multi-cast probe. |
| 7 | `PrbRspDataXferSel` | Reset: 0. Data Transfer selector for probe response count. |
| 6:4 | `PrbRspStatePDSel` | Reset: 0h. {State[1:0],PassDirty} selector for probe response count. |
| 3:2 | `PrbRspSel` | Reset: 0h. Probe Response Selector. Value Description 0h Disabled, no SDP probe response counted. 1h Count SDP probe responses matching PrbRspStatePDSel field. 2h Count SDP probe responses matching PrbRspDataXferSel field. 3h Count all SDP probe responses. |
| 1:0 | `PrbReqSel` | Reset: 0h. Probe Request Selector. Value Description 0h Disabled, no FTI probe requests counted. 1h Count FTI Probe Request with Rsp2Tgt=0 (3-hop probe request). 2h Count FTI Probe Request with Rsp2Tgt=1 (4-hop probe request). 3h Count all FTI probe requests. |


## DFPMCx000007[0...C]0 — DF/NCM — NCM REQQ_OCCPNCY (GCQ) Queue Occupancy

**Symbolic:** `DF::PMC::NCM::NCM_REQQ_OCCPNCY`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000700 _instNCMIOMMU1; DFPMCx00000740 _instNCMIOMMU2; DFPMCx00000780 _instNCMIOMMU3; DFPMCx000007C0`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx000007[0...C]1 — DF/NCM — NCM RSPQ_OCCPNCY (GRSPQ) Queue Occupancy

**Symbolic:** `DF::PMC::NCM::NCM_RSPQ_OCCPNCY`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000701 _instNCMIOMMU1; DFPMCx00000741 _instNCMIOMMU2; DFPMCx00000781 _instNCMIOMMU3; DFPMCx000007C1`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx000007[0...C]2 — DF/NCM — NCM RSPDQ_OCCPNCY (GRSPQDat) Queue Occupancy

**Symbolic:** `DF::PMC::NCM::NCM_RSPDQ_OCCPNCY`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000702 _instNCMIOMMU1; DFPMCx00000742 _instNCMIOMMU2; DFPMCx00000782 _instNCMIOMMU3; DFPMCx000007C2`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx000007[0...C]3 — DF/NCM — NCM REQDQ_OCCPNCY (GDQ) Queue Occupancy

**Symbolic:** `DF::PMC::NCM::NCM_REQDQ_OCCPNCY`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000703 _instNCMIOMMU1; DFPMCx00000743 _instNCMIOMMU2; DFPMCx00000783 _instNCMIOMMU3; DFPMCx000007C3`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx000007[0...C]4 — DF/NCM — NCM REQQ_STAT (GCQ) Statistics

**Symbolic:** `DF::PMC::NCM::NCM_REQQ_STAT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000704 _instNCMIOMMU1; DFPMCx00000744 _instNCMIOMMU2; DFPMCx00000784 _instNCMIOMMU3; DFPMCx000007C4`

Pipe Kill due to Large Read

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `PipekillLrgRd` | Reset: 0. Pipe Kill due to Large Read |
| 5 | `PipekillFtiDatBuf` | Reset: 0. Pipe Kill due to unavailable FTI Data Buffer |
| 4 | `PipekillFtiCmdDatBuf` | Reset: 0. Pipe Kill due to unavailable FTI Cmd or Data Buffer |
| 3 | `Pick` | Reset: 0. SDP Request Pick |
| 0 | `AllocSdpReq` | Reset: 0. SDP Request Allocation |


## DFPMCx000007[0...C]5 — DF/NCM — NCM RSPQ_STAT (GRSPQ) Statistics

**Symbolic:** `DF::PMC::NCM::NCM_RSPQ_STAT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000705 _instNCMIOMMU1; DFPMCx00000745 _instNCMIOMMU2; DFPMCx00000785 _instNCMIOMMU3; DFPMCx000007C5`

Reserved

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8 | `AllocRspNd` | Reset: 0. Reserved |
| 7 | `PipekillRdRspSdpBuf` | Reset: 0. RdRsp pipekill due to SDP RdRsp credit unavailability |
| 6 | `PipekillWrRspSdpBuf` | Reset: 0. WrRsp pipekill due to SDP WrRsp credit unavailability |
| 4 | `PipekillRspFtiCmdBuf` | Reset: 0. Response Pipekill due to FTI command token unavailability |
| 3 | `PickRdRsp` | Reset: 0. PickRdRsp |
| 2 | `PickWrRsp` | Reset: 0. PickWrRsp |
| 1 | `PickPrbRsp` | Reset: 0. Reserved |
| 0 | `Alloc` | Reset: 0. Response queue allocation |


## DFPMCx000007[0...C]6 — DF/NCM — NCM RSPDQ_STAT (GRSPQDat) Statistics

**Symbolic:** `DF::PMC::NCM::NCM_RSPDQ_STAT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000706 _instNCMIOMMU1; DFPMCx00000746 _instNCMIOMMU2; DFPMCx00000786 _instNCMIOMMU3; DFPMCx000007C6`


## DFPMCx000007[0...C]7 — DF/NCM — NCM REQDQ_STAT (GDQ) Statistics

**Symbolic:** `DF::PMC::NCM::NCM_REQDQ_STAT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000707 _instNCMIOMMU1; DFPMCx00000747 _instNCMIOMMU2; DFPMCx00000787 _instNCMIOMMU3; DFPMCx000007C7`

Pick any I/O data beat with partial byte-enables.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `PickIOAnyPtlBe` | Reset: 0. Pick any I/O data beat with partial byte-enables. |
| 3 | `PickAnyPtlBe` | Reset: 0. Pick any data beat with partial byte-enables. |
| 2 | `PickIOAny` | Reset: 0. Pick any I/O data beat. |
| 1 | `PickAny` | Reset: 0. Pick any data beat. |
| 0 | `Alloc` | Reset: 0. Allocate. |


## DFPMCx000007[0...C]8 — DF/NCM — NCM REQA Request Type

**Symbolic:** `DF::PMC::NCM::NCM_REQA`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000708 _instNCMIOMMU1; DFPMCx00000748 _instNCMIOMMU2; DFPMCx00000788 _instNCMIOMMU3; DFPMCx000007C8`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NodeId` | Reset: 0. Select target Node ID if UseNodeId is set |
| 6 | `UseNodeId` | Reset: 0. 0: Count all selected transactions. 1: Only count transactions destined to the selected NodeId |
| 4 | `MstAbort` | Reset: 0. Master Abort. |
| 3 | `Atomic` | Reset: 0. Atomic. |
| 2 | `WrSized` | Reset: 0. WriteSized (all sized writes, regardless of byte enables) |
| 1 | `RdBlkS` | Reset: 0. Reserved. |
| 0 | `RdSized` | Reset: 0. ReadSized. |


## DFPMCx000007[0...C]9 — DF/NCM — NCM REQB Request Type

**Symbolic:** `DF::PMC::NCM::NCM_REQB`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000709 _instNCMIOMMU1; DFPMCx00000749 _instNCMIOMMU2; DFPMCx00000789 _instNCMIOMMU3; DFPMCx000007C9`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NodeId` | Reset: 0. Select target Node ID if UseNodeId is set |
| 6 | `UseNodeId` | Reset: 0. 0: Count all selected transactions. 1: Only count transactions destined to the selected NodeId |
| 3 | `PIESysMgt` | Reset: 0. PIE/System Management. |
| 2 | `Atomic` | Reset: 0. Atomic. |
| 1 | `WrSized` | Reset: 0. WriteSized (all sized writes, regardless of byte enables) |
| 0 | `RdSized` | Reset: 0. Allocate. |


## DFPMCx000007[0...C]A — DF/NCM — NCM PICK_PRI Priority Picker

**Symbolic:** `DF::PMC::NCM::NCM_PICK_PRI`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000070A _instNCMIOMMU1; DFPMCx0000074A _instNCMIOMMU2; DFPMCx0000078A _instNCMIOMMU3; DFPMCx000007CA`

High-Priority request was picked over a higher priority due to pick saturate.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `SatPrioHi` | Reset: 0. High-Priority request was picked over a higher priority due to pick saturate. |
| 4 | `SatPrioMed` | Reset: 0. Medium-Priority request was picked over a higher priority due to pick saturate. |
| 3 | `SatPrioLow` | Reset: 0. Low-Priority request was picked over a higher priority due to pick saturate. |
| 2 | `RdyPrioUrg` | Reset: 0. Urgent-Priority request was picked over a lower priority. |
| 1 | `RdyPrioHi` | Reset: 0. High-Priority request was picked over a lower priority. |
| 0 | `RdyPrioMed` | Reset: 0. Medium-Priority request was picked over a lower priority. |


## DFPMCx000007[0...C]B — DF/NCM — NCM SDP_DBGA SDP Debug A

**Symbolic:** `DF::PMC::NCM::NCM_SDP_DBGA`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000070B _instNCMIOMMU1; DFPMCx0000074B _instNCMIOMMU2; DFPMCx0000078B _instNCMIOMMU3; DFPMCx000007CB`

Counts number of times received SDP Request that matches this UnitID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5:0 | `UnitID` | Reset: 00h. Counts number of times received SDP Request that matches this UnitID. |


## DFPMCx000007[1...D]F — DF/NCM — NCM DATA_BW DATA BANDWIDTH

**Symbolic:** `DF::PMC::NCM::NCM_DATA_BW`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000071F _instNCMIOMMU1; DFPMCx0000075F _instNCMIOMMU2; DFPMCx0000079F _instNCMIOMMU3; DFPMCx000007DF`

Select transactions based on the die proximity of the source/destination

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SrcDstDieProx` | Reset: 0h. Select transactions based on the die proximity of the source/destination Value Description 0h Disabled. No transactions selected 1h Count only transactions with source/destination on Local die 2h Count only transactions with source/destination on Remote die 3h Count any transaction, regardless of source/destination die proximity |
| 5:2 | `SrcDst` | Reset: 0h. Select transactions based on the source/dest of the data - UMC, CXL™, IO (ATHUB). Multi-bit selects are also possible. Value Description 0h Disabled. No transactions selected 1h Reserved. No transactions selected 2h Count only data beats to/from UMC 3h Reserved. 4h Count only data beats to/from IO (ATHUB) 7h-5h Reserved. 8h Count only data beats to/from CXL Dh-9h Reserved. Eh Count any transaction, regardless of source Fh Reserved. |
| 0 | `TxnType` | Reset: 0. 0= Count Read Response Data Beats . 1= Count Write Data Beats . Select Transaction Type |


## DFPMCx000007[3...F]0 — DF/NCM — Average Latency Transaction Count

**Symbolic:** `DF::PMC::NCM::NCM_SDP_AVG_LAT_TRANS_CNT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000730 _instNCMIOMMU1; DFPMCx00000770 _instNCMIOMMU2; DFPMCx000007B0 _instNCMIOMMU3; DFPMCx000007F0`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]1 — DF/NCM — Average Latency Cycle Count

**Symbolic:** `DF::PMC::NCM::NCM_SDP_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000731 _instNCMIOMMU1; DFPMCx00000771 _instNCMIOMMU2; DFPMCx000007B1 _instNCMIOMMU3; DFPMCx000007F1`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]2 — DF/NCM — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::NCM::NCM_SDP_LAT_HIST_GT50`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000732 _instNCMIOMMU1; DFPMCx00000772 _instNCMIOMMU2; DFPMCx000007B2 _instNCMIOMMU3; DFPMCx000007F2`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]3 — DF/NCM — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::NCM::NCM_SDP_LAT_HIST_GT100`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000733 _instNCMIOMMU1; DFPMCx00000773 _instNCMIOMMU2; DFPMCx000007B3 _instNCMIOMMU3; DFPMCx000007F3`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]4 — DF/NCM — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::NCM::NCM_SDP_LAT_HIST_GT150`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000734 _instNCMIOMMU1; DFPMCx00000774 _instNCMIOMMU2; DFPMCx000007B4 _instNCMIOMMU3; DFPMCx000007F4`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]5 — DF/NCM — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::NCM::NCM_SDP_LAT_HIST_GT200`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000735 _instNCMIOMMU1; DFPMCx00000775 _instNCMIOMMU2; DFPMCx000007B5 _instNCMIOMMU3; DFPMCx000007F5`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]6 — DF/NCM — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::NCM::NCM_SDP_LAT_HIST_GT500`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000736 _instNCMIOMMU1; DFPMCx00000776 _instNCMIOMMU2; DFPMCx000007B6 _instNCMIOMMU3; DFPMCx000007F6`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]7 — DF/NCM — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::NCM::NCM_SDP_LAT_HIST_GT1000`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000737 _instNCMIOMMU1; DFPMCx00000777 _instNCMIOMMU2; DFPMCx000007B7 _instNCMIOMMU3; DFPMCx000007F7`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]8 — DF/NCM — Average Latency Transaction Count

**Symbolic:** `DF::PMC::NCM::NCM_FTI_AVG_LAT_TRANS_CNT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000738 _instNCMIOMMU1; DFPMCx00000778 _instNCMIOMMU2; DFPMCx000007B8 _instNCMIOMMU3; DFPMCx000007F8`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]9 — DF/NCM — Average Latency Cycle Count

**Symbolic:** `DF::PMC::NCM::NCM_FTI_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instNCMIOMMU0; DFPMCx00000739 _instNCMIOMMU1; DFPMCx00000779 _instNCMIOMMU2; DFPMCx000007B9 _instNCMIOMMU3; DFPMCx000007F9`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]A — DF/NCM — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::NCM::NCM_FTI_LAT_HIST_GT50`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000073A _instNCMIOMMU1; DFPMCx0000077A _instNCMIOMMU2; DFPMCx000007BA _instNCMIOMMU3; DFPMCx000007FA`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]B — DF/NCM — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::NCM::NCM_FTI_LAT_HIST_GT100`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000073B _instNCMIOMMU1; DFPMCx0000077B _instNCMIOMMU2; DFPMCx000007BB _instNCMIOMMU3; DFPMCx000007FB`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]C — DF/NCM — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::NCM::NCM_FTI_LAT_HIST_GT150`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000073C _instNCMIOMMU1; DFPMCx0000077C _instNCMIOMMU2; DFPMCx000007BC _instNCMIOMMU3; DFPMCx000007FC`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]D — DF/NCM — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::NCM::NCM_FTI_LAT_HIST_GT200`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000073D _instNCMIOMMU1; DFPMCx0000077D _instNCMIOMMU2; DFPMCx000007BD _instNCMIOMMU3; DFPMCx000007FD`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]E — DF/NCM — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::NCM::NCM_FTI_LAT_HIST_GT500`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000073E _instNCMIOMMU1; DFPMCx0000077E _instNCMIOMMU2; DFPMCx000007BE _instNCMIOMMU3; DFPMCx000007FE`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx000007[3...F]F — DF/NCM — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::NCM::NCM_FTI_LAT_HIST_GT1000`  
**Instance:** `_instNCMIOMMU0; DFPMCx0000073F _instNCMIOMMU1; DFPMCx0000077F _instNCMIOMMU2; DFPMCx000007BF _instNCMIOMMU3; DFPMCx000007FF`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000C[0...C]0 — DF/ICNG — ICNG PRQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::ICNG::ICNG_PRQ_OCCPNCY`  
**Instance:** `_instICNG0; DFPMCx00000C00 _instICNG1; DFPMCx00000C40 _instICNG2; DFPMCx00000C80 _instICNG3; DFPMCx00000CC0`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000C[0...C]1 — DF/ICNG — ICNG PRQ_STAT Statistics

**Symbolic:** `DF::PMC::ICNG::ICNG_PRQ_STAT`  
**Instance:** `_instICNG0; DFPMCx00000C01 _instICNG1; DFPMCx00000C41 _instICNG2; DFPMCx00000C81 _instICNG3; DFPMCx00000CC1`

PRQ Stall due to FTI Prb Buffer.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `FtiPrbBufStall` | Reset: 0. PRQ Stall due to FTI Prb Buffer. |
| 6 | `FtiRspBufStall` | Reset: 0. PRQ Stall due to FTI Rsp Buffer. |


## DFPMCx00000C[0...C]2 — DF/ICNG — ICNG ICI Interrupt Controller Interface

**Symbolic:** `DF::PMC::ICNG::ICNG_ICI`  
**Instance:** `_instICNG0; DFPMCx00000C02 _instICNG1; DFPMCx00000C42 _instICNG2; DFPMCx00000C82 _instICNG3; DFPMCx00000CC2`

Ucode APIC Write.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `ApicUcodeWr` | Reset: 0. Ucode APIC Write. |
| 5 | `ApicUcodeRd` | Reset: 0. Ucode APIC Read. |
| 4 | `FastTprWrByp` | Reset: 0. Fast TPR Write Bypass. |
| 3 | `FastTprWr` | Reset: 0. Fast TPR Write. |
| 2 | `TprWr` | Reset: 0. TPR Write. |
| 1 | `ApicWr` | Reset: 0. APIC Write (other than Ucode). |
| 0 | `ApicRd` | Reset: 0. APIC Read (other than Ucode). |


## DFPMCx00000C[0...C]3 — DF/ICNG — ICNG INT_A Interrupt event A

**Symbolic:** `DF::PMC::ICNG::ICNG_INT_A`  
**Instance:** `_instICNG0; DFPMCx00000C03 _instICNG1; DFPMCx00000C43 _instICNG2; DFPMCx00000C83 _instICNG3; DFPMCx00000CC3`

Selects Interrupts sourced from IO's.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Io` | Reset: 0. Selects Interrupts sourced from IO's. |
| 6 | `Cpu` | Reset: 0. Selects Interrupts sourced from CPU's. |
| 5 | `OtherInt` | Reset: 0. Selects Other Interrupts. |
| 4 | `Smi` | Reset: 0. Selects SMI . |
| 3 | `Nmi` | Reset: 0. Selects NMI. |
| 2 | `AVICInt` | Reset: 0. Selects AVIC Interrupt. |
| 1 | `LPAInt` | Reset: 0. Selects LPA Interrupt. |
| 0 | `FixedInt` | Reset: 0. Selects Fixed Interrupt. |


## DFPMCx00000C[0...C]4 — DF/ICNG — ICNG INT_B Interrupt event B

**Symbolic:** `DF::PMC::ICNG::ICNG_INT_B`  
**Instance:** `_instICNG0; DFPMCx00000C04 _instICNG1; DFPMCx00000C44 _instICNG2; DFPMCx00000C84 _instICNG3; DFPMCx00000CC4`

Optimized (without probe) Local non-arbitration requests (including post arbitration interrupt) being presented to ICI for P2P interrut.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LclP2PICIReq` | Reset: 0. Optimized (without probe) Local non-arbitration requests (including post arbitration interrupt) being presented to ICI for P2P interrut. |
| 6 | `LclMSILPAICIReq` | Reset: 0. Optimized (without probe) Local arbitration requests being presented to ICI for MSI. |
| 5 | `LclMSINonLPAICIReq` | Reset: 0. Optimized (without probe) Local non-arbitration requests (including post arbitration interrupt) being presented to ICI for MSI. |
| 4 | `IntEdgePrb` | Reset: 0. Probe packets sent for Interrupts to CPUs. |
| 3 | `McastPrb` | Reset: 0. Selects multicast probe packets to other ICNG/PIE. |
| 2 | `DirPrb` | Reset: 0. Selects directed probe packets to other ICNG/PIE. |
| 1 | `IntPrb` | Reset: 0. Probe packets sent for Interrupts to other ICNGs/PIEs. |
| 0 | `LPAIntPrb` | Reset: 0. Probe packets sent for LPAs to other ICNGs/PIEs. |


## DFPMCx00000C[0...C]5 — DF/ICNG — ICNG INT_C Interrupt event B

**Symbolic:** `DF::PMC::ICNG::ICNG_INT_C`  
**Instance:** `_instICNG0; DFPMCx00000C05 _instICNG1; DFPMCx00000C45 _instICNG2; DFPMCx00000C85 _instICNG3; DFPMCx00000CC5`

LPAs where a APIC from different PIE/ICNG is selected.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9 | `LpaRemoteApcSel` | Reset: 0. LPAs where a APIC from different PIE/ICNG is selected. |
| 8 | `LpaLclApcSel` | Reset: 0. LPAs where a APIC from same PIE/ICNG is selected. |
| 7 | `LpaFocusCoreSel` | Reset: 0. LPAs where a Focus core is selected. |
| 6 | `LpaPriorFocusCoreSel` | Reset: 0. In Local (Optimized) LPAs flow a Prior Focus core is selected. |
| 5 | `LpaCc6CoreSel` | Reset: 0. In Local (Optimized) LPAs flow a CC6 core is selected. |
| 4 | `BcstArbIntRcvd` | Reset: 0. Broadcast (Un-Optimized) Arbitration Management Probe Received. |
| 3 | `LclArbIntRcvd` | Reset: 0. Local (Optimized) Arbitration Management Probe Received. |
| 2 | `EoiBcst` | Reset: 0. EOI broadcasts sent. |
| 1 | `ClrVectSent` | Reset: 0. Clear vectors sent. |
| 0 | `VectorRd` | Reset: 0. Vector Read seen. |


## DFPMCx00000D00 — DF/PIE — PIE GENERAL General

**Symbolic:** `DF::PMC::PIE::PIE_GENERAL`  
**Instance:** `_instPIE0; DFPMCx00000D00`

Number of FCLK cycles the bucket REFCLK tick counter is at an invalid lead of >=48 REFCLK cycles.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `RefclkTickErr` | Reset: 0. Number of FCLK cycles the bucket REFCLK tick counter is at an invalid lead of >=48 REFCLK cycles. |
| 3 | `RefclkTickStall` | Reset: 0. Number of occurances the single REFCLK tick counter is at the maximum lead of 192 REFCLK cycles. |
| 2 | `RefclkSlow` | Reset: 0. Number of low precision REFCLK-based beats. |
| 1 | `RefclkFast` | Reset: 0. Number of high precision REFCLK-based beats. |
| 0 | `FCLK` | Reset: 0. Number of FCLK cycles. |


## DFPMCx00000D02 — DF/PIE — PIE PRQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::PIE::PIE_PRQ_OCCPNCY`  
**Instance:** `_instPIE0; DFPMCx00000D02`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000D03 — DF/PIE — PIE PRQ_STAT Statistics

**Symbolic:** `DF::PMC::PIE::PIE_PRQ_STAT`  
**Instance:** `_instPIE0; DFPMCx00000D03`

PRQ Stall due to FTI Prb Buffer.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `FtiPrbBufStall` | Reset: 0. PRQ Stall due to FTI Prb Buffer. |
| 6 | `FtiRspBufStall` | Reset: 0. PRQ Stall due to FTI Rsp Buffer. |
| 5 | `FtiReqBufStall` | Reset: 0. PRQ Stall due to FTI Req Buffer. |
| 2 | `SysMgtBcst` | Reset: 0. System Management Broadcasts. |
| 1 | `BusLockBcst` | Reset: 0. Bus Lock Broadcasts. |
| 0 | `BusLockReq` | Reset: 0. Bus Lock Request. |


## DFPMCx00000D04 — DF/PIE — PIE PWRMGT_SM0 Power Management State Machine

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_SM0`  
**Instance:** `_instPIE0; DFPMCx00000D04`

Selects count type.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `SelCountType` | Reset: 0h. Selects count type. Value Description 0h Count all cycles in the selected state. 1h Number of Timeouts. 2h Count cycles in selected state when active. 3h Count high precision REFCLK-based beats in selected state when active. 4h Cycles blocked in selected state when ready to go active. 5h Reserved. 6h Number of entries into selected state. 7h Count low precision REFCLK-based beats in selected state when active. |
| 4:0 | `SelState` | Reset: 00h. Select Power Management State. See PM StateMachine0 States information in http://twiki.amd.com/twiki/pub/DFArch/DFPowerManagement/DF_PIE_PowerManagement.pdf , under State Machine Microarchitecture. |


## DFPMCx00000D05 — DF/PIE — PIE PWRMGT_SM1 Power Management State Machine

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_SM1`  
**Instance:** `_instPIE0; DFPMCx00000D05`

Selects count type.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `SelCountType` | Reset: 0h. Selects count type. Value Description 0h Count all cycles in the selected state. 1h Number of Timeouts. 2h Count cycles in selected state when active. 3h Count high precision REFCLK-based beats in selected state when active. 4h Cycles blocked in selected state when ready to go active. 5h Reserved. 6h Number of entries into selected state. 7h Count low precision REFCLK-based beats in selected state when active. |
| 4:0 | `SelState` | Reset: 00h. Select Power Management State. See PM StateMachine0 States information in http://twiki.amd.com/twiki/pub/DFArch/DFPowerManagement/DF_PIE_PowerManagement.pdf , under State Machine Microarchitecture. |


## DFPMCx00000D06 — DF/PIE — PIE PWRMGT_SM2 Power Management State Machine

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_SM2`  
**Instance:** `_instPIE0; DFPMCx00000D06`

Selects count type.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `SelCountType` | Reset: 0h. Selects count type. Value Description 0h Count all cycles in the selected state. 1h Number of Timeouts. 2h Count cycles in selected state when active. 3h Count high precision REFCLK-based beats in selected state when active. 4h Cycles blocked in selected state when ready to go active. 5h Reserved. 6h Number of entries into selected state. 7h Count low precision REFCLK-based beats in selected state when active. |
| 4:0 | `SelState` | Reset: 00h. Select Power Management State. See PM StateMachine0 States information in http://twiki.amd.com/twiki/pub/DFArch/DFPowerManagement/DF_PIE_PowerManagement.pdf , under State Machine Microarchitecture. |


## DFPMCx00000D07 — DF/PIE — PIE PWRMGT_WAKE_REQ Power Management Wake Request

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_WAKE_REQ`  
**Instance:** `_instPIE0; DFPMCx00000D07`

Wake Request Count Selector.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CountType` | Reset: 0. 0= Counts active Wake Request cycles. 1= Counts Wake Request assertion events. Wake Request Count Selector. |
| 6:0 | `Sel` | Reset: 00h. Selector. Specifies the physical core for Wake Request. Value Description 7Eh-00h Selects Wake Request on physical Core. 7Fh Count Wake Request on any CPU core. |


## DFPMCx00000D08 — DF/PIE — PIE PWRMGT_GMI_MSG Power Management CAKE GMI Messaging

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_GMI_MSG`  
**Instance:** `_instPIE0; DFPMCx00000D08`

Selects GMI State.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `State` | Reset: 0h. Selects GMI State. Value Description 0h Link Up (both local and pper FabricCtl). 1h Physical Disconnect (both local and peer FabricCtl). 2h Logical Disconnect (both local and peer FabricCtl). 3h Local Active Disconnect (Peer Logical Disconnect). 4h Monitor disconnect (both in monitor/active disconnect). 5h Cycles spent in transitional state. 6h CakeActive==1. 7h Upgrade or Reconnect. |
| 4 | `CountType` | Reset: 0. 0= Count low precision REFCLK-based beats in a given state. 1= Entries into a given state. Selects Count Type. |
| 3:0 | `SelInstance` | Reset: 0h. Selects CAKE instance. Value Description 7h-0h CAKE Instance. Dh-8h Reserved. Eh All CAKES. Fh Any CAKES. |


## DFPMCx00000D09 — DF/PIE — PIE PWRMGT_UMC_CSTATE Power Management UMC Cstate

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_UMC_CSTATE`  
**Instance:** `_instPIE0; DFPMCx00000D09`

Selects desired UMC State.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `State` | Reset: 0h. Selects desired UMC State. Value Description 0h C-state/stutter SR entry events. DstateSel 0->2 transition events. 1h C-state/stutter residence. DstateSel=2 non-transition time in low precision REFCLK-based beats. 2h C-state/stutter SR exit time. DstateSel 2->0 transition time in low precision REFCLK-based beats. 3h C-state/stutter SR entry time. DstateSel 0->2 transition time in low precision REFCLK-based beats. 4h Light C-state/stutter SR entry events. DstateSel 0->4 transition events. 5h Light C-state/stutter residence. DstateSel=4 non-transition time in low precision REFCLK-based beats. 6h Light C-state/stutter SR exit time. DstateSel 4->0 transition time in low precision REFCLK-based beats. 7h Light C-state/stutter SR entry time. DstateSel 0->4 transition time in low precision REFCLK-based beats. |
| 4:0 | `Sel` | Reset: 00h. Selects UMCCH. Value Description 0Fh-00h UMCCH Id. 13h-10h All UMCCH Ids that fall within the quarter Id[1:0]. 17h-14h Any UMCCH Ids that fall within the quarter Id[1:0]. 19h-18h All UMCCH Ids that fall within the half Id[0]. 1Bh-1Ah Any UMCCH Ids that fall within the half Id[0]. 1Ch All UMCCHs. 1Dh Exactly 1 UMCCH. 1Eh Exactly 2 UMCCH. 1Fh Any UMCCHs. |


## DFPMCx00000D0A — DF/PIE — PIE PWRMGT_UMC_PSTATE_OFF Power Management UMC Pstate and Cstate PHYOFF

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_UMC_PSTATE_OFF`  
**Instance:** `_instPIE0; DFPMCx00000D0A`

Selects desired UMC State.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `State` | Reset: 0h. Selects desired UMC State. Value Description 0h P-state change SR entry events. DstateSel 0->1 transition events. 1h P-state change residence. DstateSel=1 non-transition time in low precision REFCLK-based beats. 2h P-state change SR exit time. DstateSel 1->0 transition time in low precision REFCLK-based beats. 3h P-state change SR entry time. DstateSel 0->1 transition time in low precision REFCLK-based beats. 4h DstateSel 0->6 transition events (C-state PHYOFF SR entry). 5h DstateSel=6 non-transition time in low precision REFCLK-based beats (C-state PHYOFF residence). 6h DstateSel 6->0 transition time in low precision REFCLK-based beats (C-state PHYOFF SR exit). 7h DstateSel 0->6 transition time in low precision REFCLK-based beats (C-state PHYOFF SR entry). |


## DFPMCx00000D0B — DF/PIE — PIE PWRMGT_CLK Power Management CLK

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_CLK`  
**Instance:** `_instPIE0; DFPMCx00000D0B`

Selects CLK State.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:4 | `State` | Reset: 0h. Selects CLK State. Value Description 0h FcstateSel=0 non-transition FCLK cycles (Operational). 1h FcstateSel=0 non-transition time in low precision REFCLK-based beats (Operational). 3h-2h Reserved. 4h FcstateSel 0->1 transition events ( P-state change SR entry) 5h FcstateSel=1 non-transition time in low precision REFCLK-based beats ( P-state change residence). 6h FcstateSel 1->0 transition time in low precision REFCLK-based beats ( P-state change SR exit). 7h FcstateSel 0->1 transition time in low precision REFCLK-based beats ( P-state change SR entry). 8h FcstateSel 0->2 transition events (C-state/stutter SR entry) 9h FcstateSel=2 non-transition time in low precision REFCLK-based beats (C-state/stutter residence). Ah FcstateSel 2->0 transition time in low precision REFCLK-based beats (C-state/stutter SR exit). Bh FcstateSel 0->2 transition time in low precision REFCLK-based beats (C-state/stutter SR entry). Ch FcstateSel 0->4 transition events (light C-state/stutter SR entry) Dh FcstateSel=4 non-transition time in low precision REFCLK-based beats (light C-state/stutter residence). Eh FcstateSel 4->0 transition time in low precision REFCLK-based beats (light C-state/stutter SR exit). Fh FcstateSel 0->4 transition time in low precision REFCLK-based beats (light C-state/stutter SR entry). |
| 2:0 | `Sel` | Reset: 0h. Selects CLK. Value Description 5h-0h UCLK id. 6h UCLKs, counts all instances in residence or any instance in transition 7h FCLK. |


## DFPMCx00000D0C — DF/PIE — PIE PWRMGT_CCM_GMI Power Management CCM GMI

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_CCM_GMI`  
**Instance:** `_instPIE0; DFPMCx00000D0C`

Selects CCM GMI State.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:6 | `State` | Reset: 0h. Selects CCM GMI State. Value Description 0h PCS requests operational clock. 1h GMI low power residence hit. 2h Powered Up. 3h Powered Down. 4h Power Up Transition. 5h Power Down Transition. 6h SDP port control Transition. 7h Outgoing WAKE. |
| 5 | `CountType` | Reset: 0. 0= Count low precision REFCLK-based beats in a given state. 1= Entries into a given state. Selects Count Type. |
| 4:0 | `SelInstance` | Reset: 00h. Selects CCM instance. Value Description 0Bh-00h CCM Instance. 1Dh-0Ch Reserved. 1Eh All CCMs. 1Fh Any CCMs. |


## DFPMCx00000D0D — DF/PIE — PIE PRQ_DVM

**Symbolic:** `DF::PMC::PIE::PIE_PRQ_DVM`  
**Instance:** `_instPIE0; DFPMCx00000D0D`

DvmComp completion broadcasts sent.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `Comp` | Reset: 0. DvmComp completion broadcasts sent. |
| 2 | `Sync` | Reset: 0. Dvm Syncs received. |
| 1 | `Op` | Reset: 0. Dvm Operations received. |


## DFPMCx00000D0E — DF/PIE — PIE PWRMGT_STATS Power Management Statistics

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_STATS`  
**Instance:** `_instPIE0; DFPMCx00000D0E`

Selects Count Type.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 | `CountType` | Reset: 0h. Selects Count Type. Value Description 0h Entries into a given state. 1h Active Cycles in a given state. 2h High precision REFCLK-based beats. 3h Low precision REFCLK-based beats. |
| 5:0 | `Sel` | Reset: 00h. Selects Stat encoding. Value Description 00h C-state or stutter. C-state commit to exit condition. 01h C-state or stutter. C-state readiness. 02h C-state or stutter. C-state exit duration. 08h-03h Reserved. 09h C-state or stutter. SOC in OBFF or IDLE states. 0Ah C-state or stutter. SOC in IDLE state. 0Ch-0Bh Reserved. 0Dh Deep C-state residence is allowed by monitor/hysteresis. 0Eh Deep C-state is allowed but prevented by APIC heads up. 0Fh C-state readiness is achieved but prevented by APIC heads up. 10h Reserved. 11h P-state . USB P-state watermark wait duration. 12h Reserved. 13h P-state . P-state local DRAM blackout. 14h MEMPHY CLDO context 0 to 1 transition duration. 15h MEMPHY CLDO context 1 to 0 transition duration. 16h MEMPHY CLDO context 1 residence. 17h Reserved. 18h Power off status. CLK powered down in C-state (shortcut for FcState=2 in CLK perfmon). 19h Power off status. UMC in C-state self refresh (shortcut for all DstateSel=2 in UMC perfmon). 1Ah Power off status. CAKE GMI in C-state LS1/Quiet (shortcut for all GMIs power down in GMI perfmon). 1Bh Power off status. PC6 duration. 1Ch Power off status. Per-CPU PC6 duration. 1Dh OS ACPI C-state selection meets minimum PC6 requirement 1Eh Hysteresis blocking power up to transition from active to monitor disconnect. 1Fh Reserved. 20h Power Gating. Stutter domain power gated. 21h Power Gating. C-state domain power gated. 22h Clock Gating. Stutter region coarse gated. 24h-23h Reserved. 25h Clock Gating. C-state region coarse gated. 26h Clock gating. SPF region coarse gated. 27h Reserved. 28h Per-die C-state or stutter. C-state commit to exit condition. 29h Light C-state or stutter. C-state commit to exit condition. 2Ah PC6 entry during non-C-state self refresh. 2Bh PC6 exit during non-C-state self refresh. 2Ch Cache CLDO context 0 to 1 transition duration. 2Dh Cache CLDO context 1 to 0 transition duration. 2Fh-2Eh Reserved. 30h Firmware Stats. C-state disabled by firmware or BIOS. 31h Firmware Stats. C-state entry disabled by firmware. 32h Firmware Stats. C-state exit disabled by firmware. 33h Firmware Stats. CC6 exit blocked by ASP . 34h Firmware Stats. CC6 exit blocked by MP1 . 35h Firmware Stats. VDCI frequency being adjusted by CCX . 36h Firmware Stats. C-state limit enforced to light C-state (DFC1). 37h Firmware Stats. C-state limit enforced to normal C-state (DFC2). 38h Firmware Stats. S0i3 exits. 39h Firmware Stats. Z9/Z10 entry attempts (ZSC first stage fence request asserted during entry). 3Ah Firmware Stats. Z9/Z10 exits. 3Bh Firmware Stats. Z9/Z10 exited but waiting for client active. 3Ch Elapsed time from ZSC read is greater than snapshot APIC Timer 3Fh-3Dh Reserved. |


## DFPMCx00000D0F — DF/PIE — PIE PWRMGT_IDLE Power Management Idle

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_IDLE`  
**Instance:** `_instPIE0; DFPMCx00000D0F`

Selects Count Type.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `CountType` | Reset: 0h. Selects Count Type. Value Description 0h Entries into a given state. 1h Active Cycles in a given state. 2h High precision REFCLK-based beats. 3h Low precision REFCLK-based beats. |
| 8 | `CNLI` | Reset: 0. AcmOrigClkReq and CmpCompClkReq : CNLI SDPs disconnected. |
| 6 | `CPU` | Reset: 0. CpuOrigClkReq : CPU SDP disconnected. |
| 5 | `CAKE_GMI` | Reset: 0. GmiPhysDiscon or GmiMonDiscon : CAKEs in physical disconnect (shortcut for GMI perfmon). |
| 3 | `NBIO` | Reset: 0. IohubmOrigClkReq and IommuOrigClkReq : NBIO master SDPs disconnected. |
| 0 | `AllCoresInCc6Raw` | Reset: 0. All cores in CC6. |


## DFPMCx00000D10 — DF/PIE — PIE PWRMGT_CC6 Power Management CC6 Core Count Residence

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_CC6`  
**Instance:** `_instPIE0; DFPMCx00000D10`

Residence in which the total number of CC6 cores exceeds this programmed value, counted in low precision REFCLK-based beats. This performance monitor may be used to build residence buckets.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Cc6Cores` | Reset: 00h. Residence in which the total number of CC6 cores exceeds this programmed value, counted in low precision REFCLK-based beats. This performance monitor may be used to build residence buckets. |


## DFPMCx00000D11 — DF/PIE — PIE SRSB_STAT Save Restore Score Board (SRSB) Statistics

**Symbolic:** `DF::PMC::PIE::PIE_SRSB_STAT`  
**Instance:** `_instPIE0; DFPMCx00000D11`

ApicCachelineSave

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `ApicCachelineSave` | Reset: 0. ApicCachelineSave |
| 3 | `SaveAfterReset` | Reset: 0. SaveAfterReset |
| 2 | `Restore` | Reset: 0. Restore |
| 1 | `CachelineSave` | Reset: 0. CachelineSave |
| 0 | `Reset` | Reset: 0. Reset |


## DFPMCx00000D12 — DF/PIE — PIE PWRMGT_GMI_LINK Power Management CAKE GMI Link

**Symbolic:** `DF::PMC::PIE::PIE_PWRMGT_GMI_LINK`  
**Instance:** `_instPIE0; DFPMCx00000D12`

Selects GMI State.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `State` | Reset: 0h. Selects GMI State. Value Description 0h PCS requests operational clock. 1h GMI low power residence hit. 2h Powered Up. 3h Powered Down. 4h Power Up Transition. 5h Power Down Transition. 6h Incoming or outgoing MA-WAKE. 7h Incoming or outgoing INT-WAKE. |
| 4 | `CountType` | Reset: 0. 0= Count low precision REFCLK-based beats in a given state. 1= Entries into a given state. Selects Count Type. |
| 3:0 | `SelInstance` | Reset: 0h. Selects CAKE instance. Value Description 7h-0h CAKE Instance. Dh-8h Reserved. Eh All CAKES. Fh Any CAKES. |


## DFPMCx00000D17 — DF/PIE — PIE REG_ACC

**Symbolic:** `DF::PMC::PIE::PIE_REG_ACC`  
**Instance:** `_instPIE0; DFPMCx00000D17`

Selects register access trust level.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:4 | `TrustLevel` | Reset: 00h. Selects register access trust level. Value Description 00h All trust level. 01h Trust Level 0 02h Reserved. 03h Trust Level 1 04h Reserved. 05h Trust Level 2 06h Reserved. 07h Trust Level 3 08h Reserved. 09h Trust Level 4 0Ah Reserved. 0Bh Trust Level 5 0Ch Reserved. 0Dh Trust Level 6 0Eh Reserved. 0Fh Trust Level 7 1Fh-10h Reserved. |
| 3:2 | `AccessSrc` | Reset: 0h. Selects register access source. Value Description 0h Disabled. 1h SMN 2h FTI 3h SMN+FTI |
| 1:0 | `AccessType` | Reset: 0h. Selects read or writes. Value Description 0h Disabled. 1h Reads 2h Writes 3h Reads+Writes |


## DFPMCx00000D18 — DF/PIE — PIE PCC_RES

**Symbolic:** `DF::PMC::PIE::PIE_PCC_RES`  
**Instance:** `_instPIE0; DFPMCx00000D18`

Selects PCC Valid event type

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `CntType` | Reset: 0. 0= Count number of FCLK when PCC Valid is asserted. 1= Count number of active transitions. Selects PCC Valid event type |
| 10:9 | `PCCInSelect` | Reset: 0h. Selects PCC input for PCCValType. Value Description 0h Disabled. 1h SOC Pcc Valid 2h Internal Pcc Valid 3h Both SOC Pcc and Internal Pcc Valid. |
| 8 | `PCCStepTrans` | Reset: 0. PCC Step transition count |
| 7:0 | `PccStepResMask` | Reset: 00h. PCC throttle residency event mask. Setting any bit in this mask enables residency count for corresponding PCC step. |


## DFPMCx00000[00...3C]0 — DF/CS — CS CSQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CS::CS_CSQ_OCC`  
**Instance:** `_instCMP0; DFPMCx00000300 _instCMP1; DFPMCx00000340 _instCMP2; DFPMCx00000380 _instCMP3; DFPMCx000003C0 _instCS0; DFPMCx00000000 _instCS10; DFPMCx00000280 _instCS11; DFPMCx000002C0 _instCS1; DFPMCx00000040 _instCS2; DFPMCx00000080 _instCS3; DFPMCx000000C0 _instCS4; DFPMCx00000100 _instCS5; DFPMCx00000140 _instCS6; DFPMCx00000180 _instCS7; DFPMCx000001C0 _instCS8; DFPMCx00000200 _instCS9; DFPMCx00000240`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[00...3C]1 — DF/CS — CS CSQ_WAIT CSQ Wait Conditions

**Symbolic:** `DF::PMC::CS::CS_CSQ_WAIT`  
**Instance:** `_instCMP0; DFPMCx00000301 _instCMP1; DFPMCx00000341 _instCMP2; DFPMCx00000381 _instCMP3; DFPMCx000003C1 _instCS0; DFPMCx00000001 _instCS10; DFPMCx00000281 _instCS11; DFPMCx000002C1 _instCS1; DFPMCx00000041 _instCS2; DFPMCx00000081 _instCS3; DFPMCx000000C1 _instCS4; DFPMCx00000101 _instCS5; DFPMCx00000141 _instCS6; DFPMCx00000181 _instCS7; DFPMCx000001C1 _instCS8; DFPMCx00000201 _instCS9; DFPMCx00000241`

Request channel selector. 0:REQ channel, 1:REQND channel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 7 | `AtmOpRet` | Reset: 0. Atomic Op that has to wait for prior Op due to address match. |
| 6 | `AnyOpRet` | Reset: 0. Any Op that has to wait for prior Op due to address match. |
| 5 | `FtMtch` | Reset: 0. Wait for prior Op due to Tag (F_T) Match. |
| 4 | `LrgMtch` | Reset: 0. Wait due to Large Read match. |
| 3 | `DatRcvd` | Reset: 0. Wait for data from FTI. |
| 2 | `DatBuf` | Reset: 0. DatBuf |
| 1 | `UmcStream` | Reset: 0. Wait for stream to switch. |
| 0 | `DngrdDn` | Reset: 0. Wait for downgrade to complete. |


## DFPMCx00000[00...3C]2 — DF/CS — CS REQA Request Type

**Symbolic:** `DF::PMC::CS::CS_REQA`  
**Instance:** `_instCMP0; DFPMCx00000302 _instCMP1; DFPMCx00000342 _instCMP2; DFPMCx00000382 _instCMP3; DFPMCx000003C2 _instCS0; DFPMCx00000002 _instCS10; DFPMCx00000282 _instCS11; DFPMCx000002C2 _instCS1; DFPMCx00000042 _instCS2; DFPMCx00000082 _instCS3; DFPMCx000000C2 _instCS4; DFPMCx00000102 _instCS5; DFPMCx00000142 _instCS6; DFPMCx00000182 _instCS7; DFPMCx000001C2 _instCS8; DFPMCx00000202 _instCS9; DFPMCx00000242`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 10 | `ChgToXNR` | Reset: 0. ChgToXNR |
| 9 | `ChgToX` | Reset: 0. ChgToX |
| 8 | `VicBlkClnD` | Reset: 0. VicBlkClnD |
| 7 | `VicBlkCln` | Reset: 0. VicBlkCln |
| 6 | `VicBlkFullZero` | Reset: 0. VicBlkFullZero |
| 5 | `VicBlkFull` | Reset: 0. VicBlkFull |
| 4 | `RdBlkNotO` | Reset: 0. RdBlkNotO |
| 3 | `RdBlkC` | Reset: 0. RdBlkC |
| 2 | `RdBlkX` | Reset: 0. RdBlkX |
| 1 | `RdBlkS` | Reset: 0. RdBlkS |
| 0 | `RdBlkL` | Reset: 0. RdBlkL |


## DFPMCx00000[00...3C]3 — DF/CS — CS REQB Request Type

**Symbolic:** `DF::PMC::CS::CS_REQB`  
**Instance:** `_instCMP0; DFPMCx00000303 _instCMP1; DFPMCx00000343 _instCMP2; DFPMCx00000383 _instCMP3; DFPMCx000003C3 _instCS0; DFPMCx00000003 _instCS10; DFPMCx00000283 _instCS11; DFPMCx000002C3 _instCS1; DFPMCx00000043 _instCS2; DFPMCx00000083 _instCS3; DFPMCx000000C3 _instCS4; DFPMCx00000103 _instCS5; DFPMCx00000143 _instCS6; DFPMCx00000183 _instCS7; DFPMCx000001C3 _instCS8; DFPMCx00000203 _instCS9; DFPMCx00000243`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 8 | `WrNoData` | Reset: 0. WrNoData by itself |
| 7 | `Posted` | Reset: 0. All Posted WrSized |
| 6 | `WrSizedFullZero` | Reset: 0. WrSizedFullZero |
| 5 | `WrSizedFull` | Reset: 0. All WrSizedFull (includes WrNoData) |
| 4 | `WrSized` | Reset: 0. All WrSized (includes WrNoData) |
| 3 | `RdSizedFull` | Reset: 0. RdSizedFull |
| 2 | `RdSizedNoWriter` | Reset: 0. RdSizedNoWriter |
| 1 | `RdSizedDW` | Reset: 0. RdSizedDW |
| 0 | `RdSized` | Reset: 0. RdSized |


## DFPMCx00000[00...3C]4 — DF/CS — CS REQC Request Type

**Symbolic:** `DF::PMC::CS::CS_REQC`  
**Instance:** `_instCMP0; DFPMCx00000304 _instCMP1; DFPMCx00000344 _instCMP2; DFPMCx00000384 _instCMP3; DFPMCx000003C4 _instCS0; DFPMCx00000004 _instCS10; DFPMCx00000284 _instCS11; DFPMCx000002C4 _instCS1; DFPMCx00000044 _instCS2; DFPMCx00000084 _instCS3; DFPMCx000000C4 _instCS4; DFPMCx00000104 _instCS5; DFPMCx00000144 _instCS6; DFPMCx00000184 _instCS7; DFPMCx000001C4 _instCS8; DFPMCx00000204 _instCS9; DFPMCx00000244`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 9 | `Atomic` | Reset: 0. Atomic |
| 8 | `AtomicNC` | Reset: 0. AtomicNC |
| 7 | `AtomicNR` | Reset: 0. AtomicNR |
| 6 | `AtomicNRNC` | Reset: 0. AtomicNRNC |
| 5 | `InjectError` | Reset: 0. InjectError |
| 3 | `ClnBlkAll` | Reset: 0. ClnBlkAll |
| 2 | `WbInvBlkAll` | Reset: 0. WbInvBlkAll |
| 1 | `ValBlk` | Reset: 0. ValBlk |
| 0 | `QosCtl` | Reset: 0. QosCtl |


## DFPMCx00000[00...3C]5 — DF/CS — CS UMC_RSP Miscellaneous

**Symbolic:** `DF::PMC::CS::CS_UMC_RSP`  
**Instance:** `_instCMP0; DFPMCx00000305 _instCMP1; DFPMCx00000345 _instCMP2; DFPMCx00000385 _instCMP3; DFPMCx000003C5 _instCS0; DFPMCx00000005 _instCS10; DFPMCx00000285 _instCS11; DFPMCx000002C5 _instCS1; DFPMCx00000045 _instCS2; DFPMCx00000085 _instCS3; DFPMCx000000C5 _instCS4; DFPMCx00000105 _instCS5; DFPMCx00000145 _instCS6; DFPMCx00000185 _instCS7; DFPMCx000001C5 _instCS8; DFPMCx00000205 _instCS9; DFPMCx00000245`

Any SDP Read Response

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `ReadRspSdpAny` | Reset: 0. Any SDP Read Response |
| 4 | `ReadRspNotCan` | Reset: 0. Failed SPD Cancel Request |
| 3 | `ReadRspSkpCsd` | Reset: 0. SDP Read Response skips CSD update |
| 2 | `ReadRspError` | Reset: 0. SDP Read Response indicates Data Error |
| 1 | `ReadRspRetry` | Reset: 0. SDP Read Response indicates Retransmit |
| 0 | `ReadRspNoDat` | Reset: 0. SDP Read Response indicates cancelled SDP Read Request |


## DFPMCx00000[00...3C]6 — DF/CS — CS RSP Responses

**Symbolic:** `DF::PMC::CS::CS_RSP`  
**Instance:** `_instCMP0; DFPMCx00000306 _instCMP1; DFPMCx00000346 _instCMP2; DFPMCx00000386 _instCMP3; DFPMCx000003C6 _instCS0; DFPMCx00000006 _instCS10; DFPMCx00000286 _instCS11; DFPMCx000002C6 _instCS1; DFPMCx00000046 _instCS2; DFPMCx00000086 _instCS3; DFPMCx000000C6 _instCS4; DFPMCx00000106 _instCS5; DFPMCx00000146 _instCS6; DFPMCx00000186 _instCS7; DFPMCx000001C6 _instCS8; DFPMCx00000206 _instCS9; DFPMCx00000246`

Response channel selector. 0:RSP channel, 1:RSPND channel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Response channel selector. 0:RSP channel, 1:RSPND channel. |
| 8 | `SrcDnD` | Reset: 0. Source Done with Data. |
| 7 | `SrcDn` | Reset: 0. Source Done. |
| 3 | `PrbRspSingle` | Reset: 0. Single PrbRsp with MultiRsp==0. |
| 2 | `PrbRspMulti` | Reset: 0. PrbRsp with MultiRsp != 0. |
| 1 | `PrbRspD` | Reset: 0. PrbRsp with data. |
| 0 | `MemFetch` | Reset: 0. MemFetch |


## DFPMCx00000[00...3C]7 — DF/CS — CS UMC_REQ UMC Requests

**Symbolic:** `DF::PMC::CS::CS_UMC_REQ`  
**Instance:** `_instCMP0; DFPMCx00000307 _instCMP1; DFPMCx00000347 _instCMP2; DFPMCx00000387 _instCMP3; DFPMCx000003C7 _instCS0; DFPMCx00000007 _instCS10; DFPMCx00000287 _instCS11; DFPMCx000002C7 _instCS1; DFPMCx00000047 _instCS2; DFPMCx00000087 _instCS3; DFPMCx000000C7 _instCS4; DFPMCx00000107 _instCS5; DFPMCx00000147 _instCS6; DFPMCx00000187 _instCS7; DFPMCx000001C7 _instCS8; DFPMCx00000207 _instCS9; DFPMCx00000247`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:7 | `WrSzSel` | Reset: 0h. Options for WrSizedNc selection. Value Description 0h All writes 1h Writes with full byte enables 2h Writes with partial byte enables (for given length) 3h Writes forced to full, regardless of request byte enables 4h Writes triggered by downgrades 5h Read-modify-write operations triggered by an Atomic op 6h Read-modify-write operations triggered by a partial write 7h All Read-modify-write operations |
| 6 | `WrSizedNc` | Reset: 0. WrSized - see WrSzSel field for options |
| 5 | `Cancel` | Reset: 0. Cancel |
| 4 | `SyncFlood` | Reset: 0. SyncFlood |
| 3 | `QoSCtlVc` | Reset: 0. QoS Control for VC. |
| 2 | `QoSCtlFt` | Reset: 0. QoS Control for FT |
| 1 | `RdSizedNC` | Reset: 0. RdSizedNC |
| 0 | `RdBlkS` | Reset: 0. RdBlkS |


## DFPMCx00000[00...3C]8 — DF/CS — CS SPECDRAMRD SpecDramRd

**Symbolic:** `DF::PMC::CS::CS_SPECDRAMRD`  
**Instance:** `_instCMP0; DFPMCx00000308 _instCMP1; DFPMCx00000348 _instCMP2; DFPMCx00000388 _instCMP3; DFPMCx000003C8 _instCS0; DFPMCx00000008 _instCS10; DFPMCx00000288 _instCS11; DFPMCx000002C8 _instCS1; DFPMCx00000048 _instCS2; DFPMCx00000088 _instCS3; DFPMCx000000C8 _instCS4; DFPMCx00000108 _instCS5; DFPMCx00000148 _instCS6; DFPMCx00000188 _instCS7; DFPMCx000001C8 _instCS8; DFPMCx00000208 _instCS9; DFPMCx00000248`

Request channel selector. 0:REQ channel, 1:REQND channel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 5 | `CanAddrMtch` | Reset: 0. SpecDramRd cancelled due to address match. |
| 4 | `CanOccLmt` | Reset: 0. SpecDramRd cancelled due to CSQ occupancy. |
| 3 | `CanCntLmt` | Reset: 0. SpecDramRd cancelled due to number of SpecDramRd's in CSQ. |
| 2 | `CanMonLmt` | Reset: 0. SpecDramRd cancelled due to SpecDramRd monitor. |
| 1 | `SpecHit` | Reset: 0. Incoming command hit on SpecDramRd. |
| 0 | `Rcvd` | Reset: 0. SpecDramRd command received. |


## DFPMCx00000[00...3C]9 — DF/CS — CS PICKER Request Picker

**Symbolic:** `DF::PMC::CS::CS_PICKER`  
**Instance:** `_instCMP0; DFPMCx00000309 _instCMP1; DFPMCx00000349 _instCMP2; DFPMCx00000389 _instCMP3; DFPMCx000003C9 _instCS0; DFPMCx00000009 _instCS10; DFPMCx00000289 _instCS11; DFPMCx000002C9 _instCS1; DFPMCx00000049 _instCS2; DFPMCx00000089 _instCS3; DFPMCx000000C9 _instCS4; DFPMCx00000109 _instCS5; DFPMCx00000149 _instCS6; DFPMCx00000189 _instCS7; DFPMCx000001C9 _instCS8; DFPMCx00000209 _instCS9; DFPMCx00000249`

Pipeline selector.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `PipeSel` | Reset: 0h. Pipeline selector. Value Description 0h REQ pipe. 1h RSP pipe. 2h PRB pipe. 3h Reserved. |
| 8 | `HiWon` | Reset: 0. High priority request was picked over an Urgent priority request. |
| 7 | `MedWon` | Reset: 0. Medium priority request was picked over a High priority request. |
| 6 | `LowWon` | Reset: 0. Low priority request was picked over a higher (Medium or High) priority request. |
| 5 | `UrgLost` | Reset: 0. Urgent priority request was skipped in favor of a lower (Low/Medium/High) priority request. |
| 4 | `HiLost` | Reset: 0. High priority request was skipped in favor of a lower (Low or Medium) priority request. |
| 3 | `MedLost` | Reset: 0. Medium priority request was skipped in favor of a Low priority request. |
| 2 | `BypSat` | Reset: 0. Picker was favored over bypass, because of saturation. |
| 1 | `Bypass` | Reset: 0. Transaction availed a bypass. |
| 0 | `Pick` | Reset: 0. Transaction picked. |


## DFPMCx00000[00...3C]A — DF/CS — CS ENCRYPTION Encryption

**Symbolic:** `DF::PMC::CS::CS_ENCRYPTION`  
**Instance:** `_instCMP0; DFPMCx0000030A _instCMP1; DFPMCx0000034A _instCMP2; DFPMCx0000038A _instCMP3; DFPMCx000003CA _instCS0; DFPMCx0000000A _instCS10; DFPMCx0000028A _instCS11; DFPMCx000002CA _instCS1; DFPMCx0000004A _instCS2; DFPMCx0000008A _instCS3; DFPMCx000000CA _instCS4; DFPMCx0000010A _instCS5; DFPMCx0000014A _instCS6; DFPMCx0000018A _instCS7; DFPMCx000001CA _instCS8; DFPMCx0000020A _instCS9; DFPMCx0000024A`

Encrypted TMZ writes enabled

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `SdpReqTMZ` | Reset: 0. Encrypted TMZ writes enabled |
| 5 | `SdpReqEncrypted` | Reset: 0. Reserved |
| 4 | `SdpReqVal` | Reset: 0. SDP transaction |
| 3 | `FtiReqNdEncrypted` | Reset: 0. Reserved |
| 2 | `FtiReqEncrypted` | Reset: 0. Reserved |
| 1 | `FtiReqNdVal` | Reset: 0. FtiReqNd transaction |
| 0 | `FtiReqVal` | Reset: 0. FtiReq transaction |


## DFPMCx00000[00...3C]B — DF/CS — CS PFQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CS::CS_PFQ_OCC`  
**Instance:** `_instCMP0; DFPMCx0000030B _instCMP1; DFPMCx0000034B _instCMP2; DFPMCx0000038B _instCMP3; DFPMCx000003CB _instCS0; DFPMCx0000000B _instCS10; DFPMCx0000028B _instCS11; DFPMCx000002CB _instCS1; DFPMCx0000004B _instCS2; DFPMCx0000008B _instCS3; DFPMCx000000CB _instCS4; DFPMCx0000010B _instCS5; DFPMCx0000014B _instCS6; DFPMCx0000018B _instCS7; DFPMCx000001CB _instCS8; DFPMCx0000020B _instCS9; DFPMCx0000024B`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[00...3C]C — DF/CS — CS PRB Probes

**Symbolic:** `DF::PMC::CS::CS_PRB`  
**Instance:** `_instCMP0; DFPMCx0000030C _instCMP1; DFPMCx0000034C _instCMP2; DFPMCx0000038C _instCMP3; DFPMCx000003CC _instCS0; DFPMCx0000000C _instCS10; DFPMCx0000028C _instCS11; DFPMCx000002CC _instCS1; DFPMCx0000004C _instCS2; DFPMCx0000008C _instCS3; DFPMCx000000CC _instCS4; DFPMCx0000010C _instCS5; DFPMCx0000014C _instCS6; DFPMCx0000018C _instCS7; DFPMCx000001CC _instCS8; DFPMCx0000020C _instCS9; DFPMCx0000024C`

Reserved.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9 | `AcmSent` | Reset: 0. ACM probe sent. |
| 7 | `GpuSent` | Reset: 0. Reserved. |
| 5 | `CpuDirSent` | Reset: 0. CPU directed probe sent. |
| 4 | `CpuMcastSent` | Reset: 0. CPU multicast probe sent. |
| 2 | `CpuRspToTgt` | Reset: 0. CPU RspToTgt probe sent. |
| 1 | `CpuRspToSrc` | Reset: 0. CPU RspToSrc probe sent. |
| 0 | `SpfDngrd` | Reset: 0. CPU downgrade probe sent. |


## DFPMCx00000[00...3C]D — DF/CS — CS PRB_ACT0 Probe Actions

**Symbolic:** `DF::PMC::CS::CS_PRB_ACT0`  
**Instance:** `_instCMP0; DFPMCx0000030D _instCMP1; DFPMCx0000034D _instCMP2; DFPMCx0000038D _instCMP3; DFPMCx000003CD _instCS0; DFPMCx0000000D _instCS10; DFPMCx0000028D _instCS11; DFPMCx000002CD _instCS1; DFPMCx0000004D _instCS2; DFPMCx0000008D _instCS3; DFPMCx000000CD _instCS4; DFPMCx0000010D _instCS5; DFPMCx0000014D _instCS6; DFPMCx0000018D _instCS7; DFPMCx000001CD _instCS8; DFPMCx0000020D _instCS9; DFPMCx0000024D`

CPU TgtReqGO probe sent.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `TgtReqGO` | Reset: 0. CPU TgtReqGO probe sent. |
| 8 | `SuperDmt` | Reset: 0. Super Demote Probe |
| 7 | `Nop` | Reset: 0. Nop |
| 6 | `Shr` | Reset: 0. Shared |
| 5 | `Fetch` | Reset: 0. Fetch |
| 4 | `Clean` | Reset: 0. Clean |
| 3 | `Mig` | Reset: 0. Migrate |
| 2 | `IcInv` | Reset: 0. IcInv |
| 1 | `Inv` | Reset: 0. Inv |
| 0 | `SuperInv` | Reset: 0. Super Invalidate Probe |


## DFPMCx00000[00...3C]E — DF/CS — CS PRB_ACT1 Probe Actions Type 1

**Symbolic:** `DF::PMC::CS::CS_PRB_ACT1`  
**Instance:** `_instCMP0; DFPMCx0000030E _instCMP1; DFPMCx0000034E _instCMP2; DFPMCx0000038E _instCMP3; DFPMCx000003CE _instCS0; DFPMCx0000000E _instCS10; DFPMCx0000028E _instCS11; DFPMCx000002CE _instCS1; DFPMCx0000004E _instCS2; DFPMCx0000008E _instCS3; DFPMCx000000CE _instCS4; DFPMCx0000010E _instCS5; DFPMCx0000014E _instCS6; DFPMCx0000018E _instCS7; DFPMCx000001CE _instCS8; DFPMCx0000020E _instCS9; DFPMCx0000024E`

CPU RspToTgt probe sent.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CpuRspToTgt` | Reset: 0. CPU RspToTgt probe sent. |
| 6 | `CpuRspToSrc` | Reset: 0. CPU RspToSrc probe sent.(Not counting TgtReqGO). |
| 5 | `CpuMcastSent` | Reset: 0. CPU multicast probe sent. |
| 4 | `CpuDirSent` | Reset: 0. CPU directed probe sent. |
| 3:0 | `ActionType` | Reset: 0h. Prb Action that is to be matched against.4'b1100 disables comparison |


## DFPMCx00000[00...3C]F — DF/CS — CS BYP Bypass and Retry

**Symbolic:** `DF::PMC::CS::CS_BYP`  
**Instance:** `_instCMP0; DFPMCx0000030F _instCMP1; DFPMCx0000034F _instCMP2; DFPMCx0000038F _instCMP3; DFPMCx000003CF _instCS0; DFPMCx0000000F _instCS10; DFPMCx0000028F _instCS11; DFPMCx000002CF _instCS1; DFPMCx0000004F _instCS2; DFPMCx0000008F _instCS3; DFPMCx000000CF _instCS4; DFPMCx0000010F _instCS5; DFPMCx0000014F _instCS6; DFPMCx0000018F _instCS7; DFPMCx000001CF _instCS8; DFPMCx0000020F _instCS9; DFPMCx0000024F`

Retry spotted on RdDatSch path.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `RetryRDS` | Reset: 0. Retry spotted on RdDatSch path. |
| 3 | `RetryByp` | Reset: 0. Retry spotted on Bypass path. |
| 2 | `PfqRspByp` | Reset: 0. PFQ Response Bypass |
| 1 | `PfqReqByp` | Reset: 0. PFQ Request Bypass |
| 0 | `SpecPrbByp` | Reset: 0. Reserved. |


## DFPMCx00000[01...3D]0 — DF/CS — CS PIPE Pipekills and Allocation

**Symbolic:** `DF::PMC::CS::CS_PIPE`  
**Instance:** `_instCMP0; DFPMCx00000310 _instCMP1; DFPMCx00000350 _instCMP2; DFPMCx00000390 _instCMP3; DFPMCx000003D0 _instCS0; DFPMCx00000010 _instCS10; DFPMCx00000290 _instCS11; DFPMCx000002D0 _instCS1; DFPMCx00000050 _instCS2; DFPMCx00000090 _instCS3; DFPMCx000000D0 _instCS4; DFPMCx00000110 _instCS5; DFPMCx00000150 _instCS6; DFPMCx00000190 _instCS7; DFPMCx000001D0 _instCS8; DFPMCx00000210 _instCS9; DFPMCx00000250`

Pipeline selector.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `PipeSel` | Reset: 0h. Pipeline selector. Value Description 0h REQ pipe. 1h RSP pipe. 2h PRB pipe. 3h Reserved. |
| 7 | `KillWDS` | Reset: 0. Pipe kill due to WDS unavailable. |
| 6 | `KillWCB` | Reset: 0. Pipe kill due to WCB unavailable. |
| 5 | `KillSdpDat` | Reset: 0. Pipe kill due to SDP data credit unavailable. |
| 4 | `KillSdpReq` | Reset: 0. Pipe kill due to SDP request credit unavailable. |
| 3 | `KillRDS` | Reset: 0. Pipe kill due to RDS unavailable. |
| 2 | `KillAtomic` | Reset: 0. Pipe kill due to CS atomic resource unavailable. |
| 1 | `KillFtiDat` | Reset: 0. Pipe kill due to FTI data token unavailable. |
| 0 | `KillFtiCmd` | Reset: 0. Pipe kill due to FTI command token unavailable. |


## DFPMCx00000[01...3D]1 — DF/CS — CS BWMON Bandwidth Monitors

**Symbolic:** `DF::PMC::CS::CS_BWMON`  
**Instance:** `_instCMP0; DFPMCx00000311 _instCMP1; DFPMCx00000351 _instCMP2; DFPMCx00000391 _instCMP3; DFPMCx000003D1 _instCS0; DFPMCx00000011 _instCS10; DFPMCx00000291 _instCS11; DFPMCx000002D1 _instCS1; DFPMCx00000051 _instCS2; DFPMCx00000091 _instCS3; DFPMCx000000D1 _instCS4; DFPMCx00000111 _instCS5; DFPMCx00000151 _instCS6; DFPMCx00000191 _instCS7; DFPMCx000001D1 _instCS8; DFPMCx00000211 _instCS9; DFPMCx00000251`

Select Bandwidth Monitor.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SelBWMon` | Reset: 0h. Select Bandwidth Monitor. Value Description 0h Count events for BWMon 0. 1h Count events for BWMon 1. 2h Count events for BWMon 2. 3h Reserved. |
| 6 | `ConvertPoolToHT` | Reset: 0. Count tokens converted from Pool to Hard Tokens. |
| 5 | `ConvertHTtoPool` | Reset: 0. Count tokens converted from Hard Tokens to Pool. |
| 4 | `OpCntLvl3Esc` | Reset: 0. Count ops touched by Level3 escalation (boost-to-Hi). |
| 3 | `OpCntLvl2Esc` | Reset: 0. Count ops touched by Level2 escalation (boost-to-Med). |
| 2 | `DurLvl3Esc` | Reset: 0. Time duration (number of cycles) spent in Level3 escalation. |
| 1 | `DurLvl2Esc` | Reset: 0. Time duration (number of cycles) spent in Level2 escalation. |
| 0 | `DurLvl1Esc` | Reset: 0. Time duration (number of cycles) spent in Level1 escalation. |


## DFPMCx00000[01...3D]2 — DF/CS — CS RSPBW Response Bandwidth

**Symbolic:** `DF::PMC::CS::CS_RSPBW`  
**Instance:** `_instCMP0; DFPMCx00000312 _instCMP1; DFPMCx00000352 _instCMP2; DFPMCx00000392 _instCMP3; DFPMCx000003D2 _instCS0; DFPMCx00000012 _instCS10; DFPMCx00000292 _instCS11; DFPMCx000002D2 _instCS1; DFPMCx00000052 _instCS2; DFPMCx00000092 _instCS3; DFPMCx000000D2 _instCS4; DFPMCx00000112 _instCS5; DFPMCx00000152 _instCS6; DFPMCx00000192 _instCS7; DFPMCx000001D2 _instCS8; DFPMCx00000212 _instCS9; DFPMCx00000252`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `SelOrigNodeId` | Reset: 0. Select Originator Node ID if UseNodeId is set |
| 6 | `UseNodeId` | Reset: 0. 0: All selected transactions. 1: Only transactions from the selected NodeId |
| 5 | `ChanSel` | Reset: 0. Response channel selector. 0:RSP channel, 1:RSPND channel. |
| 4 | `TgtDnDAutoMemFetch` | Reset: 0. Target Done with data, sent with directed probe. |
| 3 | `TgtDnDByp` | Reset: 0. Target Done with data, eligible for transport bypass. |
| 2 | `TgtDnDNoByp` | Reset: 0. Target Done with data, not eligible for transport bypass. |
| 1 | `TgtDn` | Reset: 0. Target Done without data. |
| 0 | `TgtSt` | Reset: 0. Target Start. |


## DFPMCx00000[01...3D]3 — DF/CS — CS SPF_DNGRD Downgrades

**Symbolic:** `DF::PMC::CS::CS_SPF_DNGRD`  
**Instance:** `_instCMP0; DFPMCx00000313 _instCMP1; DFPMCx00000353 _instCMP2; DFPMCx00000393 _instCMP3; DFPMCx000003D3 _instCS0; DFPMCx00000013 _instCS10; DFPMCx00000293 _instCS11; DFPMCx000002D3 _instCS1; DFPMCx00000053 _instCS2; DFPMCx00000093 _instCS3; DFPMCx000000D3 _instCS4; DFPMCx00000113 _instCS5; DFPMCx00000153 _instCS6; DFPMCx00000193 _instCS7; DFPMCx000001D3 _instCS8; DFPMCx00000213 _instCS9; DFPMCx00000253`

Downgrade request used hard-allocated CSQ token.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `HardTok` | Reset: 0. Downgrade request used hard-allocated CSQ token. |
| 6 | `PoolTok` | Reset: 0. Downgrade request used stolen FTI request pool token. |
| 5 | `BusyStall` | Reset: 0. Downgrade request stalled due to CS busy. |
| 4 | `TokStall` | Reset: 0. Downgrade request stalled due to no tokens available. |
| 3 | `Demote` | Reset: 0. Demote Super Probe Allocation |
| 2 | `LineDng` | Reset: 0. Line Downgrade Allocation |
| 1 | `PageDng` | Reset: 0. Page Downgrade Allocation |
| 0 | `Valid` | Reset: 0. Successful Downgrade Allocation |


## DFPMCx00000[01...3D]4 — DF/CS — CS WIDGET Read and Write Combining Widgets

**Symbolic:** `DF::PMC::CS::CS_WIDGET`  
**Instance:** `_instCMP0; DFPMCx00000314 _instCMP1; DFPMCx00000354 _instCMP2; DFPMCx00000394 _instCMP3; DFPMCx000003D4 _instCS0; DFPMCx00000014 _instCS10; DFPMCx00000294 _instCS11; DFPMCx000002D4 _instCS1; DFPMCx00000054 _instCS2; DFPMCx00000094 _instCS3; DFPMCx000000D4 _instCS4; DFPMCx00000114 _instCS5; DFPMCx00000154 _instCS6; DFPMCx00000194 _instCS7; DFPMCx000001D4 _instCS8; DFPMCx00000214 _instCS9; DFPMCx00000254`

RCB Allocate: Contended Lock Acceleration Possible.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RcbAlc` | Reset: 0. RCB Allocate: Contended Lock Acceleration Possible. |
| 6 | `RcbFwd` | Reset: 0. RCB Hit: Contended Lock Acceleration Active. |
| 5 | `RcbClsNonComb` | Reset: 0. RCB Closed due to non-combinable operation. |
| 4 | `RcbClsCsd` | Reset: 0. RCB Closed due to CSD deallocation. |
| 3 | `WcbHit` | Reset: 0. WCB Hit. |
| 2 | `WcbClsNonComb` | Reset: 0. WCB Closed due to non-combinable operation. |
| 1 | `WcbClsDramWr` | Reset: 0. WCB Closed due to parent DRAM write issue. |
| 0 | `WcbClsHitThr` | Reset: 0. WCB Closed due to Hit Threshold. |


## DFPMCx00000[01...3D]5 — DF/CS — CS SPF_MISC Miscellaneous

**Symbolic:** `DF::PMC::CS::CS_SPF_MISC`  
**Instance:** `_instCMP0; DFPMCx00000315 _instCMP1; DFPMCx00000355 _instCMP2; DFPMCx00000395 _instCMP3; DFPMCx000003D5 _instCS0; DFPMCx00000015 _instCS10; DFPMCx00000295 _instCS11; DFPMCx000002D5 _instCS1; DFPMCx00000055 _instCS2; DFPMCx00000095 _instCS3; DFPMCx000000D5 _instCS4; DFPMCx00000115 _instCS5; DFPMCx00000155 _instCS6; DFPMCx00000195 _instCS7; DFPMCx000001D5 _instCS8; DFPMCx00000215 _instCS9; DFPMCx00000255`

Pipe Kill due to Lack of SPF tokens.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `PipeKill` | Reset: 0. Pipe Kill due to Lack of SPF tokens. |
| 6 | `IndexMatchRaw` | Reset: 0. PFQ Raw Index Match. |
| 5 | `IndexMatchEff` | Reset: 0. PFQ Eff Index Match. |
| 4 | `IndexMatchByp` | Reset: 0. PFQ Allocation due to lack of Bypass Saturation. |


## DFPMCx00000[01...3D]6 — DF/CS — CS DAT_CAC Response Data Transition CAC

**Symbolic:** `DF::PMC::CS::CS_DAT_CAC`  
**Instance:** `_instCMP0; DFPMCx00000316 _instCMP1; DFPMCx00000356 _instCMP2; DFPMCx00000396 _instCMP3; DFPMCx000003D6 _instCS0; DFPMCx00000016 _instCS10; DFPMCx00000296 _instCS11; DFPMCx000002D6 _instCS1; DFPMCx00000056 _instCS2; DFPMCx00000096 _instCS3; DFPMCx000000D6 _instCS4; DFPMCx00000116 _instCS5; DFPMCx00000156 _instCS6; DFPMCx00000196 _instCS7; DFPMCx000001D6 _instCS8; DFPMCx00000216 _instCS9; DFPMCx00000256`

Count total word transfers on CS to FTI data bus.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `TotalWords` | Reset: 0. Count total word transfers on CS to FTI data bus. |
| 0 | `SparseTrans` | Reset: 0. Count sparse data transitions on CS to FTI data bus. |


## DFPMCx00000[01...3D]7 — DF/CS — CS SPF_REQ_PICK Request Picker

**Symbolic:** `DF::PMC::CS::CS_SPF_REQ_PICK`  
**Instance:** `_instCMP0; DFPMCx00000317 _instCMP1; DFPMCx00000357 _instCMP2; DFPMCx00000397 _instCMP3; DFPMCx000003D7 _instCS0; DFPMCx00000017 _instCS10; DFPMCx00000297 _instCS11; DFPMCx000002D7 _instCS1; DFPMCx00000057 _instCS2; DFPMCx00000097 _instCS3; DFPMCx000000D7 _instCS4; DFPMCx00000117 _instCS5; DFPMCx00000157 _instCS6; DFPMCx00000197 _instCS7; DFPMCx000001D7 _instCS8; DFPMCx00000217 _instCS9; DFPMCx00000257`

High priority request was picked over an Urgent priority request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `HiWon` | Reset: 0. High priority request was picked over an Urgent priority request. |
| 6 | `MedWon` | Reset: 0. Medium priority request was picked over a High priority request. |
| 5 | `LowWon` | Reset: 0. Low priority request was picked over a higher (Medium or High) priority request. |
| 4 | `UrgLost` | Reset: 0. Urgent priority request was skipped in favor of a lower (Low/Medium/High) priority request. |
| 3 | `HiLost` | Reset: 0. High priority request was skipped in favor of a lower (Low or Medium) priority request. |
| 2 | `MedLost` | Reset: 0. Medium priority request was skipped in favor of a Low priority request. |
| 0 | `Any` | Reset: 0. Any request picked. |


## DFPMCx00000[01...3D]8 — DF/CS — CS CDMA

**Symbolic:** `DF::PMC::CS::CS_CDMA`  
**Instance:** `_instCMP0; DFPMCx00000318 _instCMP1; DFPMCx00000358 _instCMP2; DFPMCx00000398 _instCMP3; DFPMCx000003D8 _instCS0; DFPMCx00000018 _instCS10; DFPMCx00000298 _instCS11; DFPMCx000002D8 _instCS1; DFPMCx00000058 _instCS2; DFPMCx00000098 _instCS3; DFPMCx000000D8 _instCS4; DFPMCx00000118 _instCS5; DFPMCx00000158 _instCS6; DFPMCx00000198 _instCS7; DFPMCx000001D8 _instCS8; DFPMCx00000218 _instCS9; DFPMCx00000258`

Count Steering Prb Cancels due to PF recommended a Mcast probe.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10 | `Mcast` | Reset: 0. Count Steering Prb Cancels due to PF recommended a Mcast probe. |
| 9 | `NoTgt` | Reset: 0. Count Steering Prb Cancels due to PF miss and no Steer Tag. |
| 8 | `MismtchTgt` | Reset: 0. Count Steering Prb Cancels due to PF owner mismatch with Steer Tag. |
| 7 | `Wr` | Reset: 0. Count incoming CDMA writes. |
| 6 | `WrACM` | Reset: 0. Count incoming writes allocated during ACM. |
| 5 | `WrReg` | Reset: 0. Count incoming CDMA writes allocated with programmed delay. |
| 4 | `Rd` | Reset: 0. Reads |
| 3 | `RdHit` | Reset: 0. Count incoming CDMA reads which hit on an CDMA write. |
| 2 | `RdMis` | Reset: 0. Count incoming CDMA reads which do not hit on an CDMA write. |
| 1:0 | `Dur` | Reset: 0h. Select Escalation Level durations. Value Description 0h Disabled, do not count escalation level durations. 1h Count time spent in Accelerated Countdown Mode (ACM). 2h Count time spent over High Water Limit. 3h Count time spend under Low Water Limit. |


## DFPMCx00000[01...3D]9 — DF/CS — CS DNG_REQ Request Picker

**Symbolic:** `DF::PMC::CS::CS_DNG_REQ`  
**Instance:** `_instCMP0; DFPMCx00000319 _instCMP1; DFPMCx00000359 _instCMP2; DFPMCx00000399 _instCMP3; DFPMCx000003D9 _instCS0; DFPMCx00000019 _instCS10; DFPMCx00000299 _instCS11; DFPMCx000002D9 _instCS1; DFPMCx00000059 _instCS2; DFPMCx00000099 _instCS3; DFPMCx000000D9 _instCS4; DFPMCx00000119 _instCS5; DFPMCx00000159 _instCS6; DFPMCx00000199 _instCS7; DFPMCx000001D9 _instCS8; DFPMCx00000219 _instCS9; DFPMCx00000259`

Explicit Downgrade request encountered conditions that made it expand to full multi-cast.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `ExpMcast` | Reset: 0. Explicit Downgrade request encountered conditions that made it expand to full multi-cast. |
| 2 | `LagUnkwn` | Reset: 0. Explicit Downgrade request lags tag matching PFQ responses. |
| 1 | `HitUnkwn` | Reset: 0. Explicit Downgrade request hits tag matching PFQ requests. |
| 0 | `Valid` | Reset: 0. Explicit Downgrade Request |


## DFPMCx00000[01...3D]A — DF/CS — CS UMC_SPM UMC Streaming Performance Monitor

**Symbolic:** `DF::PMC::CS::CS_UMC_SPM`  
**Instance:** `_instCMP0; DFPMCx0000031A _instCMP1; DFPMCx0000035A _instCMP2; DFPMCx0000039A _instCMP3; DFPMCx000003DA _instCS0; DFPMCx0000001A _instCS10; DFPMCx0000029A _instCS11; DFPMCx000002DA _instCS1; DFPMCx0000005A _instCS2; DFPMCx0000009A _instCS3; DFPMCx000000DA _instCS4; DFPMCx0000011A _instCS5; DFPMCx0000015A _instCS6; DFPMCx0000019A _instCS7; DFPMCx000001DA _instCS8; DFPMCx0000021A _instCS9; DFPMCx0000025A`

Count incoming UMC SPM Event 7.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Event7` | Reset: 0. Count incoming UMC SPM Event 7. |
| 6 | `Event6` | Reset: 0. Count incoming UMC SPM Event 6. |
| 5 | `Event5` | Reset: 0. Count incoming UMC SPM Event 5. |
| 4 | `Event4` | Reset: 0. Count incoming UMC SPM Event 4. |
| 3 | `Event3` | Reset: 0. Count incoming UMC SPM Event 3. |
| 2 | `Event2` | Reset: 0. Count incoming UMC SPM Event 2. |
| 1 | `Event1` | Reset: 0. Count incoming UMC SPM Event 1. |
| 0 | `Event0` | Reset: 0. Count incoming UMC SPM Event 0. |


## DFPMCx00000[01...3D]B — DF/CS — CS MSTR_REQA Requests Received from FTI by master

**Symbolic:** `DF::PMC::CS::CS_MSTR_REQA`  
**Instance:** `_instCMP0; DFPMCx0000031B _instCMP1; DFPMCx0000035B _instCMP2; DFPMCx0000039B _instCMP3; DFPMCx000003DB _instCS0; DFPMCx0000001B _instCS10; DFPMCx0000029B _instCS11; DFPMCx000002DB _instCS1; DFPMCx0000005B _instCS2; DFPMCx0000009B _instCS3; DFPMCx000000DB _instCS4; DFPMCx0000011B _instCS5; DFPMCx0000015B _instCS6; DFPMCx0000019B _instCS7; DFPMCx000001DB _instCS8; DFPMCx0000021B _instCS9; DFPMCx0000025B`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 10 | `AIE` | Reset: 0. Master Type is an AIED CCM. |
| 9 | `NCM_N` | Reset: 0. Reserved. |
| 8 | `ACM` | Reset: 0. Master Type is ACM. |
| 7 | `GIOM` | Reset: 0. Reserved. |
| 6 | `NCM_I` | Reset: 0. Master Type is NCM_I. |
| 5 | `NCM_G` | Reset: 0. Reserved. |
| 4 | `NCM_D` | Reset: 0. Reserved. |
| 3 | `NCM_M` | Reset: 0. Reserved. |
| 2 | `IOM` | Reset: 0. Master Type is IOM |
| 1 | `CCM` | Reset: 0. Master Type is CCM. |
| 0 | `GCM` | Reset: 0. Reserved. |


## DFPMCx00000[01...3D]C — DF/CS — CS APF_RSP Request Picker

**Symbolic:** `DF::PMC::CS::CS_APF_RSP`  
**Instance:** `_instCMP0; DFPMCx0000031C _instCMP1; DFPMCx0000035C _instCMP2; DFPMCx0000039C _instCMP3; DFPMCx000003DC _instCS0; DFPMCx0000001C _instCS10; DFPMCx0000029C _instCS11; DFPMCx000002DC _instCS1; DFPMCx0000005C _instCS2; DFPMCx0000009C _instCS3; DFPMCx000000DC _instCS4; DFPMCx0000011C _instCS5; DFPMCx0000015C _instCS6; DFPMCx0000019C _instCS7; DFPMCx000001DC _instCS8; DFPMCx0000021C _instCS9; DFPMCx0000025C`

APF forces a Fetch probe

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `Fetch` | Reset: 0. APF forces a Fetch probe |
| 3 | `Rinse` | Reset: 0. Rinse Recommendation from APF |
| 2 | `Retry` | Reset: 0. APF Response with Retry Status. |
| 1 | `Unkwn` | Reset: 0. APF Response with Unknown Status |
| 0 | `Valid` | Reset: 0. Any APF Response |


## DFPMCx00000[01...3D]D — DF/CS — CS DMR Debug Match Regions

**Symbolic:** `DF::PMC::CS::CS_DMR`  
**Instance:** `_instCMP0; DFPMCx0000031D _instCMP1; DFPMCx0000035D _instCMP2; DFPMCx0000039D _instCMP3; DFPMCx000003DD _instCS0; DFPMCx0000001D _instCS10; DFPMCx0000029D _instCS11; DFPMCx000002DD _instCS1; DFPMCx0000005D _instCS2; DFPMCx0000009D _instCS3; DFPMCx000000DD _instCS4; DFPMCx0000011D _instCS5; DFPMCx0000015D _instCS6; DFPMCx0000019D _instCS7; DFPMCx000001DD _instCS8; DFPMCx0000021D _instCS9; DFPMCx0000025D`

Request channel selector. 0:REQ channel, 1:REQND channel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Request channel selector. 0:REQ channel, 1:REQND channel. |
| 1 | `DMR1` | Reset: 0. Result of DMR1. |
| 0 | `DMR0` | Reset: 0. Result of DMR0. |


## DFPMCx00000[01...3D]F — DF/CS — CS DATA_BW Data Bandwidth

**Symbolic:** `DF::PMC::CS::CS_DATA_BW`  
**Instance:** `_instCMP0; DFPMCx0000031F _instCMP1; DFPMCx0000035F _instCMP2; DFPMCx0000039F _instCMP3; DFPMCx000003DF _instCS0; DFPMCx0000001F _instCS10; DFPMCx0000029F _instCS11; DFPMCx000002DF _instCS1; DFPMCx0000005F _instCS2; DFPMCx0000009F _instCS3; DFPMCx000000DF _instCS4; DFPMCx0000011F _instCS5; DFPMCx0000015F _instCS6; DFPMCx0000019F _instCS7; DFPMCx000001DF _instCS8; DFPMCx0000021F _instCS9; DFPMCx0000025F`

Select transactions based on the die proximity of the source. Must be programmed to 0x3 when measuring CS read bandwidth

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SrcDstDieProx` | Reset: 0h. Select transactions based on the die proximity of the source. Must be programmed to 0x3 when measuring CS read bandwidth Value Description 0h Disabled. No transactions selected 1h Count only transactions with source on Local die 2h Count only transactions with source on Remote die 3h Count any transaction, regardless of source die proximity |
| 7:6 | `SrcDstDieType` | Reset: 0h. Select transactions based on die type of the source Value Description 0h Disabled. No transactions selected 1h Count only transactions with source on the same die type 2h Count only transactions with source on a different die type 3h Count any transaction, regardless of source die type |
| 5:2 | `SrcDst` | Reset: 0h. Select transactions based on the type of the requestor: CXL™, IO, GPU, or CPU. Must be programmed to 0xF when measuring CS read bandwidth. Multi-bit selects are also possible. Value Description 0h Disabled. No transactions selected 1h Count only transactions from CPU source 2h Count only transactions from GPU source 3h Reserved. 4h Count only transactions from IO source 7h-5h Reserved. 8h Count only transactions from CXL source Eh-9h Reserved. Fh Count any transaction, regardless of source |
| 0 | `TxnType` | Reset: 0. 0= Count Read Response Data Beats . 1= Count Write Data Beats . Select Transaction Type |


## DFPMCx00000[02...3E]0 — DF/CS — CS BEQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CS::CS_BEQ_OCC`  
**Instance:** `_instCMP0; DFPMCx00000320 _instCMP1; DFPMCx00000360 _instCMP2; DFPMCx000003A0 _instCMP3; DFPMCx000003E0 _instCS0; DFPMCx00000020 _instCS10; DFPMCx000002A0 _instCS11; DFPMCx000002E0 _instCS1; DFPMCx00000060 _instCS2; DFPMCx000000A0 _instCS3; DFPMCx000000E0 _instCS4; DFPMCx00000120 _instCS5; DFPMCx00000160 _instCS6; DFPMCx000001A0 _instCS7; DFPMCx000001E0 _instCS8; DFPMCx00000220 _instCS9; DFPMCx00000260`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[02...3E]C — DF/CS — PFI_RSP Average Latency Transaction Count

**Symbolic:** `DF::PMC::CS::CS_PFI_RSP_AVG_LAT_TRANS_CNT`  
**Instance:** `_instCMP0; DFPMCx0000032C _instCMP1; DFPMCx0000036C _instCMP2; DFPMCx000003AC _instCMP3; DFPMCx000003EC _instCS0; DFPMCx0000002C _instCS10; DFPMCx000002AC _instCS11; DFPMCx000002EC _instCS1; DFPMCx0000006C _instCS2; DFPMCx000000AC _instCS3; DFPMCx000000EC _instCS4; DFPMCx0000012C _instCS5; DFPMCx0000016C _instCS6; DFPMCx000001AC _instCS7; DFPMCx000001EC _instCS8; DFPMCx0000022C _instCS9; DFPMCx0000026C`

Select only Cache Eligible ops for analysis

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `CacheElig` | Reset: 0. Select only Cache Eligible ops for analysis |
| 2 | `ProbeElig` | Reset: 0. Select only Probe Eligible ops for analysis |
| 1 | `DemandReq` | Reset: 0. Select only Demand Request ops for analysis. Directory maintenance ops are skipped |
| 0 | `SelectAll` | Reset: 0. Select all lookups for analysis |


## DFPMCx00000[02...3E]D — DF/CS — PFI_RSP Average Latency Cycle Count

**Symbolic:** `DF::PMC::CS::CS_PFI_RSP_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instCMP0; DFPMCx0000032D _instCMP1; DFPMCx0000036D _instCMP2; DFPMCx000003AD _instCMP3; DFPMCx000003ED _instCS0; DFPMCx0000002D _instCS10; DFPMCx000002AD _instCS11; DFPMCx000002ED _instCS1; DFPMCx0000006D _instCS2; DFPMCx000000AD _instCS3; DFPMCx000000ED _instCS4; DFPMCx0000012D _instCS5; DFPMCx0000016D _instCS6; DFPMCx000001AD _instCS7; DFPMCx000001ED _instCS8; DFPMCx0000022D _instCS9; DFPMCx0000026D`

Select only Cache Eligible ops for analysis

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `CacheElig` | Reset: 0. Select only Cache Eligible ops for analysis |
| 2 | `ProbeElig` | Reset: 0. Select only Probe Eligible ops for analysis |
| 1 | `DemandReq` | Reset: 0. Select only Demand Request ops for analysis. Directory maintenance ops are skipped |
| 0 | `SelectAll` | Reset: 0. Select all lookups for analysis |


## DFPMCx00000[02...3E]E — DF/CS — PRB_FTI Average Latency Transaction Count

**Symbolic:** `DF::PMC::CS::CS_PRB_FTI_AVG_LAT_TRANS_CNT`  
**Instance:** `_instCMP0; DFPMCx0000032E _instCMP1; DFPMCx0000036E _instCMP2; DFPMCx000003AE _instCMP3; DFPMCx000003EE _instCS0; DFPMCx0000002E _instCS10; DFPMCx000002AE _instCS11; DFPMCx000002EE _instCS1; DFPMCx0000006E _instCS2; DFPMCx000000AE _instCS3; DFPMCx000000EE _instCS4; DFPMCx0000012E _instCS5; DFPMCx0000016E _instCS6; DFPMCx000001AE _instCS7; DFPMCx000001EE _instCS8; DFPMCx0000022E _instCS9; DFPMCx0000026E`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Prb latency is calculated. 1= FTI Prb1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on FTI PrbReq Action. Bh-8h Reserved. Ch Page Downgrade Dh Line Downgrade Eh Reserved. Fh Any Action. |


## DFPMCx00000[02...3E]F — DF/CS — PRB_FTI Average Latency Cycle Count

**Symbolic:** `DF::PMC::CS::CS_PRB_FTI_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instCMP0; DFPMCx0000032F _instCMP1; DFPMCx0000036F _instCMP2; DFPMCx000003AF _instCMP3; DFPMCx000003EF _instCS0; DFPMCx0000002F _instCS10; DFPMCx000002AF _instCS11; DFPMCx000002EF _instCS1; DFPMCx0000006F _instCS2; DFPMCx000000AF _instCS3; DFPMCx000000EF _instCS4; DFPMCx0000012F _instCS5; DFPMCx0000016F _instCS6; DFPMCx000001AF _instCS7; DFPMCx000001EF _instCS8; DFPMCx0000022F _instCS9; DFPMCx0000026F`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Prb latency is calculated. 1= FTI Prb1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on FTI PrbReq Action. Bh-8h Reserved. Ch Page Downgrade Dh Line Downgrade Eh Reserved. Fh Any Action. |


## DFPMCx00000[03...3F]0 — DF/CS — Average Latency Transaction Count

**Symbolic:** `DF::PMC::CS::CS_SDP_AVG_LAT_TRANS_CNT`  
**Instance:** `_instCMP0; DFPMCx00000330 _instCMP1; DFPMCx00000370 _instCMP2; DFPMCx000003B0 _instCMP3; DFPMCx000003F0 _instCS0; DFPMCx00000030 _instCS10; DFPMCx000002B0 _instCS11; DFPMCx000002F0 _instCS1; DFPMCx00000070 _instCS2; DFPMCx000000B0 _instCS3; DFPMCx000000F0 _instCS4; DFPMCx00000130 _instCS5; DFPMCx00000170 _instCS6; DFPMCx000001B0 _instCS7; DFPMCx000001F0 _instCS8; DFPMCx00000230 _instCS9; DFPMCx00000270`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]1 — DF/CS — Average Latency Cycle Count

**Symbolic:** `DF::PMC::CS::CS_SDP_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instCMP0; DFPMCx00000331 _instCMP1; DFPMCx00000371 _instCMP2; DFPMCx000003B1 _instCMP3; DFPMCx000003F1 _instCS0; DFPMCx00000031 _instCS10; DFPMCx000002B1 _instCS11; DFPMCx000002F1 _instCS1; DFPMCx00000071 _instCS2; DFPMCx000000B1 _instCS3; DFPMCx000000F1 _instCS4; DFPMCx00000131 _instCS5; DFPMCx00000171 _instCS6; DFPMCx000001B1 _instCS7; DFPMCx000001F1 _instCS8; DFPMCx00000231 _instCS9; DFPMCx00000271`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]2 — DF/CS — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::CS::CS_SDP_LAT_HIST_GT50`  
**Instance:** `_instCMP0; DFPMCx00000332 _instCMP1; DFPMCx00000372 _instCMP2; DFPMCx000003B2 _instCMP3; DFPMCx000003F2 _instCS0; DFPMCx00000032 _instCS10; DFPMCx000002B2 _instCS11; DFPMCx000002F2 _instCS1; DFPMCx00000072 _instCS2; DFPMCx000000B2 _instCS3; DFPMCx000000F2 _instCS4; DFPMCx00000132 _instCS5; DFPMCx00000172 _instCS6; DFPMCx000001B2 _instCS7; DFPMCx000001F2 _instCS8; DFPMCx00000232 _instCS9; DFPMCx00000272`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]3 — DF/CS — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::CS::CS_SDP_LAT_HIST_GT100`  
**Instance:** `_instCMP0; DFPMCx00000333 _instCMP1; DFPMCx00000373 _instCMP2; DFPMCx000003B3 _instCMP3; DFPMCx000003F3 _instCS0; DFPMCx00000033 _instCS10; DFPMCx000002B3 _instCS11; DFPMCx000002F3 _instCS1; DFPMCx00000073 _instCS2; DFPMCx000000B3 _instCS3; DFPMCx000000F3 _instCS4; DFPMCx00000133 _instCS5; DFPMCx00000173 _instCS6; DFPMCx000001B3 _instCS7; DFPMCx000001F3 _instCS8; DFPMCx00000233 _instCS9; DFPMCx00000273`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]4 — DF/CS — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::CS::CS_SDP_LAT_HIST_GT150`  
**Instance:** `_instCMP0; DFPMCx00000334 _instCMP1; DFPMCx00000374 _instCMP2; DFPMCx000003B4 _instCMP3; DFPMCx000003F4 _instCS0; DFPMCx00000034 _instCS10; DFPMCx000002B4 _instCS11; DFPMCx000002F4 _instCS1; DFPMCx00000074 _instCS2; DFPMCx000000B4 _instCS3; DFPMCx000000F4 _instCS4; DFPMCx00000134 _instCS5; DFPMCx00000174 _instCS6; DFPMCx000001B4 _instCS7; DFPMCx000001F4 _instCS8; DFPMCx00000234 _instCS9; DFPMCx00000274`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]5 — DF/CS — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::CS::CS_SDP_LAT_HIST_GT200`  
**Instance:** `_instCMP0; DFPMCx00000335 _instCMP1; DFPMCx00000375 _instCMP2; DFPMCx000003B5 _instCMP3; DFPMCx000003F5 _instCS0; DFPMCx00000035 _instCS10; DFPMCx000002B5 _instCS11; DFPMCx000002F5 _instCS1; DFPMCx00000075 _instCS2; DFPMCx000000B5 _instCS3; DFPMCx000000F5 _instCS4; DFPMCx00000135 _instCS5; DFPMCx00000175 _instCS6; DFPMCx000001B5 _instCS7; DFPMCx000001F5 _instCS8; DFPMCx00000235 _instCS9; DFPMCx00000275`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]6 — DF/CS — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::CS::CS_SDP_LAT_HIST_GT500`  
**Instance:** `_instCMP0; DFPMCx00000336 _instCMP1; DFPMCx00000376 _instCMP2; DFPMCx000003B6 _instCMP3; DFPMCx000003F6 _instCS0; DFPMCx00000036 _instCS10; DFPMCx000002B6 _instCS11; DFPMCx000002F6 _instCS1; DFPMCx00000076 _instCS2; DFPMCx000000B6 _instCS3; DFPMCx000000F6 _instCS4; DFPMCx00000136 _instCS5; DFPMCx00000176 _instCS6; DFPMCx000001B6 _instCS7; DFPMCx000001F6 _instCS8; DFPMCx00000236 _instCS9; DFPMCx00000276`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]7 — DF/CS — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::CS::CS_SDP_LAT_HIST_GT1000`  
**Instance:** `_instCMP0; DFPMCx00000337 _instCMP1; DFPMCx00000377 _instCMP2; DFPMCx000003B7 _instCMP3; DFPMCx000003F7 _instCS0; DFPMCx00000037 _instCS10; DFPMCx000002B7 _instCS11; DFPMCx000002F7 _instCS1; DFPMCx00000077 _instCS2; DFPMCx000000B7 _instCS3; DFPMCx000000F7 _instCS4; DFPMCx00000137 _instCS5; DFPMCx00000177 _instCS6; DFPMCx000001B7 _instCS7; DFPMCx000001F7 _instCS8; DFPMCx00000237 _instCS9; DFPMCx00000277`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]8 — DF/CS — Average Latency Transaction Count

**Symbolic:** `DF::PMC::CS::CS_FTI_AVG_LAT_TRANS_CNT`  
**Instance:** `_instCMP0; DFPMCx00000338 _instCMP1; DFPMCx00000378 _instCMP2; DFPMCx000003B8 _instCMP3; DFPMCx000003F8 _instCS0; DFPMCx00000038 _instCS10; DFPMCx000002B8 _instCS11; DFPMCx000002F8 _instCS1; DFPMCx00000078 _instCS2; DFPMCx000000B8 _instCS3; DFPMCx000000F8 _instCS4; DFPMCx00000138 _instCS5; DFPMCx00000178 _instCS6; DFPMCx000001B8 _instCS7; DFPMCx000001F8 _instCS8; DFPMCx00000238 _instCS9; DFPMCx00000278`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]9 — DF/CS — Average Latency Cycle Count

**Symbolic:** `DF::PMC::CS::CS_FTI_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instCMP0; DFPMCx00000339 _instCMP1; DFPMCx00000379 _instCMP2; DFPMCx000003B9 _instCMP3; DFPMCx000003F9 _instCS0; DFPMCx00000039 _instCS10; DFPMCx000002B9 _instCS11; DFPMCx000002F9 _instCS1; DFPMCx00000079 _instCS2; DFPMCx000000B9 _instCS3; DFPMCx000000F9 _instCS4; DFPMCx00000139 _instCS5; DFPMCx00000179 _instCS6; DFPMCx000001B9 _instCS7; DFPMCx000001F9 _instCS8; DFPMCx00000239 _instCS9; DFPMCx00000279`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]A — DF/CS — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::CS::CS_FTI_LAT_HIST_GT50`  
**Instance:** `_instCMP0; DFPMCx0000033A _instCMP1; DFPMCx0000037A _instCMP2; DFPMCx000003BA _instCMP3; DFPMCx000003FA _instCS0; DFPMCx0000003A _instCS10; DFPMCx000002BA _instCS11; DFPMCx000002FA _instCS1; DFPMCx0000007A _instCS2; DFPMCx000000BA _instCS3; DFPMCx000000FA _instCS4; DFPMCx0000013A _instCS5; DFPMCx0000017A _instCS6; DFPMCx000001BA _instCS7; DFPMCx000001FA _instCS8; DFPMCx0000023A _instCS9; DFPMCx0000027A`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]B — DF/CS — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::CS::CS_FTI_LAT_HIST_GT100`  
**Instance:** `_instCMP0; DFPMCx0000033B _instCMP1; DFPMCx0000037B _instCMP2; DFPMCx000003BB _instCMP3; DFPMCx000003FB _instCS0; DFPMCx0000003B _instCS10; DFPMCx000002BB _instCS11; DFPMCx000002FB _instCS1; DFPMCx0000007B _instCS2; DFPMCx000000BB _instCS3; DFPMCx000000FB _instCS4; DFPMCx0000013B _instCS5; DFPMCx0000017B _instCS6; DFPMCx000001BB _instCS7; DFPMCx000001FB _instCS8; DFPMCx0000023B _instCS9; DFPMCx0000027B`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]C — DF/CS — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::CS::CS_FTI_LAT_HIST_GT150`  
**Instance:** `_instCMP0; DFPMCx0000033C _instCMP1; DFPMCx0000037C _instCMP2; DFPMCx000003BC _instCMP3; DFPMCx000003FC _instCS0; DFPMCx0000003C _instCS10; DFPMCx000002BC _instCS11; DFPMCx000002FC _instCS1; DFPMCx0000007C _instCS2; DFPMCx000000BC _instCS3; DFPMCx000000FC _instCS4; DFPMCx0000013C _instCS5; DFPMCx0000017C _instCS6; DFPMCx000001BC _instCS7; DFPMCx000001FC _instCS8; DFPMCx0000023C _instCS9; DFPMCx0000027C`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]D — DF/CS — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::CS::CS_FTI_LAT_HIST_GT200`  
**Instance:** `_instCMP0; DFPMCx0000033D _instCMP1; DFPMCx0000037D _instCMP2; DFPMCx000003BD _instCMP3; DFPMCx000003FD _instCS0; DFPMCx0000003D _instCS10; DFPMCx000002BD _instCS11; DFPMCx000002FD _instCS1; DFPMCx0000007D _instCS2; DFPMCx000000BD _instCS3; DFPMCx000000FD _instCS4; DFPMCx0000013D _instCS5; DFPMCx0000017D _instCS6; DFPMCx000001BD _instCS7; DFPMCx000001FD _instCS8; DFPMCx0000023D _instCS9; DFPMCx0000027D`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]E — DF/CS — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::CS::CS_FTI_LAT_HIST_GT500`  
**Instance:** `_instCMP0; DFPMCx0000033E _instCMP1; DFPMCx0000037E _instCMP2; DFPMCx000003BE _instCMP3; DFPMCx000003FE _instCS0; DFPMCx0000003E _instCS10; DFPMCx000002BE _instCS11; DFPMCx000002FE _instCS1; DFPMCx0000007E _instCS2; DFPMCx000000BE _instCS3; DFPMCx000000FE _instCS4; DFPMCx0000013E _instCS5; DFPMCx0000017E _instCS6; DFPMCx000001BE _instCS7; DFPMCx000001FE _instCS8; DFPMCx0000023E _instCS9; DFPMCx0000027E`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[03...3F]F — DF/CS — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::CS::CS_FTI_LAT_HIST_GT1000`  
**Instance:** `_instCMP0; DFPMCx0000033F _instCMP1; DFPMCx0000037F _instCMP2; DFPMCx000003BF _instCMP3; DFPMCx000003FF _instCS0; DFPMCx0000003F _instCS10; DFPMCx000002BF _instCS11; DFPMCx000002FF _instCS1; DFPMCx0000007F _instCS2; DFPMCx000000BF _instCS3; DFPMCx000000FF _instCS4; DFPMCx0000013F _instCS5; DFPMCx0000017F _instCS6; DFPMCx000001BF _instCS7; DFPMCx000001FF _instCS8; DFPMCx0000023F _instCS9; DFPMCx0000027F`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[40...5C]D — DF/CCM — CCM REQC Request Type (PIE Requests)

**Symbolic:** `DF::PMC::CCM::CCM_REQC`  
**Instance:** `_instCCM0; DFPMCx0000040D _instCCM1; DFPMCx0000044D _instCCM2; DFPMCx0000048D _instCCM3; DFPMCx000004CD _instCCM4; DFPMCx0000050D _instCCM5; DFPMCx0000054D _instCCM6; DFPMCx0000058D _instCCM7; DFPMCx000005CD`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 3:0 | `Type` | Reset: 0h. Select type of request. Value Description 0h APIC access. 1h APIC ucode access. 2h Fast TPR write. 3h Bus Lock Request. 4h Bus Lock Grant. 5h Bus Lock Release. 6h Join System Management request. 7h Leave System Management request. 8h Interrupt Request. 9h APIC ISR Request. Ah MCA Request. Bh SKINIT Request. Ch System Management Request. Dh DVM Op request. Eh DVM Comp request. Fh DVM Sync request. |


## DFPMCx00000[40...5C]E — DF/CCM — CCM PROBES Memory Probes and Probe Responses for SDP0 and FTI0 channel

**Symbolic:** `DF::PMC::CCM::CCM_PROBES`  
**Instance:** `_instCCM0; DFPMCx0000040E _instCCM1; DFPMCx0000044E _instCCM2; DFPMCx0000048E _instCCM3; DFPMCx000004CE _instCCM4; DFPMCx0000050E _instCCM5; DFPMCx0000054E _instCCM6; DFPMCx0000058E _instCCM7; DFPMCx000005CE`

Counts the number of FTI probe requests TAPs received on this FTI channel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `TapRx` | Reset: 0. Counts the number of FTI probe requests TAPs received on this FTI channel. |
| 10 | `TapAlloc` | Reset: 0. Counts the number of FTI probe requests TAPs allocated in TAPQ. |
| 9 | `TapDemandColl` | Reset: 0. Counts the number of FTI demand probe requests that collides (are serviced by) TAPs. |
| 8 | `McastPrbRspSrcD` | Reset: 0. Sent 3-hop PrbRspD for a multi-cast probe. |
| 7 | `PrbRspDataXferSel` | Reset: 0. Data Transfer selector for probe response count. |
| 6:4 | `PrbRspStatePDSel` | Reset: 0h. {State[1:0],PassDirty} selector for probe response count. |
| 3:2 | `PrbRspSel` | Reset: 0h. Probe Response Selector. Value Description 0h Disabled, no SDP probe response counted. 1h Count SDP probe responses matching PrbRspStatePDSel field. 2h Count SDP probe responses matching PrbRspDataXferSel field. 3h Count all SDP probe responses. |
| 1:0 | `PrbReqSel` | Reset: 0h. Probe Request Selector. Value Description 0h Disabled, no FTI probe requests counted. 1h Count FTI Probe Request with Rsp2Tgt=0 (3-hop probe request). 2h Count FTI Probe Request with Rsp2Tgt=1 (4-hop probe request). 3h Count all FTI probe requests. |


## DFPMCx00000[40...6C]0 — DF/CCM — CCM REQQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_REQQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000600 _instACM1; DFPMCx00000640 _instACM2; DFPMCx00000680 _instACM3; DFPMCx000006C0 _instCCM0; DFPMCx00000400 _instCCM1; DFPMCx00000440 _instCCM2; DFPMCx00000480 _instCCM3; DFPMCx000004C0 _instCCM4; DFPMCx00000500 _instCCM5; DFPMCx00000540 _instCCM6; DFPMCx00000580 _instCCM7; DFPMCx000005C0`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[40...6C]1 — DF/CCM — CCM RSPQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_RSPQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000601 _instACM1; DFPMCx00000641 _instACM2; DFPMCx00000681 _instACM3; DFPMCx000006C1 _instCCM0; DFPMCx00000401 _instCCM1; DFPMCx00000441 _instCCM2; DFPMCx00000481 _instCCM3; DFPMCx000004C1 _instCCM4; DFPMCx00000501 _instCCM5; DFPMCx00000541 _instCCM6; DFPMCx00000581 _instCCM7; DFPMCx000005C1`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[40...6C]2 — DF/CCM — CCM PRBQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_PRBQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000602 _instACM1; DFPMCx00000642 _instACM2; DFPMCx00000682 _instACM3; DFPMCx000006C2 _instCCM0; DFPMCx00000402 _instCCM1; DFPMCx00000442 _instCCM2; DFPMCx00000482 _instCCM3; DFPMCx000004C2 _instCCM4; DFPMCx00000502 _instCCM5; DFPMCx00000542 _instCCM6; DFPMCx00000582 _instCCM7; DFPMCx000005C2`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[40...6C]3 — DF/CCM — CCM RSPDQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_RSPDQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000603 _instACM1; DFPMCx00000643 _instACM2; DFPMCx00000683 _instACM3; DFPMCx000006C3 _instCCM0; DFPMCx00000403 _instCCM1; DFPMCx00000443 _instCCM2; DFPMCx00000483 _instCCM3; DFPMCx000004C3 _instCCM4; DFPMCx00000503 _instCCM5; DFPMCx00000543 _instCCM6; DFPMCx00000583 _instCCM7; DFPMCx000005C3`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[40...6C]4 — DF/CCM — CCM ORIGDQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_ORIGDQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000604 _instACM1; DFPMCx00000644 _instACM2; DFPMCx00000684 _instACM3; DFPMCx000006C4 _instCCM0; DFPMCx00000404 _instCCM1; DFPMCx00000444 _instCCM2; DFPMCx00000484 _instCCM3; DFPMCx000004C4 _instCCM4; DFPMCx00000504 _instCCM5; DFPMCx00000544 _instCCM6; DFPMCx00000584 _instCCM7; DFPMCx000005C4`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[40...6C]5 — DF/CCM — CCM REQQ_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_REQQ_STAT`  
**Instance:** `_instACM0; DFPMCx00000605 _instACM1; DFPMCx00000645 _instACM2; DFPMCx00000685 _instACM3; DFPMCx000006C5 _instCCM0; DFPMCx00000405 _instCCM1; DFPMCx00000445 _instCCM2; DFPMCx00000485 _instCCM3; DFPMCx000004C5 _instCCM4; DFPMCx00000505 _instCCM5; DFPMCx00000545 _instCCM6; DFPMCx00000585 _instCCM7; DFPMCx000005C5`

For events which correlate to an SDP port, this bit selects the SDP port which should be tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. For events which correlate to an SDP port, this bit selects the SDP port which should be tracked. |
| 10 | `FtiSelect` | Reset: 0. 0= Primary . 1= (fti_rspnd_src_present==1) ? ReqND : Reserved. For events which correlate to an FtiReqSrc picker or port, this bit selects the request port. |
| 8 | `FastTprByp` | Reset: 0. FastTprWr took REQQ bypass to the FtiReqSrc port selected by FtiSelect. |
| 7 | `SkidBypass` | A request from the SDP port selected by SdpSelect bypassed to FtiReqSrc through the skid buffer. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 6 | `BypassBlocked` | Reset: 0. Request eligible for bypass to the FtiReqSrc port selected by FtiSelect is blocked and is allocated into REQQ. |
| 5:3 | `Pipekill` | Reset: 0h. Selects events which killed REQQ pipeline. The FtiReqSrc picker to monitor is chosen by FtiSelect. Value Description 0h Disabled. No pipekill event. 1h REQQ pick waiting due to unavailable FTI request command token. 2h REQQ pick waiting due to unavailable FTI request data token. 3h REQQ pick waiting due to unavailable FTI request command and data tokens. 4h REQQ pick waiting due to unavailable RSPQ buffer. 5h REQQ pick waiting due to unavailable RSPDQ buffer. 6h Reserved. 7h REQQ pipeline killed for any reason. |
| 2 | `Pick` | Reset: 0. Picker chosen by the FtiSelect bit makes a pick. |
| 1 | `Bypass` | Reset: 0. A request from the SDP port chosen by SdpSelect is bypassed to the FtiReqSrc port chosen by FtiSelect. |
| 0 | `Allocate` | Reset: 0. A request from the SDP port chosen by SdpSelect is allocated into REQQ |


## DFPMCx00000[40...6C]6 — DF/CCM — CCM RSPQ_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_RSPQ_STAT`  
**Instance:** `_instACM0; DFPMCx00000606 _instACM1; DFPMCx00000646 _instACM2; DFPMCx00000686 _instACM3; DFPMCx000006C6 _instCCM0; DFPMCx00000406 _instCCM1; DFPMCx00000446 _instCCM2; DFPMCx00000486 _instCCM3; DFPMCx000004C6 _instCCM4; DFPMCx00000506 _instCCM5; DFPMCx00000546 _instCCM6; DFPMCx00000586 _instCCM7; DFPMCx000005C6`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 9 | `RdRspSpecDramHit` | Reset: 0. Indicates read response SpecDramHit. |
| 8 | `RdRspLocal` | Reset: 0. Indicates local read response. |
| 7:4 | `Pipekill` | Reset: 0h. Selects events which killed RSPQ pipeline. Value Description 0h Disabled. No pipekill event. 1h Reserved. 2h RSPQ RdRsp pipeline killed due to unavailable WaitAck buffer. 3h RSPQ RdRsp pipeline killed due to bypass collision. 4h RSPQ RdRsp pipeline killed for any reason. 5h RSPQ WrRsp pipeline killed due to unavailable SDP buffer. 6h RSPQ WrRsp pipeline killed for any reason. 7h RSPQ SrcDn pipeline killed due to ordering fail. 8h RSPQ SrcDn pipeline killed due to unavailable FTI buffer. 9h RSPQ SrcDn pipeline killed for any reason. Ah RSPQ WrRsp pipeline killed due to unavailable WAITACK buffer. Bh RSPQ WrRsp pipeline killed due to ORIGDQ tag match. Ch fti_rspnd_src_present==1 ? RSPQ SrcDn pipeline killed due to unavailable FTI ND buffer. : Reserved. Fh-Dh Reserved. |
| 3:2 | `Pick` | Reset: 0h. Selects type of RSPQ Pick event. Value Description 0h Disabled. No pick event. 1h RSPQ RdRsp Picker. 2h RSPQ WrRsp Picker. 3h RSPQ SrcDn Picker. |
| 1 | `Bypass` | Reset: 0. RspQ Bypass. Bypass mode as specified by CCMControl[RspDQBypMode]. |
| 0 | `Allocate` | Reset: 0. RspQ Allocates. |


## DFPMCx00000[40...6C]7 — DF/CCM — CCM PRBQ_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_PRBQ_STAT`  
**Instance:** `_instACM0; DFPMCx00000607 _instACM1; DFPMCx00000647 _instACM2; DFPMCx00000687 _instACM3; DFPMCx000006C7 _instCCM0; DFPMCx00000407 _instCCM1; DFPMCx00000447 _instCCM2; DFPMCx00000487 _instCCM3; DFPMCx000004C7 _instCCM4; DFPMCx00000507 _instCCM5; DFPMCx00000547 _instCCM6; DFPMCx00000587 _instCCM7; DFPMCx000005C7`

Selects events which killed PRBQ pipeline.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:9 | `Pipekill` | Reset: 0h. Selects events which killed PRBQ pipeline. Value Description 0h Disabled. No pipekill event. 1h PRBQ Response pipeline killed due to unavailable FTI response buffer. 2h PRBQ Response pipeline killed due to unavailable FTI data buffer. 3h PRBQ Request SDP0 pipeline killed due to unavailable SDP buffer. 4h num_sdp > 1 ? PRBQ Request SDP1 pipeline killed due to unavailable SDP buffer. : Reserved. 7h-5h Reserved. |
| 8 | `RspBypassAny` | Reset: 0. PRBQ Response Bypass for any FtiRsp*Src channels. |
| 7 | `RspPick` | Reset: 0. PRBQ Response Picker. |
| 6 | `RspNdPick` | Reset: 0. PRBQ Response ND Picker. |
| 5 | `ReqPickSdp1` | PRBQ Request Picker for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 4 | `ReqBypassSdp1` | PRBQ Bypass for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 3 | `ReqPickSdp0` | Reset: 0. PRBQ Request Picker for SDP0. |
| 2 | `ReqBypassSdp0` | Reset: 0. PRBQ Bypass for SDP0. |
| 1 | `AllocateFti1` | Reset: 0. PrbQ Allocates from FtiPrbTgt1. |
| 0 | `AllocateFti0` | Reset: 0. PrbQ Allocates from FtiPrbTgt0. |


## DFPMCx00000[40...6C]8 — DF/CCM — CCM RSPDQ_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_RSPDQ_STAT`  
**Instance:** `_instACM0; DFPMCx00000608 _instACM1; DFPMCx00000648 _instACM2; DFPMCx00000688 _instACM3; DFPMCx000006C8 _instCCM0; DFPMCx00000408 _instCCM1; DFPMCx00000448 _instCCM2; DFPMCx00000488 _instCCM3; DFPMCx000004C8 _instCCM4; DFPMCx00000508 _instCCM5; DFPMCx00000548 _instCCM6; DFPMCx00000588 _instCCM7; DFPMCx000005C8`

RSPDQ Allocation from Early Response that took RSPQ bypass for SDP1.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8 | `AllocateEarlyRspSdp1` | RSPDQ Allocation from Early Response that took RSPQ bypass for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 7 | `PickSdp1` | RSPDQ Picker for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 6 | `DataBypSdp1` | RSPDQ data beat bypass for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 5 | `AllocateEarlyRspSdp0` | Reset: 0. RSPDQ Allocation from Early Response that took RSPQ bypass for SDP0. |
| 4 | `PickSdp0` | Reset: 0. RSPDQ Picker for SDP0. |
| 3 | `DataBypSdp0` | Reset: 0. RSPDQ data beat bypass for SDP0. |
| 2 | `AllocateEarly` | Reset: 0. RSPDQ Allocation from RSPQ picker for an Early Response. |
| 1 | `AllocateByp` | Reset: 0. RSPDQ Allocation from RSPQ bypass. |
| 0 | `Allocate` | Reset: 0. RSPDQ Allocation from RSPQ Picker. |


## DFPMCx00000[40...6C]9 — DF/CCM — CCM ORIGDQ_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_ORIGDQ_STAT`  
**Instance:** `_instACM0; DFPMCx00000609 _instACM1; DFPMCx00000649 _instACM2; DFPMCx00000689 _instACM3; DFPMCx000006C9 _instCCM0; DFPMCx00000409 _instCCM1; DFPMCx00000449 _instCCM2; DFPMCx00000489 _instCCM3; DFPMCx000004C9 _instCCM4; DFPMCx00000509 _instCCM5; DFPMCx00000549 _instCCM6; DFPMCx00000589 _instCCM7; DFPMCx000005C9`

ORIGDQ Picker chose a data beat for Probe Response.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `PrbRspPick` | Reset: 0. ORIGDQ Picker chose a data beat for Probe Response. |
| 10 | `WrPick` | Reset: 0. ORIGDQ Picker chhose a data beat for Write Request. |
| 9 | `InBandBytEnSdp1` | Received in-band byte enable on SDP1 Originator Data channel. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 8 | `PrbRspBypSdp1` | ORIGDQ Bypass for Probe Response for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 7 | `WrBypSdp1` | ORIGDQ Bypass for Write Request from SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 6 | `PrbRspAllocSdp1` | ORIGDQ Allocation from Probe Response from SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 5 | `WrAllocSdp1` | ORIGDQ Allocation from Write Request from SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 4 | `InBandBytEnSdp0` | Reset: 0. Received in-band byte enable on SDP0 Originator Data channel. |
| 3 | `PrbRspBypSdp0` | Reset: 0. ORIGDQ Bypass for Probe Response for SDP0. |
| 2 | `WrBypSdp0` | Reset: 0. ORIGDQ Bypass for Write Request from SDP0. |
| 1 | `PrbRspAllocSdp0` | Reset: 0. ORIGDQ Allocation from Probe Response from SDP0. |
| 0 | `WrAllocSdp0` | Reset: 0. ORIGDQ Allocation from Write Request from SDP0. |


## DFPMCx00000[40...6C]A — DF/CCM — CCM PICK_PRI Priority Picker

**Symbolic:** `DF::PMC::CCM::CCM_PICK_PRI`  
**Instance:** `_instACM0; DFPMCx0000060A _instACM1; DFPMCx0000064A _instACM2; DFPMCx0000068A _instACM3; DFPMCx000006CA _instCCM0; DFPMCx0000040A _instCCM1; DFPMCx0000044A _instCCM2; DFPMCx0000048A _instCCM3; DFPMCx000004CA _instCCM4; DFPMCx0000050A _instCCM5; DFPMCx0000054A _instCCM6; DFPMCx0000058A _instCCM7; DFPMCx000005CA`

Medium priority request was picked over a High priority request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `MedWon` | Reset: 0. Medium priority request was picked over a High priority request. |
| 5 | `LoWon` | Reset: 0. Low priority request was picked over a higher (Medium or High) priority request. |
| 3 | `HiLost` | Reset: 0. High priority request was skipped in favor of a lower (Low or Medium) priority request. |
| 2 | `MedLost` | Reset: 0. Medium priority request was skipped in favor of a Low priority request. |
| 0 | `BypBlockedPri` | Reset: 0. Request bypass is blocked due to the existence of a higher priority request in REQQ. |


## DFPMCx00000[40...6C]B — DF/CCM — CCM REQA Request Type (DRAM)

**Symbolic:** `DF::PMC::CCM::CCM_REQA`  
**Instance:** `_instACM0; DFPMCx0000060B _instACM1; DFPMCx0000064B _instACM2; DFPMCx0000068B _instACM3; DFPMCx000006CB _instCCM0; DFPMCx0000040B _instCCM1; DFPMCx0000044B _instCCM2; DFPMCx0000048B _instCCM3; DFPMCx000004CB _instCCM4; DFPMCx0000050B _instCCM5; DFPMCx0000054B _instCCM6; DFPMCx0000058B _instCCM7; DFPMCx000005CB`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 7:5 | `NodeId` | Reset: 0h. Select target Node ID. Value Description 0h Request target Node 0. 7h-1h Reserved. |
| 4 | `WrSzOrd` | Reset: 0. Specifies whether WrSized request is ordered. |
| 3:0 | `Type` | Reset: 0h. Select type of request. Value Description 0h Disabled, no transaction selected. 1h RdBlkL. 2h RdBlkS. 3h RdBlkX. 4h RdBlkC. 5h Any RdBlk. 6h SpecDramRd Or PrbAsReq . 7h RdSized (coherent). 8h RdSizedNC. 9h WrSized (coherent). Ah WrSizedFull. Bh WrSizedFullZero. Ch WrSizedNC. Dh WrSizedFullNC. Eh Reserved. Fh Any DRAM transaction. |


## DFPMCx00000[40...6C]C — DF/CCM — CCM REQB Request Type (IO Requests and Cache-related Requests)

**Symbolic:** `DF::PMC::CCM::CCM_REQB`  
**Instance:** `_instACM0; DFPMCx0000060C _instACM1; DFPMCx0000064C _instACM2; DFPMCx0000068C _instACM3; DFPMCx000006CC _instCCM0; DFPMCx0000040C _instCCM1; DFPMCx0000044C _instCCM2; DFPMCx0000048C _instCCM3; DFPMCx000004CC _instCCM4; DFPMCx0000050C _instCCM5; DFPMCx0000054C _instCCM6; DFPMCx0000058C _instCCM7; DFPMCx000005CC`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 7:5 | `NodeId` | Reset: 0h. Select target Node ID. Value Description 0h Request target Node 0. 7h-1h Reserved. |
| 3:0 | `Type` | Reset: 0h. Select type of request. Value Description 0h Disabled, no transaction selected. 1h Any RdSized. 2h WrSizedNC posted. 3h WrSizedFullNC posted. 4h WrSizedNC non-posted. 5h WrSizedFullNC non-posted. 6h Any WrSized. 7h Any IO Request. 8h ClnBlkAll. 9h VicBlkCln (on either FtiReqSrc channel). Ah VicBlkFull. Bh VicBlkFullZero. Ch WbInvBlkAll. Dh ValBlk. Eh ChgToX or ChgToXNR. Fh SuperPrb Victim. |


## DFPMCx00000[40...6C]F — DF/CCM — CCM WAITACK_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_WAITACK_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx0000060F _instACM1; DFPMCx0000064F _instACM2; DFPMCx0000068F _instACM3; DFPMCx000006CF _instCCM0; DFPMCx0000040F _instCCM1; DFPMCx0000044F _instCCM2; DFPMCx0000048F _instCCM3; DFPMCx000004CF _instCCM4; DFPMCx0000050F _instCCM5; DFPMCx0000054F _instCCM6; DFPMCx0000058F _instCCM7; DFPMCx000005CF`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[41...5D]A — DF/CCM — CCM SDP1_READY SDP Ready

**Symbolic:** `DF::PMC::CCM::CCM_SDP1_READY`  
**Instance:** `_instCCM0; DFPMCx0000041A _instCCM1; DFPMCx0000045A _instCCM2; DFPMCx0000049A _instCCM3; DFPMCx000004DA _instCCM4; DFPMCx0000051A _instCCM5; DFPMCx0000055A _instCCM6; DFPMCx0000059A _instCCM7; DFPMCx000005DA`

Note that unless DF::PwrMgtCfg0 [ ClkGateDis ] is set, Rdy=0 events may not be reported if CCM is Idle and is clock-gated.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RawReady` | Reset: 0. Determines when PCS or VDCI is ready whenever CCM is ready to send. |
| 6:4 | `RdySel` | Reset: 0h. Select SDP channel. Value Description 0h Any. 1h SDP RdRsp Rdy. 2h SDP WrRsp Rdy. 3h SDP ReqCredit Rdy. 4h SDP OrigDataCredit Rdy. 5h SDP Prb Rdy. 6h SDP PrbRspCredit Rdy. 7h SDP AckCredit Rdy. |
| 1:0 | `Mode` | Reset: 0h. Mode Value Description 0h Count all cycles (subject to RawReady) where PCS is not asserting ready. 1h Count all cycles (subject to RawReady) where PCS has not asserted ready for 16 or more cycles. 2h Count events where ready deasserted for 16 cycles or more (not subject to RawReady). 3h Reserved. |


## DFPMCx00000[41...5D]B — DF/CCM — CCM GMI_FOLD GMI3 link folding stats

**Symbolic:** `DF::PMC::CCM::CCM_GMI_FOLD`  
**Instance:** `_instCCM0; DFPMCx0000041B _instCCM1; DFPMCx0000045B _instCCM2; DFPMCx0000049B _instCCM3; DFPMCx000004DB _instCCM4; DFPMCx0000051B _instCCM5; DFPMCx0000055B _instCCM6; DFPMCx0000059B _instCCM7; DFPMCx000005DB`

Selects SDP ports

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:5 | `SDPPortSel` | Reset: 0h. Selects SDP ports Value Description 0h None of SDP port is selected. 1h Only SDP port 0 is selected. 2h Only SDP port 1 is selected. 3h Both SDP ports is selected. |
| 4 | `TxLinkSel` | Reset: 0. Selects outboound GMI link. |
| 3 | `RxLinkSel` | Reset: 0. Selects inbound GMI link. |
| 2:0 | `Mode` | Reset: 0h. Mode Value Description 0h Count number of cycles when link folding is requested. 1h Count number of Folding request (Unfold -> Fold transition). 2h Count number of cycle when selected channel's causing Emergency Full. 3h Count number of Emergency Full assertions. 4h Count number of cycles Folding is requested and PCS is yet to assert IsFolded. 5h Count number of cycles Un-Folding is requested and PCS is yet to de-assert IsFolded. 6h Count number of cycle when High Queue occupancy is preventing folding. 7h Count number of cycle when urgent QOS response is preventing folding. |


## DFPMCx00000[41...5D]D — DF/CCM — CCM PROBES1 Memory Probes and Probe Responses for SDP1 and FTI1 channel

**Symbolic:** `DF::PMC::CCM::CCM_PROBES1`  
**Instance:** `_instCCM0; DFPMCx0000041D _instCCM1; DFPMCx0000045D _instCCM2; DFPMCx0000049D _instCCM3; DFPMCx000004DD _instCCM4; DFPMCx0000051D _instCCM5; DFPMCx0000055D _instCCM6; DFPMCx0000059D _instCCM7; DFPMCx000005DD`

Counts the number of FTI probe requests TAPs received on this FTI channel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `TapRx` | Reset: 0. Counts the number of FTI probe requests TAPs received on this FTI channel. |
| 10 | `TapAlloc` | Reset: 0. Counts the number of FTI probe requests TAPs allocated in TAPQ. |
| 9 | `TapDemandColl` | Reset: 0. Counts the number of FTI demand probe requests that collides (are serviced by) TAPs. |
| 8 | `McastPrbRspSrcD` | Reset: 0. Sent 3-hop PrbRspD for a multi-cast probe. |
| 7 | `PrbRspDataXferSel` | Reset: 0. Data Transfer selector for probe response count. |
| 6:4 | `PrbRspStatePDSel` | Reset: 0h. {State[1:0],PassDirty} selector for probe response count. |
| 3:2 | `PrbRspSel` | Reset: 0h. Probe Response Selector. Value Description 0h Disabled, no SDP probe response counted. 1h Count SDP probe responses matching PrbRspStatePDSel field. 2h Count SDP probe responses matching PrbRspDataXferSel field. 3h Count all SDP probe responses. |
| 1:0 | `PrbReqSel` | Reset: 0h. Probe Request Selector. Value Description 0h Disabled, no FTI probe requests counted. 1h Count FTI Probe Request with Rsp2Tgt=0 (3-hop probe request). 2h Count FTI Probe Request with Rsp2Tgt=1 (4-hop probe request). 3h Count all FTI probe requests. |


## DFPMCx00000[41...5D]F — DF/CCM — CCM DATA_BW1 SDP Bandwidth

**Symbolic:** `DF::PMC::CCM::CCM_DATA_BW1`  
**Instance:** `_instCCM0; DFPMCx0000041F _instCCM1; DFPMCx0000045F _instCCM2; DFPMCx0000049F _instCCM3; DFPMCx000004DF _instCCM4; DFPMCx0000051F _instCCM5; DFPMCx0000055F _instCCM6; DFPMCx0000059F _instCCM7; DFPMCx000005DF`

All-zero cachelines may not be captured by write b/w monitor.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SrcDstDieProx` | Reset: 0h. Select transactions based on the die proximity of the source/destination Value Description 0h Disabled. No transactions selected 1h Count only transactions with source/destination on Local cluster 2h Count only transactions with source/destination on Remote cluster 3h Count any transaction, regardless of source/destination cluster proximity |
| 5:2 | `SrcDst` | Reset: 0h. Select transactions based on the source/dest of the data - UMC, CXL™, IO, CPU (cache). Multi-bit selects are also possible. Value Description 0h Disabled. No transactions selected 1h Count only data beats from CPU (cache). For Reads only. 2h Count only data beats to/from UMC 3h Reserved. 4h Count only data beats to/from IO 7h-5h Reserved. 8h Count only data beats to/from CXL Eh-9h Reserved. Fh Count any transaction, regardless of source |
| 1 | `ModeSel` | Reset: 0. 0= Source mode: Attributes in [11:2] are used to match the actual source of data (originator of the consumed response) . 1= Home mode: Attributes in [11:2] are used to match the home of data (destination of the read). Select between Source mode and Home mode for Read Responses. For Writes (TxnType == 1), only Home mode is applicable |
| 0 | `TxnType` | Reset: 0. 0= Count Read Response Data Beats . 1= Count Write Data Beats . Select Transaction Type. |


## DFPMCx00000[41...6D]0 — DF/CCM — CCM VQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_VQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000610 _instACM1; DFPMCx00000650 _instACM2; DFPMCx00000690 _instACM3; DFPMCx000006D0 _instCCM0; DFPMCx00000410 _instCCM1; DFPMCx00000450 _instCCM2; DFPMCx00000490 _instCCM3; DFPMCx000004D0 _instCCM4; DFPMCx00000510 _instCCM5; DFPMCx00000550 _instCCM6; DFPMCx00000590 _instCCM7; DFPMCx000005D0`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[41...6D]1 — DF/CCM — CCM VQ_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_VQ_STAT`  
**Instance:** `_instACM0; DFPMCx00000611 _instACM1; DFPMCx00000651 _instACM2; DFPMCx00000691 _instACM3; DFPMCx000006D1 _instCCM0; DFPMCx00000411 _instCCM1; DFPMCx00000451 _instCCM2; DFPMCx00000491 _instCCM3; DFPMCx000004D1 _instCCM4; DFPMCx00000511 _instCCM5; DFPMCx00000551 _instCCM6; DFPMCx00000591 _instCCM7; DFPMCx000005D1`

Selects events which killed VQ pipeline.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `Pipekill` | Reset: 0h. Selects events which killed VQ pipeline. Value Description 0h Disabled. No pipekill event. 1h VQ WrRsp killed due to unavailable SDP buffer. 2h VQ WrRsp killed due to unavailable WAITACK buffer. 3h VQ WrRsp killed due to any reason. 4h VQ SrcDn killed due to unavailable FTI buffers. 5h num_sdp > 1 ? VQ WrRsp killed due to unavailable SDP buffer. : Reserved. 6h num_sdp > 1 ? VQ WrRsp killed due to unavailable WAITACK buffer. : Reserved. 7h num_sdp > 1 ? VQ WrRsp killed due to any reason. : Reserved. |
| 4 | `SrcDnPick` | Reset: 0. VQ SrcDn Pick. |
| 3 | `WrRspPickSdp1` | VQ WrRsp Pick from SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 2 | `AllocateSdp1` | VQ Allocates from SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 1 | `WrRspPickSdp0` | Reset: 0. VQ WrRsp Pick from SDP0. |
| 0 | `AllocateSdp0` | Reset: 0. VQ Allocates from SDP0. |


## DFPMCx00000[41...6D]2 — DF/CCM — CCM REQ_ELV_PRI Requests with Elevated Priority

**Symbolic:** `DF::PMC::CCM::CCM_REQ_ELV_PRI`  
**Instance:** `_instACM0; DFPMCx00000612 _instACM1; DFPMCx00000652 _instACM2; DFPMCx00000692 _instACM3; DFPMCx000006D2 _instCCM0; DFPMCx00000412 _instCCM1; DFPMCx00000452 _instCCM2; DFPMCx00000492 _instCCM3; DFPMCx000004D2 _instCCM4; DFPMCx00000512 _instCCM5; DFPMCx00000552 _instCCM6; DFPMCx00000592 _instCCM7; DFPMCx000005D2`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 7 | `EpaSdpHiPri` | Reset: 0. EPA sent for non-Low SDP QOS priority requests. |
| 6 | `EpaLLTO` | Reset: 0. EPA sent from LLTO request. |
| 5 | `EpaElvRdBlkC` | Reset: 0. EPA sent from elevated RdBlkC request. |
| 4 | `EpaElvRdBlkX` | Reset: 0. EPA sent from elevated RdBlkX request. |
| 3 | `QosKillPipe` | Reset: 0. QoS request killed REQQ pipeline to favor LLTO. This counts per-CCM, so SdpSelect is ignored. |
| 2 | `ReqBypLLTO` | Reset: 0. Elevated LLTO took REQQ bypass. |
| 1 | `ReqBypElvRdBlkX` | Reset: 0. Elevated RdBlkX took REQQ bypass. |
| 0 | `ReqBypElvRdBlkC` | Reset: 0. Elevated RdBlkC took REQQ bypass. |


## DFPMCx00000[41...6D]3 — DF/CCM — CCM SPVQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::CCM::CCM_SPVQ_OCCPNCY`  
**Instance:** `_instACM0; DFPMCx00000613 _instACM1; DFPMCx00000653 _instACM2; DFPMCx00000693 _instACM3; DFPMCx000006D3 _instCCM0; DFPMCx00000413 _instCCM1; DFPMCx00000453 _instCCM2; DFPMCx00000493 _instCCM3; DFPMCx000004D3 _instCCM4; DFPMCx00000513 _instCCM5; DFPMCx00000553 _instCCM6; DFPMCx00000593 _instCCM7; DFPMCx000005D3`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[41...6D]4 — DF/CCM — CCM SUPERPRB_STAT Queue Statistics

**Symbolic:** `DF::PMC::CCM::CCM_SUPERPRB_STAT`  
**Instance:** `_instACM0; DFPMCx00000614 _instACM1; DFPMCx00000654 _instACM2; DFPMCx00000694 _instACM3; DFPMCx000006D4 _instCCM0; DFPMCx00000414 _instCCM1; DFPMCx00000454 _instCCM2; DFPMCx00000494 _instCCM3; DFPMCx000004D4 _instCCM4; DFPMCx00000514 _instCCM5; DFPMCx00000554 _instCCM6; DFPMCx00000594 _instCCM7; DFPMCx000005D4`

Number of cycles Super Probe is waiting for VicRes.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10 | `SuperPrbWaitVicRes` | Reset: 0. Number of cycles Super Probe is waiting for VicRes. |
| 8 | `SPVQNoFtiTok` | Reset: 0. SPVQ request killed due to unavailable FTI buffer. |
| 7 | `SuperPrbWaitPrbResSdp1` | Number of cycles Super Probe is waiting for PrbRes for SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 6 | `Sdp1PrbRspNoData` | SDP1 PrbRsp for SuperProbe with no-data. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 5 | `Sdp1PrbReq` | SDP1 PrbReq for SuperProbe. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 4 | `AllocateSdp1` | SPVQ Allocates from SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 3 | `SuperPrbWaitPrbResSdp0` | Reset: 0. Number of cycles Super Probe is waiting for PrbRes for SDP0. |
| 2 | `Sdp0PrbRspNoData` | Reset: 0. SDP0 PrbRsp for SuperProbe with no-data. |
| 1 | `Sdp0PrbReq` | Reset: 0. SDP0 PrbReq for SuperProbe. |
| 0 | `AllocateSdp0` | Reset: 0. SPVQ Allocates from SDP0. |


## DFPMCx00000[41...6D]5 — DF/CCM — CCM PROBES2 Probes 2

**Symbolic:** `DF::PMC::CCM::CCM_PROBES2`  
**Instance:** `_instACM0; DFPMCx00000615 _instACM1; DFPMCx00000655 _instACM2; DFPMCx00000695 _instACM3; DFPMCx000006D5 _instCCM0; DFPMCx00000415 _instCCM1; DFPMCx00000455 _instCCM2; DFPMCx00000495 _instCCM3; DFPMCx000004D5 _instCCM4; DFPMCx00000515 _instCCM5; DFPMCx00000555 _instCCM6; DFPMCx00000595 _instCCM7; DFPMCx000005D5`

Received a Line Super Probe for FTI1.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `LineSuperFti1` | Reset: 0. Received a Line Super Probe for FTI1. |
| 10 | `SuperDemoteFti1` | Reset: 0. Received a Demoting Super Probe for FTI1. |
| 9 | `InvSuperFti1` | Reset: 0. Received a Inv Super Probe for FTI1. |
| 8 | `SrcCcmMcastNoBpFti1` | Reset: 0. Received probe request on FtiPrb1Tgt with BP=0, Mcast=1, PrbFabId=myFabId. |
| 7 | `LineSuperFti0` | Reset: 0. Received a Line Super Probe for FTI0. |
| 6 | `SuperDemoteFti0` | Reset: 0. Received a Demoting Super Probe for FTI0. |
| 5 | `InvSuperFti0` | Reset: 0. Received a Inv Super Probe for FTI0. |
| 4 | `SrcCcmMcastNoBpFti0` | Reset: 0. Received probe request on FtiPrb0Tgt with BP=0, Mcast=1, PrbFabId=myFabId. |
| 3 | `PrbCollisionFailSdp1` | Number of times Probe requests fail address collision check with VicBlkCln. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 2 | `VicCollisionFailSdp1` | Number of times VicBlkCln requests fail address collision check with Probes. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 1 | `PrbCollisionFailSdp0` | Reset: 0. Number of times Probe requests fail address collision check with VicBlkCln. |
| 0 | `VicCollisionFailSdp0` | Reset: 0. Number of times VicBlkCln requests fail address collision check with Probes. |


## DFPMCx00000[41...6D]6 — DF/CCM — CCM RSPQ_STAT2 Queue Statistics 2

**Symbolic:** `DF::PMC::CCM::CCM_RSPQ_STAT2`  
**Instance:** `_instACM0; DFPMCx00000616 _instACM1; DFPMCx00000656 _instACM2; DFPMCx00000696 _instACM3; DFPMCx000006D6 _instCCM0; DFPMCx00000416 _instCCM1; DFPMCx00000456 _instCCM2; DFPMCx00000496 _instCCM3; DFPMCx000004D6 _instCCM4; DFPMCx00000516 _instCCM5; DFPMCx00000556 _instCCM6; DFPMCx00000596 _instCCM7; DFPMCx000005D6`

Selects RSPQ Arbiter events.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `RspQArb` | Reset: 0h. Selects RSPQ Arbiter events. Value Description 0h Disabled. 1h (ccm__vq_present==0) ? Reserved. : Number of cycles RSPQ WrRsp ready, but blocked by SDP WrRsp arbiter. 2h Number of cycles RSPQ SrcDn ready, but blocked by FTI RspSrc arbiter. 3h (fti_rspnd_src_present==1) ? Number of cycles RSPQ SrcDn ready, but blocked by FTI RspNdSrc arbiter. : Reserved. 4h (ccm__vq_present==0) ? Reserved. : (num_sdp > 1) ? Number of cycles RSPQ WrRsp ready, but blocked by SDP WrRsp arbiter. : Reserved. 7h-5h Reserved. |
| 4:2 | `RdRspRx` | Reset: 0h. Selects types of Read Responses received. Value Description 0h Disabled. 1h Received TgtDnD, no PrbRspD. 2h Reserved. 3h Last TgtDnD beat received before last PrbRspD beat. 4h Last TgtDnD beat received after last PrbRspD beat. 5h SDP0 RdRsp with no data. 6h num_sdp > 1 ? SDP1 RdRsp with no data. : Reserved. 7h Received 64B response from IOS. |
| 1 | `WrRspLocalSdp1` | Indicates local write response on SDP1. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 0 | `WrRspLocalSdp0` | Reset: 0. Indicates local write response on SDP0. |


## DFPMCx00000[41...6D]7 — DF/CCM — CCM PROBES3 Probes 3

**Symbolic:** `DF::PMC::CCM::CCM_PROBES3`  
**Instance:** `_instACM0; DFPMCx00000617 _instACM1; DFPMCx00000657 _instACM2; DFPMCx00000697 _instACM3; DFPMCx000006D7 _instCCM0; DFPMCx00000417 _instCCM1; DFPMCx00000457 _instCCM2; DFPMCx00000497 _instCCM3; DFPMCx000004D7 _instCCM4; DFPMCx00000517 _instCCM5; DFPMCx00000557 _instCCM6; DFPMCx00000597 _instCCM7; DFPMCx000005D7`

Selects the RspCnt of the 3-hop combined probe responses received on RspNd FTI channel that are counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:8 | `CombPrbRspNdRx` | Reset: 0h. Selects the RspCnt of the 3-hop combined probe responses received on RspNd FTI channel that are counted. Value Description 0h Disabled. Fh-1h Counts Probe Responses with (MultiRsp==1) and (RspCnt >= CombPrbRsp). |
| 7 | `Fti1PrbSteer` | Reset: 0. Counts the number of steering probes received on FTI PrbTgt1. |
| 6 | `Fti0PrbSteer` | Reset: 0. Counts the number of steering probes received on FTI PrbTgt0. |
| 5 | `FtiTapInv` | Counts the number of Invalidating TAP probes sent on FTI Prb Src channels. AccessType: _inst[ACM[3:0]]: Reserved AccessType: _inst[CCM[7:0]]: Read-write Reset: _inst[CCM[7:0]]: 0 |
| 4 | `FtiTapMig` | Reset: 0. Counts the number of Migrate TAP probes sent on FTI Prb Src channels. |
| 3 | `TapByCtp` | Reset: 0. Counts the number of TAP probes generated by CTP widget |
| 2 | `TapByHrc` | Reset: 0. Counts the number of TAP probes generated by HRC widget |
| 1 | `CtpLmtExceeded` | Reset: 0. Counts the number of times CTPLmt exceeded. CTPLmt specifies the limit for how many TAPs are launched from CTP hit within a 64 FCLK moving window. |
| 0 | `HrcLmtExceeded` | Reset: 0. Counts the number of times HRCLmt exceeded. HRCLmt specifies the limit for how many TAPs are launched from HRC hit within a 64 FCLK moving window. |


## DFPMCx00000[41...6D]8 — DF/CCM — CCM SYSRSP_LAT Profiling of system PrbRsp/TgtRsp

**Symbolic:** `DF::PMC::CCM::CCM_SYSRSP_LAT`  
**Instance:** `_instACM0; DFPMCx00000618 _instACM1; DFPMCx00000658 _instACM2; DFPMCx00000698 _instACM3; DFPMCx000006D8 _instCCM0; DFPMCx00000418 _instCCM1; DFPMCx00000458 _instCCM2; DFPMCx00000498 _instCCM3; DFPMCx000004D8 _instCCM4; DFPMCx00000518 _instCCM5; DFPMCx00000558 _instCCM6; DFPMCx00000598 _instCCM7; DFPMCx000005D8`

When CountMode is 0x1, report a sample only if the delay between TgtRsp and the last PrbRsp exceeds this threshold.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:9 | `Threshold` | Reset: 0h. When CountMode is 0x1, report a sample only if the delay between TgtRsp and the last PrbRsp exceeds this threshold. Value Description 1h-0h Reserved. 2h 50ns 3h 100ns 4h 150ns 5h 200ns 6h 500ns 7h 1us |
| 8 | `RdResponseNoData` | Reset: 0. 0= If ChToX==1, include a ChToX only if a response provided data. If OtherCmds==1, then the set of Other Commands is everything excluding RdBlkL, RdBlkX, or ChgToX (with or without data). 1= If ChToX==1, include a ChToX only if the response is no-data. If OtherCmds==1, then the set of Other Commands is limited to ONLY ValBlk and ChgToXNR. Modifies the sampling when OtherCmds or ChgToX bits are set. Behavior is undefined if either RdBlkX or RdBlkL are set and RdReponseNoData==1. |
| 7 | `OtherCmds` | Reset: 0. Command type transaction filter. Include other requests which launch probes. |
| 6 | `ChgToX` | Reset: 0. Command type transaction filter. Include ChgToX FTI requests. |
| 5 | `RdBlkX` | Reset: 0. Command type transaction filter. Include RdBlkX FTI requests. |
| 4 | `RdBlkL` | Reset: 0. Command type transaction filter. Include RdBlkL FTI requests. |
| 3 | `Remote` | Reset: 0. Include last probe response misses which arrive from remote nodes. See DEDFRTL-10039 for note regarding the effects of DF::TcdxConfig [ RspCmbEn ]. |
| 2 | `Local` | Reset: 0. Include last probe response misses which arrive from the local node. See DEDFRTL-10039 for note regarding the effects of DF::TcdxConfig [ RspCmbEn ]. |
| 1:0 | `CountMode` | Reset: 0h. Selects the perfmon reporting mode. Value Description 0h Count Samples. 1h Count Samples which exceed delay threshold. 2h Simple count of the number last system responses which were misses on the primary channel. 3h Simple count of the number last system responses which were misses on the secondary (ND) channel. |


## DFPMCx00000[41...6D]9 — DF/CCM — CCM SDP0_READY SDP Ready

**Symbolic:** `DF::PMC::CCM::CCM_SDP0_READY`  
**Instance:** `_instACM0; DFPMCx00000619 _instACM1; DFPMCx00000659 _instACM2; DFPMCx00000699 _instACM3; DFPMCx000006D9 _instCCM0; DFPMCx00000419 _instCCM1; DFPMCx00000459 _instCCM2; DFPMCx00000499 _instCCM3; DFPMCx000004D9 _instCCM4; DFPMCx00000519 _instCCM5; DFPMCx00000559 _instCCM6; DFPMCx00000599 _instCCM7; DFPMCx000005D9`

Note that unless DF::PwrMgtCfg0 [ ClkGateDis ] is set, Rdy=0 events may not be reported if CCM is Idle and is clock-gated.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RawReady` | Reset: 0. Determines when PCS or VDCI is ready whenever CCM is ready to send. |
| 6:4 | `RdySel` | Reset: 0h. Select SDP channel. Value Description 0h Any. 1h SDP RdRsp Rdy. 2h SDP WrRsp Rdy. 3h SDP ReqCredit Rdy. 4h SDP OrigDataCredit Rdy. 5h SDP Prb Rdy. 6h SDP PrbRspCredit Rdy. 7h SDP AckCredit Rdy. |
| 1:0 | `Mode` | Reset: 0h. Mode Value Description 0h Count all cycles (subject to RawReady) where PCS is not asserting ready. 1h Count all cycles (subject to RawReady) where PCS has not asserted ready for 16 or more cycles. 2h Count events where ready deasserted for 16 cycles or more (not subject to RawReady). 3h Reserved. |


## DFPMCx00000[41...6D]C — DF/CCM — CCM REQA_ND Request Type (DRAM)

**Symbolic:** `DF::PMC::CCM::CCM_REQA_ND`  
**Instance:** `_instACM0; DFPMCx0000061C _instACM1; DFPMCx0000065C _instACM2; DFPMCx0000069C _instACM3; DFPMCx000006DC _instCCM0; DFPMCx0000041C _instCCM1; DFPMCx0000045C _instCCM2; DFPMCx0000049C _instCCM3; DFPMCx000004DC _instCCM4; DFPMCx0000051C _instCCM5; DFPMCx0000055C _instCCM6; DFPMCx0000059C _instCCM7; DFPMCx000005DC`

Specifies which SDP port to count in queue occupancy.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SdpSelect` | Reset: 0. 0= SDP0 . 1= (num_sdp>1) ? SDP1 : Reserved. Specifies which SDP port to count in queue occupancy. |
| 7:5 | `NodeId` | Reset: 0h. Select target Node ID. Value Description 0h Request target Node 0. 7h-1h Reserved. |
| 3:0 | `Type` | Reset: 0h. Select type of request. Value Description 0h Disabled, no transaction selected. 1h RdBlkL. 2h RdBlkS. 3h RdBlkX. 4h RdBlkC. 5h Any RdBlk. 6h SpecDramRd Or PrbAsReq . 8h-7h Reserved. 9h VicBlkCln on the secondary request channel Eh-Ah Reserved. Fh Any DRAM transaction. |


## DFPMCx00000[41...6D]E — DF/CCM — CCM DATA_BW0 SDP Bandwidth

**Symbolic:** `DF::PMC::CCM::CCM_DATA_BW0`  
**Instance:** `_instACM0; DFPMCx0000061E _instACM1; DFPMCx0000065E _instACM2; DFPMCx0000069E _instACM3; DFPMCx000006DE _instCCM0; DFPMCx0000041E _instCCM1; DFPMCx0000045E _instCCM2; DFPMCx0000049E _instCCM3; DFPMCx000004DE _instCCM4; DFPMCx0000051E _instCCM5; DFPMCx0000055E _instCCM6; DFPMCx0000059E _instCCM7; DFPMCx000005DE`

All-zero cachelines may not be captured by write b/w monitor.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SrcDstDieProx` | Reset: 0h. Select transactions based on the die proximity of the source/destination Value Description 0h Disabled. No transactions selected 1h Count only transactions with source/destination on Local cluster 2h Count only transactions with source/destination on Remote cluster 3h Count any transaction, regardless of source/destination cluster proximity |
| 5:2 | `SrcDst` | Reset: 0h. Select transactions based on the source/dest of the data - UMC, CXL™, IO, CPU (cache). Multi-bit selects are also possible. Value Description 0h Disabled. No transactions selected 1h Count only data beats from CPU (cache). For Reads only. 2h Count only data beats to/from UMC 3h Reserved. 4h Count only data beats to/from IO 7h-5h Reserved. 8h Count only data beats to/from CXL Eh-9h Reserved. Fh Count any transaction, regardless of source |
| 1 | `ModeSel` | Reset: 0. 0= Source mode: Attributes in [11:2] are used to match the actual source of data (originator of the consumed response) . 1= Home mode: Attributes in [11:2] are used to match the home of data (destination of the read). Select between Source mode and Home mode for Read Responses. For Writes (TxnType == 1), only Home mode is applicable |
| 0 | `TxnType` | Reset: 0. 0= Count Read Response Data Beats . 1= Count Write Data Beats . Select Transaction Type. |


## DFPMCx00000[42...6E]0 — DF/CCM — PRB_SDP Average Latency Transaction Count

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_AVG_LAT_TRANS_CNT`  
**Instance:** `_instACM0; DFPMCx00000620 _instACM1; DFPMCx00000660 _instACM2; DFPMCx000006A0 _instACM3; DFPMCx000006E0 _instCCM0; DFPMCx00000420 _instCCM1; DFPMCx00000460 _instCCM2; DFPMCx000004A0 _instCCM3; DFPMCx000004E0 _instCCM4; DFPMCx00000520 _instCCM5; DFPMCx00000560 _instCCM6; DFPMCx000005A0 _instCCM7; DFPMCx000005E0`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]1 — DF/CCM — PRB_SDP Average Latency Cycle Count

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instACM0; DFPMCx00000621 _instACM1; DFPMCx00000661 _instACM2; DFPMCx000006A1 _instACM3; DFPMCx000006E1 _instCCM0; DFPMCx00000421 _instCCM1; DFPMCx00000461 _instCCM2; DFPMCx000004A1 _instCCM3; DFPMCx000004E1 _instCCM4; DFPMCx00000521 _instCCM5; DFPMCx00000561 _instCCM6; DFPMCx000005A1 _instCCM7; DFPMCx000005E1`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]2 — DF/CCM — PRB_SDP Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_LAT_HIST_GT50`  
**Instance:** `_instACM0; DFPMCx00000622 _instACM1; DFPMCx00000662 _instACM2; DFPMCx000006A2 _instACM3; DFPMCx000006E2 _instCCM0; DFPMCx00000422 _instCCM1; DFPMCx00000462 _instCCM2; DFPMCx000004A2 _instCCM3; DFPMCx000004E2 _instCCM4; DFPMCx00000522 _instCCM5; DFPMCx00000562 _instCCM6; DFPMCx000005A2 _instCCM7; DFPMCx000005E2`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]3 — DF/CCM — PRB_SDP Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_LAT_HIST_GT100`  
**Instance:** `_instACM0; DFPMCx00000623 _instACM1; DFPMCx00000663 _instACM2; DFPMCx000006A3 _instACM3; DFPMCx000006E3 _instCCM0; DFPMCx00000423 _instCCM1; DFPMCx00000463 _instCCM2; DFPMCx000004A3 _instCCM3; DFPMCx000004E3 _instCCM4; DFPMCx00000523 _instCCM5; DFPMCx00000563 _instCCM6; DFPMCx000005A3 _instCCM7; DFPMCx000005E3`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]4 — DF/CCM — PRB_SDP Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_LAT_HIST_GT150`  
**Instance:** `_instACM0; DFPMCx00000624 _instACM1; DFPMCx00000664 _instACM2; DFPMCx000006A4 _instACM3; DFPMCx000006E4 _instCCM0; DFPMCx00000424 _instCCM1; DFPMCx00000464 _instCCM2; DFPMCx000004A4 _instCCM3; DFPMCx000004E4 _instCCM4; DFPMCx00000524 _instCCM5; DFPMCx00000564 _instCCM6; DFPMCx000005A4 _instCCM7; DFPMCx000005E4`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]5 — DF/CCM — PRB_SDP Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_LAT_HIST_GT200`  
**Instance:** `_instACM0; DFPMCx00000625 _instACM1; DFPMCx00000665 _instACM2; DFPMCx000006A5 _instACM3; DFPMCx000006E5 _instCCM0; DFPMCx00000425 _instCCM1; DFPMCx00000465 _instCCM2; DFPMCx000004A5 _instCCM3; DFPMCx000004E5 _instCCM4; DFPMCx00000525 _instCCM5; DFPMCx00000565 _instCCM6; DFPMCx000005A5 _instCCM7; DFPMCx000005E5`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]6 — DF/CCM — PRB_SDP Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_LAT_HIST_GT500`  
**Instance:** `_instACM0; DFPMCx00000626 _instACM1; DFPMCx00000666 _instACM2; DFPMCx000006A6 _instACM3; DFPMCx000006E6 _instCCM0; DFPMCx00000426 _instCCM1; DFPMCx00000466 _instCCM2; DFPMCx000004A6 _instCCM3; DFPMCx000004E6 _instCCM4; DFPMCx00000526 _instCCM5; DFPMCx00000566 _instCCM6; DFPMCx000005A6 _instCCM7; DFPMCx000005E6`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[42...6E]7 — DF/CCM — PRB_SDP Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::CCM::CCM_PRB_SDP_LAT_HIST_GT1000`  
**Instance:** `_instACM0; DFPMCx00000627 _instACM1; DFPMCx00000667 _instACM2; DFPMCx000006A7 _instACM3; DFPMCx000006E7 _instCCM0; DFPMCx00000427 _instCCM1; DFPMCx00000467 _instCCM2; DFPMCx000004A7 _instCCM3; DFPMCx000004E7 _instCCM4; DFPMCx00000527 _instCCM5; DFPMCx00000567 _instCCM6; DFPMCx000005A7 _instCCM7; DFPMCx000005E7`

Selects sub-channel of the probe being tracked.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the probe being tracked. |
| 7 | `SelPrbRspDLstRsp` | 0= Count latency until last response. 1= Count latency until last response or PrbRspD is received. Select PrbRspD as last response |
| 6:4 | `SelRD` | Select Return Data encoding. Value Description 0h Counts when SDP PrbReq RD==00. 1h Counts when SDP PrbReq RD==01. 2h Counts when SDP PrbReq RD==10. 3h Counts when SDP PrbReq RD==11. 7h-4h Ignore the value of SDP PrbReq RD. |
| 3:0 | `SelAction` | Select Probe Action encoding. Value Description 7h-0h Match based on SDP PrbReq Action. 8h All coherency probes, where SDP PrbReq Action[MSB]==0. Ah-9h Reserved. Bh SDP PrbReq Action. Ch Reserved. Dh Demoting line probe. Eh Reserved. Fh All Probes requiring a response (excludes broadcast without response and DVM probes). |


## DFPMCx00000[43...6F]0 — DF/CCM — Average Latency Transaction Count

**Symbolic:** `DF::PMC::CCM::CCM_SDP_AVG_LAT_TRANS_CNT`  
**Instance:** `_instACM0; DFPMCx00000630 _instACM1; DFPMCx00000670 _instACM2; DFPMCx000006B0 _instACM3; DFPMCx000006F0 _instCCM0; DFPMCx00000430 _instCCM1; DFPMCx00000470 _instCCM2; DFPMCx000004B0 _instCCM3; DFPMCx000004F0 _instCCM4; DFPMCx00000530 _instCCM5; DFPMCx00000570 _instCCM6; DFPMCx000005B0 _instCCM7; DFPMCx000005F0`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]1 — DF/CCM — Average Latency Cycle Count

**Symbolic:** `DF::PMC::CCM::CCM_SDP_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instACM0; DFPMCx00000631 _instACM1; DFPMCx00000671 _instACM2; DFPMCx000006B1 _instACM3; DFPMCx000006F1 _instCCM0; DFPMCx00000431 _instCCM1; DFPMCx00000471 _instCCM2; DFPMCx000004B1 _instCCM3; DFPMCx000004F1 _instCCM4; DFPMCx00000531 _instCCM5; DFPMCx00000571 _instCCM6; DFPMCx000005B1 _instCCM7; DFPMCx000005F1`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]2 — DF/CCM — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::CCM::CCM_SDP_LAT_HIST_GT50`  
**Instance:** `_instACM0; DFPMCx00000632 _instACM1; DFPMCx00000672 _instACM2; DFPMCx000006B2 _instACM3; DFPMCx000006F2 _instCCM0; DFPMCx00000432 _instCCM1; DFPMCx00000472 _instCCM2; DFPMCx000004B2 _instCCM3; DFPMCx000004F2 _instCCM4; DFPMCx00000532 _instCCM5; DFPMCx00000572 _instCCM6; DFPMCx000005B2 _instCCM7; DFPMCx000005F2`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]3 — DF/CCM — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::CCM::CCM_SDP_LAT_HIST_GT100`  
**Instance:** `_instACM0; DFPMCx00000633 _instACM1; DFPMCx00000673 _instACM2; DFPMCx000006B3 _instACM3; DFPMCx000006F3 _instCCM0; DFPMCx00000433 _instCCM1; DFPMCx00000473 _instCCM2; DFPMCx000004B3 _instCCM3; DFPMCx000004F3 _instCCM4; DFPMCx00000533 _instCCM5; DFPMCx00000573 _instCCM6; DFPMCx000005B3 _instCCM7; DFPMCx000005F3`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]4 — DF/CCM — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::CCM::CCM_SDP_LAT_HIST_GT150`  
**Instance:** `_instACM0; DFPMCx00000634 _instACM1; DFPMCx00000674 _instACM2; DFPMCx000006B4 _instACM3; DFPMCx000006F4 _instCCM0; DFPMCx00000434 _instCCM1; DFPMCx00000474 _instCCM2; DFPMCx000004B4 _instCCM3; DFPMCx000004F4 _instCCM4; DFPMCx00000534 _instCCM5; DFPMCx00000574 _instCCM6; DFPMCx000005B4 _instCCM7; DFPMCx000005F4`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]5 — DF/CCM — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::CCM::CCM_SDP_LAT_HIST_GT200`  
**Instance:** `_instACM0; DFPMCx00000635 _instACM1; DFPMCx00000675 _instACM2; DFPMCx000006B5 _instACM3; DFPMCx000006F5 _instCCM0; DFPMCx00000435 _instCCM1; DFPMCx00000475 _instCCM2; DFPMCx000004B5 _instCCM3; DFPMCx000004F5 _instCCM4; DFPMCx00000535 _instCCM5; DFPMCx00000575 _instCCM6; DFPMCx000005B5 _instCCM7; DFPMCx000005F5`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]6 — DF/CCM — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::CCM::CCM_SDP_LAT_HIST_GT500`  
**Instance:** `_instACM0; DFPMCx00000636 _instACM1; DFPMCx00000676 _instACM2; DFPMCx000006B6 _instACM3; DFPMCx000006F6 _instCCM0; DFPMCx00000436 _instCCM1; DFPMCx00000476 _instCCM2; DFPMCx000004B6 _instCCM3; DFPMCx000004F6 _instCCM4; DFPMCx00000536 _instCCM5; DFPMCx00000576 _instCCM6; DFPMCx000005B6 _instCCM7; DFPMCx000005F6`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]7 — DF/CCM — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::CCM::CCM_SDP_LAT_HIST_GT1000`  
**Instance:** `_instACM0; DFPMCx00000637 _instACM1; DFPMCx00000677 _instACM2; DFPMCx000006B7 _instACM3; DFPMCx000006F7 _instCCM0; DFPMCx00000437 _instCCM1; DFPMCx00000477 _instCCM2; DFPMCx000004B7 _instCCM3; DFPMCx000004F7 _instCCM4; DFPMCx00000537 _instCCM5; DFPMCx00000577 _instCCM6; DFPMCx000005B7 _instCCM7; DFPMCx000005F7`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]8 — DF/CCM — Average Latency Transaction Count

**Symbolic:** `DF::PMC::CCM::CCM_FTI_AVG_LAT_TRANS_CNT`  
**Instance:** `_instACM0; DFPMCx00000638 _instACM1; DFPMCx00000678 _instACM2; DFPMCx000006B8 _instACM3; DFPMCx000006F8 _instCCM0; DFPMCx00000438 _instCCM1; DFPMCx00000478 _instCCM2; DFPMCx000004B8 _instCCM3; DFPMCx000004F8 _instCCM4; DFPMCx00000538 _instCCM5; DFPMCx00000578 _instCCM6; DFPMCx000005B8 _instCCM7; DFPMCx000005F8`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]9 — DF/CCM — Average Latency Cycle Count

**Symbolic:** `DF::PMC::CCM::CCM_FTI_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instACM0; DFPMCx00000639 _instACM1; DFPMCx00000679 _instACM2; DFPMCx000006B9 _instACM3; DFPMCx000006F9 _instCCM0; DFPMCx00000439 _instCCM1; DFPMCx00000479 _instCCM2; DFPMCx000004B9 _instCCM3; DFPMCx000004F9 _instCCM4; DFPMCx00000539 _instCCM5; DFPMCx00000579 _instCCM6; DFPMCx000005B9 _instCCM7; DFPMCx000005F9`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]A — DF/CCM — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::CCM::CCM_FTI_LAT_HIST_GT50`  
**Instance:** `_instACM0; DFPMCx0000063A _instACM1; DFPMCx0000067A _instACM2; DFPMCx000006BA _instACM3; DFPMCx000006FA _instCCM0; DFPMCx0000043A _instCCM1; DFPMCx0000047A _instCCM2; DFPMCx000004BA _instCCM3; DFPMCx000004FA _instCCM4; DFPMCx0000053A _instCCM5; DFPMCx0000057A _instCCM6; DFPMCx000005BA _instCCM7; DFPMCx000005FA`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]B — DF/CCM — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::CCM::CCM_FTI_LAT_HIST_GT100`  
**Instance:** `_instACM0; DFPMCx0000063B _instACM1; DFPMCx0000067B _instACM2; DFPMCx000006BB _instACM3; DFPMCx000006FB _instCCM0; DFPMCx0000043B _instCCM1; DFPMCx0000047B _instCCM2; DFPMCx000004BB _instCCM3; DFPMCx000004FB _instCCM4; DFPMCx0000053B _instCCM5; DFPMCx0000057B _instCCM6; DFPMCx000005BB _instCCM7; DFPMCx000005FB`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]C — DF/CCM — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::CCM::CCM_FTI_LAT_HIST_GT150`  
**Instance:** `_instACM0; DFPMCx0000063C _instACM1; DFPMCx0000067C _instACM2; DFPMCx000006BC _instACM3; DFPMCx000006FC _instCCM0; DFPMCx0000043C _instCCM1; DFPMCx0000047C _instCCM2; DFPMCx000004BC _instCCM3; DFPMCx000004FC _instCCM4; DFPMCx0000053C _instCCM5; DFPMCx0000057C _instCCM6; DFPMCx000005BC _instCCM7; DFPMCx000005FC`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]D — DF/CCM — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::CCM::CCM_FTI_LAT_HIST_GT200`  
**Instance:** `_instACM0; DFPMCx0000063D _instACM1; DFPMCx0000067D _instACM2; DFPMCx000006BD _instACM3; DFPMCx000006FD _instCCM0; DFPMCx0000043D _instCCM1; DFPMCx0000047D _instCCM2; DFPMCx000004BD _instCCM3; DFPMCx000004FD _instCCM4; DFPMCx0000053D _instCCM5; DFPMCx0000057D _instCCM6; DFPMCx000005BD _instCCM7; DFPMCx000005FD`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]E — DF/CCM — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::CCM::CCM_FTI_LAT_HIST_GT500`  
**Instance:** `_instACM0; DFPMCx0000063E _instACM1; DFPMCx0000067E _instACM2; DFPMCx000006BE _instACM3; DFPMCx000006FE _instCCM0; DFPMCx0000043E _instCCM1; DFPMCx0000047E _instCCM2; DFPMCx000004BE _instCCM3; DFPMCx000004FE _instCCM4; DFPMCx0000053E _instCCM5; DFPMCx0000057E _instCCM6; DFPMCx000005BE _instCCM7; DFPMCx000005FE`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[43...6F]F — DF/CCM — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::CCM::CCM_FTI_LAT_HIST_GT1000`  
**Instance:** `_instACM0; DFPMCx0000063F _instACM1; DFPMCx0000067F _instACM2; DFPMCx000006BF _instACM3; DFPMCx000006FF _instCCM0; DFPMCx0000043F _instCCM1; DFPMCx0000047F _instCCM2; DFPMCx000004BF _instCCM3; DFPMCx000004FF _instCCM4; DFPMCx0000053F _instCCM5; DFPMCx0000057F _instCCM6; DFPMCx000005BF _instCCM7; DFPMCx000005FF`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[80...9C]0 — DF/IOM — IOM MRQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOM::IOM_MRQ_OCCPNCY`  
**Instance:** `_instIOM0; DFPMCx00000800 _instIOM1; DFPMCx00000840 _instIOM2; DFPMCx00000880 _instIOM3; DFPMCx000008C0 _instIOM4; DFPMCx00000900 _instIOM5; DFPMCx00000940 _instIOM6; DFPMCx00000980 _instIOM7; DFPMCx000009C0`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[80...9C]1 — DF/IOM — IOM MRSP_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOM::IOM_MRSP_OCCPNCY`  
**Instance:** `_instIOM0; DFPMCx00000801 _instIOM1; DFPMCx00000841 _instIOM2; DFPMCx00000881 _instIOM3; DFPMCx000008C1 _instIOM4; DFPMCx00000901 _instIOM5; DFPMCx00000941 _instIOM6; DFPMCx00000981 _instIOM7; DFPMCx000009C1`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[80...9C]2 — DF/IOM — IOM MDQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOM::IOM_MDQ_OCCPNCY`  
**Instance:** `_instIOM0; DFPMCx00000802 _instIOM1; DFPMCx00000842 _instIOM2; DFPMCx00000882 _instIOM3; DFPMCx000008C2 _instIOM4; DFPMCx00000902 _instIOM5; DFPMCx00000942 _instIOM6; DFPMCx00000982 _instIOM7; DFPMCx000009C2`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[80...9C]3 — DF/IOM — IOM RRSP_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOM::IOM_RRSP_OCCPNCY`  
**Instance:** `_instIOM0; DFPMCx00000803 _instIOM1; DFPMCx00000843 _instIOM2; DFPMCx00000883 _instIOM3; DFPMCx000008C3 _instIOM4; DFPMCx00000903 _instIOM5; DFPMCx00000943 _instIOM6; DFPMCx00000983 _instIOM7; DFPMCx000009C3`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[80...9C]4 — DF/IOM — IOM MRQ_STAT Statistics

**Symbolic:** `DF::PMC::IOM::IOM_MRQ_STAT`  
**Instance:** `_instIOM0; DFPMCx00000804 _instIOM1; DFPMCx00000844 _instIOM2; DFPMCx00000884 _instIOM3; DFPMCx000008C4 _instIOM4; DFPMCx00000904 _instIOM5; DFPMCx00000944 _instIOM6; DFPMCx00000984 _instIOM7; DFPMCx000009C4`

RdSized finally sent on FTI ReqND

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9 | `FtiReqNdSent` | Reset: 0. RdSized finally sent on FTI ReqND |
| 8 | `FtiReqNdAddrFail` | Reset: 0. FTI ReqND address collide with prior writes/atomics |
| 7 | `FtiReqNdNoBuf` | Reset: 0. FTI ReqND token unavailable |
| 6 | `PipekillLrgRd` | Reset: 0. Pipe Kill due to Large Read |
| 5 | `PipekillFtiDatBuf` | Reset: 0. Pipe Kill due to unavailable FTI Data Buffer |
| 4 | `PipekillFtiCmdDatBuf` | Reset: 0. Pipe Kill due to unavailable FTI Cmd or Data Buffer |
| 3 | `Pick` | Reset: 0. SDP Request Pick |
| 2 | `IosRspBypass` | Reset: 0. IOS Response Bypass |
| 1 | `AllocIosRsp` | Reset: 0. IOS Response Allocation |
| 0 | `AllocSdpReq` | Reset: 0. SDP Request Allocation |


## DFPMCx00000[80...9C]5 — DF/IOM — IOM MRSP_STAT Statistics

**Symbolic:** `DF::PMC::IOM::IOM_MRSP_STAT`  
**Instance:** `_instIOM0; DFPMCx00000805 _instIOM1; DFPMCx00000845 _instIOM2; DFPMCx00000885 _instIOM3; DFPMCx000008C5 _instIOM4; DFPMCx00000905 _instIOM5; DFPMCx00000945 _instIOM6; DFPMCx00000985 _instIOM7; DFPMCx000009C5`

IosRsp command cancel due to ordering check failed

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `IosRsOrdFailCan` | Reset: 0. IosRsp command cancel due to ordering check failed |
| 10 | `WrRspOrdFailCan` | Reset: 0. WrRsp command cancel due to ordering check failed |
| 9 | `SrcDnOrdFailCan` | Reset: 0. SrcDn command cancel due to ordering check failed |
| 7 | `PipekillRdRspSdpBuf` | Reset: 0. RdRsp pipekill due to SDP RdRsp credit unavailability |
| 6 | `PipekillWrRspSdpBuf` | Reset: 0. WrRsp pipekill due to SDP WrRsp credit unavailability |
| 5 | `PipekillRspFtiDatBuf` | Reset: 0. Response Pipekill due to FTI data token unavailability |
| 4 | `PipekillRspFtiCmdBuf` | Reset: 0. Response Pipekill due to FTI command token unavailability |
| 3 | `PickRdRsp` | Reset: 0. PickRdRsp |
| 2 | `PickWrRsp` | Reset: 0. Pick WrRsp or IosRsp. |
| 1 | `PickSrcDn` | Reset: 0. PickSrcDn |
| 0 | `Alloc` | Reset: 0. Response queue allocation |


## DFPMCx00000[80...9C]6 — DF/IOM — IOM RRSP_STAT Statistics

**Symbolic:** `DF::PMC::IOM::IOM_RRSP_STAT`  
**Instance:** `_instIOM0; DFPMCx00000806 _instIOM1; DFPMCx00000846 _instIOM2; DFPMCx00000886 _instIOM3; DFPMCx000008C6 _instIOM4; DFPMCx00000906 _instIOM5; DFPMCx00000946 _instIOM6; DFPMCx00000986 _instIOM7; DFPMCx000009C6`

RdRsp cancel due to ordering check fail for large read responses

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `RdRspOrdFailCanLgRd` | Reset: 0. RdRsp cancel due to ordering check fail for large read responses |
| 5 | `RdRspOrdFailCanWr` | Reset: 0. RdRsp cancel due to ordering check fail for writes/atomics |
| 4 | `PipekillSdpBuf` | Reset: 0. RdRsp Pick |
| 3 | `PipekillFtiCmdBuf` | Reset: 0. Pipekill due Pick |
| 2 | `PickRdRsp` | Reset: 0. RdRsp Pick |
| 1 | `PickSrcDn` | Reset: 0. SrcDn Pick |
| 0 | `Alloc` | Reset: 0. Response queue allocation |


## DFPMCx00000[80...9C]7 — DF/IOM — IOM MDQ_STAT Statistics

**Symbolic:** `DF::PMC::IOM::IOM_MDQ_STAT`  
**Instance:** `_instIOM0; DFPMCx00000807 _instIOM1; DFPMCx00000847 _instIOM2; DFPMCx00000887 _instIOM3; DFPMCx000008C7 _instIOM4; DFPMCx00000907 _instIOM5; DFPMCx00000947 _instIOM6; DFPMCx00000987 _instIOM7; DFPMCx000009C7`

Pick any I/O data beat (p2p).

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 2 | `PickIOAny` | Reset: 0. Pick any I/O data beat (p2p). |
| 1 | `PickAny` | Reset: 0. Pick any data beat. |
| 0 | `Alloc` | Reset: 0. Allocate. |


## DFPMCx00000[80...9C]8 — DF/IOM — IOM REQA Request Type

**Symbolic:** `DF::PMC::IOM::IOM_REQA`  
**Instance:** `_instIOM0; DFPMCx00000808 _instIOM1; DFPMCx00000848 _instIOM2; DFPMCx00000888 _instIOM3; DFPMCx000008C8 _instIOM4; DFPMCx00000908 _instIOM5; DFPMCx00000948 _instIOM6; DFPMCx00000988 _instIOM7; DFPMCx000009C8`

Select target Node ID if UseNodeId is set

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NodeId` | Reset: 0. Select target Node ID if UseNodeId is set |
| 6 | `UseNodeId` | Reset: 0. 0: Count all selected transactions. 1: Only count transactions destined to the selected NodeId |
| 5:4 | `Misc` | Reset: 0h. Select type of Misc transaction. Value Description 0h Disabled, no Misc selected. 1h Master Abort. 3h-2h Reserved. |
| 3 | `Atomic` | Reset: 0. Atomic. |
| 2 | `WrNoData` | Reset: 0. WrSized command issued on FTI as WrNoDataC |
| 1 | `WrSized` | Reset: 0. WrSized command issued on FTI as WrSized |
| 0 | `RdSized` | Reset: 0. ReadSized |


## DFPMCx00000[80...9C]9 — DF/IOM — IOM REQB Request Type

**Symbolic:** `DF::PMC::IOM::IOM_REQB`  
**Instance:** `_instIOM0; DFPMCx00000809 _instIOM1; DFPMCx00000849 _instIOM2; DFPMCx00000889 _instIOM3; DFPMCx000008C9 _instIOM4; DFPMCx00000909 _instIOM5; DFPMCx00000949 _instIOM6; DFPMCx00000989 _instIOM7; DFPMCx000009C9`

Select target Node ID if UseNodeId is set

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NodeId` | Reset: 0. Select target Node ID if UseNodeId is set |
| 6 | `UseNodeId` | Reset: 0. 0: Count all selected transactions. 1: Only count transactions destined to the selected NodeId |
| 5:4 | `PIESysMgt` | Reset: 0h. Select type of PIE/SysMgt transaction. Value Description 0h Disabled, no PIE/SysMgt selected. 1h PIE, Interrupt. 3h-2h Reserved. |
| 3 | `IoAtomic` | Reset: 0. IO Atomic. |
| 2 | `IoWrSzP` | Reset: 0. IO WriteSized Posted. |
| 1 | `IoWrSzNP` | Reset: 0. IO WriteSized Non-posted. |
| 0 | `IoRdSz` | Reset: 0. IO ReadSized. |


## DFPMCx00000[80...9C]A — DF/IOM — IOM ORDERING Cancellations due to Ordering

**Symbolic:** `DF::PMC::IOM::IOM_ORDERING`  
**Instance:** `_instIOM0; DFPMCx0000080A _instIOM1; DFPMCx0000084A _instIOM2; DFPMCx0000088A _instIOM3; DFPMCx000008CA _instIOM4; DFPMCx0000090A _instIOM5; DFPMCx0000094A _instIOM6; DFPMCx0000098A _instIOM7; DFPMCx000009CA`

Select priority level of request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 | `FtiPri` | Reset: 0h. Select priority level of request. Value Description 0h Low Priority. 1h Medium Priority. 2h High Priority. 3h Urgent Priority. |
| 5:4 | `FtiVc` | Reset: 0h. Select VC of request. Value Description 0h FTI VC0 or FTI VC2. 1h FTI VC1 or FTI VC3. 2h FTI VC4. 3h FTI VC5, FTI VC7, or FTI VC8. |
| 3:2 | `BlkLvl` | Reset: 0h. Specifies Block Level of request. Value Description 0h Block Level 0. 1h Block Level 1. 2h Block Level 2. 3h Block Level 3. |
| 1 | `PassPW` | Reset: 0. Select PassPW bit of request. |
| 0 | `Select` | Reset: 0. 0= Ignore other fields. Count for all requests. 1= Count cancellations for requests matching the other fields. Selector Enable |


## DFPMCx00000[80...9C]B — DF/IOM — IOM PICK_PRI Priority Picker

**Symbolic:** `DF::PMC::IOM::IOM_PICK_PRI`  
**Instance:** `_instIOM0; DFPMCx0000080B _instIOM1; DFPMCx0000084B _instIOM2; DFPMCx0000088B _instIOM3; DFPMCx000008CB _instIOM4; DFPMCx0000090B _instIOM5; DFPMCx0000094B _instIOM6; DFPMCx0000098B _instIOM7; DFPMCx000009CB`

High-Priority request was picked over a higher priority due to pick saturate.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `SatPrioHi` | Reset: 0. High-Priority request was picked over a higher priority due to pick saturate. |
| 4 | `SatPrioMed` | Reset: 0. Medium-Priority request was picked over a higher priority due to pick saturate. |
| 3 | `SatPrioLow` | Reset: 0. Low-Priority request was picked over a higher priority due to pick saturate. |
| 2 | `RdyPrioUrg` | Reset: 0. Urgent-Priority request was picked over a lower priority. |
| 1 | `RdyPrioHi` | Reset: 0. High-Priority request was picked over a lower priority. |
| 0 | `RdyPrioMed` | Reset: 0. Medium-Priority request was picked over a lower priority. |


## DFPMCx00000[80...9C]C — DF/IOM — IOM SDP_DBGA SDP Debug A

**Symbolic:** `DF::PMC::IOM::IOM_SDP_DBGA`  
**Instance:** `_instIOM0; DFPMCx0000080C _instIOM1; DFPMCx0000084C _instIOM2; DFPMCx0000088C _instIOM3; DFPMCx000008CC _instIOM4; DFPMCx0000090C _instIOM5; DFPMCx0000094C _instIOM6; DFPMCx0000098C _instIOM7; DFPMCx000009CC`

Counts number of times received SDP Request that matches this UnitID.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5:0 | `UnitID` | Reset: 00h. Counts number of times received SDP Request that matches this UnitID. |


## DFPMCx00000[80...9C]D — DF/IOM — IOM CNL_AND_RPLY Cancel and Replay

**Symbolic:** `DF::PMC::IOM::IOM_CNL_AND_RPLY`  
**Instance:** `_instIOM0; DFPMCx0000080D _instIOM1; DFPMCx0000084D _instIOM2; DFPMCx0000088D _instIOM3; DFPMCx000008CD _instIOM4; DFPMCx0000090D _instIOM5; DFPMCx0000094D _instIOM6; DFPMCx0000098D _instIOM7; DFPMCx000009CD`

Select type of ordering fail that leads to the cancel.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 | `OrdFailSel` | Reset: 0h. Select type of ordering fail that leads to the cancel. Value Description 0h Disabled, no PIE/SysMgt selected. 1h Ordering check fail against request queue. 3h-2h Reserved. |
| 5 | `SrcDn` | Reset: 0. IOM sent a SrcDn without data |
| 4 | `SrcDnWithCancel` | Reset: 0. IOM sent a SrcDn without data with Cancel=1 |
| 3 | `SrcDnFull` | Reset: 0. IOM sent a SrcDn without data for a Full WrNoData command |
| 2 | `SrcDnD` | Reset: 0. IOM sent a SrcDnD |
| 1 | `ReplayPtl` | Reset: 0. IOM sent a replay for a non-64B WrNoData command |
| 0 | `Replay` | Reset: 0. IOM sent a replay for non-64B or 64B WrNoData command |


## DFPMCx00000[81...9D]F — DF/IOM — IOM DATA_BW DATA BANDWIDTH

**Symbolic:** `DF::PMC::IOM::IOM_DATA_BW`  
**Instance:** `_instIOM0; DFPMCx0000081F _instIOM1; DFPMCx0000085F _instIOM2; DFPMCx0000089F _instIOM3; DFPMCx000008DF _instIOM4; DFPMCx0000091F _instIOM5; DFPMCx0000095F _instIOM6; DFPMCx0000099F _instIOM7; DFPMCx000009DF`

Select transactions based on the die proximity of the source/destination

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SrcDstDieProx` | Reset: 0h. Select transactions based on the die proximity of the source/destination Value Description 0h Disabled. No transactions selected 1h Count only transactions with source/destination on Local die 2h Count only transactions with source/destination on Remote die 3h Count any transaction, regardless of source/destination die proximity |
| 5:2 | `SrcDst` | Reset: 0h. Select transactions based on the source/dest of the data - UMC, CXL™, IO, CPU (cache). Multi-bit selects are also possible. Value Description 0h Disabled. No transactions selected 1h Count only data beats from CPU (cache). For Reads only. 2h Count only data beats to/from UMC 3h Reserved. 4h Count only data beats to/from IO 7h-5h Reserved. 8h Count only data beats to/from CXL Eh-9h Reserved. Fh Count any transaction, regardless of source |
| 0 | `TxnType` | Reset: 0. 0= Count Read Response Data Beats . 1= Count Write Data Beats . Select Transaction Type |


## DFPMCx00000[83...9F]0 — DF/IOM — Average Latency Transaction Count

**Symbolic:** `DF::PMC::IOM::IOM_SDP_AVG_LAT_TRANS_CNT`  
**Instance:** `_instIOM0; DFPMCx00000830 _instIOM1; DFPMCx00000870 _instIOM2; DFPMCx000008B0 _instIOM3; DFPMCx000008F0 _instIOM4; DFPMCx00000930 _instIOM5; DFPMCx00000970 _instIOM6; DFPMCx000009B0 _instIOM7; DFPMCx000009F0`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]1 — DF/IOM — Average Latency Cycle Count

**Symbolic:** `DF::PMC::IOM::IOM_SDP_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instIOM0; DFPMCx00000831 _instIOM1; DFPMCx00000871 _instIOM2; DFPMCx000008B1 _instIOM3; DFPMCx000008F1 _instIOM4; DFPMCx00000931 _instIOM5; DFPMCx00000971 _instIOM6; DFPMCx000009B1 _instIOM7; DFPMCx000009F1`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]2 — DF/IOM — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::IOM::IOM_SDP_LAT_HIST_GT50`  
**Instance:** `_instIOM0; DFPMCx00000832 _instIOM1; DFPMCx00000872 _instIOM2; DFPMCx000008B2 _instIOM3; DFPMCx000008F2 _instIOM4; DFPMCx00000932 _instIOM5; DFPMCx00000972 _instIOM6; DFPMCx000009B2 _instIOM7; DFPMCx000009F2`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]3 — DF/IOM — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::IOM::IOM_SDP_LAT_HIST_GT100`  
**Instance:** `_instIOM0; DFPMCx00000833 _instIOM1; DFPMCx00000873 _instIOM2; DFPMCx000008B3 _instIOM3; DFPMCx000008F3 _instIOM4; DFPMCx00000933 _instIOM5; DFPMCx00000973 _instIOM6; DFPMCx000009B3 _instIOM7; DFPMCx000009F3`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]4 — DF/IOM — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::IOM::IOM_SDP_LAT_HIST_GT150`  
**Instance:** `_instIOM0; DFPMCx00000834 _instIOM1; DFPMCx00000874 _instIOM2; DFPMCx000008B4 _instIOM3; DFPMCx000008F4 _instIOM4; DFPMCx00000934 _instIOM5; DFPMCx00000974 _instIOM6; DFPMCx000009B4 _instIOM7; DFPMCx000009F4`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]5 — DF/IOM — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::IOM::IOM_SDP_LAT_HIST_GT200`  
**Instance:** `_instIOM0; DFPMCx00000835 _instIOM1; DFPMCx00000875 _instIOM2; DFPMCx000008B5 _instIOM3; DFPMCx000008F5 _instIOM4; DFPMCx00000935 _instIOM5; DFPMCx00000975 _instIOM6; DFPMCx000009B5 _instIOM7; DFPMCx000009F5`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]6 — DF/IOM — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::IOM::IOM_SDP_LAT_HIST_GT500`  
**Instance:** `_instIOM0; DFPMCx00000836 _instIOM1; DFPMCx00000876 _instIOM2; DFPMCx000008B6 _instIOM3; DFPMCx000008F6 _instIOM4; DFPMCx00000936 _instIOM5; DFPMCx00000976 _instIOM6; DFPMCx000009B6 _instIOM7; DFPMCx000009F6`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]7 — DF/IOM — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::IOM::IOM_SDP_LAT_HIST_GT1000`  
**Instance:** `_instIOM0; DFPMCx00000837 _instIOM1; DFPMCx00000877 _instIOM2; DFPMCx000008B7 _instIOM3; DFPMCx000008F7 _instIOM4; DFPMCx00000937 _instIOM5; DFPMCx00000977 _instIOM6; DFPMCx000009B7 _instIOM7; DFPMCx000009F7`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= SDP0 latency is calculated. 1= SDP1 latency is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]8 — DF/IOM — Average Latency Transaction Count

**Symbolic:** `DF::PMC::IOM::IOM_FTI_AVG_LAT_TRANS_CNT`  
**Instance:** `_instIOM0; DFPMCx00000838 _instIOM1; DFPMCx00000878 _instIOM2; DFPMCx000008B8 _instIOM3; DFPMCx000008F8 _instIOM4; DFPMCx00000938 _instIOM5; DFPMCx00000978 _instIOM6; DFPMCx000009B8 _instIOM7; DFPMCx000009F8`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]9 — DF/IOM — Average Latency Cycle Count

**Symbolic:** `DF::PMC::IOM::IOM_FTI_AVG_LAT_CYCLE_CNT`  
**Instance:** `_instIOM0; DFPMCx00000839 _instIOM1; DFPMCx00000879 _instIOM2; DFPMCx000008B9 _instIOM3; DFPMCx000008F9 _instIOM4; DFPMCx00000939 _instIOM5; DFPMCx00000979 _instIOM6; DFPMCx000009B9 _instIOM7; DFPMCx000009F9`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]A — DF/IOM — Latency Histogram Greater Than 50ns

**Symbolic:** `DF::PMC::IOM::IOM_FTI_LAT_HIST_GT50`  
**Instance:** `_instIOM0; DFPMCx0000083A _instIOM1; DFPMCx0000087A _instIOM2; DFPMCx000008BA _instIOM3; DFPMCx000008FA _instIOM4; DFPMCx0000093A _instIOM5; DFPMCx0000097A _instIOM6; DFPMCx000009BA _instIOM7; DFPMCx000009FA`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]B — DF/IOM — Latency Histogram Greater Than 100ns

**Symbolic:** `DF::PMC::IOM::IOM_FTI_LAT_HIST_GT100`  
**Instance:** `_instIOM0; DFPMCx0000083B _instIOM1; DFPMCx0000087B _instIOM2; DFPMCx000008BB _instIOM3; DFPMCx000008FB _instIOM4; DFPMCx0000093B _instIOM5; DFPMCx0000097B _instIOM6; DFPMCx000009BB _instIOM7; DFPMCx000009FB`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]C — DF/IOM — Latency Histogram Greater Than 150ns

**Symbolic:** `DF::PMC::IOM::IOM_FTI_LAT_HIST_GT150`  
**Instance:** `_instIOM0; DFPMCx0000083C _instIOM1; DFPMCx0000087C _instIOM2; DFPMCx000008BC _instIOM3; DFPMCx000008FC _instIOM4; DFPMCx0000093C _instIOM5; DFPMCx0000097C _instIOM6; DFPMCx000009BC _instIOM7; DFPMCx000009FC`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]D — DF/IOM — Latency Histogram Greater Than 200ns

**Symbolic:** `DF::PMC::IOM::IOM_FTI_LAT_HIST_GT200`  
**Instance:** `_instIOM0; DFPMCx0000083D _instIOM1; DFPMCx0000087D _instIOM2; DFPMCx000008BD _instIOM3; DFPMCx000008FD _instIOM4; DFPMCx0000093D _instIOM5; DFPMCx0000097D _instIOM6; DFPMCx000009BD _instIOM7; DFPMCx000009FD`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]E — DF/IOM — Latency Histogram Greater Than 500ns

**Symbolic:** `DF::PMC::IOM::IOM_FTI_LAT_HIST_GT500`  
**Instance:** `_instIOM0; DFPMCx0000083E _instIOM1; DFPMCx0000087E _instIOM2; DFPMCx000008BE _instIOM3; DFPMCx000008FE _instIOM4; DFPMCx0000093E _instIOM5; DFPMCx0000097E _instIOM6; DFPMCx000009BE _instIOM7; DFPMCx000009FE`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[83...9F]F — DF/IOM — Latency Histogram Greater Than 1000ns

**Symbolic:** `DF::PMC::IOM::IOM_FTI_LAT_HIST_GT1000`  
**Instance:** `_instIOM0; DFPMCx0000083F _instIOM1; DFPMCx0000087F _instIOM2; DFPMCx000008BF _instIOM3; DFPMCx000008FF _instIOM4; DFPMCx0000093F _instIOM5; DFPMCx0000097F _instIOM6; DFPMCx000009BF _instIOM7; DFPMCx000009FF`

Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `SelChannel` | Reset: 0. 0= FTI Req latency is calculated. 1= FTI ReqND is calculated. Selects sub-channel of the transaction being tracked. This field is ignored if only one sub-channel is connected to the component. |
| 8:7 | `SelectPriority` | Reset: 0h. Select Priority. Value Description 0h Low. 1h Medium. 2h High. 3h Urgent. |
| 6:3 | `SelectCmdType` | Reset: 0h. Select Command Type. Value Description 0h RdBlk. 1h RdSized, RdSizedDW, RdSizedNoWriter. 2h RdSizedNC. 3h WrSized, WrSizedFull, WrSizedFullZero, WrSizedFullComp. 4h WrSizedNC, WrSizedFullNC, WrNoDataNC. 5h VicBlkFull, VicBlkFullZero, VicBlkFullComp. 6h VicBlkCln. 7h Atomics. Fh-8h Reserved. |
| 2:0 | `SelSrcTgt` | Reset: 0h. Select Src/Tgt of the request being tracked. Value Description 0h Node 0. 1h Node 1. 7h-2h Reserved. |


## DFPMCx00000[A0...BC]0 — DF/IOS — IOS REQQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOS::IOS_REQQ_OCCPNCY`  
**Instance:** `_instIOS0; DFPMCx00000A00 _instIOS1; DFPMCx00000A40 _instIOS2; DFPMCx00000A80 _instIOS3; DFPMCx00000AC0 _instIOS4; DFPMCx00000B00 _instIOS5; DFPMCx00000B40 _instIOS6; DFPMCx00000B80 _instIOS7; DFPMCx00000BC0`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[A0...BC]1 — DF/IOS — IOS BRCQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOS::IOS_BRCQ_OCCPNCY`  
**Instance:** `_instIOS0; DFPMCx00000A01 _instIOS1; DFPMCx00000A41 _instIOS2; DFPMCx00000A81 _instIOS3; DFPMCx00000AC1 _instIOS4; DFPMCx00000B01 _instIOS5; DFPMCx00000B41 _instIOS6; DFPMCx00000B81 _instIOS7; DFPMCx00000BC1`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[A0...BC]2 — DF/IOS — IOS REQDQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOS::IOS_REQDQ_OCCPNCY`  
**Instance:** `_instIOS0; DFPMCx00000A02 _instIOS1; DFPMCx00000A42 _instIOS2; DFPMCx00000A82 _instIOS3; DFPMCx00000AC2 _instIOS4; DFPMCx00000B02 _instIOS5; DFPMCx00000B42 _instIOS6; DFPMCx00000B82 _instIOS7; DFPMCx00000BC2`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[A0...BC]3 — DF/IOS — IOS RDRSPQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOS::IOS_RDRSPQ_OCCPNCY`  
**Instance:** `_instIOS0; DFPMCx00000A03 _instIOS1; DFPMCx00000A43 _instIOS2; DFPMCx00000A83 _instIOS3; DFPMCx00000AC3 _instIOS4; DFPMCx00000B03 _instIOS5; DFPMCx00000B43 _instIOS6; DFPMCx00000B83 _instIOS7; DFPMCx00000BC3`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[A0...BC]4 — DF/IOS — IOS WRRSPQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::IOS::IOS_WRRSPQ_OCCPNCY`  
**Instance:** `_instIOS0; DFPMCx00000A04 _instIOS1; DFPMCx00000A44 _instIOS2; DFPMCx00000A84 _instIOS3; DFPMCx00000AC4 _instIOS4; DFPMCx00000B04 _instIOS5; DFPMCx00000B44 _instIOS6; DFPMCx00000B84 _instIOS7; DFPMCx00000BC4`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[A0...BC]5 — DF/IOS — IOS RDREQ Read Requests

**Symbolic:** `DF::PMC::IOS::IOS_RDREQ`  
**Instance:** `_instIOS0; DFPMCx00000A05 _instIOS1; DFPMCx00000A45 _instIOS2; DFPMCx00000A85 _instIOS3; DFPMCx00000AC5 _instIOS4; DFPMCx00000B05 _instIOS5; DFPMCx00000B45 _instIOS6; DFPMCx00000B85 _instIOS7; DFPMCx00000BC5`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Channel select. 0:Nonposted, 1:Posted. |
| 6 | `Other` | Reset: 0. Read from other source |
| 5 | `GUS` | Reset: 0. Reserved |
| 4 | `DCE` | Reset: 0. Reserved |
| 3 | `MMHUB` | Reset: 0. Reserved |
| 2 | `IOM` | Reset: 0. Reserved |
| 1 | `CCM` | Reset: 0. Read from CCM. |
| 0 | `GCM` | Reset: 0. Read from GCM. |


## DFPMCx00000[A0...BC]6 — DF/IOS — IOS WRREQ Write Requests

**Symbolic:** `DF::PMC::IOS::IOS_WRREQ`  
**Instance:** `_instIOS0; DFPMCx00000A06 _instIOS1; DFPMCx00000A46 _instIOS2; DFPMCx00000A86 _instIOS3; DFPMCx00000AC6 _instIOS4; DFPMCx00000B06 _instIOS5; DFPMCx00000B46 _instIOS6; DFPMCx00000B86 _instIOS7; DFPMCx00000BC6`

Filter is implemented for this perfmon. See 13.15.2.1 [Filter Implementation] .

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `ChanSel` | Reset: 0. Channel select. 0:Nonposted, 1:Posted. |
| 6 | `Other` | Reset: 0. Write from other source. |
| 5 | `GUS` | Reset: 0. Reserved |
| 4 | `DCE` | Reset: 0. Reserved |
| 3 | `MMHUB` | Reset: 0. Reserved |
| 2 | `IOM` | Reset: 0. Reserved |
| 1 | `CCM` | Reset: 0. Write from CCM. |
| 0 | `GCM` | Reset: 0. Reserved |


## DFPMCx00000[A0...BC]7 — DF/IOS — IOS MISCREQ Miscellaneous Requests

**Symbolic:** `DF::PMC::IOS::IOS_MISCREQ`  
**Instance:** `_instIOS0; DFPMCx00000A07 _instIOS1; DFPMCx00000A47 _instIOS2; DFPMCx00000A87 _instIOS3; DFPMCx00000AC7 _instIOS4; DFPMCx00000B07 _instIOS5; DFPMCx00000B47 _instIOS6; DFPMCx00000B87 _instIOS7; DFPMCx00000BC7`

Device Message Write.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `DevMsgWr` | Reset: 0. Device Message Write. |
| 5 | `DevMsgRd` | Reset: 0. Device Message Read. |
| 4 | `Brdcst` | Reset: 0. Broadcast. |
| 3 | `Atomic` | Reset: 0. Atomic. |
| 2 | `CfgWr` | Reset: 0. Config Write. |
| 1 | `CfgRd` | Reset: 0. Config Read. |
| 0 | `Lrg` | Reset: 0. Large Read. |


## DFPMCx00000[A0...BC]8 — DF/IOS — IOS OTHERREQ Other Requests

**Symbolic:** `DF::PMC::IOS::IOS_OTHERREQ`  
**Instance:** `_instIOS0; DFPMCx00000A08 _instIOS1; DFPMCx00000A48 _instIOS2; DFPMCx00000A88 _instIOS3; DFPMCx00000AC8 _instIOS4; DFPMCx00000B08 _instIOS5; DFPMCx00000B48 _instIOS6; DFPMCx00000B88 _instIOS7; DFPMCx00000BC8`

Write from other VC.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `OtherWrVc` | Reset: 0. Write from other VC. |
| 6 | `OtherWrSrc` | Reset: 0. Write from other Source. |
| 3 | `OtherRdVc` | Reset: 0. Read from other VC. |
| 2 | `OtherRdSrc` | Reset: 0. Read from other Source. |


## DFPMCx00000[A1...BD]F — DF/IOS — IOS DATA_BW Data Bandwidth

**Symbolic:** `DF::PMC::IOS::IOS_DATA_BW`  
**Instance:** `_instIOS0; DFPMCx00000A1F _instIOS1; DFPMCx00000A5F _instIOS2; DFPMCx00000A9F _instIOS3; DFPMCx00000ADF _instIOS4; DFPMCx00000B1F _instIOS5; DFPMCx00000B5F _instIOS6; DFPMCx00000B9F _instIOS7; DFPMCx00000BDF`

Select transactions based on the die proximity of the source

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `SrcDstDieProx` | Reset: 0h. Select transactions based on the die proximity of the source Value Description 0h Disabled. No transactions selected 1h Count only transactions with source on Local die 2h Count only transactions with source on Remote die 3h Count any transaction, regardless of source die proximity |
| 7:6 | `SrcDstDieType` | Reset: 0h. Select transactions based on die type of the source Value Description 0h Disabled. No transactions selected 1h Count only transactions with source on the same die type 2h Count only transactions with source on a different die type 3h Count any transaction, regardless of source die type |
| 5:2 | `SrcDst` | Reset: 0h. Select transactions based on the type of the requestor - CXL™, IO, GPU, or CPU. Multi-bit selects are also possible. Value Description 0h Disabled. No transactions selected 1h Count only transactions from CPU source 2h Count only transactions from GPU source 3h Reserved. 4h Count only transactions from IO source 7h-5h Reserved. 8h Count only transactions from CXL source Eh-9h Reserved. Fh Count any transaction, regardless of source |
| 0 | `TxnType` | Reset: 0. 0= Count Read Response Data Beats . 1= Count Write Data Beats . Select Transaction Type |


## DFPMCx00000[D4...E8]0 — DF/CAKE — CAKE PRB_COMB_STAT Probe Combining Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_PRB_COMB_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D40 _instCAKEXGMI1; DFPMCx00000D80 _instCAKEXGMI2; DFPMCx00000DC0 _instCAKEXGMI3; DFPMCx00000E00 _instCAKEXGMI4; DFPMCx00000E40 _instCAKEXGMI5; DFPMCx00000E80`

Track

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Track` | Reset: 0. Track |
| 4 | `Alloc` | Reset: 0. Alloc |
| 3 | `DatLst` | Reset: 0. DatLst |
| 2 | `Dat` | Reset: 0. Dat |
| 1 | `Drop` | Reset: 0. Drop |
| 0 | `Full` | Reset: 0. Full |


## DFPMCx00000[D4...E8]1 — DF/CAKE — CAKE GMI_FOLD GMI3 link folding stats

**Symbolic:** `DF::PMC::CAKE::CAKE_GMI_FOLD`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D41 _instCAKEXGMI1; DFPMCx00000D81 _instCAKEXGMI2; DFPMCx00000DC1 _instCAKEXGMI3; DFPMCx00000E01 _instCAKEXGMI4; DFPMCx00000E41 _instCAKEXGMI5; DFPMCx00000E81`

Mode

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3:0 | `Mode` | Reset: 0h. Mode Value Description 0h Count number of cycles when link folding is requested. 1h Count number of Folding requests (Unfold -> Fold transition). 2h Count number of cycles when Emergency Full is asserted. 3h Count number of Emergency Full assertion. 4h Count number of cycles Folding is requested and PCS is yet to assert IsFolded. 5h Count number of cycles Un-Folding is requested and PCS is yet to de-assert IsFolded. Fh-6h Reserved. |


## DFPMCx00000[D4...E8]2 — DF/CAKE — CAKE PACK_STAT_0 Packing Buffer Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_PACK_STAT_0`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D42 _instCAKEXGMI1; DFPMCx00000D82 _instCAKEXGMI2; DFPMCx00000DC2 _instCAKEXGMI3; DFPMCx00000E02 _instCAKEXGMI4; DFPMCx00000E42 _instCAKEXGMI5; DFPMCx00000E82`

Threshold to match or exceed for selected source

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:6 | `Threshold` | Reset: 0h. Threshold to match or exceed for selected source |
| 5 | `Mode` | Reset: 0. 0= Count when number of packets packed is an exact match to Threshold . 1= Count when number of packets packed is greater than or equal to Threshold . Comparison mode for threshold |
| 4:0 | `Src` | Reset: 00h. Select Packet Type (Source for Packing Buffer Arbitration) Value Description 00h Raw (uncompressed) Tokens 01h Compressed Tokens 02h Compressed Responses 03h Raw (uncompressed) Responses 04h Compressed Requests 05h Raw (uncompressed) Requests 06h Raw (uncompressed) Requests (No-Data channel) 07h Compressed Requests (No-Data channel) 08h Raw (uncompressed) Victims 09h FTO Requests 0Ah Raw (uncompressed) Probes 0Bh Raw (uncompressed) Probes (PRB1 channel) 0Ch Compressed Probes (PRB1 channel) 0Dh Raw (uncompressed) Responses (No-Data channel) 0Eh Compressed Responses (No-Data channel) 0Fh Compressed USR token 10h Compressed USR response 1Fh-11h Reserved. |


## DFPMCx00000[D4...E8]3 — DF/CAKE — CAKE DAT_COMP_STAT Data Compression Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_DAT_COMP_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D43 _instCAKEXGMI1; DFPMCx00000D83 _instCAKEXGMI2; DFPMCx00000DC3 _instCAKEXGMI3; DFPMCx00000E03 _instCAKEXGMI4; DFPMCx00000E43 _instCAKEXGMI5; DFPMCx00000E83`

DataAll0Pattern

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `DataAll0Pattern` | Reset: 0. DataAll0Pattern |
| 6 | `Data48B0Pattern` | Reset: 0. Data48B0Pattern |
| 5 | `Data32B0Pattern` | Reset: 0. Data32B0Pattern |
| 4 | `Data4B1Pattern` | Reset: 0. Data4B1Pattern |
| 3 | `Data4B0Pattern` | Reset: 0. Data4B0Pattern |
| 2 | `Data2B1Pattern` | Reset: 0. Data2B1Pattern |
| 1 | `Data2B0Pattern` | Reset: 0. Data2B0Pattern |
| 0 | `Data1B0Pattern` | Reset: 0. Data1B0Pattern |


## DFPMCx00000[D4...E8]4 — DF/CAKE — CAKE TKNINSTALL FTI Inbound Picker Token Stall

**Symbolic:** `DF::PMC::CAKE::CAKE_TKNINSTALL`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D44 _instCAKEXGMI1; DFPMCx00000D84 _instCAKEXGMI2; DFPMCx00000DC4 _instCAKEXGMI3; DFPMCx00000E04 _instCAKEXGMI4; DFPMCx00000E44 _instCAKEXGMI5; DFPMCx00000E84`

Received FTI Probe but stalled due to insufficient CAKE-to-CAKE tokens.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `Probe` | Reset: 0. Received FTI Probe but stalled due to insufficient CAKE-to-CAKE tokens. |
| 3 | `RspData` | Reset: 0. Received FTI RspData but stalled due to insufficient CAKE-to-CAKE tokens. |
| 2 | `RspCmd` | Reset: 0. Received FTI RspCommand but stalled due to insufficient CAKE-to-CAKE tokens. |
| 1 | `ReqData` | Reset: 0. Received FTI ReqData but stalled due to insufficient CAKE-to-CAKE tokens. |
| 0 | `ReqCmd` | Reset: 0. Received FTI ReqCommand but stalled due to insufficient CAKE-to-CAKE tokens. |


## DFPMCx00000[D4...E8]5 — DF/CAKE — CAKE TKNOUTSTALL FTI Outbound Picker Token Stall

**Symbolic:** `DF::PMC::CAKE::CAKE_TKNOUTSTALL`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D45 _instCAKEXGMI1; DFPMCx00000D85 _instCAKEXGMI2; DFPMCx00000DC5 _instCAKEXGMI3; DFPMCx00000E05 _instCAKEXGMI4; DFPMCx00000E45 _instCAKEXGMI5; DFPMCx00000E85`

Received CAKE Rsp No Data but stalled due to insufficient CAKE-to-FTI tokens.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RspNd` | Reset: 0. Received CAKE Rsp No Data but stalled due to insufficient CAKE-to-FTI tokens. |
| 6 | `ReqNd` | Reset: 0. Received CAKE Req No Data but stalled due to insufficient CAKE-to-FTI tokens. |
| 5 | `Probe1` | Reset: 0. Received CAKE Probe1 but stalled due to insufficient CAKE-to-FTI tokens. |
| 4 | `Probe` | Reset: 0. Received CAKE Probe but stalled due to insufficient CAKE-to-FTI tokens. |
| 3 | `RspData` | Reset: 0. Received CAKE RspData but stalled due to insufficient CAKE-to-FTI tokens. |
| 2 | `RspCmd` | Reset: 0. Received CAKE RspCommand but stalled due to insufficient CAKE-to-FTI tokens. |
| 1 | `ReqData` | Reset: 0. Received CAKE ReqData but stalled due to insufficient CAKE-to-FTI tokens. |
| 0 | `ReqCmd` | Reset: 0. Received CAKE ReqCommand but stalled due to insufficient CAKE-to-FTI tokens. |


## DFPMCx00000[D4...E8]6 — DF/CAKE — CAKE PCS_IN_FLIT0_STAT PCS Inbound Flit 0 (RX) Stats

**Symbolic:** `DF::PMC::CAKE::CAKE_PCS_IN_FLIT0_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D46 _instCAKEXGMI1; DFPMCx00000D86 _instCAKEXGMI2; DFPMCx00000DC6 _instCAKEXGMI3; DFPMCx00000E06 _instCAKEXGMI4; DFPMCx00000E46 _instCAKEXGMI5; DFPMCx00000E86`

RxToken

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `RxToken` | Reset: 0. RxToken |
| 5 | `RxByteEn` | Reset: 0. RxByteEn |
| 4 | `RxMeta` | Reset: 0. RxMeta |
| 3 | `RxNop` | Reset: 0. RxNop |
| 2 | `RxWrData` | Reset: 0. RxData |
| 1 | `RxRdData` | Reset: 0. RxData |
| 0 | `RxCmd` | Reset: 0. RxCmd |


## DFPMCx00000[D4...E8]7 — DF/CAKE — CAKE PCS_OUT_FLIT0_STAT PCS Outbound Flit 0 (TX) Stats

**Symbolic:** `DF::PMC::CAKE::CAKE_PCS_OUT_FLIT0_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D47 _instCAKEXGMI1; DFPMCx00000D87 _instCAKEXGMI2; DFPMCx00000DC7 _instCAKEXGMI3; DFPMCx00000E07 _instCAKEXGMI4; DFPMCx00000E47 _instCAKEXGMI5; DFPMCx00000E87`

TxMeta

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `TxIdle` | Reset: 0. TxMeta |
| 6 | `TxToken` | Reset: 0. TxMeta |
| 5 | `TxByteEn` | Reset: 0. TxByteEn |
| 4 | `TxMeta` | Reset: 0. TxMeta |
| 3 | `TxNop` | Reset: 0. TxNop |
| 2 | `TxWrData` | Reset: 0. TxData |
| 1 | `TxRdData` | Reset: 0. TxData |
| 0 | `TxCmd` | Reset: 0. TxCmd |


## DFPMCx00000[D4...E8]8 — DF/CAKE — CAKE ACACHE_STAT Address Cache Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_ACACHE_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D48 _instCAKEXGMI1; DFPMCx00000D88 _instCAKEXGMI2; DFPMCx00000DC8 _instCAKEXGMI3; DFPMCx00000E08 _instCAKEXGMI4; DFPMCx00000E48 _instCAKEXGMI5; DFPMCx00000E88`

HitWay3

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `HitWay3` | Reset: 0. HitWay3 |
| 5 | `HitWay2` | Reset: 0. HitWay2 |
| 4 | `HitWay1` | Reset: 0. HitWay1 |
| 3 | `HitWay0` | Reset: 0. HitWay0 |
| 2 | `HitRmt` | Reset: 0. HitRmt |
| 1 | `HitLcl` | Reset: 0. HitLcl |
| 0 | `Miss` | Reset: 0. Miss |


## DFPMCx00000[D4...E8]9 — DF/CAKE — CAKE PCS_IN_FLIT1_STAT PCS Inbound Flit 1 (RX) Stats

**Symbolic:** `DF::PMC::CAKE::CAKE_PCS_IN_FLIT1_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D49 _instCAKEXGMI1; DFPMCx00000D89 _instCAKEXGMI2; DFPMCx00000DC9 _instCAKEXGMI3; DFPMCx00000E09 _instCAKEXGMI4; DFPMCx00000E49 _instCAKEXGMI5; DFPMCx00000E89`

RxToken

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `RxToken` | Reset: 0. RxToken |
| 5 | `RxByteEn` | Reset: 0. RxByteEn |
| 4 | `RxMeta` | Reset: 0. RxMeta |
| 3 | `RxNop` | Reset: 0. RxNop |
| 2 | `RxWrData` | Reset: 0. RxData |
| 1 | `RxRdData` | Reset: 0. RxData |
| 0 | `RxCmd` | Reset: 0. RxCmd |


## DFPMCx00000[D4...E8]A — DF/CAKE — CAKE RETRY_STAT Retry Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_RETRY_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D4A _instCAKEXGMI1; DFPMCx00000D8A _instCAKEXGMI2; DFPMCx00000DCA _instCAKEXGMI3; DFPMCx00000E0A _instCAKEXGMI4; DFPMCx00000E4A _instCAKEXGMI5; DFPMCx00000E8A`

RawReady

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RawReady` | Reset: 0. 0= Count only cycles where CAKE/CCM has something to send. 1= Count all cycles. RawReady |
| 2:0 | `Mode` | Reset: 0h. Mode Value Description 0h Count all cycles (subject to RAW_READY) where PCS is not asserting ready. 1h Count all cycles (subject to RAW_READY) where PCS has not asserted ready for 16 or more cycles. 2h Count events where ready deasserted for 16 cycles or more (not subject to RAW_READY) 7h-3h Reserved. |


## DFPMCx00000[D4...E8]B — DF/CAKE — CAKE FTIIN_STAT FTI Inbound Transaction Sources

**Symbolic:** `DF::PMC::CAKE::CAKE_FTIIN_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D4B _instCAKEXGMI1; DFPMCx00000D8B _instCAKEXGMI2; DFPMCx00000DCB _instCAKEXGMI3; DFPMCx00000E0B _instCAKEXGMI4; DFPMCx00000E4B _instCAKEXGMI5; DFPMCx00000E8B`

Probe directed allocation.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `PrbDirAllo` | Reset: 0. Probe directed allocation. |
| 10 | `PrbMcstAllo` | Reset: 0. Probe multi-cast allocation. |
| 9 | `PrbRspNd` | Reset: 0. Probe response without data. |
| 8 | `PrbRspDat` | Reset: 0. Probe response with data. |
| 7 | `Prb1DirAllo` | Reset: 0. Second Probe channel directed allocation. |
| 6 | `Prb1McstAllo` | Reset: 0. Second Probe channel multi-cast allocation. |
| 5 | `RspNdAlloc` | Reset: 0. RspNdAlloc |
| 4 | `PrbAlloc` | Reset: 0. PrbAlloc |
| 3 | `RspAlloc` | Reset: 0. RspAlloc |
| 2 | `ReqAlloc` | Reset: 0. ReqAlloc |
| 1 | `RspLcl` | Reset: 0. RspLcl |
| 0 | `ReqLcl` | Reset: 0. ReqLcl |


## DFPMCx00000[D4...E8]C — DF/CAKE — CAKE PACK_STAT_1 Packing Buffer Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_PACK_STAT_1`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D4C _instCAKEXGMI1; DFPMCx00000D8C _instCAKEXGMI2; DFPMCx00000DCC _instCAKEXGMI3; DFPMCx00000E0C _instCAKEXGMI4; DFPMCx00000E4C _instCAKEXGMI5; DFPMCx00000E8C`

Raw Request No data at threshold.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9 | `RawRq1Thr` | Reset: 0. Raw Request No data at threshold. |
| 8 | `CmpRq1Thr` | Reset: 0. Compressed Request No data at threshold. |
| 7 | `RawPrbThr` | Reset: 0. Raw Probe at threshold. |
| 6 | `RawTknThr` | Reset: 0. Raw Token at threshold. |
| 5 | `CmpTknThr` | Reset: 0. Compressed Token at threshold. |
| 4 | `RawVicThr` | Reset: 0. Raw Victim at threshold. |
| 3 | `RawReqThr` | Reset: 0. Raw Request at threshold. |
| 2 | `CmpReqThr` | Reset: 0. Compressed Request at threshold. |
| 1 | `RawRspThr` | Reset: 0. Raw Response at threshold. |
| 0 | `CmpRspThr` | Reset: 0. Compressed Response at threshold. |


## DFPMCx00000[D4...E8]D — DF/CAKE — CAKE PACK_STAT_2 Packing Buffer Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_PACK_STAT_2`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D4D _instCAKEXGMI1; DFPMCx00000D8D _instCAKEXGMI2; DFPMCx00000DCD _instCAKEXGMI3; DFPMCx00000E0D _instCAKEXGMI4; DFPMCx00000E4D _instCAKEXGMI5; DFPMCx00000E8D`

Sent an uncompressed packet.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `UnCmpPkt` | Reset: 0. Sent an uncompressed packet. |
| 6 | `CmpPrbThr` | Reset: 0. Compressed Probe at threshold. |
| 2 | `PackBufMask` | Reset: 0. Counts the number of packets that include a certain number (specified by DF::CakePckBufPerfMonCtl ) of unmasked (specified by DF::CakePckBufPerfMonMsk ) transactions. When all unmasked thresholds are met (specified by DF::CakePckBufPerfMonCtl [ PackThresholdMode ], then the PerfMon will increment. |
| 1 | `CmpRspNdThr` | Reset: 0. Compressed Response ND at threshold. |
| 0 | `RawRspNdThr` | Reset: 0. Raw Response ND at threshold. |


## DFPMCx00000[D4...E8]E — DF/CAKE — CAKE PCS_OUT_FLIT1_STAT PCS Outbound Flit 1 (TX) Stats

**Symbolic:** `DF::PMC::CAKE::CAKE_PCS_OUT_FLIT1_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D4E _instCAKEXGMI1; DFPMCx00000D8E _instCAKEXGMI2; DFPMCx00000DCE _instCAKEXGMI3; DFPMCx00000E0E _instCAKEXGMI4; DFPMCx00000E4E _instCAKEXGMI5; DFPMCx00000E8E`

TxMeta

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `TxIdle` | Reset: 0. TxMeta |
| 6 | `TxToken` | Reset: 0. TxMeta |
| 5 | `TxByteEn` | Reset: 0. TxByteEn |
| 4 | `TxMeta` | Reset: 0. TxMeta |
| 3 | `TxNop` | Reset: 0. TxNop |
| 2 | `TxWrData` | Reset: 0. TxData |
| 1 | `TxRdData` | Reset: 0. TxData |
| 0 | `TxCmd` | Reset: 0. TxCmd |


## DFPMCx00000[D4...E8]F — DF/CAKE — CAKE DAT_COMP_STAT2 Data Compression Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_DAT_COMP_STAT2`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D4F _instCAKEXGMI1; DFPMCx00000D8F _instCAKEXGMI2; DFPMCx00000DCF _instCAKEXGMI3; DFPMCx00000E0F _instCAKEXGMI4; DFPMCx00000E4F _instCAKEXGMI5; DFPMCx00000E8F`

Response Data Compressed Pattern 3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RspInRdPat3` | Reset: 0. Response Data Compressed Pattern 3. |
| 6 | `RspInRdPat2` | Reset: 0. Response Data Compressed Pattern 2. |
| 5 | `RspInRdPat1` | Reset: 0. Response Data Compressed Pattern 1. |
| 4 | `RspInRdPat0` | Reset: 0. Response Data Compressed Pattern 0. |
| 3 | `ReqInRdPat3` | Reset: 0. Request Data Compressed Pattern 3. |
| 2 | `ReqInRdPat2` | Reset: 0. Request Data Compressed Pattern 2. |
| 1 | `ReqInRdPat1` | Reset: 0. Request Data Compressed Pattern 1. |
| 0 | `ReqInRdPat0` | Reset: 0. Request Data Compressed Pattern 0. |


## DFPMCx00000[D5...E9]0 — DF/CAKE — CAKE LWC_STAT Large Write Combining Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_LWC_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D50 _instCAKEXGMI1; DFPMCx00000D90 _instCAKEXGMI2; DFPMCx00000DD0 _instCAKEXGMI3; DFPMCx00000E10 _instCAKEXGMI4; DFPMCx00000E50 _instCAKEXGMI5; DFPMCx00000E90`

Split a combined write which contained 2 requests.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6 | `SplitLWC2` | Reset: 0. Split a combined write which contained 2 requests. |
| 5 | `SplitLWC3` | Reset: 0. Split a combined write which contained 3 requests. |
| 4 | `SplitLWC4` | Reset: 0. Split a combined write which contained 4 requests. |
| 3 | `SentLWC1` | Reset: 0. Sent a combined write containing 1 requests. |
| 2 | `SentLWC2` | Reset: 0. Sent a combined write containing 2 requests. |
| 1 | `SentLWC3` | Reset: 0. Sent a combined write containing 3 requests. |
| 0 | `SentLWC4` | Reset: 0. Sent a combined write containing 4 requests. |


## DFPMCx00000[D5...E9]1 — DF/CAKE — CAKE LWC_STAT2 Large Write Combining Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_LWC_STAT2`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D51 _instCAKEXGMI1; DFPMCx00000D91 _instCAKEXGMI2; DFPMCx00000DD1 _instCAKEXGMI3; DFPMCx00000E11 _instCAKEXGMI4; DFPMCx00000E51 _instCAKEXGMI5; DFPMCx00000E91`

Sent a four-to-one data compression request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5 | `Cmp4to1` | Reset: 0. Sent a four-to-one data compression request. |
| 4 | `NoCombData` | Reset: 0. Combining opportunity lost data pattern mismatch. |
| 3 | `NoCombMstr` | Reset: 0. Combining opportunity lost master write sent. |
| 2 | `Combine2` | Reset: 0. Marked a second write in sequence as combinable. |
| 1 | `Combine3` | Reset: 0. Marked a third write in sequence as combinable. |
| 0 | `Combine4` | Reset: 0. Marked a fourth write in sequence as combinable. |


## DFPMCx00000[D5...E9]2 — DF/CAKE — CAKE REQIN_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_REQIN_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D52 _instCAKEXGMI1; DFPMCx00000D92 _instCAKEXGMI2; DFPMCx00000DD2 _instCAKEXGMI3; DFPMCx00000E12 _instCAKEXGMI4; DFPMCx00000E52 _instCAKEXGMI5; DFPMCx00000E92`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]3 — DF/CAKE — CAKE RSPIN_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_RSPIN_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D53 _instCAKEXGMI1; DFPMCx00000D93 _instCAKEXGMI2; DFPMCx00000DD3 _instCAKEXGMI3; DFPMCx00000E13 _instCAKEXGMI4; DFPMCx00000E53 _instCAKEXGMI5; DFPMCx00000E93`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]4 — DF/CAKE — CAKE PRBIN_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_PRBIN_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D54 _instCAKEXGMI1; DFPMCx00000D94 _instCAKEXGMI2; DFPMCx00000DD4 _instCAKEXGMI3; DFPMCx00000E14 _instCAKEXGMI4; DFPMCx00000E54 _instCAKEXGMI5; DFPMCx00000E94`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]5 — DF/CAKE — CAKE RNDIN_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_RNDIN_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D55 _instCAKEXGMI1; DFPMCx00000D95 _instCAKEXGMI2; DFPMCx00000DD5 _instCAKEXGMI3; DFPMCx00000E15 _instCAKEXGMI4; DFPMCx00000E55 _instCAKEXGMI5; DFPMCx00000E95`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]6 — DF/CAKE — CAKE DATREQIN_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_DATREQIN_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D56 _instCAKEXGMI1; DFPMCx00000D96 _instCAKEXGMI2; DFPMCx00000DD6 _instCAKEXGMI3; DFPMCx00000E16 _instCAKEXGMI4; DFPMCx00000E56 _instCAKEXGMI5; DFPMCx00000E96`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]7 — DF/CAKE — CAKE DATRSPIN_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_DATRSPIN_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D57 _instCAKEXGMI1; DFPMCx00000D97 _instCAKEXGMI2; DFPMCx00000DD7 _instCAKEXGMI3; DFPMCx00000E17 _instCAKEXGMI4; DFPMCx00000E57 _instCAKEXGMI5; DFPMCx00000E97`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]8 — DF/CAKE — CAKE REQOUT_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_REQOUT_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D58 _instCAKEXGMI1; DFPMCx00000D98 _instCAKEXGMI2; DFPMCx00000DD8 _instCAKEXGMI3; DFPMCx00000E18 _instCAKEXGMI4; DFPMCx00000E58 _instCAKEXGMI5; DFPMCx00000E98`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]9 — DF/CAKE — CAKE RSPOUT_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_RSPOUT_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D59 _instCAKEXGMI1; DFPMCx00000D99 _instCAKEXGMI2; DFPMCx00000DD9 _instCAKEXGMI3; DFPMCx00000E19 _instCAKEXGMI4; DFPMCx00000E59 _instCAKEXGMI5; DFPMCx00000E99`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]A — DF/CAKE — CAKE PRBOUT_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_PRBOUT_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D5A _instCAKEXGMI1; DFPMCx00000D9A _instCAKEXGMI2; DFPMCx00000DDA _instCAKEXGMI3; DFPMCx00000E1A _instCAKEXGMI4; DFPMCx00000E5A _instCAKEXGMI5; DFPMCx00000E9A`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]B — DF/CAKE — CAKE DATREQOUT_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_DATREQOUT_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D5B _instCAKEXGMI1; DFPMCx00000D9B _instCAKEXGMI2; DFPMCx00000DDB _instCAKEXGMI3; DFPMCx00000E1B _instCAKEXGMI4; DFPMCx00000E5B _instCAKEXGMI5; DFPMCx00000E9B`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]C — DF/CAKE — CAKE DATRSPOUT_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CAKE::CAKE_DATRSPOUT_OCC`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D5C _instCAKEXGMI1; DFPMCx00000D9C _instCAKEXGMI2; DFPMCx00000DDC _instCAKEXGMI3; DFPMCx00000E1C _instCAKEXGMI4; DFPMCx00000E5C _instCAKEXGMI5; DFPMCx00000E9C`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[D5...E9]D — DF/CAKE — CAKE PACK_STAT_3 Packing Buffer Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_PACK_STAT_3`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D5D _instCAKEXGMI1; DFPMCx00000D9D _instCAKEXGMI2; DFPMCx00000DDD _instCAKEXGMI3; DFPMCx00000E1D _instCAKEXGMI4; DFPMCx00000E5D _instCAKEXGMI5; DFPMCx00000E9D`

Raw Request no data loaded into packing buffer.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9 | `RawRq1` | Reset: 0. Raw Request no data loaded into packing buffer. |
| 8 | `CmpRq1` | Reset: 0. Compressed Request no data loaded into packing buffer. |
| 7 | `RawPrb` | Reset: 0. Raw Probe loaded into packing buffer. |
| 6 | `CmpRnd` | Reset: 0. Compressed Response-no-data loaded into packing buffer. |
| 5 | `RawRnd` | Reset: 0. Raw Response-no-data loaded into packing buffer. |
| 4 | `RawVic` | Reset: 0. Raw Victim loaded into packing buffer. |
| 3 | `RawReq` | Reset: 0. Raw Request loaded into packing buffer. |
| 2 | `CmpReq` | Reset: 0. Compressed Request loaded into packing buffer. |
| 1 | `RawRsp` | Reset: 0. Raw Response loaded into packing buffer. |
| 0 | `CmpRsp` | Reset: 0. Compressed Response loaded into packing buffer. |


## DFPMCx00000[D5...E9]F — DF/CAKE — CAKE DATA_BW Data Bandwidth

**Symbolic:** `DF::PMC::CAKE::CAKE_DATA_BW`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D5F _instCAKEXGMI1; DFPMCx00000D9F _instCAKEXGMI2; DFPMCx00000DDF _instCAKEXGMI3; DFPMCx00000E1F _instCAKEXGMI4; DFPMCx00000E5F _instCAKEXGMI5; DFPMCx00000E9F`

SrcDst mode selection for Req beats

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:10 | `ReqSrcDstMode` | Reset: 0h. SrcDst mode selection for Req beats Value Description 0h Disabled. No Req beats counted 1h Count Req beats where receiver (FabRcv) matches SrcDst field 2h Count Req beats where sender (FabXmt) matches SrcDst field 3h Count all Req beats, regardless of SrcDst field |
| 9:8 | `RspSrcDstMode` | Reset: 0h. SrcDst mode selection for Rsp beats. (FabXmt is invalid for beats from CAKE to FTI) Value Description 0h Disabled. No Rsp beats counted 1h Count Rsp beats where receiver (FabRcv) matches SrcDst field 2h Count Rsp beats where sender (FabXmt) matches SrcDst field 3h Count all Rsp beats, regardless of SrcDst field |
| 5:1 | `SrcDst` | Reset: 00h. Select transactions based on the source/dest of the data - UMC, CXL™, IO, GPU, or CPU. Multi-bit selects are also possible. See Mode fields for more options Value Description 00h Disabled. No transactions selected 01h Count only beats to/from UMC 02h Count only beats to/from CPU 03h Reserved. 04h Count only beats to/from GPU 07h-05h Reserved. 08h Count only beats to/from IO 0Fh-09h Reserved. 10h Count only beats to/from CXL 1Eh-11h Reserved. 1Fh Count any beat |
| 0 | `Dirn` | Reset: 0. 0= Count Data Beats from FTI to CAKE (outbound to link) . 1= Count Data Beats from CAKE to FTI (inbound from link) . Select Direction of Data Movement |


## DFPMCx00000[D6...EA]0 — DF/CAKE — CAKE PACK_STAT_4 Packing Buffer Statistics

**Symbolic:** `DF::PMC::CAKE::CAKE_PACK_STAT_4`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D60 _instCAKEXGMI1; DFPMCx00000DA0 _instCAKEXGMI2; DFPMCx00000DE0 _instCAKEXGMI3; DFPMCx00000E20 _instCAKEXGMI4; DFPMCx00000E60 _instCAKEXGMI5; DFPMCx00000EA0`

Raw Victim Compression Pck Gnt for Nd Channel

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8 | `RawVic1` | Reset: 0. Raw Victim Compression Pck Gnt for Nd Channel |
| 7 | `UsrTkn` | Reset: 0. Compressed token sent in extra USR command sector. |
| 6 | `UsrRsp` | Reset: 0. Compressed response sent in extra USR command sector. |
| 5 | `RawAtm` | Reset: 0. Raw Atomic loaded into packing buffer. |
| 4 | `CmpPrb` | Reset: 0. Compressed Probe loaded into packing buffer. |
| 3 | `PckAny` | Reset: 0. Any packet type loaded into packing buffer. |
| 2 | `RawTkn` | Reset: 0. Raw token packet loaded into packing buffer. |
| 1 | `CmpTkn` | Reset: 0. Compressed token packet loaded into packing buffer. |
| 0 | `FtoReq` | Reset: 0. Four-to-one data compression request loaded into packing buffer. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE CCMCS_RDBLK_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_CCMCS_RDBLK_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is CCM to CS/ CMP RdBlk) 01h Any fails 02h 56-bit address 03h Ack 04h Not ordered 05h No TMZ 06h RspPassPw 07h PassPw 08h Security level 09h Attr 0Ah VC 0Bh Node ID 1Fh-0Ch Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 00h Request CCM to CS/CSCMP RdBlk 09h-01h Reserved. 0Ah Request no data CCM to CS/CSCMP RdBlk 1Fh-0Bh Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE CCMCS_WRSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_CCMCS_WRSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is CCM to CS/ CMP WrSized) 01h Any fails 02h 56-bit address 03h QOS priority Low 04h Ack 05h Not ordered 06h No TMZ 07h RspPassPw 08h PassPw 09h Security level 0Ah Aligned 32/64 bit 0Bh Attr 0Ch VC 0Dh Node ID 1Fh-0Eh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 00h Reserved. 01h Request CCM to CS/CSCMP WrSized 0Ah-02h Reserved. 0Bh Request no data CCM to CS/CSCMP WrSized 1Fh-0Ch Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE COMP_CHK_STAT Transaction compression events

**Symbolic:** `DF::PMC::CAKE::CAKE_COMP_CHK_STAT`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Select one of the transaction types to count compression events for.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Select one of the transaction types to count compression events for. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE GCMCS_RDSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_GCMCS_RDSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is GCM to CS/ CMP RdSized ) 01h Any fails 02h Reserved. 03h 56-bit address 04h QOS priority based on CntlGcmRdQosPri0 05h Large read check 06h GCM unit id check based on GCMCompUnitIdTbl* 07h Ack 08h Not ordered 09h No TMZ 0Ah RspPassPw 0Bh PassPw 0Ch Security level 0Dh Aligned 32/64 bit 0Eh Attr 0Fh VC 10h Node ID 11h GcmFabIdSlice 1Fh-12h Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 01h-00h Reserved. 02h Request GCM to CS/CSCMP RdSized 0Bh-03h Reserved. 0Ch Request no data GCM to CS/CSCMP RdSized 1Fh-0Dh Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE GCMCS_WRSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_GCMCS_WRSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is GCM to CS/ CMP WrSized ) 01h Any fails 02h Reserved. 03h 56-bit address 04h QOS priority based on CntlGcmWrQosPri 05h GCM unit id check based on GCMCompUnitIdTbl* 06h Ack 07h Not ordered 08h No TMZ 09h RspPassPw 0Ah PassPw 0Bh Security level 0Ch Aligned 32/64 bit 0Dh Attr 0Eh VC 0Fh Node ID 10h GcmFabIdSlice 1Fh-11h Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 02h-00h Reserved. 03h Request GCM to CS/CSCMP WrSized 0Ch-04h Reserved. 0Dh Request no data GCM to CS/CSCMP WrSized 1Fh-0Eh Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE IOMCS_RDSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_IOMCS_RDSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is IOM/GIOM to CS/ CMP RdSized ) 01h Any fails 02h IO Rd source 03h 56-bit address 04h QOS priority Low/Med 05h Large read check 06h Ack 07h Not ordered 08h No TMZ 09h RspPassPw 0Ah Security level 0Bh Aligned 32/64 bit 0Ch Attr 0Dh VC 0Eh Node ID 1Fh-0Fh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 03h-00h Reserved. 04h Request IOM/GIOM to CS/CSCMP RdSized 0Dh-05h Reserved. 0Eh Request no data IOM/GIOM to CS/CSCMP RdSized 1Fh-0Fh Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE IOMCS_WRSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_IOMCS_WRSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is IOM/GIOM to CS/ CMP WrSized ) 01h Any fails 02h IO Wr source 03h 56-bit address 04h QOS priority Low 05h No chain 06h Not ordered 07h No TMZ 08h RspPassPw 09h Security level 0Ah Aligned 32/64 bit 0Bh Attr 0Ch VC 0Dh Node ID 1Fh-0Eh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 04h-00h Reserved. 05h Request IOM/GIOM to CS/CSCMP WrSized 0Eh-06h Reserved. 0Fh Request no data IOM/GIOM to CS/CSCMP WrSized 1Fh-10h Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE IOMIOS_RDSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_IOMIOS_RDSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is IOM to IOS RdSized ) 01h Any fails 02h 56-bit address 03h Ack 04h Not ordered 05h No TMZ 06h Security level 07h Aligned 32/64 bit 08h Attr 09h VC 0Ah Node ID 1Fh-0Bh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 07h-00h Reserved. 08h Request IOM to IOS RdSized 11h-09h Reserved. 12h Request no data IOM to IOS RdSized 1Fh-13h Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE IOMIOS_WRSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_IOMIOS_WRSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is IOM to IOS WrSized ) 01h Any fails 02h 56-bit address 03h QOS priority Low 04h Ack 05h Not ordered 06h No TMZ 07h Security level 08h Aligned 32/64 bit 09h VC 0Ah Node ID 1Fh-0Bh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 08h-00h Reserved. 09h Request IOM to IOS WrSized 12h-0Ah Reserved. 13h Request no data IOM to IOS WrSized 1Fh-14h Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE NCMCS_RDSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_NCMCS_RDSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is NCM to CS/ CMP RdSized ) 01h Any fails 02h 56-bit address 03h Large read check 04h NCM unit id check based on CntlMMHCompUnitIdTbl* 05h Ack 06h Not ordered 07h No TMZ 08h RspPassPw 09h PassPw 0Ah Security level 0Bh Aligned 32/64 bit 0Ch Attr 0Dh VC 0Eh Node ID 1Fh-0Fh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 05h-00h Reserved. 06h Request NCM to CS/CSCMP RdSized 0Fh-07h Reserved. 10h Request no data NCM to CS/CSCMP RdSized 1Fh-11h Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE NCMCS_WRSZ_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_NCMCS_WRSZ_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is NCM to CS/ CMP WrSized ) 01h Any fails 02h 56-bit address 03h QOS priority Low 04h NCM unit id check based on CntlMMHCompUnitIdTbl* 05h Ack 06h Not ordered 07h No TMZ 08h RspPassPw 09h PassPw 0Ah Security level 0Bh Aligned 32/64 bit 0Ch Attr 0Dh VC 0Eh Node ID 1Fh-0Fh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 06h-00h Reserved. 07h Request NCM to CS/CSCMP WrSized 10h-08h Reserved. 11h Request no data NCM to CS/CSCMP WrSized 1Fh-12h Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE SRCDN_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_SRCDN_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is SRCDN) 01h Any fails 02h VC 03h RspSrc check 04h FabRcv is CS 05h No Data and NumBeats is 1 06h No InvCnt 07h No Cancel 1Fh-08h Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 15h-00h Reserved. 16h Response SRCDN 1Ah-17h Reserved. 1Bh Response no data SRCDN 1Fh-1Ch Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE TGTDND_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_TGTDND_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is TGTDND) 01h Any fails 02h UnitId check 03h FabRcv check 04h VC 05h NumBeats set 06h PassPw 07h State check 08h No PassDirty 09h No InvCnt 0Ah No Final 0Bh No WrNoData 0Ch No SpecHit 0Dh RspStatus OK 0Eh ExpPrbRspCnt check 0Fh No Start 1Fh-10h Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 16h-00h Reserved. 17h Response TGTDND 1Bh-18h Reserved. 1Ch Response no data TGTDND 1Fh-1Dh Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE TGTDNIO_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_TGTDNIO_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is TGTDNIO) 01h Any fails 02h UnitId check 03h VC 04h No TxnOffset 05h PassPw 06h State check 07h No PassDirty 08h No InvCnt 09h No Hold 0Ah No WrNoData 0Bh No SpecHit 0Ch No ExpPrbRspCnt 0Dh RspStatus OK 0Eh No Start 1Fh-0Fh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 17h-00h Reserved. 18h Response TGTDNIO 1Ch-19h Reserved. 1Dh Response no data TGTDNIO 1Fh-1Eh Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE TGTDN_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_TGTDN_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is TGTDN) 01h Any fails 02h Unit id check 03h FabRcv check 04h VC 05h No TxnOffset 06h PassPw 07h No PassDirty 08h No InvCnt 09h No Hold 0Ah No WrNoData 0Bh No SpecHit 0Ch RspStatus OK 0Dh ExpPrbRspCnt check 0Eh No Start 1Fh-0Fh Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 13h-00h Reserved. 14h Response TGTDN 18h-15h Reserved. 19h Response no data TGTDN 1Fh-1Ah Reserved. |


## DFPMCx00000[D6...EA]1 — DF/CAKE — CAKE TGTST_COMP_CHK Compression Fail Events

**Symbolic:** `DF::PMC::CAKE::CAKE_TGTST_COMP_CHK`  
**Instance:** `_instCAKEXGMI0; DFPMCx00000D61 _instCAKEXGMI1; DFPMCx00000DA1 _instCAKEXGMI2; DFPMCx00000DE1 _instCAKEXGMI3; DFPMCx00000E21 _instCAKEXGMI4; DFPMCx00000E61 _instCAKEXGMI5; DFPMCx00000EA1`

Identifies cause for compression failure.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 9:5 | `TransSelect` | Reset: 00h. Identifies cause for compression failure. Value Description 00h Decode only. Is TGTST) 01h Any fails 02h VC 03h FabRcv check 04h No ExpPrbRspCnt 05h No UnitId 06h No UnitIdVal 07h No TxnOffset 08h No InvCnt 09h No Done 1Fh-0Ah Reserved. |
| 4:0 | `CondSelect` | Reset: 00h. Select the compression event to count for the selected transaction type. Value Description 14h-00h Reserved. 15h Response TGTST 19h-16h Reserved. 1Ah Response no data TGTST 1Fh-1Bh Reserved. |


## DFPMCx00000[EC...F8]0 — DF/CNLI — CNLI MRQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_MRQ_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC0 _instCNLI1; DFPMCx00000F00 _instCNLI2; DFPMCx00000F40 _instCNLI3; DFPMCx00000F80`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]1 — DF/CNLI — CNLI MRD_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_MRD_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC1 _instCNLI1; DFPMCx00000F01 _instCNLI2; DFPMCx00000F41 _instCNLI3; DFPMCx00000F81`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]2 — DF/CNLI — CNLI MEM_RSP_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_RSP_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC2 _instCNLI1; DFPMCx00000F02 _instCNLI2; DFPMCx00000F42 _instCNLI3; DFPMCx00000F82`

Counts event only on the selected CNLI Queue. 0: MRRS; 1: MWRS

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `QSel` | Reset: 0. Counts event only on the selected CNLI Queue. 0: MRRS; 1: MWRS |
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]3 — DF/CNLI — CNLI DRQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_DRQ_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC3 _instCNLI1; DFPMCx00000F03 _instCNLI2; DFPMCx00000F43 _instCNLI3; DFPMCx00000F83`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]4 — DF/CNLI — CNLI PRQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_PRQ_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC4 _instCNLI1; DFPMCx00000F04 _instCNLI2; DFPMCx00000F44 _instCNLI3; DFPMCx00000F84`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]5 — DF/CNLI — CNLI DDB_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_DDB_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC5 _instCNLI1; DFPMCx00000F05 _instCNLI2; DFPMCx00000F45 _instCNLI3; DFPMCx00000F85`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:6 | `DevReqThreshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. Value Description 00h Reserved. 01h 4 entries. 02h 8 entries. 03h Reserved. 04h 16 entries. 07h-05h Reserved. 08h 32 entries. 0Fh-09h Reserved. 10h 64 entries. 1Fh-11h Reserved. 20h 96 entries. 3Fh-21h Reserved. |
| 5:0 | `PrbThreshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. Value Description 00h Reserved. 01h 4 entries. 02h 8 entries. 03h Reserved. 04h 16 entries. 07h-05h Reserved. 08h 32 entries. 0Fh-09h Reserved. 10h 64 entries. 1Fh-11h Reserved. 20h 96 entries. 3Fh-21h Reserved. |


## DFPMCx00000[EC...F8]6 — DF/CNLI — CNLI HRSQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_HRSQ_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC6 _instCNLI1; DFPMCx00000F06 _instCNLI2; DFPMCx00000F46 _instCNLI3; DFPMCx00000F86`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]7 — DF/CNLI — CNLI HRSD_OCC Queue Occupancy

**Symbolic:** `DF::PMC::CNLI::CNLI_HRSD_OCC`  
**Instance:** `_instCNLI0; DFPMCx00000EC7 _instCNLI1; DFPMCx00000F07 _instCNLI2; DFPMCx00000F47 _instCNLI3; DFPMCx00000F87`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 5:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00000[EC...F8]8 — DF/CNLI — CNLI MEM_REQ Request Type

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_REQ`  
**Instance:** `_instCNLI0; DFPMCx00000EC8 _instCNLI1; DFPMCx00000F08 _instCNLI2; DFPMCx00000F48 _instCNLI3; DFPMCx00000F88`

PrbAsReq for write request from CS

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `PrbAsReqWr` | Reset: 0. PrbAsReq for write request from CS |
| 10 | `PrbAsReqRd` | Reset: 0. PrbAsReq for read request from CS |
| 9 | `ChgToXNR` | Reset: 0. ChgToXNR request from CS |
| 8 | `RinseVictim` | Reset: 0. Rinsing Victim request from CS |
| 7 | `DirtyVictim` | Reset: 0. Dirty Victim request from CS |
| 6 | `WrSizedFull` | Reset: 0. WrSizedFull (type 2) or WrSizedFullNc(type 3) request from CS |
| 5 | `WrSized` | Reset: 0. WrSized (type 2) or WrSizedNc(type 3) request from CS |
| 4 | `RdSized` | Reset: 0. RdSized (type 2) or RdSizedNc (type 3) request from CS |
| 3 | `RdBlk` | Reset: 0. RdBlk request from CS |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00000[EC...F8]9 — DF/CNLI — CNLI REQ_PICK Request Picker

**Symbolic:** `DF::PMC::CNLI::CNLI_REQ_PICK`  
**Instance:** `_instCNLI0; DFPMCx00000EC9 _instCNLI1; DFPMCx00000F09 _instCNLI2; DFPMCx00000F49 _instCNLI3; DFPMCx00000F89`

Picker favored over Flit Buf bypass due to saturation. PickerSel is ignored for this event

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `BypSat` | Reset: 0. Picker favored over Flit Buf bypass due to saturation. PickerSel is ignored for this event |
| 6 | `WrWon` | Reset: 0. Write request was picked over a read request. |
| 5 | `LowWon` | Reset: 0. Low/Medium priority request was picked over a higher (High or Urgent) priority request. |
| 4 | `AnyPick` | Reset: 0. Any request picked. Counts number of picks |
| 3 | `PickerSel` | Reset: 0. Picker select. 0=Picker0 Sel, 1=Picker1 Sel |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00000[EC...F8]A — DF/CNLI — CNLI MEM_PRI Incoming Request VC and Priority Levels

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_PRI`  
**Instance:** `_instCNLI0; DFPMCx00000ECA _instCNLI1; DFPMCx00000F0A _instCNLI2; DFPMCx00000F4A _instCNLI3; DFPMCx00000F8A`

Select Priority to be counted.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:5 | `SelPri` | Reset: 0h. Select Priority to be counted. Value Description 0h Low priority. 1h Medium priority. 2h High priority. 3h Urgent priority. 6h-4h Reserved. 7h All priority transactions. |
| 4 | `WrEn` | Reset: 0. Count writes as selected by SelPri. |
| 3 | `RdEn` | Reset: 0. Count reads as selected by SelPri. |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00000[EC...F8]B — DF/CNLI — CNLI MEM_BYP Bypass and Retry

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_BYP`  
**Instance:** `_instCNLI0; DFPMCx00000ECB _instCNLI1; DFPMCx00000F0B _instCNLI2; DFPMCx00000F4B _instCNLI3; DFPMCx00000F8B`

Un-encrypted Read Response bypassed to the end of pipeline.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `UnEncRspBypBot` | Reset: 0. Un-encrypted Read Response bypassed to the end of pipeline. |
| 6 | `UnEncRspBypTop` | Reset: 0. Un-encrypted Read Response bypassed to the top of pipeline. |
| 5 | `EncRspByp` | Reset: 0. Encrypted Read Response bypassed. |
| 4 | `ReqPackByp` | Reset: 0. Read bypass to PackingBuffer. |
| 3 | `ReqFlitByp` | Reset: 0. Read Bypass to FlitBuffer. |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00000[EC...F8]C — DF/CNLI — CNLI MEM_REQ_FLIT0 .Mem Request Flit Packing

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_REQ_FLIT0`  
**Instance:** `_instCNLI0; DFPMCx00000ECC _instCNLI1; DFPMCx00000F0C _instCNLI2; DFPMCx00000F4C _instCNLI3; DFPMCx00000F8C`

Number of Data Slots in .mem Protocol Flit: 1/2/3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in .mem Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoReq` | Reset: 0. Two Req in .mem Protocol Flit. |
| 6 | `OneReq` | Reset: 0. Only One Req in .mem Protocol Flit, not including FlitBypass. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `OutFlit` | Reset: 0. Outgoing Flit excluding those having CRC errors. |


## DFPMCx00000[EC...F8]D — DF/CNLI — CNLI MEM_REQ_FLIT1 .Mem Request Flit Packing

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_REQ_FLIT1`  
**Instance:** `_instCNLI0; DFPMCx00000ECD _instCNLI1; DFPMCx00000F0D _instCNLI2; DFPMCx00000F4D _instCNLI3; DFPMCx00000F8D`

Number of Data Slots in .mem Protocol Flit: 1/2/3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in .mem Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoReq` | Reset: 0. Two Req in .mem Protocol Flit. |
| 6 | `OneReq` | Reset: 0. Only One Req in .mem Protocol Flit, not including FlitBypass. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `OutFlit` | Reset: 0. Outgoing Flit excluding those having CRC errors. |


## DFPMCx00000[EC...F8]E — DF/CNLI — CNLI MEM_REQ_FLIT2 .Mem Request Flit Packing

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_REQ_FLIT2`  
**Instance:** `_instCNLI0; DFPMCx00000ECE _instCNLI1; DFPMCx00000F0E _instCNLI2; DFPMCx00000F4E _instCNLI3; DFPMCx00000F8E`

Number of Data Slots in .mem Protocol Flit: 1/2/3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in .mem Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoReq` | Reset: 0. Two Req in .mem Protocol Flit. |
| 6 | `OneReq` | Reset: 0. Only One Req in .mem Protocol Flit, not including FlitBypass. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `OutFlit` | Reset: 0. Outgoing Flit excluding those having CRC errors. |


## DFPMCx00000[EC...F8]F — DF/CNLI — CNLI MEM_REQ_FLIT3 .Mem Request Flit Packing

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_REQ_FLIT3`  
**Instance:** `_instCNLI0; DFPMCx00000ECF _instCNLI1; DFPMCx00000F0F _instCNLI2; DFPMCx00000F4F _instCNLI3; DFPMCx00000F8F`

Number of Data Slots in .mem Protocol Flit: 1/2/3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in .mem Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoReq` | Reset: 0. Two Req in .mem Protocol Flit. |
| 6 | `OneReq` | Reset: 0. Only One Req in .mem Protocol Flit, not including FlitBypass. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `OutFlit` | Reset: 0. Outgoing Flit excluding those having CRC errors. |


## DFPMCx00000[ED...F9]0 — DF/CNLI — CNLI MEM_RSP_FLIT0 .Mem Response Flit UnPacking

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_RSP_FLIT0`  
**Instance:** `_instCNLI0; DFPMCx00000ED0 _instCNLI1; DFPMCx00000F10 _instCNLI2; DFPMCx00000F50 _instCNLI3; DFPMCx00000F90`

Flit containing MDH slot.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `MDH` | Reset: 0. Flit containing MDH slot. |
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoNDR` | Reset: 0. Two NDRs in Protocol Flit. |
| 6 | `OneNDR` | Reset: 0. Only One NDR in Protocol Flit. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. Value Description 0h Reserved. 1h 1 valid slot. 2h 2 valid slots. 3h 3 valid slots. 4h 4 valid slots. 5h 0 valid slots. 7h-6h Reserved. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `InFlit` | Reset: 0. Incoming Flit excluding those having CRC errors. |


## DFPMCx00000[ED...F9]1 — DF/CNLI — CNLI MEM_RSP_FLIT1 .Mem Response Flit UnPacking

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_RSP_FLIT1`  
**Instance:** `_instCNLI0; DFPMCx00000ED1 _instCNLI1; DFPMCx00000F11 _instCNLI2; DFPMCx00000F51 _instCNLI3; DFPMCx00000F91`

Flit containing MDH slot.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `MDH` | Reset: 0. Flit containing MDH slot. |
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoNDR` | Reset: 0. Two NDRs in Protocol Flit. |
| 6 | `OneNDR` | Reset: 0. Only One NDR in Protocol Flit. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. Value Description 0h Reserved. 1h 1 valid slot. 2h 2 valid slots. 3h 3 valid slots. 4h 4 valid slots. 5h 0 valid slots. 7h-6h Reserved. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `InFlit` | Reset: 0. Incoming Flit excluding those having CRC errors. |


## DFPMCx00000[ED...F9]2 — DF/CNLI — CNLI MEM_RSP_FLIT2 .Mem Response Flit UnPacking

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_RSP_FLIT2`  
**Instance:** `_instCNLI0; DFPMCx00000ED2 _instCNLI1; DFPMCx00000F12 _instCNLI2; DFPMCx00000F52 _instCNLI3; DFPMCx00000F92`

Flit containing MDH slot.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `MDH` | Reset: 0. Flit containing MDH slot. |
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoNDR` | Reset: 0. Two NDRs in Protocol Flit. |
| 6 | `OneNDR` | Reset: 0. Only One NDR in Protocol Flit. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. Value Description 0h Reserved. 1h 1 valid slot. 2h 2 valid slots. 3h 3 valid slots. 4h 4 valid slots. 5h 0 valid slots. 7h-6h Reserved. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `InFlit` | Reset: 0. Incoming Flit excluding those having CRC errors. |


## DFPMCx00000[ED...F9]3 — DF/CNLI — CNLI MEM_RSP_FLIT3 .Mem Response Flit UnPacking

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_RSP_FLIT3`  
**Instance:** `_instCNLI0; DFPMCx00000ED3 _instCNLI1; DFPMCx00000F13 _instCNLI2; DFPMCx00000F53 _instCNLI3; DFPMCx00000F93`

Flit containing MDH slot.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `MDH` | Reset: 0. Flit containing MDH slot. |
| 10:9 | `NumDatSlot` | Reset: 0h. Number of Data Slots in Protocol Flit: 1/2/3. |
| 8 | `FullDat` | Reset: 0. Full Data .mem Protocol Flit. |
| 7 | `TwoNDR` | Reset: 0. Two NDRs in Protocol Flit. |
| 6 | `OneNDR` | Reset: 0. Only One NDR in Protocol Flit. |
| 5:3 | `NumValidSlot` | Reset: 0h. Number of Valid Slots in .mem Protocol Flit including All-Data Flits: 1/2/3/4. Value Description 0h Reserved. 1h 1 valid slot. 2h 2 valid slots. 3h 3 valid slots. 4h 4 valid slots. 5h 0 valid slots. 7h-6h Reserved. |
| 2 | `MemFlit` | Reset: 0. .mem protocol flit including those having .cache slots. |
| 1 | `Control` | Reset: 0. Control Flit. |
| 0 | `InFlit` | Reset: 0. Incoming Flit excluding those having CRC errors. |


## DFPMCx00000[ED...F9]4 — DF/CNLI — CNLI FLOW_CTRL Flow Control

**Symbolic:** `DF::PMC::CNLI::CNLI_FLOW_CTRL`  
**Instance:** `_instCNLI0; DFPMCx00000ED4 _instCNLI1; DFPMCx00000F14 _instCNLI2; DFPMCx00000F54 _instCNLI3; DFPMCx00000F94`

Count cycles when head of RdRsp queue belongs to this port, but is blocked by CS SDP RrRsp tokens

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CsRdRspTokStall` | Reset: 0. Count cycles when head of RdRsp queue belongs to this port, but is blocked by CS SDP RrRsp tokens |
| 6 | `CsWrRspTokStall` | Reset: 0. Count cycles when head of WdRsp queue belongs to this port, but is blocked by CS SDP WrRsp tokens |
| 5 | `CmdTokRdStall` | Reset: 0. Count cycles when the head of the queue is RdReq and is blocked due to Cmd token |
| 4 | `DatTokWrStall` | Reset: 0. Count cycles when the head of the queue is WrReq and is blocked only due to Data token. Cmd Tok is implicit for writes |
| 3 | `CmpTokStall` | Reset: 0. Count cycles when Packing Buffer is ready but CXLArbMux tokens unavailable |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00000[ED...F9]5 — DF/CNLI — CNLI RETRY CRC Error Retry Monitor

**Symbolic:** `DF::PMC::CNLI::CNLI_RETRY`  
**Instance:** `_instCNLI0; DFPMCx00000ED5 _instCNLI1; DFPMCx00000F15 _instCNLI2; DFPMCx00000F55 _instCNLI3; DFPMCx00000F95`

Stall due to retry buffer reaching capacity

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `RetryBufStall` | Reset: 0. Stall due to retry buffer reaching capacity |
| 6 | `FlitRetransmit` | Reset: 0. A flit has been retransmitted from Retry buffer |
| 5 | `RetryReqRcvd` | Reset: 0. Retry.Req flit seen to recover an error detected on other side |
| 4 | `PhyReinit` | Reset: 0. PHY retraining initiated by CNLI |
| 3 | `CrcError` | Reset: 0. CRC error detected by CNLI |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00000[ED...F9]6 — DF/CNLI — CNLI PRB_REQ Request Type

**Symbolic:** `DF::PMC::CNLI::CNLI_PRB_REQ`  
**Instance:** `_instCNLI0; DFPMCx00000ED6 _instCNLI1; DFPMCx00000F16 _instCNLI2; DFPMCx00000F56 _instCNLI3; DFPMCx00000F96`

Select type of Probe request from ACM.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:9 | `BlockedPrb` | Reset: 0h. Select type of Probe request from ACM. Value Description 0h Reserved. 1h NOP. 2h Share. 3h Fetch. 4h Clean. 5h Migrate. 6h Invalidate. 7h Any Probe type. |
| 8 | `SnpCurr` | Reset: 0. Probe request type as SnpCurr to device |
| 7 | `SnpInv` | Reset: 0. Probe request type as SnpInv to device |
| 6 | `SnpData` | Reset: 0. Probe request type as SnpData to device |
| 5 | `PrbMig` | Reset: 0. ACM Probe request type as PrbMigrate |
| 4 | `PrbClean` | Reset: 0. ACM Probe request type as PrbClean |
| 3 | `PrbFetch` | Reset: 0. ACM Probe request type as PrbFetch |
| 2 | `PrbShare` | Reset: 0. ACM Probe request type as PrbShare |
| 1 | `PrbInv` | Reset: 0. ACM Probe request type as PrbInv |
| 0 | `PrbNop` | Reset: 0. ACM Probe request type as PrbNop |


## DFPMCx00000[ED...F9]7 — DF/CNLI — CNLI PRB_RSP Response Type

**Symbolic:** `DF::PMC::CNLI::CNLI_PRB_RSP`  
**Instance:** `_instCNLI0; DFPMCx00000ED7 _instCNLI1; DFPMCx00000F17 _instCNLI2; DFPMCx00000F57 _instCNLI3; DFPMCx00000F97`

Probe Rsp as RspVFwdV

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10 | `RspVFwdV` | Reset: 0. Probe Rsp as RspVFwdV |
| 9:8 | `RspIFwdM` | Reset: 0h. Select type of Probe request that receives RspIFwdM. Value Description 0h Reserved. 1h SnpCurr. 2h SnpData. 3h SnpInv. |
| 7:6 | `RspSFwdM` | Reset: 0h. Select type of Probe request that receives RspSFwdM. Value Description 0h Reserved. 1h SnpCurr. 2h SnpData. 3h SnpInv. |
| 5 | `RspIHitSE` | Reset: 0. Probe Rsp as RspIHitSE |
| 4:3 | `RspSHitSE` | Reset: 0h. Select type of Probe request that receives RspSHitSE. Value Description 0h Reserved. 1h SnpCurr. 2h SnpData. 3h SnpInv. |
| 2 | `RspVHitV` | Reset: 0. Probe Rsp as RspVHitV |
| 1:0 | `RspIHitI` | Reset: 0h. Select type of Probe request that receives RspIHitI. Value Description 0h Reserved. 1h SnpCurr. 2h SnpData. 3h SnpInv. |


## DFPMCx00000[ED...F9]8 — DF/CNLI — CNLI DEV_REQ Request Type

**Symbolic:** `DF::PMC::CNLI::CNLI_DEV_REQ`  
**Instance:** `_instCNLI0; DFPMCx00000ED8 _instCNLI1; DFPMCx00000F18 _instCNLI2; DFPMCx00000F58 _instCNLI3; DFPMCx00000F98`

Device Request type as Flushed

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `Flushed` | Reset: 0. Device Request type as Flushed |
| 10 | `ClFlush` | Reset: 0. Device Request type as ClFlush |
| 9 | `ClEvictNoDat` | Reset: 0. Device Request type as ClEvictNoDat |
| 8 | `DirEvict` | Reset: 0. Device Request type as DirEvict |
| 7 | `ClEvict` | Reset: 0. Device Request type as ClEvict |
| 6:3 | `Write` | Reset: 0h. Select Stongly-ordered write type of Device request. Value Description 0h Reserved. 1h ItoMwr. 2h MemWr. 3h WrInv. 4h Any SO-Write. 5h WoWrInv. 6h WoWrInvF. 7h Any WO-Write. 8h Any WrSized on SDP. Fh-9h Reserved. |
| 2:0 | `Read` | Reset: 0h. Select read type of Device request. Value Description 0h Reserved. 1h RdCurr. 2h RdOwn. 3h RdShared. 4h RdAny. 5h RdOwnNoDat. 6h Any read. 7h Reserved. |


## DFPMCx00000[ED...F9]9 — DF/CNLI — CNLI DEV_REQ_TYPE2 Request Type

**Symbolic:** `DF::PMC::CNLI::CNLI_DEV_REQ_TYPE2`  
**Instance:** `_instCNLI0; DFPMCx00000ED9 _instCNLI1; DFPMCx00000F19 _instCNLI2; DFPMCx00000F59 _instCNLI3; DFPMCx00000F99`

Device Request type as WrInv to Device-Attached Memory, follow flow for Host-Attached Memory

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 10 | `WrInv` | Reset: 0. Device Request type as WrInv to Device-Attached Memory, follow flow for Host-Attached Memory |
| 9 | `MemWr` | Reset: 0. Device Request type as MemWr to Device-Attached Memory, follow flow for Host-Attached Memory |
| 8 | `ItoMWr` | Reset: 0. Device Request type as ItoMWr to Device-Attached Memory, follow flow for Host-Attached Memory |
| 7 | `WOWrInvF` | Reset: 0. Device Request type as WOWrInvF to Device-Attached Memory |
| 6 | `WOWrInv` | Reset: 0. Device Request type as WOWrInv to Device-Attached Memory |
| 5 | `CLFlush` | Reset: 0. Device Request type as CLFlush to Device-Attached Memory |
| 4 | `RdOwnNoData` | Reset: 0. Device Request type as RdOwnNoData to Device-Attached Memory |
| 3 | `RdAny` | Reset: 0. Device Request type as RdAny to Device-Attached Memory |
| 2 | `RdShared` | Reset: 0. Device Request type as RdShared to Device-Attached Memory |
| 1 | `RdOwn` | Reset: 0. Device Request type as RdOwn to Device-Attached Memory |
| 0 | `RdCurr` | Reset: 0. Device Request type as RdCurr to Device-Attached Memory |


## DFPMCx00000[ED...F9]A — DF/CNLI — CNLI CACHE_OUT_FLIT .Cache Request Flit Packing

**Symbolic:** `DF::PMC::CNLI::CNLI_CACHE_OUT_FLIT`  
**Instance:** `_instCNLI0; DFPMCx00000EDA _instCNLI1; DFPMCx00000F1A _instCNLI2; DFPMCx00000F5A _instCNLI3; DFPMCx00000F9A`

Flit containting MDH slot

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `MDH` | Reset: 0. Flit containting MDH slot |
| 6:4 | `NumValidSlot` | Reset: 0h. Number of Valid Slots (not empty) in .cache Protocol Flit including data slots: 1/2/3/4. |
| 3:1 | `HeaderSlotType` | Reset: 0h. Select Header/Generic Slot Type to be counted. Value Description 0h Reserved. 1h H0. 2h H1. 3h H2. 4h H3. 5h H4. 6h H5. 7h Reserved. |
| 0 | `CacheFlit` | Reset: 0. .cache H2D protocol flit including those having .mem slots |


## DFPMCx00000[ED...F9]B — DF/CNLI — CNLI CACHE_OUT_FLIT_EXT .Cache Request Flit Additional Packing

**Symbolic:** `DF::PMC::CNLI::CNLI_CACHE_OUT_FLIT_EXT`  
**Instance:** `_instCNLI0; DFPMCx00000EDB _instCNLI1; DFPMCx00000F1B _instCNLI2; DFPMCx00000F5B _instCNLI3; DFPMCx00000F9B`

Number of Full Slots in .cache Protocol Flit including data slots: 1/2/3/4.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8:6 | `NumFullSlot` | Reset: 0h. Number of Full Slots in .cache Protocol Flit including data slots: 1/2/3/4. |
| 5 | `ThreeNoDatGSlot` | Reset: 0. Flit that contains three valid Gslots that are not data |
| 4 | `TwoNoDatGSlot` | Reset: 0. Flit that contains two valid Gslots that are not data |
| 3 | `OneNoDatGSlot` | Reset: 0. Flit that contains one valid Gslot that is not data |
| 2:0 | `NumDatSlot` | Reset: 0h. Number of data Slots in .cache Protocol Flit: 1/2/3/4. |


## DFPMCx00000[ED...F9]C — DF/CNLI — CNLI CACHE_IN_FLIT .Cache Response Flit UnPacking

**Symbolic:** `DF::PMC::CNLI::CNLI_CACHE_IN_FLIT`  
**Instance:** `_instCNLI0; DFPMCx00000EDC _instCNLI1; DFPMCx00000F1C _instCNLI2; DFPMCx00000F5C _instCNLI3; DFPMCx00000F9C`

Flit containting MDH slot

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `MDH` | Reset: 0. Flit containting MDH slot |
| 6:4 | `NumFullSlot` | Reset: 0h. Number of Full Slots in .cache Protocol Flit including data slots: 1/2/3/4. |
| 3:1 | `HeaderSlotType` | Reset: 0h. Select Header Slot Type to be counted. Value Description 0h Disabled. 1h H0. 2h H1. 3h H2. 4h H3. 5h H4. 6h H5. 7h Reserved. |
| 0 | `CacheFlit` | Reset: 0. .cache D2H protocol flit including those having .mem slots |


## DFPMCx00000[ED...F9]D — DF/CNLI — CNLI REQ_WAIT Device Request Wait Conditions

**Symbolic:** `DF::PMC::CNLI::CNLI_REQ_WAIT`  
**Instance:** `_instCNLI0; DFPMCx00000EDD _instCNLI1; DFPMCx00000F1D _instCNLI2; DFPMCx00000F5D _instCNLI3; DFPMCx00000F9D`

.Mem Write Request waiting on Older PrbAsReq request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 3 | `MemWrOnFwd` | Reset: 0. .Mem Write Request waiting on Older PrbAsReq request. |
| 2 | `MemRdOnFwd` | Reset: 0. .Mem Read Request waiting on Older PrbAsReq request. |
| 1 | `DevWrOnWr` | Reset: 0. Device Write Request waiting on Older Write/Victim request. |
| 0 | `DevRdOnWr` | Reset: 0. Device Read Request waiting on Older Write/Victim request. |


## DFPMCx00000[ED...F9]E — DF/CNLI — CNLI MEM_DEV_LOAD Mem Device Load

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_DEV_LOAD`  
**Instance:** `_instCNLI0; DFPMCx00000EDE _instCNLI1; DFPMCx00000F1E _instCNLI2; DFPMCx00000F5E _instCNLI3; DFPMCx00000F9E`

Specifies threshold value for Port 3 to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:9 | `ThresholdPort3` | Reset: 0h. Specifies threshold value for Port 3 to trigger event. |
| 8:6 | `ThresholdPort2` | Reset: 0h. Specifies threshold value for Port 2 to trigger event. |
| 5:3 | `ThresholdPort1` | Reset: 0h. Specifies threshold value for Port 1 to trigger event. |
| 2:0 | `ThresholdPort0` | Reset: 0h. Specifies threshold value for Port 0 to trigger event. |


## DFPMCx00000[ED...F9]F — DF/CNLI — CNLI MEM_DEV_LOAD_RD Mem Device Load of Reads

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_DEV_LOAD_RD`  
**Instance:** `_instCNLI0; DFPMCx00000EDF _instCNLI1; DFPMCx00000F1F _instCNLI2; DFPMCx00000F5F _instCNLI3; DFPMCx00000F9F`

Specifies threshold value for Port 3 to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:9 | `ThresholdPort3` | Reset: 0h. Specifies threshold value for Port 3 to trigger event. |
| 8:6 | `ThresholdPort2` | Reset: 0h. Specifies threshold value for Port 2 to trigger event. |
| 5:3 | `ThresholdPort1` | Reset: 0h. Specifies threshold value for Port 1 to trigger event. |
| 2:0 | `ThresholdPort0` | Reset: 0h. Specifies threshold value for Port 0 to trigger event. |


## DFPMCx00000[EE...FA]0 — DF/CNLI — CNLI CACHE_DEV_LOAD Cache Device Load

**Symbolic:** `DF::PMC::CNLI::CNLI_CACHE_DEV_LOAD`  
**Instance:** `_instCNLI0; DFPMCx00000EE0 _instCNLI1; DFPMCx00000F20 _instCNLI2; DFPMCx00000F60 _instCNLI3; DFPMCx00000FA0`

Specifies threshold value for # Pending Device Evict Request to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:9 | `DevVicThreshold` | Reset: 0h. Specifies threshold value for # Pending Device Evict Request to trigger event. |
| 8:6 | `DevWrThreshold` | Reset: 0h. Specifies threshold value for # Pending Device Write Request to trigger event. |
| 5:3 | `DevRdThreshold` | Reset: 0h. Specifies threshold value for # Pending Device Read Request to trigger event. |
| 2:0 | `PrbRspThreshold` | Reset: 0h. Specifies threshold value for # Pending Probe Rsp to trigger event. |


## DFPMCx00000[EE...FA]1 — DF/CNLI — CNLI MEM_REQ2 Request Type

**Symbolic:** `DF::PMC::CNLI::CNLI_MEM_REQ2`  
**Instance:** `_instCNLI0; DFPMCx00000EE1 _instCNLI1; DFPMCx00000F21 _instCNLI2; DFPMCx00000F61 _instCNLI3; DFPMCx00000FA1`

SpecDramRd from CS and CNLI doesn't drop due to device load

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 4 | `SpecDramRd` | Reset: 0. SpecDramRd from CS and CNLI doesn't drop due to device load |
| 3 | `VicBlkCln` | Reset: 0. Clean Victim from CS |
| 2:1 | `PortSel` | Reset: 0h. Counts event only on the selected CNLI port/sublink |
| 0 | `AllPorts` | Reset: 0. Counts event on all CNLI ports/sublinks |


## DFPMCx00001[1C...58]0 — DF/SPF — SPF ISQ_OCC Queue Occupancy

**Symbolic:** `DF::PMC::SPF::SPF_ISQ_OCC`  
**Instance:** `_instCS0; DFPMCx000011C0 _instCS10; DFPMCx00001440 _instCS11; DFPMCx00001480 _instCS12; DFPMCx000014C0 _instCS13; DFPMCx00001500 _instCS14; DFPMCx00001540 _instCS15; DFPMCx00001580 _instCS1; DFPMCx00001200 _instCS2; DFPMCx00001240 _instCS3; DFPMCx00001280 _instCS4; DFPMCx000012C0 _instCS5; DFPMCx00001300 _instCS6; DFPMCx00001340 _instCS7; DFPMCx00001380 _instCS8; DFPMCx000013C0 _instCS9; DFPMCx00001400`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:0 | `Threshold` | Reset: 00h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[1C...58]1 — DF/SPF — SPF ISQ_MISC Response Miscellaneous

**Symbolic:** `DF::PMC::SPF::SPF_ISQ_MISC`  
**Instance:** `_instCS0; DFPMCx000011C1 _instCS10; DFPMCx00001441 _instCS11; DFPMCx00001481 _instCS12; DFPMCx000014C1 _instCS13; DFPMCx00001501 _instCS14; DFPMCx00001541 _instCS15; DFPMCx00001581 _instCS1; DFPMCx00001201 _instCS2; DFPMCx00001241 _instCS3; DFPMCx00001281 _instCS4; DFPMCx000012C1 _instCS5; DFPMCx00001301 _instCS6; DFPMCx00001341 _instCS7; DFPMCx00001381 _instCS8; DFPMCx000013C1 _instCS9; DFPMCx00001401`

Transaction Unknown

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `Unkwn` | Reset: 0. Transaction Unknown |
| 0 | `Retry` | Reset: 0. Transaction Retry |


## DFPMCx00001[1C...58]2 — DF/SPF — SPF TXN_TYPEA

**Symbolic:** `DF::PMC::SPF::SPF_TXN_TYPEA`  
**Instance:** `_instCS0; DFPMCx000011C2 _instCS10; DFPMCx00001442 _instCS11; DFPMCx00001482 _instCS12; DFPMCx000014C2 _instCS13; DFPMCx00001502 _instCS14; DFPMCx00001542 _instCS15; DFPMCx00001582 _instCS1; DFPMCx00001202 _instCS2; DFPMCx00001242 _instCS3; DFPMCx00001282 _instCS4; DFPMCx000012C2 _instCS5; DFPMCx00001302 _instCS6; DFPMCx00001342 _instCS7; DFPMCx00001382 _instCS8; DFPMCx000013C2 _instCS9; DFPMCx00001402`

Transaction Type is CONTLOCK

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CONTLOCK` | Reset: 0. Transaction Type is CONTLOCK |
| 6 | `RDBLKX` | Reset: 0. Transaction Type is RDBLKX |
| 5 | `RDBLKS` | Reset: 0. Transaction Type is RDBLKS |
| 4 | `RDBLKC` | Reset: 0. Transaction Type is RDBLKC |
| 3 | `RDBLKL` | Reset: 0. Transaction Type is RDBLKL |
| 2 | `RDSZNOWR` | Reset: 0. Transaction Type is RDSZNOWR |
| 1 | `RDSIZED` | Reset: 0. Transaction Type is RDSIZED |
| 0 | `ANY` | Reset: 0. Count all transaction types |


## DFPMCx00001[1C...58]3 — DF/SPF — SPF TXN_TYPEB

**Symbolic:** `DF::PMC::SPF::SPF_TXN_TYPEB`  
**Instance:** `_instCS0; DFPMCx000011C3 _instCS10; DFPMCx00001443 _instCS11; DFPMCx00001483 _instCS12; DFPMCx000014C3 _instCS13; DFPMCx00001503 _instCS14; DFPMCx00001543 _instCS15; DFPMCx00001583 _instCS1; DFPMCx00001203 _instCS2; DFPMCx00001243 _instCS3; DFPMCx00001283 _instCS4; DFPMCx000012C3 _instCS5; DFPMCx00001303 _instCS6; DFPMCx00001343 _instCS7; DFPMCx00001383 _instCS8; DFPMCx000013C3 _instCS9; DFPMCx00001403`

Transaction Type is CLNBLK

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `CLNBLK` | Reset: 0. Transaction Type is CLNBLK |
| 6 | `RINSINGVIC` | Reset: 0. Transaction Type is RINSINGVIC |
| 5 | `VICBLKFULL` | Reset: 0. Transaction Type is VICBLKFULL |
| 4 | `VICBLKCLN` | Reset: 0. Transaction Type is VICBLKCLN |
| 3 | `VALBLK` | Reset: 0. Transaction Type is VALBLK |
| 2 | `CHGTOXNR` | Reset: 0. Transaction Type is CHGTOXNR |
| 1 | `CHGTOX` | Reset: 0. Transaction Type is CHGTOX |
| 0 | `WRSIZED` | Reset: 0. Transaction Type is WRSIZED |


## DFPMCx00001[1C...58]4 — DF/SPF — SPF TXN_TYPEC

**Symbolic:** `DF::PMC::SPF::SPF_TXN_TYPEC`  
**Instance:** `_instCS0; DFPMCx000011C4 _instCS10; DFPMCx00001444 _instCS11; DFPMCx00001484 _instCS12; DFPMCx000014C4 _instCS13; DFPMCx00001504 _instCS14; DFPMCx00001544 _instCS15; DFPMCx00001584 _instCS1; DFPMCx00001204 _instCS2; DFPMCx00001244 _instCS3; DFPMCx00001284 _instCS4; DFPMCx000012C4 _instCS5; DFPMCx00001304 _instCS6; DFPMCx00001344 _instCS7; DFPMCx00001384 _instCS8; DFPMCx000013C4 _instCS9; DFPMCx00001404`

Transaction Type is PAGERINSE

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 8 | `PAGERINSE` | Reset: 0. Transaction Type is PAGERINSE |
| 7 | `NOPFENCE` | Reset: 0. Transaction Type is NOPFENCE |
| 6 | `ARRFLOSS` | Reset: 0. Transaction Type is ARRFLOSS |
| 5 | `CHGSTM` | Reset: 0. Transaction Type is CHGSTM |
| 4 | `CHGSTO` | Reset: 0. Transaction Type is CHGSTO |
| 3 | `CHGSTF` | Reset: 0. Transaction Type is CHGSTF |
| 2 | `CHGSTI` | Reset: 0. Transaction Type is CHGSTI |
| 1 | `CHGSTX` | Reset: 0. Transaction Type is CHGSTX |
| 0 | `DECARC` | Reset: 0. Transaction Type is DECARC |


## DFPMCx00001[1C...58]5 — DF/SPF — SPF TXN_STATUS Response Status Details

**Symbolic:** `DF::PMC::SPF::SPF_TXN_STATUS`  
**Instance:** `_instCS0; DFPMCx000011C5 _instCS10; DFPMCx00001445 _instCS11; DFPMCx00001485 _instCS12; DFPMCx000014C5 _instCS13; DFPMCx00001505 _instCS14; DFPMCx00001545 _instCS15; DFPMCx00001585 _instCS1; DFPMCx00001205 _instCS2; DFPMCx00001245 _instCS3; DFPMCx00001285 _instCS4; DFPMCx000012C5 _instCS5; DFPMCx00001305 _instCS6; DFPMCx00001345 _instCS7; DFPMCx00001385 _instCS8; DFPMCx000013C5 _instCS9; DFPMCx00001405`

Transaction LPF Downgrade

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LpfDng` | Reset: 0. Transaction LPF Downgrade |
| 6 | `LpfHit` | Reset: 0. Transaction LPF Hit |
| 5 | `LpfMis` | Reset: 0. Transaction LPF Miss |
| 4 | `LpfAlc` | Reset: 0. Transaction LPF Allocate |
| 3 | `PPFDng` | Reset: 0. Transaction PPF Downgrade |
| 2 | `PpfHit` | Reset: 0. Transaction PPF Hit |
| 1 | `PpfMis` | Reset: 0. Transaction PPF Miss |
| 0 | `PpfAlc` | Reset: 0. Transaction PPF Allocate |


## DFPMCx00001[1C...58]6 — DF/SPF — SPF TXN_PROBE Response Probe Details

**Symbolic:** `DF::PMC::SPF::SPF_TXN_PROBE`  
**Instance:** `_instCS0; DFPMCx000011C6 _instCS10; DFPMCx00001446 _instCS11; DFPMCx00001486 _instCS12; DFPMCx000014C6 _instCS13; DFPMCx00001506 _instCS14; DFPMCx00001546 _instCS15; DFPMCx00001586 _instCS1; DFPMCx00001206 _instCS2; DFPMCx00001246 _instCS3; DFPMCx00001286 _instCS4; DFPMCx000012C6 _instCS5; DFPMCx00001306 _instCS6; DFPMCx00001346 _instCS7; DFPMCx00001386 _instCS8; DFPMCx000013C6 _instCS9; DFPMCx00001406`

Multicast Probe Target NDV3.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `NDV3` | Reset: 0. Multicast Probe Target NDV3. |
| 6 | `NDV2` | Reset: 0. Multicast Probe Target NDV2. |
| 5 | `NDV1` | Reset: 0. Multicast Probe Target NDV1. |
| 4 | `NDV0` | Reset: 0. Multicast Probe Target NDV0. |
| 3 | `CLV3` | Reset: 0. Multicast Probe Target CLV3. |
| 2 | `CLV2` | Reset: 0. Multicast Probe Target CLV2. |
| 1 | `CLV1` | Reset: 0. Multicast Probe Target CLV1. |
| 0 | `CLV0` | Reset: 0. Multicast Probe Target CLV0. |


## DFPMCx00001[1C...58]7 — DF/SPF — SPF TXN_STATE Response State

**Symbolic:** `DF::PMC::SPF::SPF_TXN_STATE`  
**Instance:** `_instCS0; DFPMCx000011C7 _instCS10; DFPMCx00001447 _instCS11; DFPMCx00001487 _instCS12; DFPMCx000014C7 _instCS13; DFPMCx00001507 _instCS14; DFPMCx00001547 _instCS15; DFPMCx00001587 _instCS1; DFPMCx00001207 _instCS2; DFPMCx00001247 _instCS3; DFPMCx00001287 _instCS4; DFPMCx000012C7 _instCS5; DFPMCx00001307 _instCS6; DFPMCx00001347 _instCS7; DFPMCx00001387 _instCS8; DFPMCx000013C7 _instCS9; DFPMCx00001407`

Response from LPF with state F. This event only applies to a supporting LPF in a PPF based system.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `LpfStateF` | Reset: 0. Response from LPF with state F. This event only applies to a supporting LPF in a PPF based system. |
| 10 | `LpfStateX` | Reset: 0. Response from LPF with state X. This event only applies to a supporting LPF in a PPF based system. |
| 9 | `LpfStateO` | Reset: 0. Response from LPF with state O. This event only applies to a supporting LPF in a PPF based system. |
| 8 | `LpfStateM` | Reset: 0. Response from LPF with state M. This event only applies to a supporting LPF in a PPF based system. |
| 7 | `StateI` | Reset: 0. Response from SPF with State I. For a PPF + LPF based system, this value comes from the PPF array. |
| 6 | `StateS` | Reset: 0. Response from SPF with State S. For a PPF + LPF based system, this value comes from the PPF array. |
| 5 | `StateS1` | Reset: 0. Response from SPF with State S1. For a PPF + LPF based system, this value comes from the PPF array. |
| 4 | `StateF` | Reset: 0. Response from SPF with State F. For a PPF + LPF based system, this value comes from the PPF array. |
| 3 | `StateF1` | Reset: 0. Response from SPF with State F1. For a PPF + LPF based system, this value comes from the PPF array. |
| 2 | `StateX` | Reset: 0. Response from SPF with State X. For a PPF + LPF based system, this value comes from the PPF array. |
| 1 | `StateO` | Reset: 0. Response from SPF with State O. For a PPF + LPF based system, this value comes from the PPF array. |
| 0 | `StateM` | Reset: 0. Response from SPF with State M. For a PPF + LPF based system, this value comes from the PPF array |


## DFPMCx00001[1C...58]8 — DF/SPF — SPF SPF_MISC Response Miscellaneous

**Symbolic:** `DF::PMC::SPF::SPF_SPF_MISC`  
**Instance:** `_instCS0; DFPMCx000011C8 _instCS10; DFPMCx00001448 _instCS11; DFPMCx00001488 _instCS12; DFPMCx000014C8 _instCS13; DFPMCx00001508 _instCS14; DFPMCx00001548 _instCS15; DFPMCx00001588 _instCS1; DFPMCx00001208 _instCS2; DFPMCx00001248 _instCS3; DFPMCx00001288 _instCS4; DFPMCx000012C8 _instCS5; DFPMCx00001308 _instCS6; DFPMCx00001348 _instCS7; DFPMCx00001388 _instCS8; DFPMCx000013C8 _instCS9; DFPMCx00001408`

Parse recommendation

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `Parse` | Reset: 0. Parse recommendation |
| 10 | `PrbDropIpHit` | Reset: 0. Probe was dropped due to a Hit on an Ip state |
| 9 | `AllLightSleep` | Reset: 0. One or more Banks In Light Sleep |
| 8 | `AnyLightSleep` | Reset: 0. One or more Banks In Light Sleep |
| 7 | `RvrtRinse` | Reset: 0. Reverted a Rinse |
| 6 | `RcmdRinse` | Reset: 0. Recommended a Rinse |
| 5 | `EligRinse` | Reset: 0. Eligible for Rinse |
| 4 | `DngFloss` | Reset: 0. Downgrade for a Floss |
| 3 | `PdbHit` | Reset: 0. PDB Hit. |
| 2 | `ProtMsk` | Reset: 0. Masked Protocol Error. |
| 1 | `ARCUnfl` | Reset: 0. ARC Overflow. |
| 0 | `ARCOvfl` | Reset: 0. ARC Overflow. |


## DFPMCx00001[1C...58]9 — DF/SPF — SPF SPF_REPL SPF Replacement Policy

**Symbolic:** `DF::PMC::SPF::SPF_SPF_REPL`  
**Instance:** `_instCS0; DFPMCx000011C9 _instCS10; DFPMCx00001449 _instCS11; DFPMCx00001489 _instCS12; DFPMCx000014C9 _instCS13; DFPMCx00001509 _instCS14; DFPMCx00001549 _instCS15; DFPMCx00001589 _instCS1; DFPMCx00001209 _instCS2; DFPMCx00001249 _instCS3; DFPMCx00001289 _instCS4; DFPMCx000012C9 _instCS5; DFPMCx00001309 _instCS6; DFPMCx00001349 _instCS7; DFPMCx00001389 _instCS8; DFPMCx000013C9 _instCS9; DFPMCx00001409`

LPF naturally reclaimed the entry.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `LPFReclaim` | Reset: 0. LPF naturally reclaimed the entry. |
| 6 | `LPFAlloc` | Reset: 0. LPF allocated empty way. |
| 5 | `LPFKeyMix` | Reset: 0. LPF Replaced an entry because of Key Mixing. |
| 4 | `LPFReplace` | Reset: 0. LPF Replaced an entry using LRA/LRT/Random Replacement. |
| 3 | `PPFReclaim` | Reset: 0. PPF naturally reclaimed the entry. |
| 2 | `PPFAlloc` | Reset: 0. PPF allocated empty way. |
| 1 | `PPFKeyMix` | Reset: 0. PPF Replaced an entry because of Key Mixing. |
| 0 | `PPFReplace` | Reset: 0. PPF Replaced an entry using LRA/LRT/Random Replacement. |


## DFPMCx00001[1C...58]A — DF/SPF — SPF PRB_DEST Probe Destination

**Symbolic:** `DF::PMC::SPF::SPF_PRB_DEST`  
**Instance:** `_instCS0; DFPMCx000011CA _instCS10; DFPMCx0000144A _instCS11; DFPMCx0000148A _instCS12; DFPMCx000014CA _instCS13; DFPMCx0000150A _instCS14; DFPMCx0000154A _instCS15; DFPMCx0000158A _instCS1; DFPMCx0000120A _instCS2; DFPMCx0000124A _instCS3; DFPMCx0000128A _instCS4; DFPMCx000012CA _instCS5; DFPMCx0000130A _instCS6; DFPMCx0000134A _instCS7; DFPMCx0000138A _instCS8; DFPMCx000013CA _instCS9; DFPMCx0000140A`

All Probes launched to Remote Node based on LPF recommendation.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11 | `LPFAllRmt` | Reset: 0. All Probes launched to Remote Node based on LPF recommendation. |
| 10 | `LPFMcaRmt` | Reset: 0. Multicast Probe launched to Remote Node based on LPF recommendation. Includes possible probes to Local Node |
| 9 | `LPFDirRmt` | Reset: 0. Directed Probe launched to Remote Node based on LPF recommendation. |
| 8 | `LPFAllLcl` | Reset: 0. All Probes launched to Local Node based on LPF recommendation. |
| 7 | `LPFMcoLcl` | Reset: 0. Multicast Probe (only) launched to Local Node based on LPF recommendation. |
| 6 | `LPFDirLcl` | Reset: 0. Directed Probe launched to Local Node based on LPF recommendation. |
| 5 | `PPFAllRmt` | Reset: 0. All Probes launched to Remote Node based on PPF recommendation. |
| 4 | `PPFMcaRmt` | Reset: 0. Multicast Probe launched to Remote Node based on PPF recommendation. Includes possible probes to Local Node |
| 3 | `PPFDirRmt` | Reset: 0. Directed Probe launched to Remote Node based on PPF recommendation. |
| 2 | `PPFAllLcl` | Reset: 0. All Probes launched to Local Node based on PPF recommendation. |
| 1 | `PPFMcoLcl` | Reset: 0. Multicast Probe (only) launched to Local Node based on PPF recommendation. |
| 0 | `PPFDirLcl` | Reset: 0. Directed Probe launched to Local Node based on PPF recommendation. |


## DFPMCx00001[5C...A8]0 — DF/TCDX — TCDX REQQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_REQQ_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015C0 _instTCDX10; DFPMCx00001840 _instTCDX11; DFPMCx00001880 _instTCDX12; DFPMCx000018C0 _instTCDX13; DFPMCx00001900 _instTCDX14; DFPMCx00001940 _instTCDX15; DFPMCx00001980 _instTCDX16; DFPMCx000019C0 _instTCDX17; DFPMCx00001A00 _instTCDX18; DFPMCx00001A40 _instTCDX19; DFPMCx00001A80 _instTCDX1; DFPMCx00001600 _instTCDX2; DFPMCx00001640 _instTCDX3; DFPMCx00001680 _instTCDX4; DFPMCx000016C0 _instTCDX5; DFPMCx00001700 _instTCDX6; DFPMCx00001740 _instTCDX7; DFPMCx00001780 _instTCDX8; DFPMCx000017C0 _instTCDX9; DFPMCx00001800`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5C...A8]1 — DF/TCDX — TCDX RSPQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_RSPQ_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015C1 _instTCDX10; DFPMCx00001841 _instTCDX11; DFPMCx00001881 _instTCDX12; DFPMCx000018C1 _instTCDX13; DFPMCx00001901 _instTCDX14; DFPMCx00001941 _instTCDX15; DFPMCx00001981 _instTCDX16; DFPMCx000019C1 _instTCDX17; DFPMCx00001A01 _instTCDX18; DFPMCx00001A41 _instTCDX19; DFPMCx00001A81 _instTCDX1; DFPMCx00001601 _instTCDX2; DFPMCx00001641 _instTCDX3; DFPMCx00001681 _instTCDX4; DFPMCx000016C1 _instTCDX5; DFPMCx00001701 _instTCDX6; DFPMCx00001741 _instTCDX7; DFPMCx00001781 _instTCDX8; DFPMCx000017C1 _instTCDX9; DFPMCx00001801`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5C...A8]2 — DF/TCDX — TCDX PRBQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_PRBQ_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015C2 _instTCDX10; DFPMCx00001842 _instTCDX11; DFPMCx00001882 _instTCDX12; DFPMCx000018C2 _instTCDX13; DFPMCx00001902 _instTCDX14; DFPMCx00001942 _instTCDX15; DFPMCx00001982 _instTCDX16; DFPMCx000019C2 _instTCDX17; DFPMCx00001A02 _instTCDX18; DFPMCx00001A42 _instTCDX19; DFPMCx00001A82 _instTCDX1; DFPMCx00001602 _instTCDX2; DFPMCx00001642 _instTCDX3; DFPMCx00001682 _instTCDX4; DFPMCx000016C2 _instTCDX5; DFPMCx00001702 _instTCDX6; DFPMCx00001742 _instTCDX7; DFPMCx00001782 _instTCDX8; DFPMCx000017C2 _instTCDX9; DFPMCx00001802`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5C...A8]3 — DF/TCDX — TCDX DATQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_DATQ_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015C3 _instTCDX10; DFPMCx00001843 _instTCDX11; DFPMCx00001883 _instTCDX12; DFPMCx000018C3 _instTCDX13; DFPMCx00001903 _instTCDX14; DFPMCx00001943 _instTCDX15; DFPMCx00001983 _instTCDX16; DFPMCx000019C3 _instTCDX17; DFPMCx00001A03 _instTCDX18; DFPMCx00001A43 _instTCDX19; DFPMCx00001A83 _instTCDX1; DFPMCx00001603 _instTCDX2; DFPMCx00001643 _instTCDX3; DFPMCx00001683 _instTCDX4; DFPMCx000016C3 _instTCDX5; DFPMCx00001703 _instTCDX6; DFPMCx00001743 _instTCDX7; DFPMCx00001783 _instTCDX8; DFPMCx000017C3 _instTCDX9; DFPMCx00001803`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5C...A8]D — DF/TCDX — TCDX REQQ_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_REQQ_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015CD _instTCDX10; DFPMCx0000184D _instTCDX11; DFPMCx0000188D _instTCDX12; DFPMCx000018CD _instTCDX13; DFPMCx0000190D _instTCDX14; DFPMCx0000194D _instTCDX15; DFPMCx0000198D _instTCDX16; DFPMCx000019CD _instTCDX17; DFPMCx00001A0D _instTCDX18; DFPMCx00001A4D _instTCDX19; DFPMCx00001A8D _instTCDX1; DFPMCx0000160D _instTCDX2; DFPMCx0000164D _instTCDX3; DFPMCx0000168D _instTCDX4; DFPMCx000016CD _instTCDX5; DFPMCx0000170D _instTCDX6; DFPMCx0000174D _instTCDX7; DFPMCx0000178D _instTCDX8; DFPMCx000017CD _instTCDX9; DFPMCx0000180D`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Reserved. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. 7h Reserved. 8h Packets stalled to selected output port. Fh-9h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5C...A8]E — DF/TCDX — TCDX RSPQ_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_RSPQ_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015CE _instTCDX10; DFPMCx0000184E _instTCDX11; DFPMCx0000188E _instTCDX12; DFPMCx000018CE _instTCDX13; DFPMCx0000190E _instTCDX14; DFPMCx0000194E _instTCDX15; DFPMCx0000198E _instTCDX16; DFPMCx000019CE _instTCDX17; DFPMCx00001A0E _instTCDX18; DFPMCx00001A4E _instTCDX19; DFPMCx00001A8E _instTCDX1; DFPMCx0000160E _instTCDX2; DFPMCx0000164E _instTCDX3; DFPMCx0000168E _instTCDX4; DFPMCx000016CE _instTCDX5; DFPMCx0000170E _instTCDX6; DFPMCx0000174E _instTCDX7; DFPMCx0000178E _instTCDX8; DFPMCx000017CE _instTCDX9; DFPMCx0000180E`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Reserved. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. 7h Reserved. 8h Packets stalled to selected output port. Fh-9h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5C...A8]F — DF/TCDX — TCDX PRBQ_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_PRBQ_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015CF _instTCDX10; DFPMCx0000184F _instTCDX11; DFPMCx0000188F _instTCDX12; DFPMCx000018CF _instTCDX13; DFPMCx0000190F _instTCDX14; DFPMCx0000194F _instTCDX15; DFPMCx0000198F _instTCDX16; DFPMCx000019CF _instTCDX17; DFPMCx00001A0F _instTCDX18; DFPMCx00001A4F _instTCDX19; DFPMCx00001A8F _instTCDX1; DFPMCx0000160F _instTCDX2; DFPMCx0000164F _instTCDX3; DFPMCx0000168F _instTCDX4; DFPMCx000016CF _instTCDX5; DFPMCx0000170F _instTCDX6; DFPMCx0000174F _instTCDX7; DFPMCx0000178F _instTCDX8; DFPMCx000017CF _instTCDX9; DFPMCx0000180F`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Reserved. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. 7h Multicast probe from selected in port. 8h Packets stalled to selected output port. Fh-9h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5D...A9]0 — DF/TCDX — TCDX DATQ_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_DATQ_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015D0 _instTCDX10; DFPMCx00001850 _instTCDX11; DFPMCx00001890 _instTCDX12; DFPMCx000018D0 _instTCDX13; DFPMCx00001910 _instTCDX14; DFPMCx00001950 _instTCDX15; DFPMCx00001990 _instTCDX16; DFPMCx000019D0 _instTCDX17; DFPMCx00001A10 _instTCDX18; DFPMCx00001A50 _instTCDX19; DFPMCx00001A90 _instTCDX1; DFPMCx00001610 _instTCDX2; DFPMCx00001650 _instTCDX3; DFPMCx00001690 _instTCDX4; DFPMCx000016D0 _instTCDX5; DFPMCx00001710 _instTCDX6; DFPMCx00001750 _instTCDX7; DFPMCx00001790 _instTCDX8; DFPMCx000017D0 _instTCDX9; DFPMCx00001810`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Reserved. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. Fh-7h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5D...A9]1 — DF/TCDX — TCDX RSPNDQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_RSPNDQ_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015D1 _instTCDX10; DFPMCx00001851 _instTCDX11; DFPMCx00001891 _instTCDX12; DFPMCx000018D1 _instTCDX13; DFPMCx00001911 _instTCDX14; DFPMCx00001951 _instTCDX15; DFPMCx00001991 _instTCDX16; DFPMCx000019D1 _instTCDX17; DFPMCx00001A11 _instTCDX18; DFPMCx00001A51 _instTCDX19; DFPMCx00001A91 _instTCDX1; DFPMCx00001611 _instTCDX2; DFPMCx00001651 _instTCDX3; DFPMCx00001691 _instTCDX4; DFPMCx000016D1 _instTCDX5; DFPMCx00001711 _instTCDX6; DFPMCx00001751 _instTCDX7; DFPMCx00001791 _instTCDX8; DFPMCx000017D1 _instTCDX9; DFPMCx00001811`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5D...A9]2 — DF/TCDX — TCDX RSPNDQ_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_RSPNDQ_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015D2 _instTCDX10; DFPMCx00001852 _instTCDX11; DFPMCx00001892 _instTCDX12; DFPMCx000018D2 _instTCDX13; DFPMCx00001912 _instTCDX14; DFPMCx00001952 _instTCDX15; DFPMCx00001992 _instTCDX16; DFPMCx000019D2 _instTCDX17; DFPMCx00001A12 _instTCDX18; DFPMCx00001A52 _instTCDX19; DFPMCx00001A92 _instTCDX1; DFPMCx00001612 _instTCDX2; DFPMCx00001652 _instTCDX3; DFPMCx00001692 _instTCDX4; DFPMCx000016D2 _instTCDX5; DFPMCx00001712 _instTCDX6; DFPMCx00001752 _instTCDX7; DFPMCx00001792 _instTCDX8; DFPMCx000017D2 _instTCDX9; DFPMCx00001812`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Response from selected in port was combined. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. 7h Reserved. 8h Packets stalled to selected output port. Fh-9h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5D...A9]3 — DF/TCDX — TCDX REQNDQ_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_REQNDQ_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015D3 _instTCDX10; DFPMCx00001853 _instTCDX11; DFPMCx00001893 _instTCDX12; DFPMCx000018D3 _instTCDX13; DFPMCx00001913 _instTCDX14; DFPMCx00001953 _instTCDX15; DFPMCx00001993 _instTCDX16; DFPMCx000019D3 _instTCDX17; DFPMCx00001A13 _instTCDX18; DFPMCx00001A53 _instTCDX19; DFPMCx00001A93 _instTCDX1; DFPMCx00001613 _instTCDX2; DFPMCx00001653 _instTCDX3; DFPMCx00001693 _instTCDX4; DFPMCx000016D3 _instTCDX5; DFPMCx00001713 _instTCDX6; DFPMCx00001753 _instTCDX7; DFPMCx00001793 _instTCDX8; DFPMCx000017D3 _instTCDX9; DFPMCx00001813`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5D...A9]4 — DF/TCDX — TCDX REQNDQ_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_REQNDQ_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015D4 _instTCDX10; DFPMCx00001854 _instTCDX11; DFPMCx00001894 _instTCDX12; DFPMCx000018D4 _instTCDX13; DFPMCx00001914 _instTCDX14; DFPMCx00001954 _instTCDX15; DFPMCx00001994 _instTCDX16; DFPMCx000019D4 _instTCDX17; DFPMCx00001A14 _instTCDX18; DFPMCx00001A54 _instTCDX19; DFPMCx00001A94 _instTCDX1; DFPMCx00001614 _instTCDX2; DFPMCx00001654 _instTCDX3; DFPMCx00001694 _instTCDX4; DFPMCx000016D4 _instTCDX5; DFPMCx00001714 _instTCDX6; DFPMCx00001754 _instTCDX7; DFPMCx00001794 _instTCDX8; DFPMCx000017D4 _instTCDX9; DFPMCx00001814`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Reserved. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. 7h Reserved. 8h Packets stalled to selected output port. Fh-9h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5D...A9]5 — DF/TCDX — TCDX PRB1Q_OCCPNCY Queue Occupancy

**Symbolic:** `DF::PMC::TCDX::TCDX_PRB1Q_OCCPNCY`  
**Instance:** `_instTCDX0; DFPMCx000015D5 _instTCDX10; DFPMCx00001855 _instTCDX11; DFPMCx00001895 _instTCDX12; DFPMCx000018D5 _instTCDX13; DFPMCx00001915 _instTCDX14; DFPMCx00001955 _instTCDX15; DFPMCx00001995 _instTCDX16; DFPMCx000019D5 _instTCDX17; DFPMCx00001A15 _instTCDX18; DFPMCx00001A55 _instTCDX19; DFPMCx00001A95 _instTCDX1; DFPMCx00001615 _instTCDX2; DFPMCx00001655 _instTCDX3; DFPMCx00001695 _instTCDX4; DFPMCx000016D5 _instTCDX5; DFPMCx00001715 _instTCDX6; DFPMCx00001755 _instTCDX7; DFPMCx00001795 _instTCDX8; DFPMCx000017D5 _instTCDX9; DFPMCx00001815`

Specifies threshold occupancy value to trigger event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 11:0 | `Threshold` | Reset: 000h. Specifies threshold occupancy value to trigger event. |


## DFPMCx00001[5D...A9]6 — DF/TCDX — TCDX PRB1Q_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_PRB1Q_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015D6 _instTCDX10; DFPMCx00001856 _instTCDX11; DFPMCx00001896 _instTCDX12; DFPMCx000018D6 _instTCDX13; DFPMCx00001916 _instTCDX14; DFPMCx00001956 _instTCDX15; DFPMCx00001996 _instTCDX16; DFPMCx000019D6 _instTCDX17; DFPMCx00001A16 _instTCDX18; DFPMCx00001A56 _instTCDX19; DFPMCx00001A96 _instTCDX1; DFPMCx00001616 _instTCDX2; DFPMCx00001656 _instTCDX3; DFPMCx00001696 _instTCDX4; DFPMCx000016D6 _instTCDX5; DFPMCx00001716 _instTCDX6; DFPMCx00001756 _instTCDX7; DFPMCx00001796 _instTCDX8; DFPMCx000017D6 _instTCDX9; DFPMCx00001816`

Select type of event.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 6:3 | `SelType` | Reset: 0h. Select type of event. Value Description 0h Reserved. 1h Pick to selected out port. 2h Bypass to selected out port. 3h Any dispatch (pick or bypass) to selected out port. 4h Bypass from selected in port. 5h Allocate from selected in port. 6h Any packet (allocate or bypass) from selected in port. 7h Multicast probe from selected in port. 8h Packets stalled to selected output port. Fh-9h Reserved. |
| 2:0 | `SelPort` | Reset: 0h. Select port for event. Value Description 0h Port 0. 1h Port 1. 2h Port 2. 3h Port 3. 4h Port 4. 5h Port 5. 6h Reserved. 7h TCDX events from all ports. |


## DFPMCx00001[5D...A9]7 — DF/TCDX — TCDX MISC_STAT Statistics

**Symbolic:** `DF::PMC::TCDX::TCDX_MISC_STAT`  
**Instance:** `_instTCDX0; DFPMCx000015D7 _instTCDX10; DFPMCx00001857 _instTCDX11; DFPMCx00001897 _instTCDX12; DFPMCx000018D7 _instTCDX13; DFPMCx00001917 _instTCDX14; DFPMCx00001957 _instTCDX15; DFPMCx00001997 _instTCDX16; DFPMCx000019D7 _instTCDX17; DFPMCx00001A17 _instTCDX18; DFPMCx00001A57 _instTCDX19; DFPMCx00001A97 _instTCDX1; DFPMCx00001617 _instTCDX2; DFPMCx00001657 _instTCDX3; DFPMCx00001697 _instTCDX4; DFPMCx000016D7 _instTCDX5; DFPMCx00001717 _instTCDX6; DFPMCx00001757 _instTCDX7; DFPMCx00001797 _instTCDX8; DFPMCx000017D7 _instTCDX9; DFPMCx00001817`

This event increments every time the TCDX's REQQ goes from having no Urgent requests to atleast one Urgent request.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 1 | `UrgentStart` | Reset: 0. This event increments every time the TCDX's REQQ goes from having no Urgent requests to atleast one Urgent request. |
| 0 | `UrgentPresent` | Reset: 0. This event increments on every cycle that there is at least one Urgent packet in this TCDX's REQQ. |

