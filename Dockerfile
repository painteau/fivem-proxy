FROM openresty/openresty:alpine AS openresty

COPY ./default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./stream.conf.template /etc/nginx/stream.conf.template
COPY ./run.sh /run.sh

RUN apk update && apk add --no-cache gettext
RUN echo 'include /etc/nginx/stream.conf;' >> /usr/local/openresty/nginx/conf/nginx.conf

CMD ["/bin/sh", "-c", "/run.sh"]
