# Spin up 3 node galera cluster on Percona XtraDB Cluster
```
kubectl apply -f galera.yaml
kubectl exec galera-0 -it -- mysql -uroot -pyoushallnotpass -h mysql -e "show status like '%wsrep%';"
```
