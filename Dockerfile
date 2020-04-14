FROM php:7.2-apache

ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /var/www/.composer/
ENV MAGENTO /bin/magento

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
COPY ./auth.json $COMPOSER_HOME

RUN requirements="libpng++-dev libzip-dev libmcrypt-dev libmcrypt4 libjpeg-dev libcurl3-dev libfreetype6 libfreetype6-dev libicu-dev libxslt1-dev unzip" \
    && apt-get -y update \
    && apt-get install -y git \
    && apt-get install -y $requirements \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=DIR \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install sockets

#RUN  composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $INSTALL_DIR
# RUN cd $INSTALL_DIR \
#     && find . -type d -exec chmod 770 {} \; \
#     && find . -type f -exec chmod 660 {} \; \
#     && chmod u+x bin/magento

COPY "memory-limit-php.ini" "/usr/local/etc/php/conf.d/memory-limit-php.ini"
WORKDIR $INSTALL_DIR

# RUN composer config http-basic.repo.magento.com adf97a28c4f6f0c1e6a8f3d9f11cc448 bdec1caff6c7d5632054b1c08ed4cf7b
# RUN bin/magento sampledata:deploy
RUN a2enmod rewrite
