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
          image: louislam/uptime-kuma:1@sha256:8c7cdd6aaabb759fff3d5b55cbc4aafb48e08693fa048b74022c3aee83dca51f
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