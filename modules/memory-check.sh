#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/output.sh"

EXIT_MEM_DEP=0
EXIT_MEM_SPACE=0
EXIT_MEM_SWAP=0

print_section "--- MEMORY INFORMATION ---"

# Get info about memory in bytes
if command -v free &> /dev/null; then
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

	print_property "Total RAM" "$TOTAL_MEM"

	MEM_STATUS=$(check_memory_threshold $MEM_USAGE_PERCENT)
	print_status "$MEM_STATUS" "Used RAM" "$USED_MEM (${MEM_USAGE_PERCENT}%)"
	print_status "$MEM_STATUS" "Free RAM" "$FREE_MEM"
	EXIT_MEM_SPACE=$(get_exit_code $MEM_STATUS)

	# Check swap
	SWAP_INFO=$(free -b | awk 'NR==3')
	SWAP_TOTAL_BYTES=$(echo "$SWAP_INFO" | awk '{print $2}')
	SWAP_USED_BYTES=$(echo "$SWAP_INFO" | awk '{print $3}')

	if [ $SWAP_TOTAL_BYTES -gt 0 ]; then
		SWAP_USAGE_PERCENT=$(echo "scale=1; $SWAP_USED_BYTES * 100 / $SWAP_TOTAL_BYTES" | bc)
		SWAP_TOTAL=$(free -h | awk 'NR==3 {print$2}')
		SWAP_STATUS=$(check_swap_threshold $SWAP_USAGE_PERCENT)
		print_status "$SWAP_STATUS" "Swap" "$SWAP_TOTAL total (${SWAP_USAGE_PERCENT}% used)"
		EXIT_MEM_SWAP=$(get_exit_code $SWAP_STATUS)
	fi
else
	print_warning "free not available - please install 'procps'"
    EXIT_MEM_DEP=3
fi

if [ $EXIT_MEM_DEP -eq 3 ]; then
	exit 3
elif [ $EXIT_MEM_SPACE -eq 2 ] || [ $EXIT_MEM_SWAP -eq 2 ]; then
    exit 2
elif [ $EXIT_MEM_SPACE -eq 1 ] || [ $EXIT_MEM_SWAP -eq 1 ]; then
    exit 1
else
    exit 0
fi