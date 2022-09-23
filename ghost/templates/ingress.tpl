apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ghost-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.ghost.ingress.cert_issuer }}
    ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/server-alias: {{ .Values.ghost.ingress.domain }}
    nginx.ingress.kubernetes.io/proxy-buffering: "on"
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_cache ghost;
      proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
      proxy_cache_background_update on;
      proxy_cache_revalidate on;
      proxy_cache_lock on;
      add_header X-Cache-Status $upstream_cache_status;
spec:
  tls:
    - hosts:
        - {{ .Values.ghost.ingress.domain }}
      secretName: ghost-tls
  rules:
    - host: {{ .Values.ghost.ingress.domain }}
      http:
        paths:
        - pathType: Prefix
          path: "/"
          backend:
            service:
              name: ghost
              port:
                number: 80