# Genoa — L3 PMC Events

_Source: AMD PPR #55901 Rev 0.50. Vol 1 pp.342-344_

_Total events: 5_


Events are listed in document order. Per-event, the table lists the UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.


## L3PMCx01 — L3 — L3 Cache Accesses

**Symbolic:** `Core::X86::Pmc::L3::L3RequestG1`  

Types of requests entering l3s.RQ (3 groups total). Group 1

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Group3` | Command from Group 3 (count details in event 0x3) |
| 6 | `RdSized` | uncacheable coherent reads. |
| 5 | `RdSizedNC` | uncacheable non-coherent reads. |
| 4 |  | Reserved. |
| 3 | `WrSized` | uncacheable coherent writes. |
| 2 | `WrSizedNC` | uncacheable non-coherent writes. |
| 1:0 |  | Reserved. |


## L3PMCx03 — L3 — L3 cache access types

**Symbolic:** `Core::X86::Pmc::L3::L3FillVicReq`  

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

**Symbolic:** `Core::X86::Pmc::L3::L3LookupState`  

All L3 Requests.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:0 | `L3LookupMask` | L3 Request Types ValidValues: Value Description 00h Reserved. 01h L3 Miss FDh- Reserved. 02h FEh L3 Hit FFh All coherent accesses to L3 AMD Confidential - Advance Information |


## L3PMCx09 — L3 — L3 Victim State

**Symbolic:** `Core::X86::Pmc::L3::L3VictimState`  

L3 victim lines. NOTE: To count all Modified lines, set bits 3, 5-7 simultaneously.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7 | `Od` | Modified data written back to memory from CCX. |
| 6 | `D` | Modified data written back to memory from CCX. |
| 5 | `M` | Modified data written back to memory from CCX. |
| 4 | `E_Fe` | Clean L3 victim line in E or Fe state. No data written back to memory from CCX. |
| 3 | `O` | Modified data written back to memory from CCX. |
| 2 | `F_S` | Clean L3 victim line in E or Fe state. No data written back to memory from CCX. |
| 1 |  | Reserved. |
| 0 | `I` | No L3 victim generated. |


## L3PMCxAC — L3 — L3 XiSampledLatency

**Symbolic:** `Core::X86::Pmc::L3::L3_XiSampledLatency`  

When used in conjunction with L3_XiSampledLatencyRequests, this PMC Event will measure the average memory latency (excluding MMIO) observed by this CCX. Configure two PMCs with the L3_XiSampledLatency and L3_XiSampledLatencyRequests events and use the following equation to identify the observed latency. if (L3Size-per-CCX >= 32MB) L3LatScalingFactor=10 else L3LatScalingFactor=30 end Average Sampled Latency = L3_XiSampledLatency/L3_XiSampledLatencyRequests * L3LatScalingFactor ns Some ChL3PmcCfg fields must be programmed as follows to ensure that these events accurately measure latency: ChL3PmcCfg[EnAllSlices]=0x1 and ChL3PmcCfg[SliceId]=0x3. Other ChL3PmcCfg fields can be used to filter the measured latency based on originating thread (EnAllCores, CoreID) and Data Source (UnitMask). To measure average latency from all threads to all Data Sources, use the following configuration: ChL3PmcCfg[EnAllCores]=0x1, ChL3PmcCfg[ThreadMask]=0x3, and ChL3PmcCfg[UnitMask]=0xFF.

| Bit | Mnemonic | Description |
|-----|----------|-------------|
| 7:6 |  | Reserved. |
| 5 | `Ext_Far` | Requests that target another NUMA node and return from Extension Memory (CXL) |
| 4 | `Ext_Near` | Requests that target the same NUMA node and return from Extension Memory (CXL) |
| 3 | `NearCache_FarCache_Far` | Requests that target another NUMA node and return from another CCX's cache. |
| 2 | `NearCache_FarCache_Near` | Requests that target the same NUMA node and return from another CCX's cache. |
| 1 | `Dram_Far` | Requests that target another NUMA node and return from DRAM |
| 0 | `Dram_Near` | Requests that target the same NUMA node and return from DRAM |

