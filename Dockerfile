FROM php:8.2-cli

COPY . /app
COPY .env.example /app/.env

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    unzip \
    zip 

RUN docker-php-ext-install pdo_mysql 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-scripts

RUN composer update

RUN php artisan key:generate

EXPOSE 8080

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8080

# RUN chmod +x /app/migration.sh

# CMD ["/app/migration.sh"]
