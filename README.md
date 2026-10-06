## Start application
`kubectl apply -f .`

## Check
`kubectl get pods,svc,ingress`

## Stop/remove application
`kubectl delete -f .`

## to check on termnal
```
curl http://localhost:30080 => Node Port access (NodeIP:NodePort)

curl http://10.43.167.242:80 => Cluster IP access (Use the ClusterIP + Service port:)
```

## helm
```
[root@MA-JF46674 ~/workspace/k8s-demo]$ helm install node-k8-demo ./node-k8-demo/

[root@MA-JF46674 ~/workspace/k8s-demo]$ helm upgrade node-k8-demo ./node-k8-demo/ -f node-k8-demo/values-staging.yaml

[root@MA-JF46674 ~/workspace/k8s-demo (main)]$ helm uninstall node-k8-demo
```
#### For Production with namesapces
```
[root@MA-JF46674 ~/workspace/k8s-demo (main*)]$ helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
node-k8-demo    default         1               2026-10-06 11:40:07.938352899 +0000 UTC deployed        node-k8-demo-0.1.0      1.16.0


[root@MA-JF46674 ~/workspace/k8s-demo (main)]$ helm install node-k8-demo ./node-k8-demo/ -f node-k8-demo/values-prod.yaml
NAME: node-k8-demo
LAST DEPLOYED: Tue Oct  6 11:40:07 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None

[root@MA-JF46674 ~/workspace/k8s-demo (main*)]$ kubectl get pods -n production
NAME                                 READY   STATUS    RESTARTS   AGE
k8node-deployment-7996ccf6b7-bm2cm   1/1     Running   0          14s
k8node-deployment-7996ccf6b7-cm2bq   1/1     Running   0          14s
k8node-deployment-7996ccf6b7-v2f2w   1/1     Running   0          14s

[root@MA-JF46674 ~/workspace/k8s-demo (main*)]$ kubectl get svc -n production
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
k8node-service   ClusterIP   10.43.186.210   <none>        80/TCP    22s

[root@MA-JF46674 ~/workspace/k8s-demo (main*)]$ kubectl get namespaces
NAME              STATUS   AGE
cluster-system    Active   29h
default           Active   29h
kube-node-lease   Active   29h
kube-public       Active   29h
kube-system       Active   29h
production        Active   35s
```

#### Inspect PODS with namespace
```
[root@MA-JF46674 ~/workspace/k8s-demo (main*)]$ kubectl get pods -n staging
NAME                                READY   STATUS    RESTARTS   AGE
k8node-deployment-6b8464bfb-8ndm2   1/1     Running   0          3m35s
k8node-deployment-6b8464bfb-m5dm8   1/1     Running   0          3m35s
k8node-deployment-6b8464bfb-mwb9d   1/1     Running   0          3m35s
k8node-deployment-6b8464bfb-q5fbb   1/1     Running   0          3m35s
k8node-deployment-6b8464bfb-wzcjk   1/1     Running   0          3m35s
k8node-deployment-6b8464bfb-xr5mb   1/1     Running   0          3m35s


[root@MA-JF46674 ~/workspace/k8s-demo (main*)]$ kubectl describe pod -n staging k8node-deployment-6b8464bfb-8ndm2
Name:             k8node-deployment-6b8464bfb-8ndm2
Namespace:        staging
Priority:         0
Service Account:  default
Node:             ma-jf46674/172.23.144.49
Start Time:       Tue, 06 Oct 2026 11:46:45 +0000
Labels:           app=k8node
                  pod-template-hash=6b8464bfb
Annotations:      checksum/config: 6e36478532d4fc18207ec510b0ecddc6529d9620c2ce1e7f947a975e9a569c2e
Status:           Running
IP:               10.42.0.48
IPs:
  IP:           10.42.0.48
Controlled By:  ReplicaSet/k8node-deployment-6b8464bfb
Containers:
  k8node:
    Container ID:   containerd://fc70737e80bb9f3530c9d6cf63826fac5bc51182d3f65daccfd05754db2738b4
    Image:          k8node:v3
    Image ID:       sha256:dc9edc6ea2f3c94c922bb34029812bd3949dae783980a703fb240fc63db0c6a9
    Port:           3000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 06 Oct 2026 11:46:46 +0000
    Ready:          True
    Restart Count:  0
    Environment Variables from:
      k8node-config  ConfigMap  Optional: false
    Environment:     <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-gmsnk (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-gmsnk:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m41s  default-scheduler  Successfully assigned staging/k8node-deployment-6b8464bfb-8ndm2 to ma-jf46674
  Normal  Pulled     3m41s  kubelet            spec.containers{k8node}: Container image "k8node:v3" already present on machine and can be accessed by the pod
  Normal  Created    3m41s  kubelet            spec.containers{k8node}: Container created
  Normal  Started    3m41s  kubelet            spec.containers{k8node}: Container started
  ```
