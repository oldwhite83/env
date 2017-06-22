#!/usr/bin/env bash

LATEST_NODEJS_VERSION=$($CHECK_APP version:nodejs)

[[ $LATEST_NODEJS_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 NODEJS 版本错误"
    return 1
) \
&& (
    LATEST_NODEJS_VERSION="v$LATEST_NODEJS_VERSION"
    if [ "$NODEJS_VERSION" == "$LATEST_NODEJS_VERSION" ]; then
        echo "当前 Nodejs 无需更新" "$NODEJS_VERSION"
    else
        echo "更新 Nodejs" "$LATEST_NODEJS_VERSION"
        find "$BASE_PATH"/source/ -name 'node*.tar.gz' -delete
        wget "https://npm.taobao.org/mirrors/node/$LATEST_NODEJS_VERSION/node-$LATEST_NODEJS_VERSION-linux-x64.tar.xz" -O "$BASE_PATH/source/node-$LATEST_NODEJS_VERSION-linux-x64.tar.xz"
        sed -i "s/NODEJS_VERSION.*/NODEJS_VERSION=${LATEST_NODEJS_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
    fi
)
