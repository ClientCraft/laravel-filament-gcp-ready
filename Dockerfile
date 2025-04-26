FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
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

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
RUN cd /app && \
    /usr/local/bin/composer install --no-dev

RUN chown -R www-data: /app

CMD sh /app/docker/startup.sh
