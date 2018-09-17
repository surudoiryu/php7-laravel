FROM php:7.2-fpm
LABEL maintainer="Nigel Bloemendal <info@webbever.nl>"

# Add repositories
RUN apt-get apt-get install software-properties-common && \
    add-apt-repository ppa:certbot/certbot

# Install depencies
RUN apt-get update && apt-get upgrade && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        curl \
        mongodb \
        zip \
        bash \
        git \
        certbot

# Install docker ext's
RUN docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
    
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

RUN certbot certonly

WORKDIR /var/www
HEALTHCHECK --interval=1m CMD curl -f http://localhost/ || exit 1

CMD ["/usr/local/bin/php"]
