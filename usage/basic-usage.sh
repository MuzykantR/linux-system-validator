#!/bin/bash

echo "=== Linux System Validator - Демонстрация возможностей ==="
echo ""

# Переходим в корневую директорию проекта
cd "$(dirname "$0")/.."

echo "1. 🚀 БАЗОВАЯ ПРОВЕРКА СИСТЕМЫ:"
echo "sysval"
sysval

echo ""
echo "2. 📊 ДЕТАЛЬНАЯ ДИАГНОСТИКА СИСТЕМЫ:"
echo "sysval --detailed"
sysval --detailed
pwd
echo ""
echo "3. 🔍 ПРОВЕРКА ТОЛЬКО CPU (детальный режим):"
echo "./modules/cpu-check.sh --detailed"
./modules/cpu-check.sh --detailed

echo ""
echo "4. 💾 ПРОВЕРКА ТОЛЬКО ПАМЯТИ:"
echo "./modules/memory-check.sh"
./modules/memory-check.sh

echo ""
echo "5. 💽 ПРОВЕРКА ТОЛЬКО ХРАНИЛИЩА:"
echo "./modules/storage-check.sh --detailed"
./modules/storage-check.sh --detailed

echo ""
echo "6. 🎯 БЫСТРЫЙ СТАТУС СИСТЕМЫ:"
echo "sysval --basic | grep -E \"(✓|/!\\|\(X\))\""
sysval --basic | grep -E "(✓|/!\\|\(X\))"

echo ""
echo "=================================================="
echo "💡 СОВЕТ: Для глобального использования выполните:"
echo "   ./usage/symlink.sh"
echo "   Тогда команда 'sysval' будет доступна из любой директории!"
echo "=================================================="
