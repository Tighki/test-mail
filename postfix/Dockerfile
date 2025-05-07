FROM debian:bullseye-slim

# Установка Postfix и необходимых утилит
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    postfix \
    postfix-mysql \
    postfix-ldap \
    libsasl2-modules \
    opendkim \
    opendkim-tools \
    ca-certificates \
    mailutils \
    supervisor \
    rsyslog \
    netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Копирование конфигурационных файлов
COPY config/main.cf /etc/postfix/main.cf
COPY config/master.cf /etc/postfix/master.cf
COPY config/virtual_mailbox_domains.cf /etc/postfix/virtual_mailbox_domains.cf
COPY config/virtual_mailbox_maps.cf /etc/postfix/virtual_mailbox_maps.cf
COPY config/virtual_alias_maps.cf /etc/postfix/virtual_alias_maps.cf
COPY config/sasl/smtpd.conf /etc/postfix/sasl/smtpd.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Создание необходимых директорий и прав доступа
RUN mkdir -p /var/spool/postfix/private \
    && mkdir -p /var/spool/postfix/public \
    && groupadd -g 5000 vmail \
    && useradd -g vmail -u 5000 vmail -d /var/vmail -m \
    && chown -R postfix:postfix /var/spool/postfix

# Создание скрипта инициализации
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Экспозиция портов
EXPOSE 25 587 465

# Запуск через entrypoint и supervisor
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 