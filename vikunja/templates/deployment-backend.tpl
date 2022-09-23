apiVersion: apps/v1
kind: Deployment
metadata:
  name: vikunja
  namespace: {{ .Values.namespace }}
spec:
  replicas: 1
  revisionHistoryLimit: 0
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: vikunja/api 
        ports:
        - containerPort: 3456
        env:
        volumeMounts:
        - name: vikunja-upload
          mountPath: /app/vikunja/files
        - name: vikunja-config
          mountPath: /app/vikunja/
          readOnly: true
          subPath: config.yaml
        readinessProbe:
          httpGet:
            path: /api/v1/info
            port: 3456
        resources:
          requests:
            memory: 25Mi
            cpu: 10m
          limits:
            memory: 50Mi
            cpu: 20m
      volumes:
      - name: vikunja-upload
        emptyDir: {}
      - name: vikunja-config
        configMap: 
          name: vikunja-config