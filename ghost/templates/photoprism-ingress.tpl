apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: photoprism-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: {{ .Values.photoprism.ingress.cert_issuer }}
    ingress.kubernetes.io/proxy-body-size: "100m"
    nginx.ingress.kubernetes.io/server-alias: {{ .Values.photoprism.ingress.domain }}
    nginx.ingress.kubernetes.io/proxy-buffering: "on"
spec:
  tls:
    - hosts:
        - {{ .Values.photoprism.ingress.domain }}
      secretName: photoprism-tls
  rules:
    - host: {{ .Values.photoprism.ingress.domain }}
      http:
        paths:
        - pathType: Prefix
          path: "/"
          backend:
            service:
              name: photoprism
              port:
                number: 80
