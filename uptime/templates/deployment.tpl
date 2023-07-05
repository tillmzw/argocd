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
          image: louislam/uptime-kuma:1@sha256:d841c0478e0c1d672aeada6cdfab075cad891236b34fc65abcf0efc6e9e8ebe4
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