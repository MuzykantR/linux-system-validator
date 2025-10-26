#!/bin/bash

echo "=== Linux System Validator - Примеры использования ==="
echo ""

# Переходим в корневую директорию проекта
cd ..

echo "1. 🚀 Базовая проверка системы:"
echo "./system-validator.sh"
./system-validator.sh

echo ""
echo "2. 📊 Детальная проверка системы:"
echo "./system-validator.sh --detailed"
./system-validator.sh --detailed

echo ""
echo "3. 🔍 Проверка только CPU:"
echo "./cpu-check.sh --detailed"
./cpu-check.sh --detailed

echo ""
echo "4. 💾 Проверка только памяти:"
echo "./memory-check.sh"
./memory-check.sh

echo ""
echo "5. 💽 Проверка только дисков:"
echo "./disk-check.sh"
./disk-check.sh

echo ""
