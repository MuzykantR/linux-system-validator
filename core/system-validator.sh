#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"

# Option by default
MODE="basic" # basic | detailed
EXIT_CODE=0

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

if [ "$MODE" = "basic" ]; then
	"$PROJECT_ROOT/core/modes/basic.sh"
elif [ "$MODE" = "detailed" ]; then
	"$PROJECT_ROOT/core/modes/detailed.sh"
fi


