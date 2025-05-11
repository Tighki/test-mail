FROM nginx:stable-alpine

# Копирование конфигурации
COPY config/ /etc/nginx/conf.d/

# Создание директорий для SSL и веб-контента
RUN mkdir -p /etc/nginx/ssl /usr/share/nginx/html /var/log/nginx

# Создание самоподписанного сертификата для тестирования
RUN apk add --no-cache openssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=Mail/CN=mail.example.com" && \
    chmod 644 /etc/nginx/ssl/nginx.key

# Создание базовой страницы для Roundcube или другого веб-интерфейса
RUN echo '<html><body><h1>Почтовый сервер</h1><p>Добро пожаловать на почтовый сервер</p></body></html>' > /usr/share/nginx/html/index.html

# Настройка прав доступа
RUN chown -R nginx:nginx /usr/share/nginx/html /var/log/nginx /etc/nginx/ssl

# Открытие портов HTTP и HTTPS
EXPOSE 80 443

# Запуск Nginx в foreground-режиме
CMD ["nginx", "-g", "daemon off;"] 