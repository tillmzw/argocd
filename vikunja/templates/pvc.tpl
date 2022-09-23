apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: vikunja-storage
  namespace: {{ .Values.namespace }}
spec:
  storageClassName: {{ .Values.backend.storage.className }}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.backend.storage.size }}
