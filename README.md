# Linux System Validator

**Bash-скрипт для автоматической проверки готовности тестовых окружений** перед нагрузочным тестированием и в CI/CD пайплайнах.

## 🎯 Возможности

- ✅ **Базовая проверка** - CPU, RAM, disk space
- 📊 **Расширенная диагностика** - детальная информация о системе
- 🚨 **Пороговые проверки** - цветовая индикация проблем
- 🔄 **Два режима работы** - basic и detailed
- 🐧 **Поддержка различных дистрибутивов** Linux

## 🚀 Быстрый старт

```bash
# Скачать и сделать исполняемым
chmod +x system-validator.sh

# Быстрая проверка (по умолчанию)
./system-validator.sh

# Детальная проверка
./system-validator.sh --detailed

# Показать справку
./system-validator.sh --help
```

## 📋 Пример вывода
Detailed mode:

```text
=== SYSTEM VALIDATOR ===
Timestamp: 2025-10-19 14:52:05
Mode: detailed
----------------------------------------

--- CPU INFORMATION ---
Architecture: x86_64
CPU Cores: 16
Model:  AMD Ryzen 7 7730U with Radeon Graphics
Sockets: 1
Threads per core: 2
Frequency: 1996.200 MHz

--- CURRENT LOAD ---
(✓) Current CPU usage: .1%
  - User: 0.0%
  - System: 0.0%
  - Idle: 99.9%

--- SYSTEM STATISTICS ---
Uptime: 6 hours, 12 minutes
Running processes: 0
Blocked processes: 0

--- TOP PROCESSES BY CPU ---
  PID %CPU COMMAND
  1 4.2% systemd
  43 1.4% systemd-journal
  361 1.0% systemd
  92 1.0% systemd-udevd
  208 0.8% unattended-upgr

--- MEMORY INFORMATION ---
Total RAM: 7.5Gi
(✓) Used RAM: 532Mi (6.9%)
(✓) Free RAM: 6.6Gi
(✓) Swap: 2.0Gi total (0% used)

--- DISK INFORMATION ---
/dev/sdd       1007G  5.0G  951G   1% /
Root partition: /dev/sdd
Total space: 1007G
(✓) Used space: 5.0G (1%)
(✓) Free space: 951G
Mounted on: /

All mounted partitions:
/dev/sdd       1007G  5.0G  951G   1% /

----------------------------------------
=== VALIDATION COMPLETE ===

```

## 🛠️ Установка
Клонируйте репозиторий:

```bash
git clone https://github.com/MuzykantR/linux-system-validator.git
cd linux-system-validator
```

Убедитесь что зависимости установлены:
```bash
# Обязательные
sudo apt-get install bc
# Рекомендуемые (для расширенного режима)
sudo apt-get install sysstat procps
```
## 📖 Использование
Базовые команды
```bash
# Быстрая проверка системы
./system-validator.sh
./system-validator.sh --basic

# Детальный анализ
./system-validator.sh --detailed
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
├── system-validator.sh          # Главный скрипт
├── cpu-check.sh                 # Проверка CPU
├── memory-check.sh              # Проверка памяти
├── disk-check.sh                # Проверка дисков
├── config.sh                    # Конфигурация
├── output-utils.sh              # Утилиты вывода
├── examples/
│   ├── basic-usage.sh          # Примеры использования
└── README.md                   # Документация
```

### Частые проблемы:
1. **"bc: command not found"** - установите `sudo apt-get install bc`
2. **"mpstat: command not found"** - установите `sudo apt-get install sysstat`
3. **Нет прав на выполнение** - `chmod +x *.sh`