apiVersion: v1
kind: ConfigMap
metadata:
  name: vikunja-config
data:
  config.yaml: |
    service:
      frontendurl: {{ .Values.domain }}
      enableemailreminders: false
    database:
      type: sqlite