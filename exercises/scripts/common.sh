#!/usr/bin/env bash

if [ -z ${K8S_VERSION+x} ]; then
  K8S_VERSION=1.23.4-00
fi

sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get install -y vim net-tools docker-ce avahi-daemon libnss-mdns traceroute htop httpie bash-completion kubeadm=$K8S_VERSION kubelet=$K8S_VERSION kubectl=$K8S_VERSION > /dev/null 2>&1

sudo usermod -aG docker ${USER}

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

sudo systemctl daemon-reload
sudo systemctl restart docker

# Set alias for kubectl command
echo "alias k=kubectl" >> /home/vagrant/.bashrc
