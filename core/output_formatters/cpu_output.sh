#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"
source "$PROJECT_ROOT/core/data_providers/cpu_data.sh"

EXIT_CPU_DEP=0
EXIT_CPU_LOAD=0

print_cpu_basic_info() {
    print_mini_section "Basic info:"
    if command -v lscpu &> /dev/null; then
        local -A cpu_data
        get_cpu_base_info cpu_data
        print_property "  Model" "${cpu_data["model"]}"
        print_property "  Architecture"  "${cpu_data["architecture"]}"
        print_property "  Sockets" "${cpu_data["sockets"]}"
        print_property "  Cores per socket" "${cpu_data["cores_per_socket"]}"
        print_property "  Threads per core" "${cpu_data["threads_per_core"]}"
        print_property "  Total" "${cpu_data["total_cores"]} cores, ${cpu_data["total_threads"]} threads"
        print_property "  Frequency" "${cpu_data["frequency"]} MHz"
    else
        print_warning "lscpu not available - please install 'util-linux'"
        EXIT_CPU_DEP=3
    fi
}

print_cpu_extra_info() {
	# Info about sockets, threads, frequency
	if command -v lscpu &> /dev/null; then
        local -A cpu_data
        get_cpu_extra_info cpu_data
        
        # Family, Model, Stepping
        if [ -n "${cpu_data["family"]}" ] && [ -n "${cpu_data["model_number"]}" ]; then
            print_property "  CPU Family" "${cpu_data["family"]}"
            print_property "  Model Number" "${cpu_data["model_number"]}"
            print_property "  Stepping" "${cpu_data["stepping"]}"
        fi

        # Cache cpu
        echo ""
        print_mini_section "Caches:"
        [ -n "${cpu_data["cache_l1d"]}" ] && print_property "  L1d" "${cpu_data["cache_l1d"]}"
        [ -n "${cpu_data["cache_l1i"]}" ] && print_property "  L1i" "${cpu_data["cache_l1i"]}"
        [ -n "${cpu_data["cache_l2"]}" ] && print_property "  L2" "${cpu_data["cache_l2"]}"
        [ -n "${cpu_data["cache_l3"]}" ] && print_property "  L3" "${cpu_data["cache_l3"]}"
        
        # Vector Extensions
		echo ""
        print_mini_section "Vector Extensions:"
        if [ -n "${cpu_data["vector_extensions"]}" ]; then
            print_neutral "  ${cpu_data["vector_extensions"]%,}"
        else
            print_neutral "  None detected"
        fi

        # Frequency
        echo ""
        print_mini_section "Frequency Range:"
        if [ -n "${cpu_data["min_frequency"]}" ] && [ -n "${cpu_data["max_frequency"]}" ]; then
            print_neutral "  Min: ${cpu_data["min_frequency"]}MHz - Max: ${cpu_data["max_frequency"]}MHz"
        else
            print_warning "  Frequency information not available"
        fi
    else
        print_warning "lscpu not available - microarchitecture analysis skipped"
        EXIT_CPU_DEP=3
	fi
}

print_cpu_load_info() {
    print_mini_section "Current load:"
    if command -v mpstat &> /dev/null; then
        local -A cpu_data
        get_cpu_load_info cpu_data
        if [ -n "${cpu_data["cpu_stats"]}" ]; then
            print_status "${cpu_data["status"]}" "Current CPU usage" "${cpu_data["total_load"]}%"
            print_property "  - User" "${cpu_data["user_load"]}%"
            print_property "  - System" "${cpu_data["system_load"]}%"
            print_property "  - Idle" "${cpu_data["idle_load"]}%"
        else
            print_warning "  Current load information not available"
            EXIT_CPU_LOAD=2
        fi
    else
        print_warning "mpstat not available - please install 'sysstat'"
        EXIT_CPU_DEP=3
    fi
}

print_system_info() {
    print_mini_section "System statistic:"
    if command -v uptime &> /dev/null; then
        local -A system_data
        get_cpu_system_statistic system_data
        print_property "Uptime" "${system_data["uptime"]}"
    else
        print_warning "uptime not available - please install 'procps'"
        EXIT_CPU_DEP=3
    fi

    if command -v vmstat &> /dev/null; then
        local -A system_data
        get_cpu_process_info system_data
        if [ -n "${system_data["vmstat_output"]}" ]; then
            print_property "Running processes" "${system_data["running_process"]}"
            print_property "Blocked processes" "${system_data["blocked_process"]}"
        fi
    else
        print_warning "vmstat not available - please install 'sysstat'"
        EXIT_CPU_DEP=3
    fi

    # Top proceses
    echo ""
    print_mini_section "Top processes by CPU"

    if command -v ps &> /dev/null; then
    local pid
    local cpu_usage
    local cmd
        echo -e "${COLOR_BOLD_WHITE}  PID %CPU COMMAND${COLOR_RESET}"
        ps -eo pid,%cpu,comm --sort=-%cpu | head -6 | tail -5 | while read line; do
            pid=$(echo $line | awk '{print $1}')
            cpu_usage=$(echo $line | awk '{print $2}')
            cmd=$(echo $line | awk '{print $3}')
            print_neutral "  $pid $cpu_usage% $cmd"
        done
    else
        print_warning "ps not available - please install 'procps'"
        EXIT_CPU_DEP=3
    fi
}

