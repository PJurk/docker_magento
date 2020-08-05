
FROM httpd:2.4

LABEL MAINTAINER="Patryk Jurkiewicz" 
LABEL description="Local magento 2.4 setup" 
LABEL version="1.0.0"

RUN apt-get update && apt-get install -y \
  curl \
  libnss3-tools \
  openssl

RUN echo 127.0.0.1 www.magento.test.com magento.test.com >> "/etc/hosts"
COPY "magento.test.com.conf" "/etc/apache2/sites-available/magento.test.com.conf"
COPY "magento.test.com.conf" "/etc/apache2/sites-enabled/magento.test.com.conf"
COPY "apache2.conf" "/etc/apache2/apache2.conf"
RUN rm -rf "/etc/apache2/sites-available/000-default.conf"
RUN rm -rf "/etc/apache2/sites-available/000-enabled.conf"
RUN rm -rf "/etc/apache2/sites-available/default-ssl.conf"


RUN a2enmod rewrite

VOLUME /var/www
WORKDIR /var/www/html