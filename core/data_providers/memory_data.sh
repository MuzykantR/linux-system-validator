#!/bin/bash

get_memory_info() {
	MEMORY_INFO_B=$(free -b | awk 'NR==2')
	TOTAL_BYTES=$(echo "$MEMORY_INFO_B" | awk '{print $2}')
	USED_BYTES=$(echo "$MEMORY_INFO_B" | awk '{print $3}')
	FREE_BYTES=$(echo "$MEMORY_INFO_B" | awk '{print $4}')

	# Calc percent of using
	if [ $TOTAL_BYTES -gt 0 ]; then
		MEM_USAGE_PERCENT=$(echo "scale=1; $USED_BYTES * 100 / $TOTAL_BYTES" | bc)
	else
		MEM_USAGE_PERCENT=0
	fi

	MEM_STATUS=$(check_memory_threshold $MEM_USAGE_PERCENT)
	EXIT_MEM_LOAD=$(get_exit_code $MEM_STATUS)
}

get_swap_info() {
	SWAP_INFO=$(free -b | awk 'NR==3')
	SWAP_TOTAL_BYTES=$(echo "$SWAP_INFO" | awk '{print $2}')
	SWAP_USED_BYTES=$(echo "$SWAP_INFO" | awk '{print $3}')

    if [ $SWAP_TOTAL_BYTES -gt 0 ]; then
		SWAP_USAGE_PERCENT=$(echo "scale=1; $SWAP_USED_BYTES * 100 / $SWAP_TOTAL_BYTES" | bc)
		SWAP_TOTAL=$(free -h | awk 'NR==3 {print$2}')
		SWAP_STATUS=$(check_swap_threshold $SWAP_USAGE_PERCENT)
		EXIT_MEM_SWAP=$(get_exit_code $SWAP_STATUS)
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