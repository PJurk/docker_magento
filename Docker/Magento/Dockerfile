FROM php:7.4.9-apache-buster

LABEL MAINTAINER="Patryk Jurkiewicz" 
LABEL description="Local magento 2.4 setup" 
LABEL version="1.0.0"

ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /usr/local/bin
ENV MAGENTO /bin/magento
ENV TZ UTC

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./apache2.conf /etc/apache2/apache2.conf
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \   
        && a2enmod rewrite

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get -y update && \
    apt-get install -y  \
    apt-transport-https \
    libcurl3-dev  \
    libxml2-dev  \
    libgd-dev   \
    libicu-dev   \
    libonig-dev     \
    libzip-dev    \
    libnice-dev    \
    libbz2-dev \
    libssl-dev \
    libxslt1-dev \
    openssl    \
    lsof    \
    sed    \
    tar    \
    wget \
    gnupg2 \
    unzip \
    gzip \
    curl \
    git \ 
    cron  && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \ 
    docker-php-ext-install \
    pdo_mysql \
    xsl \
    gd \
    zip \
    intl \
    soap \
    bcmath \
    sockets \
    curl \
    phar  \
    opcache \
    pcntl \
    gettext \
    bz2 && \
    pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini && \ 
    pecl install redis && docker-php-ext-enable redis && \
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update -y && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g yarn && \
    curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && \
    mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail && \
    curl -sS https://getcomposer.org/installer | \
    php --  --install-dir=$COMPOSER_HOME --filename=composer && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY "./php.ini" "$PHP_INI_DIR/conf.d/"
COPY ./auth.json $COMPOSER_HOME

RUN chmod -Rf 777  /var/www /var/www/.* 	&& chown -Rf www-data:www-data /var/www /var/www/.* 	&& usermod -u 1000 www-data 	&& chsh -s /bin/bash www-data	&& a2enmod rewrite 	&& a2enmod headers


WORKDIR $INSTALL_DIR