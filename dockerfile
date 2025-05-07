FROM php:7.4-apache

RUN a2enmod rewrite
RUN \
    apt-get update && \
    apt-get install -y libldap2-dev libicu-dev
RUN docker-php-ext-install mysqli pdo_mysql pdo ldap intl