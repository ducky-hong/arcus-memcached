#!/bin/bash

set -e

cd /arcus-memcached

if [ ! -z "$ARCUS_ZK" ]; then
    if [ -f conf/mapping.json.template ]; then
        ip=$(cat /etc/hosts | grep $(hostname) | awk '{print $1}')
        sed "s/127\.0\.0\.1/$ip/" conf/mapping.json.template > conf/mapping.json
        python init_zk.py
    fi
fi

exec /sbin/setuser memcache memcached -E /usr/local/lib/default_engine.so -z arcus-zookeeper:2181 -p 11211

