#!/usr/bin/env bash

GETPIP_MD5=$(md5sum "$BASE_PATH"/source/get-pip.py 2>&1 | awk -F ' ' '{print $1}')
LATEST_GETPIP_MD5=$($CHECK_APP md5:getpip)

[[ $LATEST_GETPIP_MD5 =~ ^[a-zA-Z0-9]{32}$ ]] || (
    echo "获取 GetPip MD5 错误"
    return 1
) \
    && if [ "$GETPIP_MD5" == "$LATEST_GETPIP_MD5" ]; then
        echo "当前 GetPip 无需更新"
    else
        wget https://bootstrap.pypa.io/get-pip.py -O "$BASE_PATH"/source/get-pip.py
    fi
