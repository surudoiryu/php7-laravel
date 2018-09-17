FROM php:7.2-fpm
LABEL maintainer="Nigel Bloemendal <info@webbever.nl>"

# Install depencies
RUN apt-get update && apt-get upgrade && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g-dev \
        wget \
        curl \
        mongodb \
        bash \
        git \ 
        supervisor

# Remove lists
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor

# Install docker ext's
# Configure, install and enable php extensions
RUN docker-php-ext-configure intl --with-icu-dir=/usr/local && \
    docker-php-ext-install intl pdo pdo_mysql zip bcmath && \
    docker-php-ext-enable opcache
    
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

CMD ["/usr/bin/supervisord"]
