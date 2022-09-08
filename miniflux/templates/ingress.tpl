apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: miniflux-ingress
  namespace: miniflux
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.cert_issuer }}
spec:
  tls:
    - hosts:
        - {{ .Values.domain }}
      secretName: miniflux-tls
  rules:
    - host: {{ .Values.domain }}
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: miniflux
                port:
                  number: 80
