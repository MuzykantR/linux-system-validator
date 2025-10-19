#!/bin/bash

source ./output.sh

print_section "--- CPU INFORMATION ---"

# Print info about CPU
print_neutral "Architecture: $(uname -m)"
print_neutral "CPU Cores: $(nproc)"
print_neutral "Model: $(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)"

# Check current load
if command -v mpstat &> /dev/null; then
	CPU_LOAD=$(mpstat 1 1 | awk 'NR==5 {printf "%.1f", 100 - $12}')
	if [ -n "$CPU_LOAD" ] && [ "$CPU_LOAD" != "nan" ]; then
		CPU_STATUS=$(check_cpu_threshold $CPU_LOAD)
		print_status "$CPU_STATUS" "Current load: ${CPU_LOAD}%"
	fi
fi

# Load avera
LOAD_AVG=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')
print_neutral "Load average: $LOAD_AVG"
