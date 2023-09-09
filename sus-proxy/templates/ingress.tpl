apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sus-proxy-ingress
  namespace: {{ .Values.namespace }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.cert_issuer }}
    nginx.ingress.kubernetes.io/server-snippet: |
      location / {
        return 301 /schatten-ueber-stranfeste;
      }
      location /schatten-ueber-stranfeste {
        proxy_pass https://publish.obsidian.md/serve?url={{ .Values.domain }}/schatten-ueber-stranfeste;
        proxy_set_header Host publish.obsidian.md;
        proxy_ssl_server_name on;
      }
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

