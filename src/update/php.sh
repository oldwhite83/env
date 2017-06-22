#!/usr/bin/env bash

LATEST_PHP_VERSION=$($CHECK_APP version:php)

[[ $LATEST_PHP_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 PHP 版本错误"
    return 1
) \
&& if [ "$PHP_VERSION" == "$LATEST_PHP_VERSION" ]; then
    echo "当前 PHP 无需更新" "$PHP_VERSION"
else
    echo "更新 PHP" "$LATEST_PHP_VERSION"
    find "$BASE_PATH"/source/ -name 'php*.tar.gz' -delete
    wget "http://hk1.php.net/get/php-$LATEST_PHP_VERSION.tar.gz/from/this/mirror" -O "$BASE_PATH/source/php-$LATEST_PHP_VERSION.tar.gz"
    sed -i "s/PHP_VERSION.*/PHP_VERSION=${LATEST_PHP_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
fi
