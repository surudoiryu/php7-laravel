FROM php:7.2-fpm
LABEL maintainer="Nigel Bloemendal <info@webbever.nl>"

# Env variables
ENV COMPOSER_CACHE_DIR=/dev/null

# Install depencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        curl \
        git \
        unzip \ 
        gnupg \
        software-properties-common \
        nodejs && \
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
   composer global require hirak/prestissimo

WORKDIR /var/www