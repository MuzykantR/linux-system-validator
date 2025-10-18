#!/bin/bash

echo "=== SYSTEM VALIDATOR ==="
echo "Cheking system components..."
echo ""

./cpu-check.sh
echo ""

./memory-check.sh
echo ""

echo "=== VALIDATION COMPLETE ==="
