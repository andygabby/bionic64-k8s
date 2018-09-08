#!/bin/bash

# TODO: Support dynamic ip ranges so 10.4 doesnt need to be hard coded.
LEAD_OCTETS=10.4
SERVER_IP=$(ip -f inet -o addr show | grep ${LEAD_OCTETS} | awk '{split($4,a,"/");print a[1]}')
apt-get install -y apt-transport-https

# We are using 18.04 (bionic) but there is not currently a repo for it. Use xenial for now.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update

# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
# Install docker if you don't have it already.
apt-get install -y docker.io
# Install k8s packages
apt-get install -y kubelet kubeadm kubectl kubernetes-cni
echo "KUBELET_EXTRA_ARGS=--node-ip=${SERVER_IP}" > /etc/default/kubelet
systemctl enable docker
systemctl start docker

hostnameMatches() {
  hostname | grep $1 > /dev/null
  return $?
}

# TODO: Make work with multiple masters.
if hostnameMatches master1; then
  # TODO: dynamically pull k8s-master1 address instead of hard coded.
  kubeadm init --apiserver-advertise-address=10.4.2.10 --pod-network-cidr=10.244.0.0/16
  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config
  # Install kube-router networking.
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
  # If you add nodes later you will need to get a new kubeadm token. Just run the following command on k8s-master1 before the vagrant up of a new node.
  kubeadm token create --print-join-command > /vagrant/config/kube-join.sh
fi

if hostnameMatches node; then
  sh /vagrant/config/kube-join.sh
fi
