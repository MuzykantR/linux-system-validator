#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"

get_storage_info() {
    local -n data=$1
    local root_info=$(df -h / | grep -E '^/dev/' | awk '$6 == "/"')
    data["root_disk"]=$(echo $root_info | awk '{print $1}')
    data["total_space"]=$(echo $root_info | awk '{print $2}')
    data["used_space"]=$(echo $root_info | awk '{print $3}')
    data["free_space"]=$(echo $root_info | awk '{print $4}')
    data["used_percent"]=$(echo $root_info | awk '{print $5}' | sed 's/%//')
    data["mount_point"]=$(echo $root_info | awk '{print $6}')
    data["status"]=$(check_disk_threshold ${data["used_percent"]})
    EXIT_DISK_USAGE=$(get_exit_code ${data["status"]})
}

get_storage_performance() {
    local -n data=$1
    # Temp directory, file
    local test_dir="/tmp"
    local test_file="/tmp/system_validator_iotest.dat"
    # Check available space
    local available_space_kb=$(df "$test_dir" | awk 'NR==2 {print $4}')
    data["available_space_gb"]=$(( available_space_kb / 1024 / 1024 ))
    
    if [ "${data["available_space_gb"]}" -gt 2 ]; then
        local write_output=$(dd if=/dev/zero of="$test_file" bs=64M count=16 oflag=direct conv=fdatasync 2>&1)
        data["write_speed"]=$(echo "$write_output" | grep -E "copied|bytes" | awk '{print $(NF-1), $NF}')
        
        local read_output=$(dd if="$test_file" of=/dev/null bs=64M iflag=direct 2>&1)
        data["read_speed"]=$(echo "$read_output" | grep -E "copied|bytes" | awk '{print $(NF-1), $NF}')
        
        rm -f "$test_file"
    fi
}

get_disk_exit_code() {
    if [ $1 -eq 3 ]; then
        EXIT_DISK=3
    elif [ $2 -eq 2 ]; then
        EXIT_DISK=2
    elif [ $2 -eq 1 ]; then
        EXIT_DISK=1
    else
        EXIT_DISK=0
    fi
}