FROM php:7.3-fpm
LABEL maintainer="Nigel Bloemendal <info@webbever.nl>"

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        libpng-dev \
        zlib1g-dev \
        libzip-dev \
        libicu-dev \
        curl \
        git \
        unzip \ 
        gnupg \
        software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    npm i -g bower gulp


# Install docker ext's
RUN docker-php-source extract \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install pdo_mysql zip mbstring exif gd intl \
    && docker-php-ext-enable opcache

# Install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php && \
   mv composer.phar /usr/bin/composer && \
   chmod +x /usr/bin/composer && \
   composer global require hirak/prestissimo --no-scripts --no-progress --prefer-dist --optimize-autoloader --no-interaction --no-ansi

# Env variables
ENV COMPOSER_CACHE_DIR=/dev/null

WORKDIR /var/www