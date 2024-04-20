# create namespace
resource "volterra_namespace" "this" {
  count = var.vk8s ? 1 : 0
  name = var.xc_namespace
}

# create virtual site
resource "volterra_virtual_site" "this" {
  count = var.vk8s ? 1 : 0
  name      = "bot-defense-testing-virtual-site"
  namespace = var.xc_namespace
  depends_on = [volterra_namespace.this]
  site_selector {
    expressions = [format("ves.io/siteName == %s", var.site_name)]
  }
  site_type = "REGIONAL_EDGE"
}

# create vK8s
resource "volterra_virtual_k8s" "this" {
  name      = format("%s-%s-vk8s", local.project_prefix, local.build_suffix)
  namespace = var.xc_namespace
  depends_on = [volterra_virtual_site.this]
  vsite_refs {
    name      = volterra_virtual_site.this.0.name
    namespace = var.xc_namespace
  }

  provisioner "local-exec" {
    command = "sleep 100s"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 20s"
  }
}

# Download kubeconfig
resource "volterra_api_credential" "this" {
  name                  = substr(volterra_virtual_k8s.this.id, 1, 30)
  api_credential_type   = "KUBE_CONFIG"
  expiry_days           = 20
  virtual_k8s_namespace = var.xc_namespace
  virtual_k8s_name      = format("%s-%s-vk8s", local.project_prefix, local.build_suffix)
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "local_file" "this_kubeconfig" {
  content  = base64decode(volterra_api_credential.this.data)
  filename = format("%s/_output/xc_vk8s_kubeconfig", path.root)
}

resource "local_file" "airline_manifest" {
  source  = format("%s/airflask.yaml", path.module)
  filename = format("%s/_output/air-flask.yaml", path.root)
}

resource "time_sleep" "wait_k8s_server" {
  depends_on = [local_file.this_kubeconfig]
  create_duration = "120s"
}

# Deploy application
resource "null_resource" "apply_manifest" {
  depends_on = [time_sleep.wait_k8s_server, local_file.this_kubeconfig]

  # download kubectl
  provisioner "local-exec" {
    command = "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl"
  }

  provisioner "local-exec" {
    command = "./kubectl apply -f _output/air-flask.yaml"
    environment = {
      KUBECONFIG = format("%s/_output/xc_vk8s_kubeconfig", path.root)
    }
  }
  provisioner "local-exec" {
    when    = destroy
    command = "./kubectl delete -f _output/air-flask.yaml --ignore-not-found=true"
    environment = {
      KUBECONFIG = format("%s/_output/xc_vk8s_kubeconfig", path.root)
    }
    on_failure = continue
  }
}
