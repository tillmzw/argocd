kind: Service
apiVersion: v1
metadata:
  name: sus-proxy-remote 
spec:
  type: ExternalName
  externalName: https://publish.obsidian.md/serve?url={{ .Values.domain }}/schatten-ueber-stranfeste/
