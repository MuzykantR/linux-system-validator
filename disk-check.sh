#!/bin/bash

echo "--- DISK INFORMATION ---"

R_INFO=$(df -h / | grep -E '^/dev/' | awk '$6 == "/"')
ROOT_DISK=$(echo $R_INFO | cut -d' ' -f1)
TOTAL_SPACE=$(echo $R_INFO | cut -d' ' -f2)
USED_SPACE=$(echo $R_INFO | cut -d' ' -f3)
FREE_SPACE=$(echo $R_INFO | cut -d' ' -f4)
USED_PERCENT=$(echo $R_INFO | cut -d' ' -f5)
MOUNT_POINT=$(echo $R_INFO | cut -d' ' -f6)

echo "Root partition: $ROOT_DISK"
echo "Total space: $TOTAL_SPACE"
echo "Used space: $USED_SPACE ($USED_PERCENT)"
echo "Free space: $FREE_SPACE"
echo "Mounted on: $MOUNT_POINT"

echo ""
echo "All mounted partitions:"
df -h | grep -E '^/dev/' | head -5
