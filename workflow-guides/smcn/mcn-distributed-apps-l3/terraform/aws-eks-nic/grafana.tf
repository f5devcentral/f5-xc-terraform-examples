resource "helm_release" "grafana" {
    name = format("%s-gfa", local.name)
    repository = "https://grafana.github.io/helm-charts"
    chart = "grafana"
    // version = "6.31.1"
    // Use chart version 6.36.1 or higher due to PodSecurityPolicy changes in K8s. Ref: https://github.com/grafana/helm-charts/issues/1826
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    values = [templatefile("./charts/grafana/values.yaml", { external_name = "${data.kubernetes_service_v1.nginx-service.status.0.load_balancer.0.ingress.0.hostname}"})]
}