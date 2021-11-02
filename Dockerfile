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


RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update \
  && apt-get install -y \
  nodejs \
  mc \
  nano


ENV APACHE_DOCUMENT_ROOT=/var/www/html/app
RUN sed -ri -e 's!/var/www/html!/var/www/html/app!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/var/www/html/app!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

