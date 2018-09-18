FROM php:7.2-fpm
LABEL maintainer="Nigel Bloemendal <info@webbever.nl>"

# Install depencies
RUN apt-get update && \
      apt-get install -y \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        curl \
        git \
        unzip

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
   chmod +x /usr/bin/composer

WORKDIR /var/www