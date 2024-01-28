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
        image: vikunja/api:0.22.1@sha256:c9415431e6235229302bb8f9ee6660b74c24859d1e8adbc4a3e25bd418604b57
        ports:
        - containerPort: 3456
        env:
        - name: VIKUNJA_MAILER_FROMEMAIL
          valueFrom:
            secretKeyRef:
              name: vikunja-smtp-password
              key: username
        - name: VIKUNJA_MAILER_USERNAME
          valueFrom:
            secretKeyRef:
              name: vikunja-smtp-password
              key: username
        - name: VIKUNJA_MAILER_PASSWORD
          valueFrom:
            secretKeyRef:
              name: vikunja-smtp-password
              key: password
        - name: VIKUNJA_SERVICE_JWTSECRET
          valueFrom:
            secretKeyRef:
              name: vikunja-jwt-secret
              key: jwt-secret
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
            memory: {{ .Values.backend.resources.requests.memory }}
            cpu: {{ .Values.backend.resources.requests.cpu }}
          limits:
            memory: {{ .Values.backend.resources.limits.memory }}
            cpu: {{ .Values.backend.resources.limits.cpu }}
      volumes:
      - name: vikunja-storage
        persistentVolumeClaim:
          claimName: vikunja-storage
      - name: vikunja-config
        configMap: 
          name: vikunja-config