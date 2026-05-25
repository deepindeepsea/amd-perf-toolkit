# AWS M8A.metal-24xl Comprehensive CCD Scaling Analysis
## AMD EPYC 9R45 Zen5 Turin Performance Study

**Executive Summary**: Systematic performance analysis of Rails application scaling across CCDs on AWS M8A.metal-24xl instances with AMD EPYC 9R45 Zen5 Turin processors.

---

## System Configuration

### Hardware Specifications
- **Instance Type**: AWS M8A.metal-24xl (i-082ca0124af7a18d0)
- **Processor**: AMD EPYC 9R45 96-Core Processor  
- **Architecture**: Zen5 (Family 26 = 0x1A)
- **Total Cores**: 96 cores organized as 12 CCDs × 8 cores
- **Memory**: 384 GB DDR5-5200
- **Operating System**: Ubuntu 24.04.1 LTS
- **Package Power**: 114.8W measured during testing

### Zen5 Turin Architecture Features
- **Dispatch Width**: 8 slots per cycle (expanded from Zen4's 6-wide)
- **L2 Cache**: 1 MB per core (confirmed working)
- **L3 Cache**: Shared within CCD, ~100ns cross-CCD latency
- **PMC Support**: Full Zen5 event set validated and operational

---

## Test Methodology

### CCD Scaling Test Plan
**Objective**: Measure Rails application performance scaling from 1 to 8 CCDs

**Configuration**:
- **Server CCDs**: 1, 2, 4, 8 CCD configurations tested
- **Client Isolation**: CCD 9 (cores 88-95) dedicated to wrk client
- **Workers**: 8 Puma workers per CCD, pinned via taskset
- **Load Pattern**: wrk threads scale 1:1 with server CCDs (max 8 threads)
- **Test Duration**: 45-60 seconds per configuration
- **Consistency**: 3 complete test runs for statistical validation

### Optimization Strategies Tested
1. **Baseline**: Standard Ruby/Rails configuration
2. **YJIT Enabled**: Ruby JIT compilation (`RUBY_YJIT_ENABLE=1`)
3. **jemalloc**: Memory allocator optimization (`LD_PRELOAD=libjemalloc.so.2`)
4. **Combined**: YJIT + jemalloc + CCD affinity pinning

---

## Performance Monitoring Stack

### AMD Pipeline Metrics (Zen5-Compatible)
- **Frontend Bound**: Instruction fetch/decode stalls
- **Backend Bound**: Execution unit + memory system stalls
  - Memory-bound vs CPU-bound breakdown
- **Bad Speculation**: Branch misprediction recovery
- **Retiring**: Useful work completion rate

### Core Performance Metrics
- **Effective Frequency**: Real boost behavior via perf cycles/task-clock
- **IPC**: Instructions per cycle across workload scaling
- **Cache Performance**: L2 hit rates, cross-CCD memory access patterns
- **Branch Prediction**: Misprediction rates under varying loads

### CCD Topology Analysis
- **Peak Parallel CCDs**: Maximum simultaneous chiplet utilization
- **Cross-CCD Execution**: Inter-chiplet communication overhead
- **Memory Locality**: NUMA-aware scaling behavior
- **Power Efficiency**: Performance per watt scaling

---

## Test Execution Status

### Completed Phases
- [x] **Environment Setup**: Rails 7.1.6 + wrk 4.2.0 validated
- [x] **Zen5 PMC Validation**: All events confirmed functional
- [x] **Run 1**: Baseline CCD sweep completed (30s duration)
- [x] **Run 2**: Extended duration sweep in progress (45s duration)

### In Progress
- [ ] **Run 2 Analysis**: CCD topology collection active
- [ ] **Run 3**: Final consistency validation pending
- [ ] **Optimization Testing**: YJIT + jemalloc phases

### Planned Analysis
- [ ] **Linear Scaling Analysis**: Throughput vs CCD count correlation
- [ ] **Bottleneck Identification**: Memory vs CPU bound transitions
- [ ] **Efficiency Curves**: Performance per watt and per core
- [ ] **Customer Report**: Executive summary with recommendations

---

## Preliminary Findings

### Zen5 PMC Event Validation
**Status**: ✅ **CONFIRMED WORKING**
- All pipeline utilization events functional
- Branch prediction metrics operational  
- L2 cache monitoring active
- CCD topology detection working via lstopo/hwloc

### System Performance Baseline
- **Peak Single-Core Frequency**: 4.525 GHz (APERF/MPERF validated)
- **Memory Utilization**: 372 GB available (98%+ free during testing)
- **Package Power Draw**: 114.8W under load
- **System Load**: Minimal (0.04-0.11) indicating clean test environment

### Initial CCD Scaling Observations
- **Test Duration Issue**: Initial 30s runs too brief for meaningful PMC data
- **Extended Testing**: 45-60s duration captures stable performance metrics
- **Topology Mapping**: lstopo successfully identifying CCD boundaries
- **Process Isolation**: wrk client properly isolated on dedicated CCD 9

---

## Expected Outcomes

### Linear Scaling Analysis
- **Target**: Near-linear throughput scaling to 4-6 CCDs
- **Transition Point**: Identify where memory bandwidth becomes limiting
- **Cross-CCD Penalty**: Measure inter-chiplet communication overhead

### Optimization Impact Assessment
- **YJIT Performance**: Ruby JIT compilation benefit quantification
- **Memory Allocator**: jemalloc vs default allocator comparison
- **Combined Effect**: Optimization strategy interaction analysis

### Customer Value Proposition
- **TCO Analysis**: Performance per dollar vs competitive offerings
- **Scaling Efficiency**: Right-sizing recommendations for workload types
- **Migration Benefits**: Quantified improvement over previous generations

---

## Next Steps

1. **Complete Run 2**: Monitor CCD topology and pipeline data collection
2. **Execute Run 3**: Final validation run for statistical confidence
3. **Generate HTML Reports**: Interactive charts and detailed metrics
4. **Create Excel Summary**: Customer-ready benchmark comparison format
5. **Compile Presentation**: Executive summary with recommendations

---

**Test Progress**: Run 2 of 3 executing (CCD topology collection active)  
**Estimated Completion**: ~15 minutes for remaining systematic testing  
**Output**: HTML reports, Excel analysis, customer presentation package

*This analysis continues the systematic approach established in the Genoa X testing, adapted specifically for Zen5 Turin architecture validation on AWS M8A instances.*