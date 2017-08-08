#!/usr/bin/env bash

python "$BASE_PATH"/source/get-pip.py

pip install supervisor

if [[ ! -f /etc/supervisord.conf ]]; then
    cp "$BASE_PATH"/ini/supervisor/supervisord.conf /etc/supervisord.conf
fi

if [ ! -d /etc/supervisord.d ]; then
    mkdir -p /etc/supervisord.d
fi

if [[ ! -f /usr/lib/systemd/system/supervisor.service ]]; then
    cp "$BASE_PATH"/ini/supervisor/supervisor.service /usr/lib/systemd/system/supervisor.service
    systemctl enable supervisor
fi

systemctl restart supervisor