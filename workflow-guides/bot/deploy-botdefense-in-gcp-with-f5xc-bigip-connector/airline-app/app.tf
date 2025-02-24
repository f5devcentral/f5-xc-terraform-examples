resource "kubectl_manifest" "ns" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: gcp-xcbotdefense-namespace1
YAML
}

resource "kubectl_manifest" "app-deployment" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
kind: Deployment
apiVersion: apps/v1
metadata:
  name: airline-flask
  namespace: gcp-xcbotdefense-namespace1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: airline-flask
  template:
    metadata:
      labels:
        app: airline-flask
    spec:
      containers:
        - name: airline-flask
          image: ghcr.io/b3nnnn/airline-flask:latest
          ports:
            - containerPort: 9000
              protocol: TCP
          env:
            - name: NODENAME
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: spec.nodeName
            - name: HOST_IP
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: status.hostIP
      nodeSelector:
        kubernetes.io/os: linux
YAML
}

resource "kubectl_manifest" "app-service" {
    depends_on = [kubectl_manifest.app-service]
    yaml_body = <<YAML
kind: Service
apiVersion: v1
metadata:
  name: airline-flask
  namespace: gcp-xcbotdefense-namespace1
  annotations:
    networking.gke.io/load-balancer-type: "Internal"
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9000
  selector:
    app: airline-flask
  type: LoadBalancer
  loadBalancerIP: "${local.lb_ip}"
  sessionAffinity: None
YAML
}
