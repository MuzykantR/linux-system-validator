#!/bin/bash

source "$PROJECT_ROOT/core/config.sh"

# Get status by value
check_cpu_threshold() {
    local usage=$1
    if (( $(echo "$usage > $CPU_CRITICAL" | bc -l) )); then 
	    echo "(X)"
    elif (( $(echo "$usage > $CPU_WARNING" | bc -l) )); then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}

check_memory_threshold() {
    local usage=$1
    if (( $(echo "$usage > $MEMORY_CRITICAL" | bc -l) )); then 
	    echo "(X)"
    elif (( $(echo "$usage > $MEMORY_WARNING" | bc -l) )); then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}

check_disk_threshold() {
    local usage=$1
    if (( $(echo "$usage > $DISK_CRITICAL" | bc -l) )); then 
	    echo "(X)"
    elif (( $(echo "$usage > $DISK_WARNING" | bc -l) )); then 
	    echo '/!\\'
    else
	    echo "(✓)"
    fi
}

check_swap_threshold() {
    local usage=$1
    if (( $(echo "$usage > $SWAP_CRITICAL" | bc -l) )); then 
	    echo "(X)"
    elif (( $(echo "$usage > $SWAP_WARNING" | bc -l) )); then 
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

# Funcs for color output
print_header() {
    echo -e "${COLOR_BOLD_CYAN}$1${COLOR_RESET}"
}

print_section() {
    echo -e "${COLOR_BOLD_BLUE}$1${COLOR_RESET}"
}

print_mini_section() {
    echo -e "${COLOR_BLUE}$1${COLOR_RESET}"
}
print_property() {
    local property=$1
    local value=$2
    echo -e "${COLOR_BOLD_WHITE}$property: ${COLOR_RESET}$value"
}

print_neutral() {
    echo -e "$1"
}

print_warning() {
    echo -e "${COLOR_RED}$1${COLOR_RESET}"
}

print_status() {
    local status=$1
    local property=$2
    local value=$3
    local color=$(get_status_color "$status")
    echo -e "${color}$status ${COLOR_BOLD_WHITE}$property: ${COLOR_RESET} $value"
}

get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

print_separator() {
    echo "----------------------------------------"
}
