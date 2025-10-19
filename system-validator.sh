#!/bin/bash

source ./output.sh

echo ""
print_header "=== SYSTEM VALIDATOR ==="
print_neutral "Cheking system components..."
print_separator
echo ""

print_section "Starting system validation..."
echo ""

print_neutral "Checking CPU..."
./cpu-check.sh
echo ""

print_neutral "Checking Memory..."
./memory-check.sh
echo ""

print_neutral "Checking Disks..."
./disk-check.sh
echo ""

print_separator
print_header "=== VALIDATION COMPLETE ==="
echo ""
