apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ghost
spec:
  storageClassName: {{ .Values.ghost.storage.className }}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.ghost.storage.size }}
