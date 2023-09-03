apiVersion: apps/v1
kind: Deployment
metadata:
  name: ghost
spec:
  replicas: {{ .Values.ghost.replicas }}
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: ghost
  template:
    metadata:
      labels:
        app: ghost
    spec:
      containers:
        - name: ghost
          image: ghost:5.60.0-alpine@sha256:ebb93fda2fe9e8400823aba25754e08d0be3abbcd17d3dbd03f3063b4bde222f
          ports:
            - containerPort: 2368
          env:
            - name: url
              value: "{{ .Values.ghost.ingress.proto }}://{{ .Values.ghost.ingress.domain }}"
            - name: database__client
              value: "mysql"
            - name: database__connection__host
              value: "mariadb"
            - name: database__connection__user
              value: "ghost"
            - name: database__connection__password
              valueFrom:
                secretKeyRef:
                  name: mariadb-password
                  key: password
            - name: database__connection__database
              value: "ghost"
            - name: mail__transport
              value: "SMTP"
            - name: mail__options__service
              value: "Mailgun"
            - name: mail__options__secure
              value: "false"
            - name: mail__options__host
              value: "smtp.eu.mailgun.org"
            - name: mail__options__port
              value: "587" 
            - name: mail__options__auth__user
              valueFrom:
                  secretKeyRef:
                    name: smtp-credentials
                    key: username
            - name: mail__options__auth__pass
              valueFrom:
                  secretKeyRef:
                    name: smtp-credentials
                    key: password
            - name: mail__from
              valueFrom:
                secretKeyRef:
                      name: smtp-credentials
                      key: mailfrom
          volumeMounts:
          - name: ghost-data
            mountPath: /var/lib/ghost/content
          readinessProbe:
            initialDelaySeconds: 30
            periodSeconds: 10
            timeoutSeconds: 3
            tcpSocket:
              port: 2368
          resources:
            requests:
              cpu: {{ .Values.ghost.resources.requests.cpu }}
              memory: {{ .Values.ghost.resources.requests.memory }}
            limits:
              cpu: {{ .Values.ghost.resources.limits.cpu }}
              memory: {{ .Values.ghost.resources.limits.memory }}
      volumes:
      - name: ghost-data
        persistentVolumeClaim:
          claimName: ghost
