apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pub-proxy-ingress
  namespace: {{ .Values.namespace }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.cert_issuer }}
    nginx.ingress.kubernetes.io/server-snippet: |
      location /{{ .Values.obsidian_path }} {
        proxy_pass https://publish.obsidian.md/serve?url={{ .Values.domain }}/{{ .Values.obsidian_path }};
        proxy_set_header Host publish.obsidian.md;
        proxy_ssl_server_name on;
      }
spec:
  tls:
  - hosts:
    - {{ .Values.domain }}
    secretName: pub-proxy-tls 
  rules:
  - host: {{ .Values.domain }}

