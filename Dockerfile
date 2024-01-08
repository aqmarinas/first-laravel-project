FROM php:8.2-cli

COPY . /app
COPY .env.example /app/.env

RUN apk add --update \
    curl \
    git \
    php \
    php-opcache \
    php-openssl \
    php-pdo \
    php-json \
    php-phar \
    php-dom \
    unzip \
    zip \
    && rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin --filename=composer

RUN cd /app && composer update
RUN cd /app && php artisan key:generate

WORKDIR /app

CMD php artisan serve --host=0.0.0.0 --port=8080

EXPOSE 8080