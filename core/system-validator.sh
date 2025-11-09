#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/configs/output.sh"

# Option by default
MODE="basic" # basic | detailed | json
EXIT_CODE=0
JSON_OUTPUT_DIR=""

# Option identification
while [[ $# -gt 0 ]]; do
	case $1 in
		--basic|-b)
			MODE='basic'
			shift ;;
		--detailed|-d)
			MODE='detailed'
			shift ;;
		--json|-j)
			MODE='json'
			# Check dir
			if [[ $# -gt 1 && ! "$2" =~ ^- ]]; then
				JSON_OUTPUT_DIR="$2"
				shift 2
			else
				shift
			fi
			;;
		--help|-h)
			print_property "Usage" "sysval -[OPTIONS]"
			print_property "Options"
			print_neutral "   -b, --basic	  Basic system check (default)"
			print_neutral "   -d, --detailed   Detailed system analysis"
			print_neutral "   -j, --json [dir] Generate JSON report (optional output directory)"
			print_neutral "   -h, --help	  Show this help"
			exit 0 ;;
		*)
			print_neutral "Unknown option: $1"
			print_neutral "Use --help for usage information"
			exit 1 ;;
	esac
done

if [ "$MODE" = "basic" ]; then
	"$PROJECT_ROOT/core/modes/basic.sh"
elif [ "$MODE" = "detailed" ]; then
	"$PROJECT_ROOT/core/modes/detailed.sh"
elif [ "$MODE" = "json" ]; then
	"$PROJECT_ROOT/core/modes/json.sh" "$JSON_OUTPUT_DIR"
fi


