#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PROJECT_ROOT/core/data_providers/cpu_data.sh"
source "$PROJECT_ROOT/core/data_providers/memory_data.sh"
source "$PROJECT_ROOT/core/data_providers/storage_data.sh"
OUTPUT_DIR=$1

check_dependencies() {
    local -A command_packages=(
        ["lscpu"]="util-linux"
        ["free"]="procps"
        ["mpstat"]="sysstat"
        ["bc"]="bc"
        ["uptime"]="procps"
        ["vmstat"]="sysstat"
        ["ps"]="procps"
        ["dd"]="coreutils"
    )
    local missing_commands=()
    local install_suggestions=()

    for cmd in "${!command_packages[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_commands+=("$cmd")
            install_suggestions+=("${command_packages[$cmd]}")
        fi
    done

    if [ ${#missing_commands[@]} -gt 0 ]; then
        echo "Missing dependencies detected:"
        printf "  - %s (install: %s)\n" "${missing_commands[@]}" "${install_suggestions[@]}"
        
        # Generate command for installing
        local unique_packages=$(printf "%s\n" "${install_suggestions[@]}" | sort -u | tr '\n' ' ')
        echo ""
        echo "Install all missing packages:"
        echo "  sudo apt-get install $unique_packages"
        return 1
    else
        echo "All system dependencies are satisfied"
        return 0
    fi
}

get_cpu_json() {
    local -A cpu_data
    get_cpu_base_info cpu_data
    get_cpu_extra_info cpu_data
    get_cpu_load_info cpu_data
    get_cpu_process_info cpu_data
    get_cpu_system_statistic cpu_data
    get_cpu_exit_code 0 $EXIT_CPU_LOAD
    cat << EOF
        "cpu": {
            "model_name": "${cpu_data["model"]}",
            "architecture": "${cpu_data["architecture"]}", 
            "sockets": "${cpu_data["sockets"]}",
            "cores_per_socket": "${cpu_data["cores_per_socket"]}",
            "total_cores": "${cpu_data["total_cores"]}",
            "total_threads": "${cpu_data["total_threads"]}",
            "frequency_mhz": "${cpu_data["frequency"]}",
            "family": "${cpu_data["family"]}",
            "model_number": "${cpu_data["model_number"]}",
            "stepping": "${cpu_data["stepping"]}",
            "cache_l1d": "${cpu_data["cache_l1d"]}",
            "cache_l1i": "${cpu_data["cache_l1i"]}",
            "cache_l2": "${cpu_data["cache_l2"]}",
            "cache_l3": "${cpu_data["cache_l3"]}",
            "vactor_extensions": "${cpu_data["vector_extensions"]}",
            "status": "${cpu_data["status"]}",
            "exit_code": "${EXIT_CPU}"
        }
EOF
}

get_memory_json(){
    local -A memory_data
    get_memory_info memory_data
    get_swap_info memory_data
    get_memory_exit_code 0 $EXIT_MEM_LOAD $EXIT_MEM_SWAP
    cat << EOF
        "memory": {
            "total_memory": "${memory_data["total_mem"]}",
            "used_memory": "${memory_data["used_mem"]}",
            "free_memory": "${memory_data["free_mem"]}",
            "used_memory_percent": "${memory_data["used_mem_percent"]}",
            "mem_status": "${memory_data["mem_status"]}",
            "total_swap": "${memory_data["swap_total"]}",
            "used_swap_percent": "${memory_data["used_swap_percent"]}",
            "swap_status": "${memory_data["swap_status"]}",
            "exit_code": "${EXIT_MEM_SWAP}"
        }
EOF
}

get_storage_json(){
    local -A storage_data
    get_storage_info storage_data
    get_storage_performance storage_data
    get_disk_exit_code 0 $EXIT_DISK_USAGE
    cat << EOF
        "storage": {
            "root_disk": "${storage_data["root_disk"]}",
            "total_space": "${storage_data["total_space"]}",
            "used_space": "${storage_data["used_space"]}",
            "free_space": "${storage_data["free_space"]}",
            "used_space_percent": "${storage_data["used_percent"]}",
            "mount_point": "${storage_data["mount_point"]}",
            "write_speed": "${storage_data["write_speed"]}",
            "read_speed": "${storage_data["read_speed"]}",
            "status": "${storage_data["status"]}",
            "exit_code": "${EXIT_DISK}"
        }
EOF
}


generate_json() {
    local report_file=$1
    local timestamp=$2
    cat > "$report_file" << EOF
{
    "timestamp": "${timestamp}",
    "system_report": {
$(get_cpu_json),
$(get_memory_json),
$(get_storage_json)
    }
}
EOF

}

main() {
    local output_dir=$1
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local default_dir="$PROJECT_ROOT/json_reports/"

    echo "Starting json mode..."

    if [[ -e "$output_dir" ]] && [[  ! -d "$output_dir" ]]; then
        echo "Error: Output directory doesnt exist"
        return 1
    elif [[ ! -e "$output_dir" ]]; then
        output_dir="$default_dir"
        if [[ ! -d "$default_dir" ]]; then
            mkdir $default_dir
        fi
    fi

    echo "Output directory: $output_dir"
    echo "Creating report file..."
    generate_json "$output_dir/system_report_${timestamp}.json" $timestamp

    echo "Done! Report file is created"
}

main $1