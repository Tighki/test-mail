#!/bin/bash
set -e

# Создаем необходимые директории
mkdir -p /var/spool/postfix/pid
mkdir -p /var/spool/postfix/private
mkdir -p /var/spool/postfix/public
mkdir -p /var/shared/postfix-dovecot
mkdir -p /var/log/supervisor

# Устанавливаем права
chmod 700 /var/spool/postfix/pid
chmod 700 /var/spool/postfix/private
chmod 777 /var/shared/postfix-dovecot

# Применяем значения из переменных окружения
sed -i "s/MYSQL_SERVER/$MYSQL_SERVER/g" /etc/postfix/config/virtual_*.cf
sed -i "s/MYSQL_DATABASE/$MYSQL_DATABASE/g" /etc/postfix/config/virtual_*.cf
sed -i "s/MYSQL_USER/$MYSQL_USER/g" /etc/postfix/config/virtual_*.cf
sed -i "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/g" /etc/postfix/config/virtual_*.cf

# Копируем конфигурационные файлы
cp -f /etc/postfix/config/main.cf /etc/postfix/main.cf
cp -f /etc/postfix/config/master.cf /etc/postfix/master.cf
cp -f /etc/postfix/config/virtual_*.cf /etc/postfix/
cp -f /etc/postfix/config/sasl/smtpd.conf /etc/postfix/sasl/

# Настраиваем hostname в конфигурации
if [ -n "$HOSTNAME" ]; then
    sed -i "s/myhostname = mail.example.com/myhostname = $HOSTNAME/g" /etc/postfix/main.cf
    postconf -e "myhostname = $HOSTNAME"
    echo "Hostname установлен как $HOSTNAME"
fi

# Ожидаем доступности MySQL
echo "Ожидание доступности MySQL-сервера..."
until nc -z $MYSQL_SERVER 3306; do
    echo "MySQL недоступен, ожидаем..."
    sleep 2
done
echo "MySQL доступен!"

# Установка часового пояса из переменной окружения
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

echo "Инициализация Postfix завершена."

# Передача управления основной команде
exec "$@" 