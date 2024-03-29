apiVersion: apps/v1
kind: Deployment
metadata:
  name: miniflux
spec:
  selector:
    matchLabels:
      app: miniflux
  replicas: 1
  revisionHistoryLimit: 1
  template:
    metadata:
      labels:
        app: miniflux
    spec:
      containers:
        - name: miniflux
          image: miniflux/miniflux:2.0.49@sha256:8fed9d8cd79b7d5e3c008a54a5c1f48523199b9fccf634ca6bdf075bb12e182c
          ports:
            - containerPort: 8080
          env:
            - name: PORT
              value: "8080"
            - name: RUN_MIGRATIONS
              value: "1"
            - name: "CREATE_ADMIN"
              value: "1"
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-password
                  key: password
            - name: DATABASE_URL
              value: "postgres://miniflux:$(POSTGRES_PASSWORD)@postgres/miniflux?sslmode=disable"
            - name: ADMIN_USERNAME
              valueFrom:
                secretKeyRef:
                  name: miniflux-password
                  key: username
            - name: ADMIN_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: miniflux-password
                  key: password
          resources:
            limits:
              memory: {{ .Values.miniflux.resources.limits.memory }}
              cpu: {{ .Values.miniflux.resources.limits.cpu }}
            requests:
              memory: {{ .Values.miniflux.resources.requests.memory }}
              cpu: {{ .Values.miniflux.resources.requests.cpu }}