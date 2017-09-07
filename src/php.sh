#!/usr/bin/env bash

CURRENT_PHP_VERSION=$(php -v 2>&1 | awk -F ' ' '{print $2}' | head -n1)
CONFIGSCANDIR=/etc/php.d

test_php() {
    if [ "$CURRENT_PHP_VERSION" == "$PHP_VERSION" ]; then
        echo "当前 PHP 无需更新" "$PHP_VERSION"
        php_install_extension
        php_install_composer
    else
        echo "安装 PHP" "$PHP_VERSION"
        install_php \
            && echo "安装 PHP 成功" || (
                echo "安装 PHP 失败"
                return 1
            )
    fi
}

# php
install_php() {
    php_configuration \
        && php_install_requirement || (
            echo "安装依赖失败"
            return 1
        ) \
        && php_build || (
            echo "编译失败"
            return 1
        ) \
        && php_install_extension \
        && php_check_install \
        && php_install_composer
}

php_configuration() {
    if [[ ! -f /usr/local/lib/php.ini ]]; then
        cp "$BASE_PATH"/ini/php/php.ini /usr/local/lib/php.ini
    fi
    if [[ ! -f /usr/local/etc/php-fpm.conf ]]; then
        cp "$BASE_PATH"/ini/php/php-fpm.conf /usr/local/etc/php-fpm.conf
    fi
    if [[ ! -f /usr/local/etc/php-fpm.d/www.conf ]]; then
        mkdir -p /usr/local/etc/php-fpm.d/
        cp "$BASE_PATH"/ini/php/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
    fi

    if [[ ! -f /usr/lib/systemd/system/php-fpm.service ]]; then
        cp "$BASE_PATH"/ini/php/php-fpm.service /usr/lib/systemd/system/php-fpm.service
        systemctl enable php-fpm
    fi
}

php_install_requirement() {
    time yum -y install gd gd-devel libxml2 libxml2-devel enchant-devel.i686 enchant-devel libvpx libvpx-devel t1lib t1lib-devel libicu libicu-devel bzip2-devel gmp-devel libcurl-devel aspell aspell-devel readline readline-devel libedit libedit-devel net-snmp net-snmp-devel net-snmp-libs net-snmp-utils recode recode-devel pam-devel libzip libzip-devel t1lib t1lib-devel || return 1

    if [ ! -d "$CONFIGSCANDIR" ]; then
        mkdir -p "$CONFIGSCANDIR"
    fi

    install_libmcrypt || return 1
    install_imap_from_yum || return 1
}

php_build() {
    tar zxf "$BASE_PATH"/source/php-"$PHP_VERSION".tar.gz -C "$SETUP_PATH"

    cd "$SETUP_PATH"/php-"$PHP_VERSION"
    ./buildconf --force

    cd "$SETUP_PATH"/php-"$PHP_VERSION"
    ./configure \
        --enable-cgi \
        --enable-fpm \
        --enable-intl \
        --enable-pcntl \
        --enable-opcache \
        --with-mcrypt \
        --with-snmp \
        --with-mhash \
        --with-zlib \
        --with-gettext \
        --enable-exif \
        --enable-zip \
        --with-bz2 \
        --enable-soap \
        --enable-sockets \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-shmop \
        --with-pear \
        --enable-mbstring \
        --with-openssl \
        --with-libdir=lib64 \
        --enable-pdo \
        --with-pdo-sqlite \
        --with-pdo-mysql \
        --with-mysqli \
        --with-curl \
        --with-gd \
        --with-xmlrpc \
        --enable-bcmath \
        --enable-calendar \
        --enable-ftp \
        --enable-gd-native-ttf \
        --with-freetype-dir=lib64 \
        --with-jpeg-dir=lib64 \
        --with-png-dir=lib64 \
        --with-xpm-dir=lib64 \
        --enable-inline-optimization \
        --with-imap \
        --with-imap-ssl \
        --with-kerberos \
        --with-readline \
        --with-libedit \
        --with-gmp \
        --with-pspell \
        --with-enchant \
        --with-fpm-user=www \
        --with-fpm-group=www \
        --with-config-file-scan-dir="$CONFIGSCANDIR"

    cd "$SETUP_PATH"/php-"$PHP_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/php-"$PHP_VERSION"
    make install
}

php_install_extension() {
    if [ ! -d "$SETUP_PATH"/php-extension ]; then
        mkdir -p "$SETUP_PATH"/php-extension
    fi

    php_install_extension_redis
    php_install_extension_imagick
}

php_check_install() {
    systemctl restart php-fpm
    systemctl status php-fpm
    php -v
    php -m
}

install_libmcrypt() {
    if [[ -d "$SETUP_PATH"/libmcrypt-"$LIBMCRYPT_VERSION" ]]; then
        echo "libmcrypt 已经安装"
        return
    fi

    tar zxf "$BASE_PATH"/source/libmcrypt-"$LIBMCRYPT_VERSION".tar.gz -C "$SETUP_PATH"

    cd "$SETUP_PATH"/libmcrypt-"$LIBMCRYPT_VERSION"
    ./configure

    cd "$SETUP_PATH"/libmcrypt-"$LIBMCRYPT_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/libmcrypt-"$LIBMCRYPT_VERSION"
    make install

    rm -rf /usr/lib64/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib64/
}

install_imap_from_yum() {
    if [[ $(
        rpm -q uw-imap-devel >/dev/null 2>&1
        echo "imap 安装成功"
    ) != '0' ]]; then
        time yum -y install uw-imap-devel || return 1
    else
        echo "imap 已经安装"
    fi
}

php_install_extension_redis() {
    CURRENT_REDIS_EXTENSION_VERSION=$(php -r 'echo phpversion("redis");')
    if [ "$CURRENT_REDIS_EXTENSION_VERSION" == "$PHP_REDIS_VERSION" ]; then
        echo "当前 redis 无需更新" "$PHP_REDIS_VERSION"
        return
    fi

    tar zxf "$BASE_PATH"/source/php-extension/redis-"$PHP_REDIS_VERSION".tgz -C "$SETUP_PATH"/php-extension/

    cd "$SETUP_PATH"/php-extension/redis-"$PHP_REDIS_VERSION"
    make clean

    cd "$SETUP_PATH"/php-extension/redis-"$PHP_REDIS_VERSION"
    phpize

    cd "$SETUP_PATH"/php-extension/redis-"$PHP_REDIS_VERSION"
    ./configure

    cd "$SETUP_PATH"/php-extension/redis-"$PHP_REDIS_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/php-extension/redis-"$PHP_REDIS_VERSION"
    make install

    # 启用扩展
    echo extension=redis.so >$CONFIGSCANDIR/redis.ini
}

php_install_extension_imagick() {
    CURRENT_IMAGICK_EXTENSION_VERSION=$(php -r 'echo phpversion("imagick");')
    if [ "$CURRENT_IMAGICK_EXTENSION_VERSION" == "$PHP_IMAGICK_VERSION" ]; then
        echo "当前 imagick 无需更新" "$PHP_IMAGICK_VERSION"
        return
    fi

    install_imagick

    tar zxf "$BASE_PATH"/source/php-extension/imagick-"$PHP_IMAGICK_VERSION".tgz -C "$SETUP_PATH"/php-extension/

    cd "$SETUP_PATH"/php-extension/imagick-"$PHP_IMAGICK_VERSION"
    make clean

    cd "$SETUP_PATH"/php-extension/imagick-"$PHP_IMAGICK_VERSION"
    phpize

    cd "$SETUP_PATH"/php-extension/imagick-"$PHP_IMAGICK_VERSION"
    ./configure

    cd "$SETUP_PATH"/php-extension/imagick-"$PHP_IMAGICK_VERSION"
    make $MAKETHREADS

    cd "$SETUP_PATH"/php-extension/imagick-"$PHP_IMAGICK_VERSION"
    make install

    # 启用扩展
    echo extension=imagick.so >$CONFIGSCANDIR/imagick.ini
}

install_imagick() {
    if [[ -d "$SETUP_PATH"/ImageMagick-"$IMAGEMAGICK_VERSION" ]]; then
        echo "imagick 已经安装"
        return
    fi

    tar zxf "$BASE_PATH"/source/ImageMagick-"$IMAGEMAGICK_VERSION".tar.gz -C "$SETUP_PATH"

    cd "$SETUP_PATH"/ImageMagick-"$IMAGEMAGICK_VERSION"
    ./configure

    cd "$SETUP_PATH"/ImageMagick-"$IMAGEMAGICK_VERSION"
    make

    cd "$SETUP_PATH"/ImageMagick-"$IMAGEMAGICK_VERSION"
    make install
}

php_install_composer() {
    CURRENT_COMPOSER_VERSION=$(composer -V 2>&1 | awk -F ' ' '{print $3}' | head -n1)
    COMPOSER_VERSION=$(php "$BASE_PATH"/source/composer.phar -V 2>&1 | awk -F ' ' '{print $3}' | head -n1)

    if [[ "$CURRENT_COMPOSER_VERSION" == "$COMPOSER_VERSION" ]]; then
        composer -V 2>/dev/null
        return
    fi

    cp "$BASE_PATH"/source/composer.phar /usr/local/bin/composer
    chmod a+x /usr/local/bin/composer
    composer -V 2>/dev/null

    su - www <<COMMAND
    composer config -g repo.packagist composer https://packagist.phpcomposer.com 2>/dev/null
    exit
COMMAND
}
