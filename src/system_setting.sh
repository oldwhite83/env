#!/usr/bin/env bash

# 添加运行用户
id -u www &>/dev/null || useradd www

# 设置时区
rm -f /etc/localtime
ln -s "/usr/share/zoneinfo/$ZONEINFO" /etc/localtime
