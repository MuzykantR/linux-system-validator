#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/output.sh"
source "$PROJECT_ROOT/core/data_providers/cpu_data.sh"

# Option by default
MODE='basic'
EXIT_CPU_DEP=0
EXIT_CPU_LOAD=0

# Option identification
while [[ $# -gt 0 ]]; do
    case $1 in
        --basic|-b)
            MODE="basic"
            shift
            ;;
        --detailed|-d)
            MODE="detailed"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

print_section "--- CPU INFORMATION ---"

# ============== BASE INFO (basic or detailed mode) ==================
if [ "$MODE" = "basic" ] || [ "$MODE" = "detailed" ]; then
    # Print info about CPU
    print_mini_section "Base info:"
    if command -v lscpu &> /dev/null; then
        get_cpu_base_info
        print_property "  Model" "$MODEL_NAME"
        print_property "  Architecture"  "$ARCHITECTURE"
        print_property "  Sockets" "$SOCKETS"
        print_property "  Cores per socket" "$CORES_PER_SOCKET"
        print_property "  Threads per core" "$THREADS_PER_CORE"
        print_property "  Total" "$TOTAL_CORES cores, $TOTAL_THREADS threads"
        print_property "  Frequency" "${CPU_MHZ} MHz"
    else
        print_warning "lscpu not available - please install 'util-linux'"
        EXIT_CPU_DEP=3
    fi
fi

# =============== EXTRA INFO (detailed mode) ===============
if [ "$MODE" = "detailed" ]; then
	# Info about sockets, threads, frequency
	if command -v lscpu &> /dev/null; then
        get_cpu_extra_info
        
        # Family, Model, Stepping
        if [ -n "$CPU_FAMILY" ] && [ -n "$CPU_MODEL_NUMBER" ]; then
            print_property "  CPU Family" "$CPU_FAMILY"
            print_property "  Model Number" "$CPU_MODEL_NUMBER"
            print_property "  Stepping" "$CPU_STEPPING"
        fi

        # Cache cpu
        echo ""
        print_mini_section "Caches:"
        [ -n "$L1D_CACHE" ] && print_property "  L1d" "$L1D_CACHE"
        [ -n "$L1I_CACHE" ] && print_property "  L1i" "$L1I_CACHE"
        [ -n "$L2_CACHE" ] && print_property "  L2" "$L2_CACHE"
        [ -n "$L3_CACHE" ] && print_property "  L3" "$L3_CACHE"
        
        # Vector Extensions
		echo ""
        print_mini_section "Vector Extensions:"
        if [ -n "$VECTOR_EXTENSIONS" ]; then
            print_neutral "  ${VECTOR_EXTENSIONS%,}"
        else
            print_neutral "  None detected"
        fi

        # Frequency
        echo ""
        print_mini_section "Frequency Range:"
        if [ -n "$MIN_FREQ" ] && [ -n "$MAX_FREQ" ]; then
            print_neutral "  Min: ${MIN_FREQ}MHz - Max: ${MAX_FREQ}MHz"
        else
            print_warning "  Frequency information not available"
        fi
    else
        print_warning "lscpu not available - microarchitecture analysis skipped"
        EXIT_CPU_DEP=3
	fi
fi

# ============== BASE INFO (basic or detailed mode) ==================
if [ "$MODE" = "basic" ] || [ "$MODE" = "detailed" ]; then
    echo ""
    print_section "--- PROCESS/SYSTEM INFORMATION ---"
    print_mini_section "Current load:"
    if command -v mpstat &> /dev/null; then
        get_cpu_load_info
        if [ -n "$CPU_STATS" ]; then
            print_status "$CPU_STATUS" "Current CPU usage" "${TOTAL_LOAD}%"
            print_property "  - User" "${USER_LOAD}%"
            print_property "  - System" "${SYSTEM_LOAD}%"
            print_property "  - Idle" "${IDLE_LOAD}%"
        else
            print_warning "  Current load information not available"
            EXIT_CPU_LOAD=2
        fi
    else
        print_warning "mpstat not available - please install 'sysstat'"
        EXIT_CPU_DEP=3
    fi
fi

# =============== EXTRA INFO (detailed mode) ===============
if [ "$MODE" = "detailed" ]; then
	echo ""
    print_mini_section "System statistic:"
    if command -v uptime &> /dev/null; then
        get_cpu_system_statistic
        print_property "Uptime" "$UPTIME"
    else
        print_warning "uptime not available - please install 'procps'"
        EXIT_CPU_DEP=3
    fi

    if command -v vmstat &> /dev/null; then
        get_cpu_process_info
        if [ -n "$VMSTAT_OUTPUT" ]; then
            print_property "Running processes" "$RUNNING_PROCS"
            print_property "Blocked processes" "$BLOCKED_PROCS"
        fi
    else
        print_warning "vmstat not available - please install 'procps'"
        EXIT_CPU_DEP=3
    fi

    # Top proceses
    echo ""
    print_mini_section "Top processes by CPU"

    if command -v ps &> /dev/null; then
        echo -e "${COLOR_BOLD_WHITE}  PID %CPU COMMAND${COLOR_RESET}"
        ps -eo pid,%cpu,comm --sort=-%cpu | head -6 | tail -5 | while read line; do
            PID=$(echo $line | awk '{print $1}')
            CPU_USAGE=$(echo $line | awk '{print $2}')
            CMD=$(echo $line | awk '{print $3}')
            print_neutral "  $PID $CPU_USAGE% $CMD"
        done
    else
        print_warning "ps not available - please install 'procps'"
        EXIT_CPU_DEP=3
    fi
fi

get_cpu_exit_code $EXIT_CPU_DEP $EXIT_CPU_LOAD
exit $EXIT_CPU