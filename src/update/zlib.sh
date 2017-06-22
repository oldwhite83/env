#!/usr/bin/env bash

LATEST_ZLIB_VERSION=$($CHECK_APP version:zlib)

[[ $LATEST_ZLIB_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 Zlib 版本错误"
    return 1
) \
&& if [ "$ZLIB_VERSION" == "$LATEST_ZLIB_VERSION" ]; then
    echo "当前 Zlib 无需更新" "$ZLIB_VERSION"
else
    echo "更新 Zlib" "$LATEST_ZLIB_VERSION"
    find "$BASE_PATH"/source/ -name 'zlib*.tar.gz' -delete
    wget "http://zlib.net/zlib-$LATEST_ZLIB_VERSION.tar.gz" -O "$BASE_PATH/source/zlib-$LATEST_ZLIB_VERSION.tar.gz"
    sed -i "s/ZLIB_VERSION.*/ZLIB_VERSION=${LATEST_ZLIB_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
fi
