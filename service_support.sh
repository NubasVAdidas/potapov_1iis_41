#!/bin/bash
# service_support.sh — проверка статуса ИИС и резервное копирование
# Использование: ./service_support.sh [status|backup]
# --- Проверка: передан ли хотя бы один аргумент ---
if [ -z "$1" ]; then
  echo "Использование: $0 [status|backup|logs]"
  exit 1
fi
# --- Режим status: список Docker-контейнеров ---
if [ "$1" == "status" ]; then
  echo "=== Проверка статуса ИИС ==="
  # Таблица: имя, статус, порты
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
  echo "============================="
# --- Режим backup: файл с меткой времени ---
elif [ "$1" == "backup" ]; then
  echo "=== Запуск резервного копирования ==="
  mkdir -p ./backups
  # Метка даты-времени для имени файла
  DATA_TAG=$(date +%Y-%m-%d_%H-%M-%S)
  BACKUP_FILE="./backups/iis_backup_$DATA_TAG.txt"
  # Имитация сохранения конфигурации ИИС
  echo "Бэкап базы знаний ИИС от $DATA_TAG" >"$BACKUP_FILE"
  echo "Конфигурация успешно сохранена в файл: $BACKUP_FILE"
  echo "====================================="
elif [ "$1" == "logs" ]; then
  echo "=== Логи Grafana Monitoring ==="
  #Показывает логи Grafana Monitoring
  #с временными отметками без отладочных сообщений
  docker logs --timestamps grafana_monitoring 2>&1 | grep -v "DEBUG"
  echo "====================================="
# --- Неизвестный аргумент ---
else
  echo "Ошибка: Неизвестная команда '$1'. Используйте 'status' или 'backup'."
  exit 1
fi
