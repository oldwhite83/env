#!/usr/bin/env bash

LATEST_PHP_REDIS_VERSION=$($CHECK_APP version:php_redis)

[[ $LATEST_PHP_REDIS_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 PHP_REDIS 版本错误"
    return 1
) \
    && if [ "$PHP_REDIS_VERSION" == "$LATEST_PHP_REDIS_VERSION" ]; then
        echo "当前 PHP_REDIS 无需更新" "$PHP_REDIS_VERSION"
    else
        echo "更新 PHP_REDIS" "$LATEST_PHP_REDIS_VERSION"
        find "$BASE_PATH"/source/php-extension/ -name 'redis*.tar.gz' -delete
        mkdir -p "$BASE_PATH/source/php-extension"
        wget "https://pecl.php.net/get/redis-$LATEST_PHP_REDIS_VERSION.tgz" -O "$BASE_PATH/source/php-extension/redis-$LATEST_PHP_REDIS_VERSION.tgz"
        sed -i "s/PHP_REDIS_VERSION.*/PHP_REDIS_VERSION=${LATEST_PHP_REDIS_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
    fi
