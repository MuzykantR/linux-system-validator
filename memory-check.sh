#!/bin/bash

source ./output.sh

print_section "--- MEMORY INFORMATION ---"

# Get info about memory in bytes
MEMORY_INFO_B=$(free -b | awk 'NR==2')
TOTAL_BYTES=$(echo "$MEMORY_INFO_B" | awk '{print $2}')
USED_BYTES=$(echo "$MEMORY_INFO_B" | awk '{print $3}')
FREE_BYTES=$(echo "$MEMORY_INFO_B" | awk '{print $4}')

# Get info about memory in human-readable format
MEMORY_INFO=$(free -h | awk 'NR==2')
TOTAL_MEM=$(echo "$MEMORY_INFO" | awk '{print $2}')
USED_MEM=$(echo "$MEMORY_INFO" | awk '{print $3}')
FREE_MEM=$(echo "$MEMORY_INFO" | awk '{print $4}')

# Calc percent of using
if [ $TOTAL_BYTES -gt 0 ]; then
	MEM_USAGE_PERCENT=$(echo "scale=1; $USED_BYTES * 100 / $TOTAL_BYTES" | bc)
else
	MEM_USAGE_PERCENT=0
fi

print_neutral "Total RAM: $TOTAL_MEM"
print_status "$(check_memory_threshold $MEM_USAGE_PERCENT)" "Used RAM: $USED_MEM (${MEM_USAGE_PERCENT}%)"
print_status "$(check_memory_threshold $MEM_USAGE_PERCENT)" "Free RAM: $FREE_MEM"

# Check swap
SWAP_INFO=$(free -b | awk 'NR==3')
SWAP_TOTAL_BYTES=$(echo "$SWAP_INFO" | awk '{print $2}')
SWAP_USED_BYTES=$(echo "$SWAP_INFO" | awk '{print $3}')

if [ $SWAP_TOTAL_BYTES -gt 0 ]; then
	SWAP_USAGE_PERCENT=$(echo "scale=1; $SWAP_USED_BYTES * 100 / $SWAP_TOTAL_BYTES" | bc)
	SWAP_TOTAL=$(free -h | awk 'NR==3 {print$2}')
	print_status "$(check_swap_threshold $SWAP_USAGE_PERCENT)" "Swap: $SWAP_TOTAL total (${SWAP_USAGE_PERCENT}% used)"
fi
