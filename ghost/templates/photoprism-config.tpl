apiVersion: v1
kind: ConfigMap
metadata:
  name: photoprism-config
  namespace: {{ .Values.namespace }}
data:
  PHOTOPRISM_DEBUG: "true"
  PHOTOPRISM_HTTP_HOST: "0.0.0.0"
  PHOTOPRISM_HTTP_PORT: "2342"
  PHOTOPRISM_AUTH_MODE: password
  PHOTOPRISM_SITE_URL: {{ .Values.photoprism.ingress.domain }}
  PHOTOPRISM_SITE_CAPTION: "Wir feierten mit euch - und hier sind die Fotos!"
  PHOTOPRISM_DATABASE_DRIVER: sqlite
  PHOTOPRISM_DATABASE_DSN: /photoprism/storage/db.sqlite3