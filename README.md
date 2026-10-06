## Start application
kubectl apply -f .

## Check
kubectl get pods,svc,ingress

## Stop/remove application
kubectl delete -f .

## to check on termnal
- curl http://localhost:30080 => Node Port access (NodeIP:NodePort)
- curl http://10.43.167.242:80 => Cluster IP access (Use the ClusterIP + Service port:)

## helm
- [root@MA-JF46674 ~/workspace/k8s-demo]$ helm install node-k8-demo ./node-k8-demo/
- [root@MA-JF46674 ~/workspace/k8s-demo]$ helm upgrade node-k8-demo ./node-k8-demo/ -f node-k8-demo/values-staging.yaml
- [root@MA-JF46674 ~/workspace/k8s-demo (main)]$ helm uninstall node-k8-demo