#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/output.sh"

# Option by default
MODE="basic" # basic | detailed

# Option identification
while [[ $# -gt 0 ]]; do
	case $1 in
		--basic|-b)
			MODE='basic'
			shift ;;
		--detailed|-d)
			MODE='detailed'
			shift ;;
		--help|-h)
			print_property "Usage" "sysval -[OPTIONS]"
			print_property "Options"
			print_neutral "   -b, --basic	  Basic system check (default)"
			print_neutral "   -d, --detailed   Detailed system analysis"
			print_neutral "   -h, --help	  Show this help"
			exit 0 ;;
		*)
			print_neutral "Uknown option: $1"
			print_neutral "Use --help for usage information"
			exit 1 ;;
	esac
done


echo ""
print_header "=== SYSTEM VALIDATOR ==="
print_property "Timestamp" "$(get_timestamp)"
print_property "Mode" "$MODE"
print_separator
echo ""

"$PROJECT_ROOT/modules/cpu-check.sh" --$MODE
echo ""

"$PROJECT_ROOT/modules/memory-check.sh"
echo ""

"$PROJECT_ROOT/modules/storage-check.sh" --$MODE
echo ""

print_separator
print_header "=== VALIDATION COMPLETE ==="
echo ""
