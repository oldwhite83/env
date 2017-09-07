#!/usr/bin/env bash

COMPOSER_MD5=$(md5sum "$BASE_PATH"/source/composer.phar 2>&1 | awk -F ' ' '{print $1}')
LATEST_COMPOSER_MD5=$($CHECK_APP md5:composer)

[[ $LATEST_COMPOSER_MD5 =~ ^[a-zA-Z0-9]{32}$ ]] || (
    echo "获取 Composer MD5 错误"
    return 1
) \
    && if [ "$COMPOSER_MD5" == "$LATEST_COMPOSER_MD5" ]; then
        echo "当前 Composer 无需更新"
    else
        wget https://dl.laravel-china.org/composer.phar -O "$BASE_PATH"/source/composer.phar
    fi
