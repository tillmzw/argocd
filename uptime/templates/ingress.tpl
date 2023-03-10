apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: uptime-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.uptime.ingress.cert_issuer }}
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header   Upgrade $http_upgrade;
      proxy_set_header   Connection "upgrade";
spec:
  tls:
    - hosts:
        - {{ .Values.uptime.ingress.domain }}
      secretName: uptime-tls
  rules:
    - host: {{ .Values.uptime.ingress.domain }}
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: uptime
                port:
                  number: 80
