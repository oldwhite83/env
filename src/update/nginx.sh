#!/usr/bin/env bash

LATEST_NGINX_VERSION=$($CHECK_APP version:nginx)

[[ $LATEST_NGINX_VERSION =~ ^openresty-([0-9]+\.?)+$ ]] || (
    echo "获取 NGINX 版本错误"
    return 1
) \
    && if [ "$NGINX_VERSION" == "$LATEST_NGINX_VERSION" ]; then
        echo "当前 Nginx 无需更新" "$NGINX_VERSION"
    else
        echo "更新 Nginx" "$LATEST_NGINX_VERSION"
        find "$BASE_PATH"/source/ -name 'openresty*.tar.gz' -delete
        wget "https://openresty.org/download/$LATEST_NGINX_VERSION.tar.gz" -O "$BASE_PATH/source/$LATEST_NGINX_VERSION.tar.gz"
        sed -i "s/NGINX_VERSION.*/NGINX_VERSION=${LATEST_NGINX_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
    fi
