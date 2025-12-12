FROM openresty/openresty:alpine AS openresty

COPY ./default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./stream.conf.template /etc/nginx/stream.conf.template
COPY ./run.sh /run.sh

# Install dependencies and configure nginx
RUN apk update && apk add --no-cache gettext curl && \
    echo 'include /etc/nginx/stream.conf;' >> /usr/local/openresty/nginx/conf/nginx.conf && \
    mkdir -p /srv/cache && \
    chmod +x /run.sh && \
    chown -R nobody:nobody /srv/cache /etc/nginx /var/log/nginx /var/run/openresty && \
    rm -rf /var/cache/apk/*

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/info.json || exit 1

# Run as non-root user
USER nobody

CMD ["/bin/sh", "-c", "/run.sh"]
