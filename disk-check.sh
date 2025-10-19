#!/bin/bash

source ./output.sh

print_section "--- DISK INFORMATION ---"

R_INFO=$(df -h / | grep -E '^/dev/' | awk '$6 == "/"')
ROOT_DISK=$(echo $R_INFO | awk '{print $1}')
TOTAL_SPACE=$(echo $R_INFO | awk '{print $2}')
USED_SPACE=$(echo $R_INFO | awk '{print $3}')
FREE_SPACE=$(echo $R_INFO | awk '{print $4}')
USED_PERCENT=$(echo $R_INFO | awk '{print $5}' | sed 's/%//')
MOUNT_POINT=$(echo $R_INFO | awk '{print $6}')
echo "$R_INFO"
print_neutral "Root partition: $ROOT_DISK"
print_neutral "Total space: $TOTAL_SPACE"
print_status "$(check_disk_threshold $USED_PERCENT)" "Used space: $USED_SPACE ($USED_PERCENT%)"
print_status "$(check_disk_threshold $USED_PERCENT)" "Free space: $FREE_SPACE"
print_neutral "Mounted on: $MOUNT_POINT"

print_neutral ""
print_neutral "All mounted partitions:"
df -h | grep -E '^/dev/' | head -5
