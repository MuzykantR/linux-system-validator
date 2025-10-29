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

print_section "--- DISK INFORMATION ---"

R_INFO=$(df -h / | grep -E '^/dev/' | awk '$6 == "/"')
ROOT_DISK=$(echo $R_INFO | awk '{print $1}')
TOTAL_SPACE=$(echo $R_INFO | awk '{print $2}')
USED_SPACE=$(echo $R_INFO | awk '{print $3}')
FREE_SPACE=$(echo $R_INFO | awk '{print $4}')
USED_PERCENT=$(echo $R_INFO | awk '{print $5}' | sed 's/%//')
MOUNT_POINT=$(echo $R_INFO | awk '{print $6}')

print_mini_section "Base info:"
print_property "Root partition" "$ROOT_DISK"
print_property "Total space" "$TOTAL_SPACE"
print_status "$(check_disk_threshold $USED_PERCENT)" "Used space" "$USED_SPACE ($USED_PERCENT%)"
print_status "$(check_disk_threshold $USED_PERCENT)" "Free space" "$FREE_SPACE"
print_property "Mounted on" "$MOUNT_POINT"

echo ""
print_mini_section "All mounted partitions:"
df -h | grep -E '^/dev/' | head -5

if [ "$MODE" = "detailed" ]; then
    echo ''
    print_mini_section "I/O Performance Test:"
    if command -v dd &> /dev/null; then
        # Temp directory, file
        TEST_DIR="/tmp"
        TEST_FILE="/tmp/system_validator_iotest.dat"

        # Check available space
        AVAILABLE_SPACE_KB=$(df "$TEST_DIR" | awk 'NR==2 {print $4}')
        AVAILABLE_SPACE_GB=$((AVAILABLE_SPACE_KB / 1024 / 1024))
        
        if [ "$AVAILABLE_SPACE_GB" -lt 2 ]; then
            print_warning "Not enough disk space for I/O test (available: ${AVAILABLE_SPACE_GB}GB, need: 2GB)"
        else
            WRITE_OUTPUT=$(dd if=/dev/zero of="$TEST_FILE" bs=64M count=16 oflag=direct conv=fdatasync 2>&1)
            WRITE_SPEED=$(echo "$WRITE_OUTPUT" | grep -E "copied|bytes" | awk '{print $(NF-1), $NF}')
            
            READ_OUTPUT=$(dd if="$TEST_FILE" of=/dev/null bs=64M iflag=direct 2>&1)
            READ_SPEED=$(echo "$READ_OUTPUT" | grep -E "copied|bytes" | awk '{print $(NF-1), $NF}')
            
            # Clean test dir
            rm -f "$TEST_FILE"
            
            print_property "  Write speed" "${WRITE_SPEED:-"Test failed"}"
            print_property "  Read speed" "${READ_SPEED:-"Test failed"}"
        fi
    else
        print_warning "dd not available - I/O test skipped"
    fi
fi