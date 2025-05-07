#!/bin/bash
set -e

# Создаем необходимые директории, если они не существуют
mkdir -p /var/vmail
mkdir -p /var/log/dovecot
chown -R vmail:vmail /var/vmail
chmod -R 0770 /var/vmail
chown -R dovecot:dovecot /var/log/dovecot

# Проверяем наличие группы postfix, создаем при необходимости
if ! getent group postfix > /dev/null; then
    groupadd postfix
fi

# Генерируем DH-параметры, если их еще нет
if [ ! -f /etc/dovecot/dh.pem ]; then
    echo "Генерация DH-параметров (это может занять некоторое время)..."
    openssl dhparam -out /etc/dovecot/dh.pem 2048
    chmod 644 /etc/dovecot/dh.pem
fi

# Проверяем доступ к директории spool Postfix
if [ ! -d /var/spool/postfix/private ]; then
    mkdir -p /var/spool/postfix/private
    chmod 700 /var/spool/postfix/private
fi

# Ожидаем доступности MySQL
echo "Ожидание доступности MySQL-сервера..."
until nc -z database-container 3306; do
    echo "MySQL недоступен, ожидаем..."
    sleep 2
done
echo "MySQL доступен!"

# Ожидаем доступности Postfix
echo "Ожидание доступности Postfix..."
until nc -z postfix 25; do
    echo "Postfix недоступен, ожидаем..."
    sleep 2
done
echo "Postfix доступен!"

# Установка часового пояса из переменной окружения
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

echo "Инициализация Dovecot завершена."

# Передача управления основной команде
exec "$@" 