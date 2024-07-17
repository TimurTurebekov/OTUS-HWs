#!/bin/bash

# Конфигурационные параметры
LOG_FILE="/var/log/nginx/access.log"  # путь к логам веб-сервера
ERROR_LOG_FILE="/var/log/nginx/error.log"  # путь к логам ошибок веб-сервера
EMAIL="timur.turebekov@gmail.com"
LOCKFILE="/tmp/cron_script.lock"

# Функция для удаления блокировки при выходе из скрипта
cleanup() {
    rm -f $LOCKFILE
}
trap cleanup EXIT

# Проверка на существование lock-файла
if [ -e $LOCKFILE ]; then
    echo "Script is already running."
    exit 1
else
    touch $LOCKFILE
fi

# Определение временного диапазона
CURRENT_TIME=$(date +'%Y-%m-%d %H:%M:%S')
LAST_RUN_FILE="/tmp/last_run_time"
if [ -e $LAST_RUN_FILE ]; then
    LAST_RUN_TIME=$(cat $LAST_RUN_FILE)
else
    LAST_RUN_TIME=$(date -d '1 hour ago' +'%Y-%m-%d %H:%M:%S')
fi
echo $CURRENT_TIME > $LAST_RUN_FILE

# Сбор данных из логов
IP_REQUESTS=$(awk -v last_run="$LAST_RUN_TIME" '$4" "$5 >= "["last_run {print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -10)
URL_REQUESTS=$(awk -v last_run="$LAST_RUN_TIME" '$4" "$5 >= "["last_run {print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -10)
ERRORS=$(awk -v last_run="$LAST_RUN_TIME" '$1" "$2 >= last_run {print}' $ERROR_LOG_FILE)
HTTP_CODES=$(awk -v last_run="$LAST_RUN_TIME" '$4" "$5 >= "["last_run {print $9}' $LOG_FILE | sort | uniq -c | sort -nr)

# Формирование письма
EMAIL_SUBJECT="Hourly Web Server Report"
EMAIL_BODY="Report from $LAST_RUN_TIME to $CURRENT_TIME

Top 10 IP addresses:
$IP_REQUESTS

Top 10 URLs:
$URL_REQUESTS

Errors:
$ERRORS

HTTP response codes:
$HTTP_CODES"

# Отправка письма
echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" $EMAIL

# Удаление блокировки
cleanup#!/bin/bash

# Конфигурационные параметры
LOG_FILE="/var/log/nginx/access.log"  # путь к логам веб-сервера
ERROR_LOG_FILE="/var/log/nginx/error.log"  # путь к логам ошибок веб-сервера
EMAIL="your_email@example.com"
LOCKFILE="/tmp/cron_script.lock"

# Функция для удаления блокировки при выходе из скрипта
cleanup() {
    rm -f $LOCKFILE
}
trap cleanup EXIT

# Проверка на существование lock-файла
if [ -e $LOCKFILE ]; then
    echo "Script is already running."
    exit 1
else
    touch $LOCKFILE
fi

# Определение временного диапазона
CURRENT_TIME=$(date +'%Y-%m-%d %H:%M:%S')
LAST_RUN_FILE="/tmp/last_run_time"
if [ -e $LAST_RUN_FILE ]; then
    LAST_RUN_TIME=$(cat $LAST_RUN_FILE)
else
    LAST_RUN_TIME=$(date -d '1 hour ago' +'%Y-%m-%d %H:%M:%S')
fi
echo $CURRENT_TIME > $LAST_RUN_FILE

# Сбор данных из логов
IP_REQUESTS=$(awk -v last_run="$LAST_RUN_TIME" '$4" "$5 >= "["last_run {print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -10)
URL_REQUESTS=$(awk -v last_run="$LAST_RUN_TIME" '$4" "$5 >= "["last_run {print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -10)
ERRORS=$(awk -v last_run="$LAST_RUN_TIME" '$1" "$2 >= last_run {print}' $ERROR_LOG_FILE)
HTTP_CODES=$(awk -v last_run="$LAST_RUN_TIME" '$4" "$5 >= "["last_run {print $9}' $LOG_FILE | sort | uniq -c | sort -nr)

# Формирование письма
EMAIL_SUBJECT="Hourly Web Server Report"
EMAIL_BODY="Report from $LAST_RUN_TIME to $CURRENT_TIME

Top 10 IP addresses:
$IP_REQUESTS

Top 10 URLs:
$URL_REQUESTS

Errors:
$ERRORS

HTTP response codes:
$HTTP_CODES"

# Отправка письма
echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" $EMAIL

# Удаление блокировки
cleanup
