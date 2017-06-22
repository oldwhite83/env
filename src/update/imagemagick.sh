#!/usr/bin/env bash

LATEST_IMAGEMAGICK_VERSION=$($CHECK_APP version:imagemagick)

[[ $LATEST_IMAGEMAGICK_VERSION =~ ^([0-9]+\.?)+ ]] || (
    echo "获取 ImageMagick 版本错误"
    return 1
) \
&& if [ "$IMAGEMAGICK_VERSION" == "$LATEST_IMAGEMAGICK_VERSION" ]; then
    echo "当前 ImageMagick 无需更新" "$IMAGEMAGICK_VERSION"
else
    echo "更新 ImageMagick" "$LATEST_IMAGEMAGICK_VERSION"
    find "$BASE_PATH"/source/ -name 'ImageMagick*.tar.gz' -delete
    wget "ftp://ftp.kddlabs.co.jp/graphics/ImageMagick/ImageMagick-$LATEST_IMAGEMAGICK_VERSION.tar.gz" -O "$BASE_PATH/source/ImageMagick-$LATEST_IMAGEMAGICK_VERSION.tar.gz"
    sed -i "s/IMAGEMAGICK_VERSION.*/IMAGEMAGICK_VERSION=${LATEST_IMAGEMAGICK_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
fi
