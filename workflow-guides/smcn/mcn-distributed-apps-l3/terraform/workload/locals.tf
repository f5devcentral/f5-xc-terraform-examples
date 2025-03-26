locals {
  name       = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  namespace  = ("" != var.namespace) ? var.namespace : local.name
  app_domain = var.app_domain

  f5xc_sd_sa = var.f5xc_sd_sa

  #------------------------------------------------
  # XC WAF Protection
  #------------------------------------------------

  xc_waf = {"true" == var.xc_waf} ? true : false
  xc_waf_policy_name = var.xc_waf_policy_name

  #------------------------------------------------
  # XC Malicious User Detection
  #------------------------------------------------

  xc_mud = ("true" == var.xc_mud) ? true : false

  #------------------------------------------------
  # XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
  #------------------------------------------------

  xc_app_type = var.xc_app_type
  xc_multi_lb = ("true" == var.xc_multi_lb) ? true : false

  #------------------------------------------------
  # XC DDoS Protection
  #------------------------------------------------

  xc_ddos_def = ("true" == var.xc_ddos_def) ? true : false

  #------------------------------------------------
  # XC DDoS Protection
  #------------------------------------------------

  xc_ddos_pro = ("true" == var.xc_ddos_pro) ? true : false

  #------------------------------------------------
  # XC Bot Defense
  #------------------------------------------------

  xc_bot_def = ("true" == var.xc_bot_def) ? true : false

  #------------------------------------------------
  # Registry
  #------------------------------------------------

  use_private_registry = ("true" == var.use_private_registry) ? true : false
  registry_server      = var.registry_server
  registry_username    = var.registry_username
  registry_password    = var.registry_password
  registry_email       = var.registry_email
  
  #------------------------------------------------
  # XC API Protection and Discovery
  #------------------------------------------------

  xc_api_pro  = ("true" == var.xc_api_pro) ? true : false
  xc_api_disc = ("true" == var.xc_api_disc) ? true : false

  #------------------------------------------------
  # AWS
  #------------------------------------------------

  aws_site_name = ("" != var.prefix) ? format("%s-%s", var.prefix, var.aws_site_name) : var.aws_site_name
  kubeconfig_name = format("%s-aws-kubeconfig", local.name)
  kubeconfig_data = nonsensitive(templatefile("templates/kubeconfig.tpl", {
    kubeconfig_name     = local.kubeconfig_name
    endpoint            = ("" != local.eks_cluster_host) ? local.eks_cluster_host : data.aws_eks_cluster.eks.endpoint
    cluster_auth_base64 = ("" != local.eks_cluster_ca_certificate) ? base64encode(local.eks_cluster_ca_certificate) : data.aws_eks_cluster.eks.certificate_authority[0].data
    secret_token        = kubernetes_secret_v1.f5xc-sd-sa-secret.data.token
  }))

  aws_service_name        = format("%s-nic-nginx-ingress-controller", local.name)
  aws_service_endpoint_ip = join("", flatten(data.kubernetes_endpoints_v1.origin-pool-k8s-service.subset[*].address[*].ip))
  # TODO: check external port
  aws_origin_port   = ("" != var.nic_external_port) ? var.nic_external_port : "80"
  aws_origin_server = local.origin_nginx
  origin_nginx      = ("" != var.nic_external_name) ? var.nic_external_name : ""
  dns_origin_pool   = local.origin_nginx != "" ? true : false 

  eks_cluster_name           = var.eks_cluster_name
  eks_cluster_host           = var.eks_cluster_host
  eks_cluster_ca_certificate = var.eks_cluster_ca_certificate

  #------------------------------------------------
  # Azure
  #------------------------------------------------

  azure_site_name           = ("" != var.prefix) ? format("%s-%s", var.prefix, var.azure_site_name) : var.azure_site_name
  azure_resource_group_name = ("" != var.azure_resource_group_name) ? var.azure_resource_group_name : local.name
  aks_cluster_name          = var.aks_cluster_name
  azure_internal_subnet_name = var.azure_internal_subnet_name
  azure_service_endpoint_ip = kubernetes_service.app2.status[0].load_balancer[0].ingress[0].ip
  aks_origin_port           = kubernetes_service.app2.spec[0].port[0].port

  #------------------------------------------------
  # GCP
  #------------------------------------------------

  gke_load_balancer_ip = kubernetes_ingress_v1.app3-ingress.status[0].load_balancer[0].ingress[0].ip
  gke_cluster_name = var.gke_cluster_name
  gcp_project_id = var.gcp_project_id
  gcp_region = var.gcp_region
  gcp_account_id = var.gcp_account_id
}