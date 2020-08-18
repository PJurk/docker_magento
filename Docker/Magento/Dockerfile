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
    echo 127.0.0.1 www.magento.test.com magento.test.com >> "/etc/hosts" && \ 
    a2enmod rewrite

COPY ./php.ini /usr/local/etc/php/
COPY ./auth.json $COMPOSER_HOME
COPY "magento.test.com.conf" "/etc/apache2/sites-available/magento.test.com.conf"
COPY "magento.test.com.conf" "/etc/apache2/sites-enabled/magento.test.com.conf"
COPY "apache2.conf" "/etc/apache2/apache2.conf"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get -y update && \
    apt-get install -y  \
    libbz2-dev \
    # libfreetype6-dev \
    libicu-dev \
    # libjpeg62-turbo-dev \
    # libssh2-1-dev \
    libsodium-dev \
    libmcrypt-dev \
    # libpng-dev \
    libpng++-dev \
    libzip-dev \
    # libmcrypt-dev \
    libmcrypt4 \
    libjpeg-dev \
    libcurl3-dev \
    libfreetype6 \
    libfreetype6-dev \
    libicu-dev \
    libxslt1-dev \
    libssl-dev \
    # build-essential \
    lsof \
    default-mysql-client \
    wget \
    gnupg2 \
    # vim \
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
 
RUN pecl channel-update pecl.php.net && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    # wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add - && \
    # echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update -y && \
    apt-get install -y nodejs \ 
    # blackfire-agent blackfire-php 
    && \
    rm -rf /var/lib/apt/lists/*
    # npm install -g yarn && \
    # npm install -g grunt-cli

RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && \
    mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail && \
    curl -sS https://getcomposer.org/installer | \
    php --  --install-dir=$COMPOSER_HOME --filename=composer




# RUN  printf '* */1 * * * php /var/www/html/update/cron.php\n' >> /etc/crontab \
#   && printf '* */1 * * * php /var/www/html/bin/magento cron:run\n' >> /etc/crontab \
#   && printf '* */1 * * * php /var/www/html/bin/magento setup:cron:run\n#\n' >> /etc/crontab \
# RUN service cron start

WORKDIR $INSTALL_DIR


