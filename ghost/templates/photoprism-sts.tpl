apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: photoprism
  namespace: ghost
spec:
  selector:
    matchLabels:
      app: photoprism
  serviceName: photoprism
  replicas: {{ .Values.photoprism.replicas }}
  template:
    metadata:
      labels:
        app: photoprism
    spec:
      containers:
      - name: photoprism
        image: photoprism/photoprism:latest@sha256:53c504ee6272cc8ddc6f25d49e621926df25842d87a41bd822fd0637acaa1836
        env:
        - name: PHOTOPRISM_ADMIN_USER
          valueFrom:
            secretKeyRef:
                name: photoprism-credentials
                key: username
                optional: false
        - name: PHOTOPRISM_ADMIN_PASSWORD
          valueFrom:
            secretKeyRef:
                name: photoprism-credentials
                key: password
                optional: false
        envFrom:
        - configMapRef:
            name: photoprism-config
            optional: false          
        ports:
        - containerPort: 2342
          name: http
        volumeMounts:
        - name: photoprism-storage
          subPath: originals
          mountPath: /photoprism/originals
        - name: photoprism-storage
          subPath: import
          mountPath: /photoprism/import
        - name: photoprism-storage
          subPath: storage
          mountPath: /photoprism/storage
        readinessProbe:
          httpGet:
            path: /api/v1/status
            port: http
        resources:
          requests:
            cpu: {{ .Values.photoprism.resources.requests.cpu }}
            memory: {{ .Values.photoprism.resources.requests.memory }}
          limits:
            cpu: {{ .Values.photoprism.resources.limits.cpu }}
            memory: {{ .Values.photoprism.resources.limits.memory }}
      volumes:
      - name: photoprism-storage
        persistentVolumeClaim:
          claimName: photoprism
