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
        image: vikunja/frontend:0.21.0@sha256:fdd4582979beee4a6bef2d4d8e3744809b82ab2e198d708a829d7189a0ad9882
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
            memory: {{ .Values.frontend.resources.requests.memory }}
            cpu: {{ .Values.frontend.resources.requests.cpu }}
          limits:
            memory: {{ .Values.frontend.resources.limits.memory }}
            cpu: {{ .Values.frontend.resources.limits.cpu }}