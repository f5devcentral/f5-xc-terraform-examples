resource "kubectl_manifest" "verlb-service" {
    yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: lb-ver
  namespace: ves-system
spec:
  type: LoadBalancer
  ports:
  - port: 80
    name: http
  selector:
    app: ver
YAML
}