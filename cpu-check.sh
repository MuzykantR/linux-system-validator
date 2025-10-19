#!/bin/bash

source ./output.sh

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
print_neutral "Architecture: $(uname -m)"
print_neutral "CPU Cores: $(nproc)"
print_neutral "Model: $(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)"

# =============== EXTRA INFO (detailed mode) ===============
if [ "$MODE" = "detailed" ]; then
	# Info about sockets, threads, frequency
	if command -v lscpu &> /dev/null; then
		SOCKETS=$(lscpu | grep "Socket(s)" | cut -d: -f2 | sed 's/^[ \t]*//;s/[ \t]*$//')
		THREADS_PER_CORE=$(lscpu | grep "Thread(s) per core" | cut -d: -f2 |  sed 's/^[ \t]*//;s/[ \t]*$//')
		CPU_MHZ=$(cat /proc/cpuinfo | grep "cpu MHz" | cut -d: -f2 | head -1 | sed 's/^[ \t]*//;s/[ \t]*$//')
		
		print_neutral "Sockets: $SOCKETS"
		print_neutral "Threads per core: $THREADS_PER_CORE"
		print_neutral "Frequency: ${CPU_MHZ} MHz"
	fi
fi
echo ""

# ============== BASE INFO (always show) ==================
print_neutral "--- CURRENT LOAD ---"
if command -v mpstat &> /dev/null; then
	CPU_STATS=$(mpstat 1 1 | awk 'NR==5')
	if [ -n "$CPU_STATS" ]; then
            USER_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $3}')
       	    SYSTEM_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $5}')
            IDLE_LOAD=$(echo $CPU_STATS | awk '{printf "%.1f", $12}')
       	    TOTAL_LOAD=$(echo "scale=1; 100 - $IDLE_LOAD" | bc)
           
            CPU_STATUS=$(check_cpu_threshold $TOTAL_LOAD)
            print_status "$CPU_STATUS" "Current CPU usage: ${TOTAL_LOAD}%"
            print_neutral "  - User: ${USER_LOAD}%"
            print_neutral "  - System: ${SYSTEM_LOAD}%"
            print_neutral "  - Idle: ${IDLE_LOAD}%"
	fi
fi

# =============== EXTRA INFO (detailed mode) ===============
if [ "$MODE" = "detailed" ]; then
	echo ""
	print_neutral "--- SYSTEM STATISTICS ---"
    	if command -v uptime &> /dev/null; then
       		UPTIME=$(uptime -p | sed 's/up //')
        	print_neutral "Uptime: $UPTIME"
    	fi

    	if command -v vmstat &> /dev/null; then
        	VMSTAT_OUTPUT=$(vmstat 1 2 | tail -1)
        	if [ -n "$VMSTAT_OUTPUT" ]; then
            		RUNNING_PROCS=$(echo $VMSTAT_OUTPUT | awk '{print $1}')
            		BLOCKED_PROCS=$(echo $VMSTAT_OUTPUT | awk '{print $2}')
            		print_neutral "Running processes: $RUNNING_PROCS"
            		print_neutral "Blocked processes: $BLOCKED_PROCS"
        	fi
    	fi

   	# Top proceses
    	echo ""
    	print_neutral "--- TOP PROCESSES BY CPU ---"
    
    	if command -v ps &> /dev/null; then
		echo -e "${COLOR_WHITE}  PID %CPU COMMAND${COLOR_RESET}"
        	ps -eo pid,%cpu,comm --sort=-%cpu | head -6 | tail -5 | while read line; do
            		PID=$(echo $line | awk '{print $1}')
            		CPU_USAGE=$(echo $line | awk '{print $2}')
            		CMD=$(echo $line | awk '{print $3}')
			print_neutral "  $PID $CPU_USAGE% $CMD"
        	done
    	fi
fi
