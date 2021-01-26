# Outputs

output "rancher_url" {
  value = "https://${var.rancher_server_dns}"
}
output "rancher_token" {
  value = rancher2_bootstrap.admin.token
}
output "api_server_url" {
  value = rke_cluster.rancher_cluster.api_server_url
}
output "client_cert" {
  value = rke_cluster.rancher_cluster.client_cert
}
output "client_key" {
  value = rke_cluster.rancher_cluster.client_key
}
output "ca_crt" {
  value = rke_cluster.rancher_cluster.ca_crt
}