#!/usr/bin/env bash

LATEST_OPENSSL_VERSION=$($CHECK_APP version:openssl)

[[ $LATEST_OPENSSL_VERSION =~ ^([0-9]+\.?)+[a-z]+$ ]] || (
    echo "获取 OPENSSL 版本错误"
    return 1
) \
    && if [ "$OPENSSL_VERSION" == "$LATEST_OPENSSL_VERSION" ]; then
        echo "当前 OPENSSL 无需更新" "$OPENSSL_VERSION"
    else
        echo "更新 OPENSSL" "$LATEST_OPENSSL_VERSION"
        find "$BASE_PATH"/source/ -name 'openssl*.tar.gz' -delete
        wget "https://www.openssl.org/source/openssl-$LATEST_OPENSSL_VERSION.tar.gz" -O "$BASE_PATH/source/openssl-$LATEST_OPENSSL_VERSION.tar.gz"
        sed -i "s/OPENSSL_VERSION.*/OPENSSL_VERSION=${LATEST_OPENSSL_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
    fi
