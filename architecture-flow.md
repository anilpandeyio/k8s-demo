# Kubernetes Application Architecture and Traffic Flow

This diagram reflects the plain manifests in `k8s/`: namespace `anil`, a NodePort Service on `30080`, and four Node.js/Express pod replicas listening on port `3000`.

```mermaid
flowchart LR
    User["External user / browser / curl"] -->|HTTP to node port 30080| NodePort["Minikube node or reachable Kubernetes node"]

    InternalClient["Client inside the cluster"] -->|Service DNS or ClusterIP on port 80| Service

    subgraph Cluster["Kubernetes cluster"]
        subgraph Namespace["Namespace: anil"]
            NodePort --> Service["Service: k8node-service<br/>NodePort 30080<br/>Service port 80 to targetPort 3000"]
            Service -->|selects app=k8node; routes to a ready endpoint| PodChoice{"Service endpoint selection"}
            PodChoice --> Pod1["Express pod 1<br/>container port 3000"]
            PodChoice --> Pod2["Express pod 2<br/>container port 3000"]
            PodChoice --> Pod3["Express pod 3<br/>container port 3000"]
            PodChoice --> Pod4["Express pod 4<br/>container port 3000"]

            Pod1 -. "HTTP response" .-> Service
            Pod2 -. "HTTP response" .-> Service
            Pod3 -. "HTTP response" .-> Service
            Pod4 -. "HTTP response" .-> Service

            Deployment["Deployment: k8node-deployment<br/>desired replicas: 4"] -->|creates and maintains| Pod1
            Deployment --> Pod2
            Deployment --> Pod3
            Deployment --> Pod4
        end
    end

    Service -->|response| NodePort
    NodePort -->|response| User

    Developer["Developer"] -->|kubectl apply -f k8s/ or Helm install/upgrade| API["Kubernetes API server"]
    API --> Deployment
    API --> Service
    Registry["Container registry<br/>anilpandeyio/k8node:v4"] -->|image pulled by the node| Pod1
    Registry --> Pod2
    Registry --> Pod3
    Registry --> Pod4
    ConfigMap["Helm ConfigMap<br/>environment variables"] -->|envFrom| Pod1
    ConfigMap --> Pod2
    ConfigMap --> Pod3
    ConfigMap --> Pod4
```

## External access on macOS with Minikube

With the Minikube Docker driver on macOS, the node's private IP may not be directly reachable from the Mac. Use Minikube's service helper to obtain a host-accessible URL:

```bash
minikube service k8node-service -n anil --url
```

Keep the helper running if it maintains a tunnel, and send HTTP requests to the URL it prints. `kubectl port-forward` is another local access method, but it forwards to one selected pod and does not demonstrate Service load balancing.

## In-cluster access

A client pod can call the Service through its DNS name or ClusterIP on port `80`:

```text
http://k8node-service.anil.svc.cluster.local/
```

The Service selects pods labeled `app: k8node` and forwards to their container port `3000`. It can route connections to any ready endpoint; this does not guarantee a different pod for each request.

## Scope

This project currently has an external/client path, Kubernetes Service networking, and an application tier. It does **not** define a separate database or persistence tier, so this is not a conventional three-tier application with presentation, business-logic, and data tiers. The ConfigMap shown above applies to the Helm chart; the plain Deployment manifest sets its environment variables directly.
