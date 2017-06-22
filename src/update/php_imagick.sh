#!/usr/bin/env bash

LATEST_PHP_IMAGICK_VERSION=$($CHECK_APP version:php_imagick)

[[ $LATEST_PHP_IMAGICK_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 PHP_IMAGICK 版本错误"
    return 1
) \
&& if [ "$PHP_IMAGICK_VERSION" == "$LATEST_PHP_IMAGICK_VERSION" ]; then
    echo "当前 PHP_IMAGICK 无需更新" "$PHP_IMAGICK_VERSION"
else
    echo "更新 PHP_IMAGICK" "$LATEST_PHP_IMAGICK_VERSION"
    find "$BASE_PATH"/source/php-extension/ -name 'imagick*.tar.gz' -delete
    wget "https://pecl.php.net/get/imagick-$LATEST_PHP_IMAGICK_VERSION.tgz" -O "$BASE_PATH/source/php-extension/imagick-$LATEST_PHP_IMAGICK_VERSION.tgz"
    sed -i "s/PHP_IMAGICK_VERSION.*/PHP_IMAGICK_VERSION=${LATEST_PHP_IMAGICK_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
fi
