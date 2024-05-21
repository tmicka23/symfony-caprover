FROM php:8.2-apache

# enable apache to rewrite urls
RUN a2enmod rewrite

# install ubuntu useful packages
RUN apt-get update \
  && apt-get install -y libzip-dev git wget libicu-dev zip unzip --no-install-recommends

# install all necessary docker php package for the application
RUN docker-php-ext-install pdo mysqli pdo_mysql zip intl;

# install composer & enable container to execute composer script
RUN wget https://getcomposer.org/download/2.7.2/composer.phar \ 
    && mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer

# copy apache config
COPY .docker/apache.conf /etc/apache2/sites-enabled/000-default.conf

# copy the entire app directory into the container
COPY . /var/www

# copy the entrypoint script into the container
COPY .docker/entrypoint.sh /entrypoint.sh

# set the working directory
WORKDIR /var/www
# enable container to execute the entrypoint script
RUN chmod +x /entrypoint.sh 

# set the commands to run when we instanciate the container
CMD ["apache2-foreground"]

# set the location of the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
