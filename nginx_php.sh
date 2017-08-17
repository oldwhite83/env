#!/usr/bin/env bash

SETUP_PATH='/svr-setup'
ZONEINFO=Asia/Shanghai

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
id -u www &>/dev/null || useradd www
# 目录
if [[ ! -d /data/wwwroot ]]; then
    mkdir -p /data/wwwroot
    chown www.www -R /data/wwwroot
fi

# 安装 Nginx
cd "$BASE_PATH" && source ./src/nginx.sh && test_nginx
# 安装 PHP
cd "$BASE_PATH" && source ./src/php.sh && test_php
