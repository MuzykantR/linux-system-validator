#!/bin/bash

echo "--- MEMORY INFORMATION ---"

MEMORY_INFO=$(free -h)

TOTAL_MEM=$(echo "$MEMORY_INFO" | awk 'NR==2 {print $2}')
USED_MEM=$(echo "$MEMORY_INFO" | awk 'NR==2 {print $3}')
FREE_MEM=$(echo "$MEMORY_INFO" | awk 'NR==2 {print $4}')

echo "Total RAM: $TOTAL_MEM"
echo "Used RAM: $USED_MEM"
echo "Free RAM: $FREE_MEM"

SWAP_TOTAL=$(echo "$MEMORY_INFO" | awk 'NR==3 {print $2}')
SWAP_USED=$(echo "$MEMORY_INFO" | awk 'NR==3 {print $3}')

if [ "$SWAP_TOTAL" != "0B" ]; then
    echo "Swap Total: $SWAP_TOTAL"
    echo "Swap Used: $SWAP_USED"
fi
