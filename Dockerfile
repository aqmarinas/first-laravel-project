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

RUN cd /app && composer update

RUN cd /app && php artisan key:generate

COPY . /app

# Expose port 8080
EXPOSE 8080

# Set execute permissions for migration.sh
RUN chmod +x /app/migration.sh

# Run migrations and start the PHP built-in server
CMD ["/app/migration.sh"]
