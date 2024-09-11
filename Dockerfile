FROM openresty/openresty AS openresty

COPY ./default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./stream.conf.template /etc/nginx/stream.conf.template
COPY ./run.sh /run.sh

RUN /bin/sh -c "apk update"
RUN /bin/sh -c "apk add gettext"
RUN /bin/sh -c "echo 'include /etc/nginx/stream.conf;' >> /usr/local/openresty/nginx/conf/nginx.conf"
CMD ["/bin/sh", "-c", "/run.sh"]
