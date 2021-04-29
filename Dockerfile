FROM alpine:3.13.5

ENV TIMEZONE Asia/Jakarta

RUN apk update && apk upgrade

RUN apk add --no-cache \
    curl \
    tzdata

RUN apk add --no-cache \
    supervisor && \
    mkdir /etc/supervisor.d && \
    mkdir /run/supervisor

RUN apk add --no-cache \
    nginx && \
    mkdir /run/nginx && \
    chown nginx:nginx /run/nginx

RUN apk add --no-cache \
    php8-bcmath \
    php8-bz2 \
    php8-calendar \
    php8-cli \
    php8-common \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-fileinfo \
    php8-fpm \
    php8-gd \
    php8-gmp \
    php8-iconv \
    php8-intl \
    php8-json \
    php8-mbstring \
    php8-mysqlnd \
    php8-opcache \
    php8-openssl \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-pecl-redis \
    php8-phar \
    php8-posix \
    php8-simplexml \
    php8-session \
    php8-tokenizer \
    php8-xml \
    php8-xmlreader \
    php8-xmlwriter \
    php8-zip \
    php8-zlib && \
    mkdir /run/php && \
    chown nginx:nginx /run/php

RUN rm -rf /var/cache/apk/* && \
    ln -s /usr/bin/php8 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm && \
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin --filename=composer

COPY --chown=root:root ./configs/supervisord.conf /etc
COPY --chown=root:root ./configs/nginx.conf /etc/nginx
COPY --chown=root:root ./configs/default.conf /etc/nginx/http.d
COPY --chown=root:root ./configs/php.ini /etc/php8
COPY --chown=root:root ./configs/php-fpm.conf /etc/php8
COPY --chown=root:root ./configs/www.conf /etc/php8/php-fpm.d

RUN mkdir /app && \
    mkdir /app/cron && \
    mkdir /app/www && \
    chown nginx:nginx /app/www && \
    mkdir /app/supervisor && \
    mkdir /app/nginx && \
    chown nginx:nginx /app/nginx && \
    mkdir /app/php && \
    chown nginx:nginx /app/php

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
