apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mariadb
spec:
  selector:
    matchLabels:
      app: mariadb
  replicas: 1
  serviceName: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:11.0@sha256:63f4ae82d147dddf4e8f206c71cd58ae0c035f2a9e213206f87320e4a1832b49
        ports:
        - containerPort: 3306 
        env:
        - name: MARIADB_RANDOM_ROOT_PASSWORD
          value: "yes"
        - name: MARIADB_USER
          value: "ghost"
        - name: MARIADB_DATABASE
          value: "ghost"
        - name: MARIADB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mariadb-password
              key: password
        volumeMounts:
        - name: mariadb-data
          mountPath: /var/lib/mysql
        resources:
          requests:
            cpu: {{ .Values.database.resources.requests.cpu }}
            memory: {{ .Values.database.resources.requests.memory }}
          limits:
            cpu: {{ .Values.database.resources.limits.cpu }}
            memory: {{ .Values.database.resources.limits.memory }}
  volumeClaimTemplates:
    - apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: mariadb-data
      spec:
        storageClassName: {{ .Values.database.storage.className | default "default" }}
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: {{ .Values.database.storage.size }}