apiVersion: apps/v1
kind: Deployment
metadata:
  name: privatebin
  namespace: {{ .Values.spec.namespace }}
spec:
  replicas: 1
  revisionHistoryLimit: 0
  selector:
    matchLabels:
      app: privatebin
  template:
    metadata:
      labels:
        app: privatebin
    spec:
      #volumes:
      #- name: privatebin-data
      #  persistentVolumeClaim:
      #    claimName: privatebin-data-pvc
      containers:
      - name: privatebin
        image: privatebin/nginx-fpm-alpine 
        ports:
        - containerPort: 8080
        env:
        - name: TZ 
          value: Europe/Zurich
        - name: PHP_TZ
          value: Europe/Zurich
        readinessProbe:
          initialDelaySeconds: 10
          periodSeconds: 10
          failureThreshold: 3
          successThreshold: 1
          timeoutSeconds: 5
          httpGet:
            path: /
            port: 8080
        resources:
          limits:
            memory: "30Mi"
            cpu: "5m"

        #volumeMounts:
        #- mountPath: /srv/data
        #  name: privatebin-data
        #  readOnly: False

