output "rancher_server_url" {
  value = module.rancher.rancher_url
}

output "rancher_node_ip" {
  value = google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip
}
output "rancher_token" {
  value = module.rancher.rancher_token
}