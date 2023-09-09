apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sus-proxy-ingress
  namespace: {{ .Values.namespace }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.cert_issuer }}
    nginx.ingress.kubernetes.io/proxy-pass: https://publish.obsidian.md/serve?url={{ .Values.domain }}/schatten-ueber-stranfeste 
    nginx.ingress.kubernetes.io/proxy-ssl-server-name: on
    nginx.ingress.kubernetes.io/proxy-set-header: Host publish.obsidian.md
spec:
  tls:
  - hosts:
    - {{ .Values.domain }}
    secretName: sus-proxy-tls 
  rules:
  - host: {{ .Values.domain }}
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: sus-proxy-remote
            port:
              number: 443

