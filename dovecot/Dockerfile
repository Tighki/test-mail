FROM debian:bullseye-slim

# Установка Dovecot и необходимых компонентов
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-lmtpd \
    dovecot-mysql \
    dovecot-ldap \
    dovecot-sieve \
    dovecot-managesieved \
    supervisor \
    rsyslog \
    netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Копирование конфигурационных файлов
COPY config/dovecot.conf /etc/dovecot/dovecot.conf
COPY config/conf.d/ /etc/dovecot/conf.d/
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Создание необходимых директорий и прав доступа
RUN mkdir -p /var/vmail \
    && groupadd -g 5000 vmail \
    && useradd -g vmail -u 5000 vmail -d /var/vmail

# Указание корректных прав доступа
RUN chown -R vmail:vmail /var/vmail \
    && chmod -R 0770 /var/vmail

# Создание скрипта инициализации
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Экспозиция портов
EXPOSE 110 995 143 993 4190

# Запуск через entrypoint и supervisor
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 