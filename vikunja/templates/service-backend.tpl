apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: {{ .Values.namespace }}
spec:
  type: ClusterIP
  ports:
  - port: 3456
    targetPort: 3456
  selector:
    app: backend
