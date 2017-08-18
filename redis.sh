#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
    echo "必须使用 root 用户进行安装"
    exit 1
fi

BASE_PATH=$(pwd)

# 配置
source ./env.sh
# 系统配置
source ./src/system_setting.sh
# 升级系统
source ./src/system_update.sh
# 版本
source ./src/soft_version.sh
# 加速编译
source ./src/makeheader.sh

# 用户
id -u redis &>/dev/null || useradd -s /sbin/nologin redis
# 目录
if [[ ! -d /data/redis ]]; then
    mkdir -p /data/redis
    chown redis.redis -R /data/redis
fi

# 安装 Redis
cd "$BASE_PATH" && source ./src/redis.sh && test_redis
