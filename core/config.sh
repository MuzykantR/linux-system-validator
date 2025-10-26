#!/bin/bash

# Threshold values
CPU_WARNING=70
CPU_CRITICAL=85

MEMORY_WARNING=80
MEMORY_CRITICAL=90

DISK_WARNING=80
DISK_CRITICAL=90    

SWAP_WARNING=10
SWAP_CRITICAL=50

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[1;37m'

# Get status by value
check_cpu_threshold() {
    local usage=$1
    if [ $(echo "$usage > $CPU_CRITICAL" | bc -l) -eq 1 ]; then 
	    echo "(X)"
    elif [ $(echo "$usage > $CPU_WARNING" | bc -l) -eq 1 ]; then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}

check_memory_threshold() {
    local usage=$1
    if [ $(echo "$usage > $MEMORY_CRITICAL" | bc -l) -eq 1 ]; then 
	    echo "(X)"
    elif [ $(echo "$usage > $MEMORY_WARNING" | bc -l) -eq 1 ]; then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}

check_disk_threshold() {
    local usage=$1
    if [ $(echo "$usage > $DISK_CRITICAL" | bc -l) -eq 1 ]; then 
	    echo "(X)"
    elif [ $(echo "$usage > $DISK_WARNING" | bc -l) -eq 1 ]; then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}

check_swap_threshold() {
    local usage=$1
    if [ $(echo "$usage > $SWAP_CRITICAL" | bc -l) -eq 1 ]; then 
	    echo "(X)"
    elif [ $(echo "$usage > $SWAP_WARNING" | bc -l) -eq 1 ]; then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}


# Get color by status
get_status_color() {
	local status=$1
	case $status in
		"(✓)") echo "$COLOR_GREEN" ;;
		"/!\\") echo "$COLOR_YELLOW" ;;
		"(X)") echo "$COLOR_RED" ;;
		*) echo "$COLOR_WHITE" ;;
	esac
}

