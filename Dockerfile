FROM alpine:3.13.0

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
    php7-bcmath \
    php7-bz2 \
    php7-calendar \
    php7-cli \
    php7-common \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-gmp \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mysqlnd \
    php7-opcache \
    php7-openssl \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-pecl-redis \
    php7-phar \
    php7-posix \
    php7-simplexml \
    php7-session \
    php7-tokenizer \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-zip \
    php7-zlib && \
    mkdir /run/php && \
    chown nginx:nginx /run/php

RUN rm -rf /var/cache/apk/* && \
    ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm && \
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin --filename=composer

COPY --chown=root:root ./configs/supervisord.conf /etc
COPY --chown=root:root ./configs/nginx.conf /etc/nginx
COPY --chown=root:root ./configs/default.conf /etc/nginx/http.d
COPY --chown=root:root ./configs/php.ini /etc/php7
COPY --chown=root:root ./configs/php-fpm.conf /etc/php7
COPY --chown=root:root ./configs/www.conf /etc/php7/php-fpm.d

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
