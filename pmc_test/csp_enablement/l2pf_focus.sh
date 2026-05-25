#!/bin/bash
# Focused re-run: 0x71 and 0x72 with 0x1F composite, multiple iterations + named events
OUT=/tmp/l2pf_focus.txt; : > $OUT
exec >>$OUT 2>&1
echo "host=$(hostname) kernel=$(uname -r) date=$(date -u +%FT%TZ)"
echo "cpu=$(grep 'model name' /proc/cpuinfo | head -1 | sed 's/.*: //')"
echo "vcpus=$(nproc)"
echo ""

# Three trials to reduce noise; longer mhammer
for TRIAL in 1 2 3; do
  echo "=== Trial $TRIAL ==="
  for COMBO in "0x70 0x1f" "0x71 0x1f" "0x72 0x1f" "0x71 0x01" "0x71 0x08" "0x72 0x01" "0x72 0x08"; do
    E=$(echo $COMBO | cut -d' ' -f1); U=$(echo $COMBO | cut -d' ' -f2)
    O=$(sudo timeout 20 perf stat -x, -e "cpu/event=$E,umask=$U/" -- /tmp/mhammer 12 2 2>&1)
    L=$(echo "$O" | grep -E "^[0-9<]" | head -1)
    printf "  E=%s U=%s => %s\n" "$E" "$U" "$L"
  done
done

echo ""
echo "=== Named events for cross-check ==="
sudo perf list 2>/dev/null | grep -iE "l2_pf|l2 prefetch" | head -20
