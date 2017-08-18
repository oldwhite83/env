#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
    echo "必须使用 root 用户进行安装"
    exit 1
fi

BASE_PATH=$(pwd)

# 配置
source ./env.sh
# 版本
source ./src/soft_version.sh
# 加速编译
source ./src/makeheader.sh
# 安装 NodeJS
cd "$BASE_PATH" && source ./src/nodejs.sh && test_nodejs
