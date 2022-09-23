apiVersion: v1
kind: ConfigMap
metadata:
  name: vikunja-config
  namespace: {{ .Values.namespace }}
data:
  config.yaml: |
    service:
      frontendurl: {{ .Values.domain }}
      enableemailreminders: false
    database:
      type: sqlite