# Linux System Validator

**Bash-скрипт для автоматической проверки готовности тестовых окружений** перед нагрузочным тестированием и в CI/CD пайплайнах.

## 🎯 Возможности

- ✅ **Базовая проверка** - CPU, RAM, Storage
- 📊 **Расширенная диагностика** - детальная информация о системе
- 🚨 **Пороговые проверки** - цветовая индикация проблем
- 🔄 **Два режима работы** - basic и detailed
- 🐧 **Поддержка различных дистрибутивов** Linux

## 🚀 Установка

```bash
git clone https://github.com/MuzykantR/linux-system-validator.git
cd linux-system-validator
chmod +x . -R
./usage/symlink.sh  # Создает глобальную команду 'sysval'

# Убедитесь что необходимые зависимости установлены:
sudo apt-get install bc sysstat procps
```

## 📖 Использование
Базовые команды
```bash
# Быстрая проверка (по умолчанию)
sysval

# Детальная проверка
sysval -d

# Показать справку
sysval -h
```

## 📋 Пример вывода
Detailed mode:

```text
=== SYSTEM VALIDATOR ===
Timestamp: 2025-10-29 11:45:02
Mode: detailed
----------------------------------------

--- CPU INFORMATION ---
Base info:
  Model:  AMD Ryzen 7 7730U with Radeon Graphics
  Architecture: x86_64
  Sockets: 1
  Cores per socket: 8
  Threads per core: 2
  Total: 8 cores, 16 threads
  Frequency: 1996.200 MHz
  CPU Family: 25
  Model: 80
  Stepping: 0

Caches:
  L1d: 256 KiB
  L1i: 256 KiB
  L2: 4 MiB
  L3: 16 MiB

Vector Extensions:
   AVX2, AVX, SSE4_2, SSE4_1, SSE3, SSE2

Frequency Range:
  Frequency information not available

--- PROCESS/SYSTEM INFORMATION ---
Current load:
(✓) Current CPU usage:  .8%
  - User: 0.0%
  - System: 0.6%
  - Idle: 99.2%

System statistic:
Uptime: 1 hour, 49 minutes
Running processes: 0
Blocked processes: 0

Top proccesses by CPU
  PID %CPU COMMAND
  613 1.3% node
  29399 0.4% cpu-check.sh
  545 0.1% node
  574 0.1% node
  567 0.0% node

--- MEMORY INFORMATION ---
Total RAM: 7.5Gi
(✓) Used RAM:  842Mi (11.0%)
(✓) Free RAM:  6.5Gi
(✓) Swap:  2.0Gi total (0% used)

--- STORAGE INFORMATION ---
Base info:
Root partition: /dev/sdd
Total space: 1007G
(✓) Used space:  5.0G (1%)
(✓) Free space:  951G
Mounted on: /

All mounted partitions:
/dev/sdd       1007G  5.0G  951G   1% /

I/O Performance Test:
  Write speed: 3.5 GB/s
  Read speed: 5.1 GB/s

----------------------------------------
=== VALIDATION COMPLETE ===
```

### Режимы работы

| Режим | Описание | Использование |
|-------|----------|---------------|
| `--basic` | Базовая информация о системе | Быстрые проверки, CI/CD |
| `--detailed` | Детальная диагностика | Глубокий анализ проблем |

## 🎯 Пороговые значения

Система использует настраиваемые пороги для индикации проблем:

| Ресурс | ✅ Норма | ⚠️ Предупреждение | ❌ Критично |
|--------|----------|-------------------|-------------|
| CPU usage | < 70% | 70-85% | > 85% |
| Memory usage | < 80% | 80-90% | > 90% |
| Disk usage | < 80% | 80-90% | > 90% |
| Swap usage | 0% | 1-50% | > 50% |


## ⚙️ Кастомизация порогов

Отредактируйте `config.sh` для изменения пороговых значений:

```bash
# Пороговые значения (в процентах)
CPU_WARNING=70
CPU_CRITICAL=85

MEMORY_WARNING=80
MEMORY_CRITICAL=90

DISK_WARNING=80
DISK_CRITICAL=90    

SWAP_WARNING=10
SWAP_CRITICAL=50
```

## 📁 Структура проекта
```text
linux-system-validator/
├── core
│   ├── config.sh               # Конфигурация
│   ├── output.sh               # Утилиты вывода
│   └── system-validator.sh     # Основная логика
├── modules
│   ├── cpu-check.sh            # Проверка CPU
│   ├── memory-check.sh         # Проверка памяти
│   └── storage-check.sh        # Проверка дисков/хранилищ
└── usage
    ├── basic-usage.sh          # Примеры использования
    └── symlink.sh              # Установка глобальной команды
├── sysval                      # Главный исполняемый файл
└── README.md                   # Документация
```