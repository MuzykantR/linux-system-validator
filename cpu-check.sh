#!/bin/bash

echo "--- CPU INFORMATION ---"
echo "Architecture: $(uname -m)"
echo "CPU Cores: $(nproc)"
echo "Model: $(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)"
