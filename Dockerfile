FROM php:7.2-fpm
LABEL maintainer="Nigel Bloemendal <info@webbever.nl>"

# Install depencies
RUN apt-get update && \
      apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        wget \
        curl \
        mongodb \
        bash \
        git && \
      rm -rf /var/lib/apt/lists/* && \
      apt-get autoremove

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

# Install Xdebug
RUN XDEBUG_VERSION=2.6.1 && \
    curl -sSL -o /tmp/xdebug-${XDEBUG_VERSION}.tgz http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz && \
    cd /tmp && tar -xzf xdebug-${XDEBUG_VERSION}.tgz && cd xdebug-${XDEBUG_VERSION} && phpize && ./configure && make && make install && \
    echo "zend_extension=xdebug" > /usr/local/etc/php/conf.d/xdebug.ini && \
    rm -rf /tmp/xdebug*
    
# Install PHPUnit
RUN curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit

WORKDIR /var/www

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]

CMD php-fpm

EXPOSE 9000