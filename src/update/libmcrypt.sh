#!/usr/bin/env bash

# 不再更新了
LATEST_LIBMCRYPT_VERSION=2.5.8

if [ "$LIBMCRYPT_VERSION" == "$LATEST_LIBMCRYPT_VERSION" ]; then
    echo "当前 LIBMCRYPT 无需更新" "$LIBMCRYPT_VERSION"
else
    echo "更新 LIBMCRYPT" "$LATEST_LIBMCRYPT_VERSION"
    find "$BASE_PATH"/source/ -name 'libmcrypt*.tar.gz' -delete
    wget "https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/$LATEST_LIBMCRYPT_VERSION/libmcrypt-$LATEST_LIBMCRYPT_VERSION.tar.gz" -O "$BASE_PATH/source/libmcrypt-$LATEST_LIBMCRYPT_VERSION.tar.gz"
    sed -i "s/LIBMCRYPT_VERSION.*/LIBMCRYPT_VERSION=${LATEST_LIBMCRYPT_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
fi
