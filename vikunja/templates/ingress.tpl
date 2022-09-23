apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vikunja-ingress
  namespace: {{ .Values.namespace }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.cert_issuer }}
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
spec:
  tls:
  - hosts:
    - {{ .Values.domain }}
    secretName: vikunja-tls 
  rules:
  - host: {{ .Values.domain }}
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: frontend
            port:
              number: 80
      - pathType: Prefix
        path: "/api"
        backend:
          service:
            name: backend
            port:
              number: 3456
