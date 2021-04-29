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
    nodejs \
    npm && \
    npm -g i npm

COPY --chown=root:root ./configs/supervisord.conf /etc

RUN rm -rf /var/cache/apk/*

RUN mkdir /app && \
    mkdir /app/cron && \
    mkdir /app/supervisor && \
    mkdir /app/nodejs && \
    mkdir /app/npm

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
