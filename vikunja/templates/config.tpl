apiVersion: v1
kind: ConfigMap
metadata:
  name: vikunja-config
  namespace: {{ .Values.namespace }}
data:
  config.yaml: |
    service:
      frontendurl: https://{{ .Values.domain }}
      enableemailreminders: false
      enableregistration: true
    database:
      type: sqlite