#!/usr/bin/env bash

# 升级
# yum clean all
# time yum -y update
time yum -y install epel-release

# 安装编译需要的工具
time yum -y group install "Development Tools"
time yum -y install vim wget bc coreutils net-tools bind-utils

# 关闭防火墙
systemctl disable firewalld
systemctl stop firewalld

# 创建软件存放文件夹
if [ ! -d "$SETUP_PATH" ]; then
    mkdir -p "$SETUP_PATH"
    chmod 0755 "$SETUP_PATH"
fi
