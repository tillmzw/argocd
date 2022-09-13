apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: miniflux-ingress
  namespace: miniflux
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.miniflux.ingress.cert_issuer }}
spec:
  tls:
    - hosts:
        - {{ .Values.miniflux.ingress.domain }}
      secretName: miniflux-tls
  rules:
    - host: {{ .Values.miniflux.ingress.domain }}
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: miniflux
                port:
                  number: 80
