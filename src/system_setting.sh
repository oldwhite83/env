#!/usr/bin/env bash

# 设置时区
rm -f /etc/localtime
ln -s "/usr/share/zoneinfo/$ZONEINFO" /etc/localtime
