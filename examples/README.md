# Spin up 3 node galera cluster on Percona XtraDB Cluster
```
kubectl apply -f galera.yaml
kubectl exec galera-0 -it -- mysql -uroot -pyoushallnotpass -h mysql -e "show status like '%wsrep%';"
```
# Spin up an nginx deployment
```
vagrant ssh k8s-master1
sudo -i
kubectl get nodes -o wide
kubectl create -f config/nginx/nginx-deployment.yaml
kubectl get pods -l app=nginx
kubectl describe service nginx-svc
```
### To test that the default.conf is running as expected run the following commands on k8s-master1 ###
nodePort = $(kubectl describe service nginx-svc | awk '/^NodePort:/ { print substr($3,0,5) }')
curl -k -H'Host: www.example.com' http://10.4.2.11:$nodePort
curl -k http://10.4.2.11:$nodePort
```

