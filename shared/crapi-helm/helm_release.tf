resource "helm_release" "crapi" {
  name       = "crapi"
  chart      = "./helm"
  namespace  = "crapi"
  create_namespace = true
  values = [
    file("./helm/values.yaml")
  ]
}