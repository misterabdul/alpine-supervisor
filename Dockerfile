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

COPY --chown=root:root ./configs/supervisord.conf /etc

RUN mkdir /app && \
    mkdir /app/cron && \
    mkdir /app/supervisor

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
