apiVersion: v1
kind: ConfigMap
metadata:
  name: vikunja-config
  namespace: {{ .Values.namespace }}
data:
  config.yaml: |
    service:
      frontendurl: https://{{ .Values.domain }}
      enableemailreminders: true
      enableregistration: true
    database:
      type: sqlite
      path: ./db/vikunja.db
    mailer:
      enabled: true
      host: smtp.eu.mailgun.org
      port: 587
      authtype: login