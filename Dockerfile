FROM php:8.5-apache

# Install the PDO MySQL extension
RUN docker-php-ext-install pdo pdo_mysql

# Enalbe Apache mod_rewrite (useful for most PHP frameworks)
RUN a2enmod rewrite
