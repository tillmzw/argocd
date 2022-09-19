apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: privatebin-ingress
  namespace: {{ .Values.namespace }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.cert_issuer }}
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
spec:
  tls:
  - hosts:
    - {{ .Values.domain }}
    secretName: privatebin-tls 
  rules:
  - host: {{ .Values.domain }}
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: privatebin
            port:
              number: 80

