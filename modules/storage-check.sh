#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/output.sh"
source "$PROJECT_ROOT/core/data_providers/storage_data.sh"

# Option by default
MODE='basic'
EXIT_DISK_DEP=0
EXIT_DISK_SPACE=0

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

print_section "--- STORAGE INFORMATION ---"


get_storage_info

print_mini_section "Base info:"
print_property "Root partition" "$ROOT_DISK"
print_property "Total space" "$TOTAL_SPACE"
print_status "$DISK_STATUS" "Used space" "$USED_SPACE ($USED_PERCENT%)"
print_status "$DISK_STATUS" "Free space" "$FREE_SPACE"
print_property "Mounted on" "$MOUNT_POINT"

echo ""
print_mini_section "All mounted partitions:"
df -h | grep -E '^/dev/' | head -5

if [ "$MODE" = "detailed" ]; then
    echo ''
    print_mini_section "I/O Performance Test:"
    if command -v dd &> /dev/null; then
        get_storage_performance
        if [ "$AVAILABLE_SPACE_GB" -lt 2 ]; then
            print_warning "Not enough disk space for I/O test (available: ${AVAILABLE_SPACE_GB}GB, need: 2GB)"
        else  
            print_property "  Write speed" "${WRITE_SPEED:-"Test failed"}"
            print_property "  Read speed" "${READ_SPEED:-"Test failed"}"
        fi
    else
        print_warning "dd not available - I/O test skipped"
        EXIT_DISK_DEP=3
    fi
fi

get_disk_exit_code $EXIT_DISK_DEP $EXIT_DISK_USAGE
exit $EXIT_DISK