# Local provider
provider "local" {
}

# RKE provider
provider "rke" {
}

# Kubernetes provider
provider "k8s" {
  host = rke_cluster.rancher_cluster.api_server_url

  client_certificate     = rke_cluster.rancher_cluster.client_cert
  client_key             = rke_cluster.rancher_cluster.client_key
  cluster_ca_certificate = rke_cluster.rancher_cluster.ca_crt

  load_config_file = false
}

# Helm provider
provider "helm" {
  kubernetes {
    host = rke_cluster.rancher_cluster.api_server_url

    client_certificate     = rke_cluster.rancher_cluster.client_cert
    client_key             = rke_cluster.rancher_cluster.client_key
    cluster_ca_certificate = rke_cluster.rancher_cluster.ca_crt

    load_config_file = false
  }
}

# Rancher2 bootstrapping provider
provider "rancher2" {
  alias = "bootstrap"
  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  bootstrap = true
}
# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap
  password = var.admin_password
  telemetry = true
    depends_on = [
    helm_release.rancher_server,
  ]
}

# Rancher2 administration provider
provider "rancher2" {
  alias = "admin"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = rancher2_bootstrap.admin.token
}
