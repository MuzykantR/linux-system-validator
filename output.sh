#!/bin/bash

source ./config.sh
# Color for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0;m' # No color 

# Funcs for color output
print_header() {
    echo -e "${COLOR_CYAN}$1${COLOR_RESET}"
}

print_section() {
    echo -e "${COLOR_BLUE}$1${COLOR_RESET}"
}

print_neutral() {
    echo -e "${COLOR_WHITE}$1${COLOR_RESET}"
}

print_status() {
    local status=$1
    local message=$2
    local color=$(get_status_color "$status")
    echo -e "${color}$status ${COLOR_WHITE}$message${COLOR_RESET}"
}

get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

print_separator() {
    echo "----------------------------------------"
}
