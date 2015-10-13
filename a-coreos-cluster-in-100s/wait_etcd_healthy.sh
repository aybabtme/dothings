#!/usr/bin/env bash

try=0
until [ $try -ge 300 ]; do
    etcdctl cluster-health && exit 0
    try=$[$try+1]
    sleep 0.1
done
echo "etcd never became healthy"
exit 1
