FROM php:7.4.9-apache-buster

LABEL MAINTAINER="Patryk Jurkiewicz" 
LABEL description="Local magento 2.4 setup" 
LABEL version="1.0.0"

ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /usr/local/bin
ENV MAGENTO /bin/magento

RUN rm -rf "/etc/apache2/sites-available/000-default.conf" && \
    rm -rf "/etc/apache2/sites-available/000-enabled.conf" && \
    rm -rf "/etc/apache2/sites-available/default-ssl.conf" && \
    #Zmien adres strony na twoją nową strone "www.magento.test.com magento.test.com" >> "www.moj.adres.strony.com moj.adres.strony.com"
    echo 127.0.0.1 www.magento.test.com magento.test.com >> "/etc/hosts" && \ 
    a2enmod rewrite

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get -y update && \
    apt-get install -y  \
    libbz2-dev \
    libicu-dev \
    libsodium-dev \
    libmcrypt-dev \
    libpng++-dev \
    libzip-dev \
    libmcrypt4 \
    libjpeg-dev \
    libcurl3-dev \
    libfreetype6 \
    libfreetype6-dev \
    libicu-dev \
    libxslt1-dev \
    libssl-dev \
    lsof \
    default-mysql-client \
    wget \
    gnupg2 \
    unzip \
    gzip \
    curl \
    git \ 
    cron && \ 
    docker-php-ext-configure gd --with-freetype --with-jpeg && \ 
    docker-php-ext-install \
    pdo_mysql \
    zip \
    intl \
    xsl \
    soap \
    bcmath \
    sockets \
    curl \
    phar  \
    opcache \
    pcntl \
    gettext \
    bz2 \
    gd && \
    rm -rf /var/lib/apt/lists/*
 
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini && \ 
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update -y && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g yarn 

RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && \
    mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail && \
    curl -sS https://getcomposer.org/installer | \
    php --  --install-dir=$COMPOSER_HOME --filename=composer

COPY ./php.ini /usr/local/etc/php/
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./auth.json $COMPOSER_HOME
# Zmienic nazwy kopiowanych plikow konfiguracyjnych na nowo ustawione 
# "magento.test.com.conf" "/etc/apache2/sites-available/magento.test.com.conf"
# "moj.nowy.adres.conf" "/etc/apache2/sites-available/moj.nowy.adres.conf"
COPY "magento.test.com.conf" "/etc/apache2/sites-available/magento.test.com.conf"
COPY "magento.test.com.conf" "/etc/apache2/sites-enabled/magento.test.com.conf"
COPY "apache2.conf" "/etc/apache2/apache2.conf"

WORKDIR $INSTALL_DIR