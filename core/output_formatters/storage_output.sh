#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"
source "$PROJECT_ROOT/core/data_providers/storage_data.sh"

# Option by default
EXIT_DISK_DEP=0
EXIT_DISK_USAGE=0
print_storage_basic_info() {
    local -A storage_data
    get_storage_info storage_data
    print_mini_section "Basic info:"
    print_property "Root partition" "${storage_data["root_disk"]}"
    print_property "Total space" "${storage_data["total_space"]}"
    print_status "${storage_data["status"]}" "Used space" "${storage_data["used_space"]} (${storage_data["used_percent"]}%)"
    print_status "${storage_data["status"]}" "Free space" "${storage_data["free_space"]}"
    print_property "Mounted on" "${storage_data["mount_point"]}"
    echo ""
    print_mini_section "All mounted partitions:"
    df -h | grep -E '^/dev/' | head -5
}

print_storage_performance() {
    print_mini_section "I/O Performance Test:"
    if command -v dd &> /dev/null; then
        local -A storage_performance_data
        get_storage_performance storage_performance_data
        if [ "${storage_performance_data["available_space_gb"]}" -lt 2 ]; then
            print_warning "Not enough disk space for I/O test (available: ${AVAILABLE_SPACE_GB}GB, need: 2GB)"
        else  
            print_property "  Write speed" "${storage_performance_data["write_speed"]:-"Test failed"}"
            print_property "  Read speed" "${storage_performance_data["read_speed"]:-"Test failed"}"
        fi
    else
        print_warning "dd not available - I/O test skipped"
        EXIT_DISK_DEP=3
    fi
}

