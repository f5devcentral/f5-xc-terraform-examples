resource "kubernetes_service_account" "f5xc-sd-sa" {
    provider = kubernetes.eks

    metadata {
        name = "${local.f5xc_sd_sa}"
    }
}

resource "kubernetes_secret_v1" "f5xc-sd-sa-secret" {
  provider = kubernetes.eks

  metadata {
    annotations = {
        "kubernetes.io/service-account.name" = "${local.f5xc_sd_sa}"
    }
    name = "${local.f5xc_sd_sa}-token"
  }

  type = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
  depends_on = [ kubernetes_service_account.f5xc-sd-sa ]
}

resource "kubernetes_cluster_role_v1" "f5xc-sd" {
    provider = kubernetes.eks

    metadata {
        name = "f5xc-sd"
    }

    rule {
        api_groups = [""]
        resources = ["endpoints", "nodes", "nodes/proxy", "namespaces", "pods", "services"]
        verbs = ["get", "list", "watch"]
    }
}
resource "kubernetes_cluster_role_binding_v1" "f5xc-sd-sa-binding" {
    provider = kubernetes.eks
    
    metadata {
        name = "f5xc-sd-sa-binding"
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "cluster-admin"
    }
    subject {
      kind = "ServiceAccount"
      name = "${local.f5xc_sd_sa}"
    }
}
