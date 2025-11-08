#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"

get_cpu_base_info() {
    local -n data=$1
    data["model"]=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)
    data["architecture"]=$(uname -m)
    data["sockets"]=$(lscpu | grep "Socket(s):" | awk '{print $2}')
    data["cores_per_socket"]=$(lscpu | grep "Core(s) per socket:" | awk '{print $4}')
    data["threads_per_core"]=$(lscpu | grep "Thread(s) per core:" | awk '{print $4}')
    data["frequency"]=$(cat /proc/cpuinfo | grep "cpu MHz" | cut -d: -f2 | head -1 | sed 's/^[ \t]*//')
    data["total_cores"]=$(( ${data["sockets"]} * ${data["cores_per_socket"]} ))
    data["total_threads"]=$(( data["total_cores"] * data["threads_per_core"] ))
}

get_cpu_extra_info() {
    local -n data=$1
    data["family"]=$(lscpu | grep "CPU family:" | awk '{print $3}')
    data["model_number"]=$(lscpu | grep "Model:" | awk '{print $2}')
    data["stepping"]=$(lscpu | grep "Stepping:" | awk '{print $2}')

    data["cache_l1d"]=$(lscpu | grep "L1d cache:" | awk '{print $3, $4}')
    data["cache_l1i"]=$(lscpu | grep "L1i cache:" | awk '{print $3, $4}')
    data["cache_l2"]=$(lscpu | grep "L2 cache:" | awk '{print $3, $4}')
    data["cache_l3"]=$(lscpu | grep "L3 cache:" | awk '{print $3, $4}')

    local flags=$(grep -m1 "flags" /proc/cpuinfo | cut -d: -f2)

    data["vector_extensions"]=""
    for extension in avx512 avx2 avx sse4_2 sse4_1 sse3 sse2; do
        if echo "${flags}" | grep -qi $extension; then
            data["vector_extensions"]="${data["vector_extensions"]} ${extension^^},"
        fi
    done

    data["min_frequency"]=$(lscpu | grep "CPU min MHz:" | awk '{print $4}')
    data["max_frequency"]=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
}

get_cpu_load_info() {
    local -n data=$1
    data["cpu_stats"]=$(mpstat 1 1 | awk 'NR==5')
    data["user_load"]=$(echo ${data["cpu_stats"]} | awk '{printf "%.1f", $3}')
    data["system_load"]=$(echo ${data["cpu_stats"]} | awk '{printf "%.1f", $5}')
    data["idle_load"]=$(echo ${data["cpu_stats"]} | awk '{printf "%.1f", $12}')
    data["total_load"]=$(echo "scale=1; 100 - ${data["idle_load"]}" | bc)
    data["status"]=$(check_cpu_threshold ${data["total_load"]})
    EXIT_CPU_LOAD=$(get_exit_code ${data["status"]})
}

get_cpu_system_statistic() {
    local -n data=$1
    data["uptime"]=$(uptime -p | sed 's/up //')
}

get_cpu_process_info() {
    local -n data=$1
    data["vmstat_output"]=$(vmstat 1 2 | tail -1)
    data["running_process"]=$(echo "${data["vmstat_output"]}" | awk '{print $1}')
    data["blocked_process"]=$(echo "${data["vmstat_output"]}" | awk '{print $2}')
}

get_cpu_exit_code() {
    if [ $1 -eq 3 ]; then
        EXIT_CPU=3
    elif [ $2 -eq 2 ]; then
        EXIT_CPU=2
    elif [ $2 -eq 1 ]; then
        EXIT_CPU=1
    else
        EXIT_CPU=0
    fi
}