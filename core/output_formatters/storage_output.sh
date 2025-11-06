#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"
source "$PROJECT_ROOT/core/data_providers/storage_data.sh"

# Option by default
EXIT_DISK_DEP=0
EXIT_DISK_SPACE=0
print_storage_basic_info() {
    get_storage_info
    print_mini_section "Basic info:"
    print_property "Root partition" "$ROOT_DISK"
    print_property "Total space" "$TOTAL_SPACE"
    print_status "$DISK_STATUS" "Used space" "$USED_SPACE ($USED_PERCENT%)"
    print_status "$DISK_STATUS" "Free space" "$FREE_SPACE"
    print_property "Mounted on" "$MOUNT_POINT"
    echo ""
    print_mini_section "All mounted partitions:"
    df -h | grep -E '^/dev/' | head -5
}

print_storage_performance() {
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
}

