apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: privatebin-ingress
  namespace: {{ .Values.spec.namespace }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.spec.cert_issuer }}
spec:
  tls:
  - hosts:
    - {{ .Values.spec.domain }}
    secretName: privatebin-tls 
  rules:
  - host: {{ .Values.spec.domain }}
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: privatebin
            port:
              number: 80

