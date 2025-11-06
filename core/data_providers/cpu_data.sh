#!/bin/bash

get_cpu_base_info() {
    MODEL_NAME=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)
    ARCHITECTURE=$(uname -m)
    SOCKETS=$(lscpu | grep "Socket(s):" | awk '{print $2}')
    CORES_PER_SOCKET=$(lscpu | grep "Core(s) per socket:" | awk '{print $4}')
    THREADS_PER_CORE=$(lscpu | grep "Thread(s) per core:" | awk '{print $4}')
    CPU_MHZ=$(cat /proc/cpuinfo | grep "cpu MHz" | cut -d: -f2 | head -1 | sed 's/^[ \t]*//')
    TOTAL_CORES=$((SOCKETS * $CORES_PER_SOCKET))
    TOTAL_THREADS=$((TOTAL_CORES * $THREADS_PER_CORE))
}

get_cpu_extra_info() {
    CPU_FAMILY=$(lscpu | grep "CPU family:" | awk '{print $3}')
    CPU_MODEL_NUMBER=$(lscpu | grep "Model:" | awk '{print $2}')
    CPU_STEPPING=$(lscpu | grep "Stepping:" | awk '{print $2}')

    L1D_CACHE=$(lscpu | grep "L1d cache:" | awk '{print $3, $4}')
    L1I_CACHE=$(lscpu | grep "L1i cache:" | awk '{print $3, $4}')
    L2_CACHE=$(lscpu | grep "L2 cache:" | awk '{print $3, $4}')
    L3_CACHE=$(lscpu | grep "L3 cache:" | awk '{print $3, $4}')

    CPU_FLAGS=$(grep -m1 "flags" /proc/cpuinfo | cut -d: -f2)

    VECTOR_EXTENSIONS=""
    for extension in avx512 avx2 avx sse4_2 sse4_1 sse3 sse2; do
        if echo "$CPU_FLAGS" | grep -qi $extension; then
            VECTOR_EXTENSIONS="$VECTOR_EXTENSIONS ${extension^^},"
        fi
    done

    MIN_FREQ=$(lscpu | grep "CPU min MHz:" | awk '{print $4}')
    MAX_FREQ=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
}

get_cpu_load_info() {
    CPU_STATS=$(mpstat 1 1 | awk 'NR==5')
    USER_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $3}')
    SYSTEM_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $5}')
    IDLE_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $12}')
    TOTAL_LOAD=$(echo "scale=1; 100 - $IDLE_LOAD" | bc)
    CPU_STATUS=$(check_cpu_threshold $TOTAL_LOAD)
    EXIT_CPU_LOAD=$(get_exit_code $CPU_STATUS)
}

get_cpu_system_statistic() {
    UPTIME=$(uptime -p | sed 's/up //')
}

get_cpu_process_info() {
    VMSTAT_OUTPUT=$(vmstat 1 2 | tail -1)
    RUNNING_PROCS=$(echo $VMSTAT_OUTPUT | awk '{print $1}')
    BLOCKED_PROCS=$(echo $VMSTAT_OUTPUT | awk '{print $2}')
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