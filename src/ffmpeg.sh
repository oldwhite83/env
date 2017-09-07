#!/usr/bin/env bash

if [ ! -d /tmp/ffmpeg ]; then
    mkdir -p /tmp/ffmpeg
fi

tar Jxf "$BASE_PATH"/source/ffmpeg-release-64bit-static.tar.xz -C /tmp/ffmpeg --strip 1
yes | cp -f /tmp/ffmpeg/ffmpeg /usr/local/bin/ffmpeg
yes | cp -f /tmp/ffmpeg/ffprobe /usr/local/bin/ffprobe

rm -rf /tmp/ffmpeg
