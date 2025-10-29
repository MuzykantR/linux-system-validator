#!/bin/bash

echo "=== Sysval Symlink Installation ==="

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSCheck_SCRIPT="$PROJECT_ROOT/sysval"
TARGET_DIR="$HOME/.local/bin"

# Check main script
if [ ! -f "$SYSCheck_SCRIPT" ]; then
    echo "Error: Main script not found: $SYSCheck_SCRIPT"
    exit 1
fi

# Create target dir
if [ ! -d "$TARGET_DIR" ]; then
    echo "Creating directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# Create symlink
echo "Creating symlink: $TARGET_DIR/sysval -> $SYSCheck_SCRIPT"
if ln -sf "$SYSCheck_SCRIPT" "$TARGET_DIR/sysval"; then
    echo "Symlink created successfully!"
else
    echo "Failed to create symlink"
    exit 1
fi

# Check PATH
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo ""
    echo "   IMPORTANT: $TARGET_DIR is not in your PATH"
    echo "   Add this to your ~/.bashrc:"
    echo "   echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
    echo "   Then run: source ~/.bashrc"
else
    echo "Installation complete! You can now use 'sysval' from anywhere!"
fi