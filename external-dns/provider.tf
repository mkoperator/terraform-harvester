# Helm provider
provider "helm" {
  kubernetes {
    host = var.api_server_url

    client_certificate     = var.client_cert
    client_key             = var.client_key
    cluster_ca_certificate = var.ca_crt

    load_config_file = false
  }
}
