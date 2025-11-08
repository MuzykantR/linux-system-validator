#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"

get_memory_info() {
	local -n data=$1
	# Get info about memory in human-readable format
	local memory_info=$(free -h | awk 'NR==2')
	data["total_mem"]=$(echo "$memory_info" | awk '{print $2}')
	data["used_mem"]=$(echo "$memory_info" | awk '{print $3}')
	data["free_mem"]=$(echo "$memory_info" | awk '{print $4}')

	local memory_info_b=$(free -b | awk 'NR==2')
	local total_bytes=$(echo "$memory_info_b" | awk '{print $2}')
	local used_bytes=$(echo "$memory_info_b" | awk '{print $3}')
	local free_bytes=$(echo "$memory_info_b" | awk '{print $4}')

	# Calc percent of using
	if [ $total_bytes -gt 0 ]; then
		data["used_mem_percent"]=$(echo "scale=1; $used_bytes * 100 / $total_bytes" | bc)
	else
		data["used_mem_percent"]=0
	fi

	data["mem_status"]=$(check_memory_threshold ${data["used_mem_percent"]})
	EXIT_MEM_LOAD=$(get_exit_code ${data["mem_status"]})
}

get_swap_info() {
	local -n data=$1
	local swap_info=$(free -b | awk 'NR==3')
	local swap_total_bytes=$(echo "$swap_info" | awk '{print $2}')
	local swap_used_bytes=$(echo "$swap_info" | awk '{print $3}')
    if [ $swap_total_bytes -gt 0 ]; then
		data["used_swap_percent"]=$(echo "scale=1; $swap_used_bytes * 100 / $swap_total_bytes" | bc)
		data["swap_total"]=$(free -h | awk 'NR==3 {print$2}')
		data["swap_status"]=$(check_swap_threshold ${data["used_swap_percent"]})
		EXIT_MEM_SWAP=$(get_exit_code ${data["swap_status"]})
	fi
}

get_memory_exit_code() {
    if [ $1 -eq 3 ]; then
        EXIT_MEMORY=3
    elif [ $2 -eq 2 ] || [ $3 -eq 2 ]; then
        EXIT_MEMORY=2
    elif [ $2 -eq 1 ] || [ $3 -eq 1 ]; then
        EXIT_MEMORY=1
    else
        EXIT_MEMORY=0
    fi
}