#!/usr/bin/env bash

SETUP_PATH='/svr-setup'
ZONEINFO=Asia/Shanghai

if [ "$(id -u)" != "0" ]; then
    echo "必须使用 root 用户进行安装"
    exit 1
fi

BASE_PATH=$(pwd)
# 版本
source ./src/soft_version.sh
# 加速编译
source ./src/makeheader.sh
# 用户
id -u redis &>/dev/null || useradd redis
# 安装 Redis
cd "$BASE_PATH" && source ./src/redis.sh && test_redis
