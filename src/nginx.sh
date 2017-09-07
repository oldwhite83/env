#!/usr/bin/env bash

CURRENT_NGINX_VERSION=$(nginx -v 2>&1 | awk -F ': ' '{print $2}' | tr '/' '-' | head -n1)

test_nginx() {
    if [ "$CURRENT_NGINX_VERSION" == "$NGINX_VERSION" ]; then
        echo "当前 Nginx 无需更新" "$NGINX_VERSION"
    else
        echo "安装 Nginx" "$NGINX_VERSION"
        install_nginx \
            && echo "安装 Nginx 成功" || (
                echo "安装 Nginx 失败"
                return 1
            )
    fi
}

# nginx
install_nginx() {
    nginx_configuration \
        && nginx_install_requirement || (
            echo "安装依赖失败"
            return 1
        ) \
        && nginx_build || (
            echo "编译失败"
            return 1
        ) \
        && nginx_check_install
}

nginx_configuration() {
    if [[ ! -d /usr/local/nginx/conf ]]; then
        mkdir -p /usr/local/nginx/conf
        cp -r "$BASE_PATH"/ini/nginx/conf/* /usr/local/nginx/conf/
    fi

    if [[ ! -f /usr/lib/systemd/system/nginx.service ]]; then
        cp "$BASE_PATH"/ini/nginx/nginx.service /usr/lib/systemd/system/nginx.service
        systemctl enable nginx
    fi
}

nginx_install_requirement() {
    time yum -y install gd gd-devel

    install_openssl
    install_pcre
    install_zlib
    install_libatomic
}

nginx_build() {
    tar zxf "$BASE_PATH"/source/"$NGINX_VERSION".tar.gz -C "$SETUP_PATH"

    cd "$SETUP_PATH"/"$NGINX_VERSION"
    ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/usr/local/nginx/conf/nginx.conf \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_degradation_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_iconv_module \
        --with-http_image_filter_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-ipv6 \
        --with-libatomic \
        --with-luajit \
        --with-openssl-opt="enable-tlsext" \
        --with-openssl="$SETUP_PATH"/openssl-"$OPENSSL_VERSION" \
        --with-pcre \
        --with-pcre-jit \
        --with-poll_module \
        --with-select_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-threads

    cd "$SETUP_PATH"/"$NGINX_VERSION"
    gmake $MAKETHREADS

    cd "$SETUP_PATH"/"$NGINX_VERSION"
    gmake install

    # 删除默认页
    rm -f /usr/local/openresty/nginx/html/index.html
}

nginx_check_install() {
    systemctl restart nginx
    systemctl status nginx
    nginx -v
}

install_openssl() {
    if [[ -d "$SETUP_PATH"/openssl-"$OPENSSL_VERSION" ]]; then
        echo "openssl 已经安装"
        return
    fi

    tar zxf "$BASE_PATH"/source/openssl-"$OPENSSL_VERSION".tar.gz -C "$SETUP_PATH"

    rm -rf "$SETUP_PATH"/staticlibssl
    mkdir "$SETUP_PATH"/staticlibssl
    cd "$SETUP_PATH"/openssl-"$OPENSSL_VERSION"
    make clean
    ./config --prefix="$SETUP_PATH"/staticlibssl no-shared enable-tlsext enable-ec_nistp_64_gcc_128

    cd "$SETUP_PATH"/openssl-"$OPENSSL_VERSION"
    make depend

    cd "$SETUP_PATH"/openssl-"$OPENSSL_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/openssl-"$OPENSSL_VERSION"
    make install
}

install_pcre() {
    if [[ -d "$SETUP_PATH"/pcre-"$PCRE_VERSION" ]]; then
        echo "pcre 已经安装"
        return
    fi

    tar zxf "$BASE_PATH"/source/pcre-"$PCRE_VERSION".tar.gz -C "$SETUP_PATH"
    cd "$SETUP_PATH"/pcre-"$PCRE_VERSION"
    ./configure

    cd "$SETUP_PATH"/pcre-"$PCRE_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/pcre-"$PCRE_VERSION"
    make install
}

install_zlib() {
    if [[ -d "$SETUP_PATH"/zlib-"$ZLIB_VERSION" ]]; then
        echo "zlib 已经安装"
        return
    fi

    tar zxf "$BASE_PATH"/source/zlib-"$ZLIB_VERSION".tar.gz -C "$SETUP_PATH"
    cd "$SETUP_PATH"/zlib-"$ZLIB_VERSION"
    ./configure

    cd "$SETUP_PATH"/zlib-"$ZLIB_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/zlib-"$ZLIB_VERSION"
    make install
}

install_libatomic() {
    if [[ -d "$SETUP_PATH"/libatomic_ops-"$LIBATOMIC_VERSION" ]]; then
        echo "libatomic 已经安装"
        return
    fi

    tar zxf "$BASE_PATH"/source/libatomic_ops-"$LIBATOMIC_VERSION".tar.gz -C "$SETUP_PATH"
    cd "$SETUP_PATH"/libatomic_ops-"$LIBATOMIC_VERSION"
    ./configure

    cd "$SETUP_PATH"/libatomic_ops-"$LIBATOMIC_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/libatomic_ops-"$LIBATOMIC_VERSION"
    make install
}
