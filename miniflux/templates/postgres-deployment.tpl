apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  selector:
    matchLabels:
      app: postgres
  replicas: 1
  revisionHistoryLimit: 1
  serviceName: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:14@sha256:a4d999730f6d9f07e8c9f1f011bcd98450d9b878d1357b48978a08078e0e3a78
          imagePullPolicy: Always
          ports:
            - containerPort: 5432
          env:
            - name: PGDATA
              value: /var/lib/postgresql/data/pgdata
            - name: POSTGRES_DB
              value: miniflux
            - name: POSTGRES_USER
              value: miniflux
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-password
                  key: password
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: postgres-data
          resources:
            limits:
              memory: {{ .Values.database.resources.limits.memory }}
              cpu: {{ .Values.database.resources.limits.cpu }}
            requests:
              memory: {{ .Values.database.resources.requests.memory }}
              cpu: {{ .Values.database.resources.requests.cpu }}
  volumeClaimTemplates:
    - apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: postgres-data
      spec:
        storageClassName: {{ .Values.database.storage.className | default "default" }}
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: {{ .Values.database.storage.size }}