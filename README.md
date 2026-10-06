# k8s-demo

A minimal Node.js/Express app used to demo deploying to Kubernetes — both with plain manifests and with a Helm chart.

## Project layout

```
index.js              # Express app (reads PORT, LOG_LEVEL, NODE_ENV from env)
Dockerfile             # Builds the app image
k8s/                   # Plain Kubernetes manifests
node-k8-demo/           # Helm chart (Deployment, Service, ConfigMap, Namespace)
```

## Prerequisites

- A running cluster (e.g. k3s) and `kubectl` configured against it
- `helm` v3+
- Image `k8node:<tag>` built and available to the cluster (see `image.repository`/`image.tag` in values files)

## Option 1: Plain manifests (`k8s/`)

```bash
# Apply
kubectl apply -f k8s/

# Check
kubectl get pods,svc,ingress

# Remove
kubectl delete -f k8s/
```

Access the service:
```bash
curl http://localhost:30080        # NodePort access (NodeIP:NodePort)
curl http://<cluster-ip>:80         # ClusterIP access
```

## Option 2: Helm chart (`node-k8-demo/`)

The chart creates its own `Namespace`, `Deployment`, `Service`, and `ConfigMap`, all placed into whatever namespace is set via `.Values.namespace` (**not** necessarily the namespace Helm's `-n` flag points to — see note below).

| Values file | namespace | service type | nodePort |
|---|---|---|---|
| `values.yaml` (default) | `default` | ClusterIP | – |
| `values-staging.yaml` | `staging` | NodePort | `30081` |
| `values-prod.yaml` | `production` | ClusterIP | – |

```bash
# Install (default values)
helm install node-k8-demo ./node-k8-demo/

# Install/upgrade for an environment
helm upgrade --install node-k8-demo ./node-k8-demo/ -f node-k8-demo/values-staging.yaml
helm upgrade --install node-k8-demo ./node-k8-demo/ -f node-k8-demo/values-prod.yaml

# Inspect
helm list
kubectl get all -n staging
kubectl get all -n production

# Uninstall
helm uninstall node-k8-demo
```

> **Note on namespaces:** the chart's `templates/namespace.yaml` creates the target namespace from `.Values.namespace`, and every resource is explicitly placed into it. This is independent of Helm's own release-tracking namespace (shown as `NAMESPACE:` in CLI output), which is whatever `--namespace`/`-n` flag or kubeconfig context you used when running the command — it defaults to `default` if you don't pass one. Resources still land correctly in `staging`/`production`; only `helm list`/`helm uninstall` need to be run against the same namespace you installed with (or omit `-n` entirely if you always installed without it).

### Environment variables

App config (`NODE_ENV`, `LOG_LEVEL`) is defined under `environment:` in each values file and injected into the container via a `ConfigMap` (`templates/configmap.yaml`) consumed through `envFrom`. A `checksum/config` pod annotation forces a rollout whenever the ConfigMap content changes.
