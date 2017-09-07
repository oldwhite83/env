#!/usr/bin/env bash

CURRENT_REDIS_VERSION=$(redis-cli -v 2>&1 | awk -F ' ' '{print $2}' | head -n1)

test_redis() {
    if [ "$CURRENT_REDIS_VERSION" == "$REDIS_VERSION" ]; then
        echo "当前 Redis 无需更新" "$REDIS_VERSION"
    else
        echo "安装 Redis" "$REDIS_VERSION"
        install_redis \
            && echo "安装 Redis 成功" || (
                echo "安装 Redis 失败"
                return 1
            )
    fi
}

# redis
install_redis() {
    redis_build
    redis_configuration
    redis_check_install
}

redis_build() {
    tar zxf "$BASE_PATH/source/redis-$REDIS_VERSION.tar.gz" -C "$SETUP_PATH"

    cd "$SETUP_PATH"/redis-"$REDIS_VERSION"/src/
    make $MAKETHREADS

    cd "$SETUP_PATH"/redis-"$REDIS_VERSION"/src/
    make install
}

redis_configuration() {
    if [[ ! -d /var/run/redis ]]; then
        mkdir -p /var/run/redis
        chown redis.redis /var/run/redis
    fi

    if [[ ! -f /etc/redis.conf ]]; then
        cp "$BASE_PATH"/ini/redis/redis.conf /etc/
    fi

    if [[ ! -f /usr/lib/systemd/system/redis.service ]]; then
        cp "$BASE_PATH"/ini/redis/redis.service /usr/lib/systemd/system/redis.service
        systemctl enable redis
    fi
}

redis_check_install() {
    systemctl restart redis
    systemctl status redis
    redis-cli -v
}
