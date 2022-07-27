# Getting Started

- create the argocd namespace: `kubectl create ns argocd`
- install argocd with helm: 
```bash
cd argocd
helm dependency build
helm install --namespace argocd --values values.yaml argocd .
```
- get the login password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
``` 