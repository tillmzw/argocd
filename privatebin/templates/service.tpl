apiVersion: v1
kind: Service
metadata:
  name: privatebin
  namespace: {{ .Values.namespace }}
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: privatebin
