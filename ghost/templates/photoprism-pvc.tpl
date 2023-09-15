apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: photoprism
spec:
  storageClassName: {{ .Values.photoprism.storage.className }}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.photoprism.storage.size }}
