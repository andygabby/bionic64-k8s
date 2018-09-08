# Vagrant up kubernetes cluster using ubuntu/bionic64 and kubeadm
This will spin up a multi-node kubernetes cluster on ubuntu 18.04.
It uses https://github.com/cloudnativelabs/kube-router for the pod network.

## Requirements:
- vagrant
- virtualbox
( Tested to work with fedora 28 as base OS )

## Usage:
```
vagrant up
```
A vagrant up with spin up a new cluster. Default behavior is 1 master and 4 nodes.

Multiple master setup has not been tested.

Add/remove nodes by adding entries to config/servers.yaml. You MUST have node in the hostname and use 10.4.2.x for it to work without modifications.

CPU and memory can be modified by adding them to the server.yaml:
```
k8s-node1:
  ip: 10.4.2.11
  cpu: 4
  mem: 2048
``` 
(Future update will add extra disk support)

### Once your cluster is running you can login to k8s-master and run kubectl as root:
```
vagrant ssh k8s-master1
sudo -i
kubectl get nodes -o wide
```

### You can also copy the config to your base OS and connect from there.
Install kubectl on base OS: https://kubernetes.io/docs/tasks/tools/install-kubectl/
```
mkdir -p $HOME/.kube
vagrant ssh k8s-master1 -- 'sudo cat /etc/kubernetes/admin.conf' > $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes -o wide
```

### Useful kubernetes commands.
Spin up single use fedora or busybox container for troubleshooting and testing.
```
kubectl run -it fedora --image=fedora --restart=Never -- bash
kubectl run -it busybox --image=busybox --restart=Never -- sh
kubectl delete pod fedora
kubectl delete pod busybox
``` 
Check status of all pods (including system)
```
kubectl get pods --all-namespaces
```

