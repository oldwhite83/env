#!/usr/bin/env bash

LATEST_LIBATOMIC_VERSION=$($CHECK_APP version:libatomic)

[[ $LATEST_LIBATOMIC_VERSION =~ ^([0-9]+\.?)+$ ]] || (
    echo "获取 libatomic_ops 版本错误"
    return 1
) \
&& if [ "$LIBATOMIC_VERSION" == "$LATEST_LIBATOMIC_VERSION" ]; then
    echo "当前 libatomic_ops 无需更新" "$LIBATOMIC_VERSION"
else
    echo "更新 libatomic_ops" "$LATEST_LIBATOMIC_VERSION"
    find "$BASE_PATH"/source/ -name 'libatomic_ops*.tar.gz' -delete
    wget "http://www.hboehm.info/gc/gc_source/libatomic_ops-$LATEST_LIBATOMIC_VERSION.tar.gz" -O "$BASE_PATH/source/libatomic_ops-$LATEST_LIBATOMIC_VERSION.tar.gz"
    sed -i "s/LIBATOMIC_VERSION.*/LIBATOMIC_VERSION=${LATEST_LIBATOMIC_VERSION}/g" "$BASE_PATH"/src/soft_version.sh
fi
