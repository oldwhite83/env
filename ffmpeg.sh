#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
    echo "必须使用 root 用户进行安装"
    exit 1
fi

BASE_PATH=$(pwd)

source ./src/ffmpeg.sh
