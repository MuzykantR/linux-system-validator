#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"
source "$PROJECT_ROOT/core/data_providers/memory_data.sh"

EXIT_MEM_DEP=0
EXIT_MEM_LOAD=0
EXIT_MEM_SWAP=0

# Get info about memory in bytes
print_memory_usage() {
	if command -v free &> /dev/null; then
		local -A memory_data
		get_memory_info memory_data
		print_property "Total RAM" "${memory_data["total_mem"]}"
		print_status "${memory_data["mem_status"]}" "Used RAM" "${memory_data["used_mem"]} (${memory_data["used_mem_percent"]}%)"
		print_status "${memory_data["mem_status"]}" "Free RAM" "${memory_data["free_mem"]}"
		
		local -A swap_data
		get_swap_info swap_data
		if [ "${swap_data["swap_total"]}" != "" ]; then
			print_status "${swap_data["swap_status"]}" "Swap" "${swap_data["swap_total"]} total (${swap_data["used_swap_percent"]}% used)"
		fi
	else
		print_warning "free not available - please install 'procps'"
		EXIT_MEM_DEP=3
	fi
}