get_storage_info() {
    R_INFO=$(df -h / | grep -E '^/dev/' | awk '$6 == "/"')
    ROOT_DISK=$(echo $R_INFO | awk '{print $1}')
    TOTAL_SPACE=$(echo $R_INFO | awk '{print $2}')
    USED_SPACE=$(echo $R_INFO | awk '{print $3}')
    FREE_SPACE=$(echo $R_INFO | awk '{print $4}')
    USED_PERCENT=$(echo $R_INFO | awk '{print $5}' | sed 's/%//')
    MOUNT_POINT=$(echo $R_INFO | awk '{print $6}')
    DISK_STATUS=$(check_disk_threshold $USED_PERCENT)
    EXIT_DISK_USAGE=$(get_exit_code $DISK_STATUS)
}

get_storage_performance() {
    # Temp directory, file
    TEST_DIR="/tmp"
    TEST_FILE="/tmp/system_validator_iotest.dat"

    # Check available space
    AVAILABLE_SPACE_KB=$(df "$TEST_DIR" | awk 'NR==2 {print $4}')
    AVAILABLE_SPACE_GB=$((AVAILABLE_SPACE_KB / 1024 / 1024))
    
    if [ "$AVAILABLE_SPACE_GB" -gt 2 ]; then
        WRITE_OUTPUT=$(dd if=/dev/zero of="$TEST_FILE" bs=64M count=16 oflag=direct conv=fdatasync 2>&1)
        WRITE_SPEED=$(echo "$WRITE_OUTPUT" | grep -E "copied|bytes" | awk '{print $(NF-1), $NF}')
        
        READ_OUTPUT=$(dd if="$TEST_FILE" of=/dev/null bs=64M iflag=direct 2>&1)
        READ_SPEED=$(echo "$READ_OUTPUT" | grep -E "copied|bytes" | awk '{print $(NF-1), $NF}')
        
        rm -f "$TEST_FILE"
    fi
}

get_disk_exit_code() {
    if [ $1 -eq 3 ]; then
        EXIT_DISK=3
    elif [ $2 -eq 2 ]; then
        EXIT_DISK=2
    elif [ $2 -eq 1 ]; then
        EXIT_DISK=1
    else
        EXIT_DISK=0
    fi
}