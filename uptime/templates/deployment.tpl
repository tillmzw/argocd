apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: uptime
spec:
  selector:
    matchLabels:
      app: uptime
  replicas: 1
  revisionHistoryLimit: 2
  template:
    metadata:
      labels:
        app: uptime
    spec:
      containers:
        - name: uptime
          image: louislam/uptime-kuma:1@sha256:a83fb715510e55f0b6f91b8f4a7c6c1f2c1d1c43ca5ad0f70139c2ca932665c4
          ports:
            - containerPort: 3001
          readinessProbe:
            httpGet:
              path: /
              port: 3001
              scheme: HTTP
          resources:
            limits:
              memory: {{ .Values.uptime.resources.limits.memory }}
              cpu: {{ .Values.uptime.resources.limits.cpu }}
            requests:
              memory: {{ .Values.uptime.resources.requests.memory }}
              cpu: {{ .Values.uptime.resources.requests.cpu }}
          volumeMounts:
          - name: uptime-data
            mountPath: /app/data
  volumeClaimTemplates:
    - apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: uptime-data
      spec:
        storageClassName: {{ .Values.uptime.storage.className | default "default" }}
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: {{ .Values.uptime.storage.size }}