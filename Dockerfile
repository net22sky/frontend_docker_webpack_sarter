FROM php:7.4-apache

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
		mc \
	; \
	apt-get install -y mc nano ; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		mysqli \
		pdo_mysql \
		pdo_pgsql \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  	&& apt-get install -y \
  	git \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libkrb5-dev \
    libicu-dev \
    zlib1g-dev \
	ffmpeg \
    libmemcached11 \
    libmemcachedutil2 \
    build-essential \
    libmemcached-dev \
    gnupg2 \
    libpq5 \
	libz-dev\
	zip 



# Activo XDebug:
# - https://dev.to/fuenrob/configurar-docker-con-xdebug-y-vs-code-252h
#RUN pecl install -f xdebug \
 # && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;


# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
#RUN { \
#		echo 'opcache.memory_consumption=128'; \
#       echo 'opcache.interned_strings_buffer=8'; \
#		echo 'opcache.max_accelerated_files=4000'; \
#		echo 'opcache.revalidate_freq=0'; \
#		echo 'opcache.fast_shutdown=1'; \
#	} > /usr/local/etc/php/conf.d/opcache-recommended.ini 

#COPY --from=composer:1.10 /usr/bin/composer /usr/local/bin/

# Instalo Node (via package manager para Debian):
# - https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update \
  && apt-get install -y \
  nodejs \
  mc \
  nano


#RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Install Drush
#RUN composer global require drush/drush && \
#    composer global update
    


#RUN npm install --global yarn
#RUN npm i npm@latest -g

#RUN yarn global add @vue/cli @vue/cli-service-global


# Instalo git y vim.


# https://www.drupal.org/node/3060/release
#ENV DRUPAL_VERSION 9.1.5

#ENV COMPOSER_ALLOW_SUPERUSER 1

#ENV APACHE_DOCUMENT_ROOT=/var/www/html/dist
#RUN sed -ri -e 's!/var/www/html!/var/www/html/dist!g' /etc/apache2/sites-available/*.conf
#RUN sed -ri -e 's!/var/www/!/var/www/html/dist!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

#ADD ./php.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www/html
# /opt
#RUN set -eux; \
#	export COMPOSER_HOME="$(mktemp -d)"; \
#	composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" ./; \
#	chown -R www-data:www-data web/sites web/modules web/themes; \
#RUN rmdir /var/www/html; \
#	ln -sf /opt /var/www/html; 

#   delete composer cache
# /opt
#RUN set -eux; \
#	export COMPOSER_HOME="$(mktemp -d)"; \
#	composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" ./; \
#	chown -R www-data:www-data web/sites web/modules web/themes; \
#RUN rmdir /var/www/html; \
#	ln -sf /opt /var/www/html; 

#   delete composer cache
#	rm -rf "$COMPOSER_HOME"

#ENV PATH=${PATH}:/opt/vendor/bin
