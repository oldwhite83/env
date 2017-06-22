#!/usr/bin/env bash

FFMPEG_MD5=$(md5sum "$BASE_PATH"/source/ffmpeg-release-64bit-static.tar.xz | awk -F ' ' '{print $1}')
LATEST_FFMPEG_MD5=$($CHECK_APP md5:ffmpeg)

[[ $LATEST_FFMPEG_MD5 =~ ^[a-zA-Z0-9]{32}$ ]] || (
    echo "获取 FFmpeg MD5 错误"
    return 1
) \
&& if [ "$FFMPEG_MD5" == "$LATEST_FFMPEG_MD5" ]; then
    echo "当前 FFmpeg 无需更新"
else
    wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -O "$BASE_PATH"/source/ffmpeg-release-64bit-static.tar.xz
fi
