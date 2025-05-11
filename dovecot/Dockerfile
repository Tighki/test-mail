FROM debian:bullseye-slim

# Установка времинной зоны
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-lmtpd \
    dovecot-mysql \
    dovecot-sieve \
    dovecot-managesieved \
    openssl \
    supervisor \
    netcat-openbsd \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Создание пользователя vmail для хранения почты
RUN groupadd -g 5000 vmail && \
    useradd -u 5000 -g vmail -s /usr/sbin/nologin -d /var/vmail -m vmail

# Создание директорий для логов supervisor
RUN mkdir -p /var/log/supervisor

# Создание директорий для Dovecot
RUN mkdir -p /var/vmail && \
    mkdir -p /var/log/dovecot && \
    mkdir -p /var/run/dovecot && \
    chown -R vmail:vmail /var/vmail && \
    chmod -R 0770 /var/vmail && \
    chown -R dovecot:dovecot /var/log/dovecot && \
    chown -R dovecot:dovecot /var/run/dovecot

# Копирование конфигурации Supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Копирование скрипта инициализации
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Открытие портов IMAP, IMAPS, POP3, POP3S, ManageSieve
EXPOSE 110 143 993 995 4190

# Запуск entrypoint скрипта для инициализации
ENTRYPOINT ["/entrypoint.sh"]

# Запуск supervisord в качестве основного процесса
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 