#!/usr/bin/env bash

POD_CIDR=$1
API_ADV_ADDRESS=$2

sudo kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $API_ADV_ADDRESS | tee /vagrant/kubeadm-init.out

echo "KUBELET_EXTRA_ARGS=--node-ip=$API_ADV_ADDRESS --cgroup-driver=systemd" > /etc/default/kubelet
sudo systemctl restart kubelet

sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml
sudo sed -i 's~cidr: 192\.168\.0\.0/16~cidr: 172\.18\.0\.0/16~g' custom-resources.yaml
sudo kubectl create -f custom-resources.yaml
sudo rm custom-resources.yaml

sudo cp /etc/kubernetes/admin.conf /vagrant/admin.conf