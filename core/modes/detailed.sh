#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"
source "$PROJECT_ROOT/core/output_formatters/cpu_output.sh"
source "$PROJECT_ROOT/core/output_formatters/memory_output.sh"
source "$PROJECT_ROOT/core/output_formatters/storage_output.sh"

echo ""
print_header "=== SYSTEM VALIDATOR ==="
print_property "Timestamp" "$(get_timestamp)"
print_property "Mode" "$MODE"
print_separator
echo ""

print_section "--- CPU INFORMATION ---"
print_cpu_basic_info
print_cpu_extra_info
echo ""

print_section "--- PROCESSES/SYSTEM INFORMATION ---"
print_cpu_load_info
echo ""
print_system_info
echo ""

print_section "--- MEMORY INFORMATION ---"
print_memory_usage
echo ""

print_section "--- STORAGE INFORMATION ---"
print_storage_basic_info
echo ""
print_storage_performance
echo ""

print_separator
print_header "=== VALIDATION COMPLETE ==="

get_cpu_exit_code $EXIT_CPU_DEP $EXIT_CPU_LOAD
get_memory_exit_code $EXIT_MEM_DEP $EXIT_MEM_LOAD $EXIT_MEM_SWAP
get_disk_exit_code $EXIT_DISK_DEP $EXIT_DISK_USAGE
OVERALL_EXIT=0
if [ $EXIT_CPU -eq 3 ] || [ $EXIT_MEMORY -eq 3 ] || [ $EXIT_DISK -eq 3 ]; then
    OVERALL_EXIT=3
elif [ $EXIT_CPU -eq 2 ] || [ $EXIT_MEMORY -eq 2 ] || [ $EXIT_DISK -eq 2 ]; then
    OVERALL_EXIT=2
elif [ $EXIT_CPU -eq 1 ] || [ $EXIT_MEMORY -eq 1 ] || [ $EXIT_DISK -eq 1 ]; then
    OVERALL_EXIT=1
fi
exit $OVERALL_EXIT