FROM alpine:3.5

ENV NGINX_VERSION 1.12.1
ENV NGX_SMALL_LIGHT_VERSION 0.9.2
ENV NGINX_DEVELOPMENT_KIT_VERSION 0.3.0
ENV LUA_NGINX_MODULE_VERSION 0.10.9rc8

ENV LUAJIT_LIB /usr/lib
ENV LUAJIT_INC /usr/include/luajit-2.1

RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
    && CONFIG="\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-threads \
        --add-module=/usr/src/ngx_devel_kit-$NGINX_DEVELOPMENT_KIT_VERSION \
        --add-module=/usr/src/lua-nginx-module-$LUA_NGINX_MODULE_VERSION \
        --add-module=/usr/src/ngx_small_light-$NGX_SMALL_LIGHT_VERSION \
    " \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        pcre-dev \
        zlib-dev \
        linux-headers \
        curl \
        gnupg \
        imagemagick-dev \
        perl \
        luajit-dev \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc -o nginx.tar.gz.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && found=''; \
    for server in \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu \
    ; do \
        echo "Fetching GPG key $GPG_KEYS from $server"; \
        gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEYS" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEYS" && exit 1; \
    gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz \
    && rm -r "$GNUPGHOME" nginx.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm nginx.tar.gz \
    && curl -fSL https://github.com/simpl/ngx_devel_kit/archive/v$NGINX_DEVELOPMENT_KIT_VERSION.tar.gz -o ngx_devel_kit.tar.gz \
    && tar -zxC /usr/src -f ngx_devel_kit.tar.gz \
    && rm ngx_devel_kit.tar.gz \
    && curl -fSL https://github.com/openresty/lua-nginx-module/archive/v$LUA_NGINX_MODULE_VERSION.tar.gz -o lua-nginx-module.tar.gz \
    && tar -zxC /usr/src -f lua-nginx-module.tar.gz \
    && rm lua-nginx-module.tar.gz \
    && curl -fSL https://github.com/cubicdaiya/ngx_small_light/archive/v$NGX_SMALL_LIGHT_VERSION.tar.gz -o ngx-small-light.tar.gz \
    && tar -zxC /usr/src -f ngx-small-light.tar.gz \
    && rm ngx-small-light.tar.gz \
    && cd /usr/src/ngx_small_light-$NGX_SMALL_LIGHT_VERSION \
    && ./setup \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && rm -rf /etc/nginx/html/ \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && install -m644 html/index.html /usr/share/nginx/html/ \
    && install -m644 html/50x.html /usr/share/nginx/html/ \
    && ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
    && strip /usr/sbin/nginx* \
    && rm -rf /usr/src/nginx-$NGINX_VERSION \
    && rm -rf /usr/src/ngx_devel_kit-$NGINX_DEVELOPMENT_KIT_VERSION \
    && rm -rf /usr/src/lua-nginx-module-$LUA_NGINX_MODULE_VERSION \
    && rm -rf /usr/src/ngx_small_light-$NGX_SMALL_LIGHT_VERSION \
    \
    # Bring in gettext so we can get `envsubst`, then throw
    # the rest away. To do this, we need to install `gettext`
    # then move `envsubst` out of the way so `gettext` can
    # be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
