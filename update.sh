#!/usr/bin/env bash

BASE_PATH=$(pwd)
CHECK_APP="$BASE_PATH/src/update/check/app"

source ./src/soft_version.sh

echo "===Nginx==="
source ./src/update/pcre.sh
source ./src/update/zlib.sh
source ./src/update/libatomic.sh
source ./src/update/openssl.sh
source ./src/update/nginx.sh
echo ""

echo "===PHP==="
source ./src/update/libmcrypt.sh
source ./src/update/php.sh
source ./src/update/imagemagick.sh
source ./src/update/php_imagick.sh
source ./src/update/php_redis.sh
source ./src/update/composer.sh
echo ""

echo "===Redis==="
source ./src/update/redis.sh
echo ""

echo "===Nodejs==="
source ./src/update/nodejs.sh
echo ""

echo "===Python==="
source ./src/update/pip.sh
echo ""

echo "===FFmpeg==="
source ./src/update/ffmpeg.sh
echo ""