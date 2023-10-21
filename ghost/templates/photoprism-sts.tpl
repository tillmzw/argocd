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
        image: photoprism/photoprism:latest@sha256:edc512d1fe3d918a45cf5ecea5b433b8600fd9574cb40975ec266e151acb8e9a
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
