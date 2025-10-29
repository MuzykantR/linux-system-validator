#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/output.sh"

# Option by default
MODE='basic'

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


# ============== BASE INFO (always show) ==================
# Print info about CPU
print_mini_section "Base info:"
print_property "  Model" "$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)"
print_property "  Architecture"  "$(uname -m)"

SOCKETS=$(lscpu | grep "Socket(s):" | awk '{print $2}')
CORES_PER_SOCKET=$(lscpu | grep "Core(s) per socket:" | awk '{print $4}')
THREADS_PER_CORE=$(lscpu | grep "Thread(s) per core:" | awk '{print $4}')
CPU_MHZ=$(cat /proc/cpuinfo | grep "cpu MHz" | cut -d: -f2 | head -1 | sed 's/^[ \t]*//;s/[ \t]*$//')
TOTAL_CORES=$((SOCKETS * $CORES_PER_SOCKET))
TOTAL_THREADS=$((TOTAL_CORES * $THREADS_PER_CORE))

print_property "  Sockets" "$SOCKETS"
print_property "  Cores per socket" "$CORES_PER_SOCKET"
print_property "  Threads per core" "$THREADS_PER_CORE"
print_property "  Total" "$TOTAL_CORES cores, $TOTAL_THREADS threads"
print_property "  Frequency" "${CPU_MHZ} MHz"

# =============== EXTRA INFO (detailed mode) ===============
if [ "$MODE" = "detailed" ]; then
	# Info about sockets, threads, frequency
	if command -v lscpu &> /dev/null; then
		 # Family, Model, Stepping
        CPU_FAMILY=$(lscpu | grep "CPU family:" | awk '{print $3}')
        CPU_MODEL=$(lscpu | grep "Model:" | awk '{print $2}')
        CPU_STEPPING=$(lscpu | grep "Stepping:" | awk '{print $2}')
        
        if [ -n "$CPU_FAMILY" ] && [ -n "$CPU_MODEL" ]; then
            print_property "  CPU Family" "$CPU_FAMILY"
            print_property "  Model" "$CPU_MODEL"
            print_property "  Stepping" "$CPU_STEPPING"
        fi

        # Cache cpu
        echo ""
        print_mini_section "Caches:"
        L1D_CACHE=$(lscpu | grep "L1d cache:" | awk '{print $3, $4}')
        L1I_CACHE=$(lscpu | grep "L1i cache:" | awk '{print $3, $4}')
        L2_CACHE=$(lscpu | grep "L2 cache:" | awk '{print $3, $4}')
        L3_CACHE=$(lscpu | grep "L3 cache:" | awk '{print $3, $4}')
        
        [ -n "$L1D_CACHE" ] && print_property "  L1d" "$L1D_CACHE"
        [ -n "$L1I_CACHE" ] && print_property "  L1i" "$L1I_CACHE"
        [ -n "$L2_CACHE" ] && print_property "  L2" "$L2_CACHE"
        [ -n "$L3_CACHE" ] && print_property "  L3" "$L3_CACHE"
		echo ""
        print_mini_section "Vector Extensions:"
        CPU_FLAGS=$(grep -m1 "flags" /proc/cpuinfo | cut -d: -f2)
        VECTOR_EXTENSIONS=""
        
        for extension in avx512 avx2 avx sse4_2 sse4_1 sse3 sse2; do
            if echo "$CPU_FLAGS" | grep -qi $extension; then
                VECTOR_EXTENSIONS="$VECTOR_EXTENSIONS ${extension^^},"
            fi
        done
        
        if [ -n "$VECTOR_EXTENSIONS" ]; then
            print_neutral "  ${VECTOR_EXTENSIONS%,}"
        else
            print_neutral "  None detected"
        fi

        # Frequency
        echo ""
        print_mini_section "Frequency Range:"
        MIN_FREQ=$(lscpu | grep "CPU min MHz:" | awk '{print $4}')
        MAX_FREQ=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
            
        if [ -n "$MIN_FREQ" ] && [ -n "$MAX_FREQ" ]; then
            print_neutral "  Min: ${MIN_FREQ}MHz - Max: ${MAX_FREQ}MHz"
        else
            print_warning "  Frequency information not available"
        fi
    else
        print_warning "lscpu not available - microarchitecture analysis skipped"
	fi
fi
echo ""

# ============== BASE INFO (always show) ==================
print_section "--- PROCESS/SYSTEM INFORMATION ---"
print_mini_section "Current load:"
if command -v mpstat &> /dev/null; then
	CPU_STATS=$(mpstat 1 1 | awk 'NR==5')
	if [ -n "$CPU_STATS" ]; then
            USER_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $3}')
       	    SYSTEM_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $5}')
            IDLE_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $12}')
       	    TOTAL_LOAD=$(echo "scale=1; 100 - $IDLE_LOAD" | bc)
           
            CPU_STATUS=$(check_cpu_threshold $TOTAL_LOAD)
            print_status "$CPU_STATUS" "Current CPU usage" "${TOTAL_LOAD}%"
            print_property "  - User" "${USER_LOAD}%"
            print_property "  - System" "${SYSTEM_LOAD}%"
            print_property "  - Idle" "${IDLE_LOAD}%"
	fi
fi

# =============== EXTRA INFO (detailed mode) ===============
if [ "$MODE" = "detailed" ]; then
	echo ""
    print_mini_section "System statistic:"
    	if command -v uptime &> /dev/null; then
       		UPTIME=$(uptime -p | sed 's/up //')
        	print_property "Uptime" "$UPTIME"
    	fi

    	if command -v vmstat &> /dev/null; then
        	VMSTAT_OUTPUT=$(vmstat 1 2 | tail -1)
        	if [ -n "$VMSTAT_OUTPUT" ]; then
            		RUNNING_PROCS=$(echo $VMSTAT_OUTPUT | awk '{print $1}')
            		BLOCKED_PROCS=$(echo $VMSTAT_OUTPUT | awk '{print $2}')
            		print_property "Running processes" "$RUNNING_PROCS"
            		print_property "Blocked processes" "$BLOCKED_PROCS"
        	fi
    	fi

   	# Top proceses
    	echo ""
    	print_mini_section "Top proccesses by CPU"
    
    	if command -v ps &> /dev/null; then
		    echo -e "${COLOR_BOLD_WHITE}  PID %CPU COMMAND${COLOR_RESET}"
        	ps -eo pid,%cpu,comm --sort=-%cpu | head -6 | tail -5 | while read line; do
            		PID=$(echo $line | awk '{print $1}')
            		CPU_USAGE=$(echo $line | awk '{print $2}')
            		CMD=$(echo $line | awk '{print $3}')
			print_neutral "  $PID $CPU_USAGE% $CMD"
        	done
    	fi
fi
