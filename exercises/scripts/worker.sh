#!/usr/bin/env bash

NODE=$1
NODE_HOST_IP="192.168.56.$((20+$NODE))"

$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
#grep -A 2 "kubeadm join" /vagrant/kubeadm-init.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g'
#grep -A 2 "kubeadm join" /vagrant/kubeadm-init.out > join.sh | chmod +x join.sh 

echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_HOST_IP --cgroup-driver=systemd" > /etc/default/kubelet
systemctl restart kubelet

cp /vagrant/admin.conf /etc/kubernetes/admin.conf
chmod ugo+r /etc/kubernetes/admin.conf
echo "KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/environment