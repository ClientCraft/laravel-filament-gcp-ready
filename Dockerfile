FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    nginx \
    wget \
    libxml2-dev \
    curl-dev \
    openssl-dev \
    mariadb-connector-c-dev \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    build-base \
    autoconf

RUN docker-php-ext-install \
    pdo_mysql \
    curl \
    mbstring \
    xml \
    intl \
    zip

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php/php.ini /usr/local/etc/php/php.ini

RUN mkdir -p /app
COPY . /app

RUN wget -O - https://raw.githubusercontent.com/composer/getcomposer.org/f3108f64b4e1c1ce6eb462b159956461592b3e3e/web/installer | php -- --quiet --install-dir=/usr/local/bin --filename=composer && \
        chmod +x /usr/local/bin/composer
    
WORKDIR /app
RUN composer install --no-dev --no-plugins --no-scripts

RUN chown -R www-data: /app

CMD sh /app/docker/startup.sh
