#!/usr/bin/env bash

LATEST_REDIS_VERSION=$($CHECK_APP version:redis)

[[ $LATEST_REDIS_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 REDIS 版本错误"
    return 1
) \
    && if [ "$REDIS_VERSION" == "$LATEST_REDIS_VERSION" ]; then
        echo "当前 REDIS 无需更新" "$REDIS_VERSION"
    else
        echo "更新 REDIS" "$LATEST_REDIS_VERSION"
        find "$BASE_PATH"/source/ -name 'redis*.tar.gz' -delete
        wget "http://download.redis.io/releases/redis-$LATEST_REDIS_VERSION.tar.gz" -O "$BASE_PATH/source/redis-$LATEST_REDIS_VERSION.tar.gz"
        sed -i "s/^REDIS_VERSION.*/REDIS_VERSION=${LATEST_REDIS_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
    fi
