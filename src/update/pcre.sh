#!/usr/bin/env bash

LATEST_PCRE_VERSION=$($CHECK_APP version:pcre)

[[ $LATEST_PCRE_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 pcre 版本错误"
    return 1
) \
    && if [ "$PCRE_VERSION" == "$LATEST_PCRE_VERSION" ]; then
        echo "当前 pcre 无需更新" "$PCRE_VERSION"
    else
        echo "更新 pcre" "$LATEST_PCRE_VERSION"
        find "$BASE_PATH"/source/ -name 'pcre*.tar.gz' -delete
        wget "https://ftp.pcre.org/pub/pcre/pcre-$LATEST_PCRE_VERSION.tar.gz" -O "$BASE_PATH/source/pcre-$LATEST_PCRE_VERSION.tar.gz"
        sed -i "s/PCRE_VERSION.*/PCRE_VERSION=${LATEST_PCRE_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
    fi
