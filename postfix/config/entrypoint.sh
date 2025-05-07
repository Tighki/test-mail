#!/bin/bash
set -e

# Создаем необходимые директории, если они не существуют
mkdir -p /var/vmail
chown -R vmail:vmail /var/vmail
chmod -R 0770 /var/vmail

# Инициализация структуры директорий Postfix
postfix set-permissions >/dev/null 2>&1 || true
chown -R postfix:postfix /var/spool/postfix

# Проверка существования файлов spool
if [ ! -d /var/spool/postfix/private ]; then
    mkdir -p /var/spool/postfix/private
    chown postfix:postfix /var/spool/postfix/private
    chmod 700 /var/spool/postfix/private
fi

# Ожидаем доступности MySQL
echo "Ожидание доступности MySQL-сервера..."
until nc -z database-container 3306; do
    echo "MySQL недоступен, ожидаем..."
    sleep 2
done
echo "MySQL доступен!"

# Установка часового пояса из переменной окружения
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

# Применение параметров из переменных окружения
if [ -n "$MAILNAME" ]; then
    echo "$MAILNAME" > /etc/mailname
    postconf -e myhostname="$MAILNAME"
    postconf -e mydestination="localhost.localdomain, localhost, $MAILNAME"
fi

if [ -n "$MYNETWORKS" ]; then
    postconf -e mynetworks="$MYNETWORKS"
fi

echo "Инициализация Postfix завершена."

# Передача управления основной команде
exec "$@" 