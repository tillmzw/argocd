apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: {{ .Values.namespace }}
spec:
  replicas: 1
  revisionHistoryLimit: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: vikunja/frontend 
        ports:
        - containerPort: 80
        env:
        - name: VIKUNJA_API_URL
          value: https://{{ .Values.domain }}/api/v1
        readinessProbe:
          httpGet:
            path: /
            port: 80
        resources:
          requests:
            memory: 25Mi
            cpu: 10m
          limits:
            memory: 50Mi
            cpu: 20m