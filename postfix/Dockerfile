FROM debian:bullseye-slim

# Установка времинной зоны
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Установка зависимостей и Postfix
RUN apt-get update && apt-get install -y \
    postfix \
    postfix-mysql \
    libsasl2-modules \
    openssl \
    supervisor \
    netcat-openbsd \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Создание директорий для supervisor и логов
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/spool/postfix/pid

# Настройка hostname для корректного разрешения имен
RUN echo "127.0.0.1 postfix" >> /etc/hosts
RUN echo "postfix" > /etc/hostname
RUN hostname postfix

# Копирование конфигурации Supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Копирование скрипта инициализации
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Открытие портов для SMTP, SUBMISSION, SMTPS
EXPOSE 25 587 465

# Запуск entrypoint скрипта для инициализации
ENTRYPOINT ["/entrypoint.sh"]

# Запуск supervisord в качестве основного процесса
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 