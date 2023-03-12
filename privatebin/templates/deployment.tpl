apiVersion: apps/v1
kind: Deployment
metadata:
  name: privatebin
  namespace: {{ .Values.namespace }}
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
      containers:
      - name: privatebin
        image: privatebin/fs:stable@sha256:515e588236a62bdc1f2fdc3b88389de13db9c1e021d9c78627707db8beff4479
        ports:
        - containerPort: 8080
        env:
        - name: TZ 
          value: Europe/Zurich
        - name: PHP_TZ
          value: Europe/Zurich
        volumeMounts:
          - name: privatebin-data
            mountPath: /srv/data 
          - name: privatebin-config
            mountPath: /srv/cfg
            readOnly: true
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
            memory: "50Mi"
            cpu: "20m"

      volumes:
        - name: privatebin-data
          emptyDir: {}
        - name: privatebin-config
          configMap: 
            name: privatebin-config