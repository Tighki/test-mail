#!/bin/bash
set -e

# Создаем необходимые директории, если они не существуют
mkdir -p /var/vmail
mkdir -p /var/log/dovecot
mkdir -p /var/shared
chown -R vmail:vmail /var/vmail
chmod -R 0770 /var/vmail
chown -R dovecot:dovecot /var/log/dovecot

# Настройка hosts для разрешения имени postfix
if [ -n "$POSTFIX_HOST" ]; then
    echo "$POSTFIX_HOST postfix" >> /etc/hosts
    echo "Добавлен хост postfix ($POSTFIX_HOST) в /etc/hosts"
else
    echo "172.18.0.1 postfix" >> /etc/hosts
    echo "Внимание: POSTFIX_HOST не определен, используется 172.18.0.1"
fi

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

# Создаем shared директорию для коммуникации с Postfix вместо сетевого соединения
mkdir -p /var/shared/postfix-dovecot
chmod 777 /var/shared/postfix-dovecot

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

echo "Инициализация Dovecot завершена."

# Передача управления основной команде
exec "$@" 