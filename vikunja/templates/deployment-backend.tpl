apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: {{ .Values.namespace }}
spec:
  replicas: 1
  revisionHistoryLimit: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      securityContext:
        fsGroup: 1000
      containers:
      - name: backend
        image: vikunja/api 
        ports:
        - containerPort: 3456
        env:
        volumeMounts:
        - name: vikunja-storage
          mountPath: /app/vikunja/files
          subPath: files
        - name: vikunja-storage
          mountPath: /app/vikunja/db
          subPath: db
        - name: vikunja-config
          mountPath: /app/vikunja/config.yaml
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
      - name: vikunja-storage
        persistentVolumeClaim:
          claimName: vikunja-storage
      - name: vikunja-config
        configMap: 
          name: vikunja-config