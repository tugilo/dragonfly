# PHP-FPM + Composer (Composer はホスト不要)
ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm

# 必要拡張
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libonig-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        zip \
        bcmath \
        gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer を公式イメージからコピー
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
