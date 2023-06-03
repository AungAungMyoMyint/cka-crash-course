#!/usr/bin/env bash

# Install etcdctl
ETCD_VERSION="v3.5.1"

wget https://github.com/etcd-io/etcd/releases/download/$ETCD_VERSION/etcd-$ETCD_VERSION-linux-arm64.tar.gz -O /tmp/etcd-$ETCD_VERSION-linux-arm64.tar.gz
tar xvf /tmp/etcd-$ETCD_VERSION-linux-arm64.tar.gz -C /tmp
sudo mv /tmp/etcd-$ETCD_VERSION-linux-arm64/etcd /tmp/etcd-$ETCD_VERSION-linux-arm64/etcdctl /usr/local/bin