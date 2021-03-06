# Vagrant up kubernetes cluster using Ubuntu 18.04 and kubeadm
This will spin up a multi-node kubernetes cluster on Ubuntu 18.04.
It uses https://github.com/cloudnativelabs/kube-router for the pod network.

## Requirements:
- vagrant + vagrant-sshfs
- libvirt or virtualbox
## On Fedora:
```
sudo dnf install vagrant vagrant-sshfs libvirt
sudo gpasswd -a $USER libvirt
```

## Alternatively, install sshfs via vagrant plugins:
```
vagrant plugin install vagrant-sshfs
vagrant up
```
A vagrant up will spin up a new cluster. Default servers.yaml contains 1 master and 4 nodes.

Add/remove nodes by adding entries to config/servers.yaml. You MUST have node in the hostname and use 10.4.2.x for it to work without modifications.

Multiple master setup is not yet supported.

CPU, memory and other provider config settings can be set by adding them to the config/servers.yaml:
```
k8s-node1:
  vm:
    ip: 10.4.2.11
  provider:
    cpus: 4
    memory: 2048
```

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
kubectl get pods -o wide --sort-by="{.spec.nodeName}"
kubectl run -it fedora --image=fedora --restart=Never -- bash
kubectl run -it busybox --image=busybox --restart=Never -- sh
kubectl delete pod fedora
kubectl delete pod busybox
```

Check status of all pods (including system)
```
kubectl get pods --all-namespaces --include-uninitialized
```

For more kubectl commands, check out the [cheat sheet!](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
