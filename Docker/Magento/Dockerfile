FROM php:7.4-fpm-buster

LABEL MAINTAINER="Patryk Jurkiewicz" 
LABEL description="Local magento 2.4 setup" 
LABEL version="1.0.0"

ENV INSTALL_DIR /app
ENV COMPOSER_HOME /usr/local/bin
ENV MAGENTO /bin/magento
ENV NVM_DIR /.nvm
ENV NODE_VER 14.7.0

RUN && apt-get -y update \
    && apt-get install -y  \
    libbz2-dev \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libssh2-1-dev \
  libsodium-dev \
  libmcrypt-dev \
  libpng-dev \
  libpng++-dev \
  libzip-dev \
  libmcrypt-dev \
  libmcrypt4 \
  libjpeg-dev \
  libcurl3-dev \
  libfreetype6 \
  libfreetype6-dev \
  libicu-dev \
  libxslt1-dev \
  libssl-dev \
  install build-essential \
  lsof \
  default-mysql-client \
  wget \
  vim \
  unzip \
  gzip \
  curl \
  git \ 
  cron

RUN rm -rf /var/lib/apt/lists/* && \
    mkdir ${NVM_DIR} && \
    rm /bin/sh && ln -s /bin/bash /bin/sh
    
# RUN apt-get install -y libonig-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
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
    gd

RUN pecl channel-update pecl.php.net \
  && pecl install xdebug

RUN docker-php-ext-enable xdebug \
  && sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz && \
    tar -xf Python-3.8.2.tar.xz && \
    Python-3.8.2/configure --enable-optimizations && \
    make -j 4 && \
    make altinstall



RUN curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    ${NVM_DIR}/nvm.sh && \
    nvm install ${NODE_VER} && \
    nvm alias default ${NODE_VER}  && \
    nvm use default && \
    npm install -g yarn && \
    npm install -g grunt-cli


  
RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x mhsendmail_linux_amd64 \
  && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN curl -sS https://getcomposer.org/installer | \
  php --  --install-dir=$COMPOSER_HOME --filename=composer
COPY ./auth.json $COMPOSER_HOME

RUN curl -s https://packages.blackfire.io/gpg.key | apt-key add - \
  && echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list \
  && apt-get update \
  && apt-get install blackfire-agent blackfire-ph

=
COPY ./php.ini /usr/local/etc/php/
# COPY ./php-fpm.conf /usr/local/etc/
=

# RUN  printf '* */1 * * * php /var/www/html/update/cron.php\n' >> /etc/crontab \
#   && printf '* */1 * * * php /var/www/html/bin/magento cron:run\n' >> /etc/crontab \
#   && printf '* */1 * * * php /var/www/html/bin/magento setup:cron:run\n#\n' >> /etc/crontab \
# RUN service cron start  
WORKDIR $INSTALL_DIR


