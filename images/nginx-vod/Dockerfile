FROM alpine AS build
RUN apk update && apk add build-base linux-headers pcre-dev openssl-dev zlib-dev
WORKDIR /opt
RUN mkdir nginx nginx-vod \
    && wget -O- https://nginx.org/download/nginx-1.20.2.tar.gz | tar -C nginx/ --strip 1 -xz \
    && wget -O- https://github.com/kaltura/nginx-vod-module/archive/refs/tags/1.29.tar.gz | tar -C nginx-vod/ --strip 1 -xz
WORKDIR /opt/nginx
RUN ./configure \
   --add-module=../nginx-vod \
   --sbin-path=/usr/local/nginx/nginx \
   --conf-path=/usr/local/nginx/nginx.conf \
   --with-file-aio \
   --with-threads \
   --with-cc-opt="-O3" \
   && make && make install

FROM alpine
RUN apk update \
    && apk add pcre-dev openssl-dev zlib-dev \
    && mkdir /usr/local/nginx /usr/local/videos
COPY --from=build /usr/local/nginx/ /usr/local/nginx/
COPY docker-entrypoint.sh /
COPY nginx.conf /usr/local/nginx/nginx.conf
ENTRYPOINT ["/docker-entrypoint.sh"]
