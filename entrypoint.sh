#!/bin/sh

set -e

if [ -f conf/mapping.json.template ]; then
    ip=$(cat /etc/hosts | grep $(hostname) | awk '{print $1}')
    sed "s/127\.0\.0\.1/$ip/" conf/mapping.json.template > conf/mapping.json
    python init_zk.py
fi

exec "$@"

