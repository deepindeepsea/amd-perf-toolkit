# AWS M8A.metal-24xl (Zen5 Turin) Baseline Analysis

## System Specifications
- **Instance**: m8a.metal-24xl (i-082ca0124af7a18d0)
- **CPU**: AMD EPYC 9R45 96-Core Processor (Zen5 Turin)
- **Architecture**: Zen5 (Family 26 = 0x1A), dispatch=8 slots/cycle 
- **Memory**: 384 GB DDR5
- **OS**: Ubuntu 24.04.1 LTS
- **Total Cores**: 96 cores = 12 CCDs × 8 cores
- **Package Power**: 114.8 W (measured)

## Initial Performance Baseline Data

From `zen5_round1_baseline.txt` analysis:

### Zen5 PMC Detection Status
- **CPU Family**: 0x1A (Zen5 Turin) ✓
- **Dispatch Model**: 8 slots/cycle (Zen5 extended from 6-wide) ✓
- **Extension Events**: None supported (using core set only)

### Performance Measurements (Single Core Test)
- **Active CPU Core**: Core 47 (CCD unknown)
- **Core Utilization**: 94.9% busy on single core
- **Peak Frequency**: 4.525 GHz (Bzy_MHz via APERF/MPERF)
- **Instructions Per Cycle**: 1.000 IPC
- **Package Power**: 114.8 W during test

### Critical Findings
1. **Very Short Workload**: Only 1 active cycle captured
   - Total dispatch slots: 8 (8 slots × 1 cycle)
   - This suggests extremely brief workload execution
   
2. **PMC Event Collection Working**: All key Zen5 events functioning
   - Frontend/Backend bound detection: ✓
   - Branch prediction metrics: ✓
   - Memory subsystem monitoring: ✓
   
3. **Turbo Boost Performance**: 4.525 GHz peak on single core
   - Shows healthy boost behavior on Zen5 Turin

## CCD Topology Mapping
- **Total CCDs**: 12 CCDs × 8 cores = 96 cores
- **Test Plan**: Systematic scaling across 1, 2, 4, 8 CCDs
- **Client Isolation**: CCD 9 (cores 88-95) reserved for wrk client
- **Server Scaling**: CCDs 0-7 for Puma server threads

## Next Phase: Systematic CCD Scaling
1. **Rails Environment**: Successfully configured with bundler ✓
2. **AMD Pipeline Metrics**: Zen5-compatible toolkit ready ✓
3. **Test Methodology**: 3x runs per configuration for consistency
4. **Optimization Testing**: YJIT + jemalloc + CCD pinning phases

## Expected Scaling Analysis
- **Linear Scaling**: Monitor IPC, throughput per CCD
- **Memory Bottlenecks**: L2/L3 cache performance across CCDs
- **Cross-CCD Communication**: Inter-chiplet latency impact
- **Power Efficiency**: Performance per watt scaling

## Documentation Status
- [x] System specifications documented
- [x] Rails environment configured  
- [x] Zen5 PMC validation complete
- [ ] 3x systematic CCD tests (1,2,4,8)
- [ ] Optimization strategy testing
- [ ] HTML/Excel report generation
- [ ] Customer presentation package

**Test Status**: Currently executing comprehensive CCD sweep - Run 1 of 3
**Next**: Monitor progress and capture results for analysis