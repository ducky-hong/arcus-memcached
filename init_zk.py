#!/usr/bin/env python
# -*- coding: utf-8 -*-

from zk import ArcusZooKeeper
import json
import os

client = ArcusZooKeeper(os.getenv('ZK_HOST', 'localhost:2181'), 15000)
client.start()
client.init_structure()
with open('conf/mapping.json', 'r') as f:
    cluster = json.load(f)
    client.update_service_code(cluster)
client.stop()
