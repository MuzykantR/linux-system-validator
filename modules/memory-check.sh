#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/output.sh"
source "$PROJECT_ROOT/core/data_providers/memory_data.sh"

EXIT_MEM_DEP=0
EXIT_MEM_LOAD=0
EXIT_MEM_SWAP=0

print_section "--- MEMORY INFORMATION ---"

# Get info about memory in bytes
if command -v free &> /dev/null; then
	get_memory_info
	# Get info about memory in human-readable format
	MEMORY_INFO=$(free -h | awk 'NR==2')
	TOTAL_MEM=$(echo "$MEMORY_INFO" | awk '{print $2}')
	USED_MEM=$(echo "$MEMORY_INFO" | awk '{print $3}')
	FREE_MEM=$(echo "$MEMORY_INFO" | awk '{print $4}')

	print_property "Total RAM" "$TOTAL_MEM"
	print_status "$MEM_STATUS" "Used RAM" "$USED_MEM (${MEM_USAGE_PERCENT}%)"
	print_status "$MEM_STATUS" "Free RAM" "$FREE_MEM"

	get_swap_info
	if [ $SWAP_TOTAL_BYTES -gt 0 ]; then
		print_status "$SWAP_STATUS" "Swap" "$SWAP_TOTAL total (${SWAP_USAGE_PERCENT}% used)"
	fi
else
	print_warning "free not available - please install 'procps'"
    EXIT_MEM_DEP=3
fi

get_memory_exit_code $EXIT_MEM_DEP $EXIT_MEM_LOAD $EXIT_MEM_SWAP
exit $EXIT_CPU