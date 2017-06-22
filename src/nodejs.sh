#!/usr/bin/env bash

CURRENT_NODEJS_VERSION=$(node -v | head -n1)

test_nodejs() {
    if [ "$CURRENT_NODEJS_VERSION" == "$NODEJS_VERSION" ]; then
        echo "当前 NodeJS 无需更新" "$NODEJS_VERSION"
    else
        echo "安装 NodeJS" "$NODEJS_VERSION"
        install_nodejs \
            && echo "安装 NodeJS 成功" || (
                echo "安装 NodeJS 失败"
                return 1
            )
    fi
}

# nodejs
install_nodejs() {
    nodejs_untar
    npm_update
}

nodejs_untar() {
    tar -xJf "$BASE_PATH/source/node-$NODEJS_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1
}

npm_update() {
    npm -g config set registry https://registry.npm.taobao.org

    npm -g install npm
    npm -g install node-gyp pm2
}
