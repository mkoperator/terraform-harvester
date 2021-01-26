# GCP infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# GCP Public Compute Address for rancher server node
resource "google_compute_address" "rancher_server_address" {
  name = "rancher-server-ipv4-address"
}

# Firewall Rule to allow all traffic
resource "google_compute_firewall" "rancher_fw_allowall" {
  name    = "${var.prefix}-rancher-allowall"
  network = "default"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# GCP Compute Instance for creating a single node RKE cluster and installing the Rancher server
resource "google_compute_instance" "rancher_server" {
  depends_on = [
    google_compute_firewall.rancher_fw_allowall,
  ]

  name             = "${var.prefix}-rancher-server"
  machine_type     = var.machine_type
  zone             = var.gcp_zone
  can_ip_forward   = true
  min_cpu_platform = "Intel Haswell"

  boot_disk {
    initialize_params {
      image = "chameleon-301412/ubuntu-2004-lts"
      size  = var.machine_disksize
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.rancher_server_address.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.global_key.public_key_openssh}"
    user-data = templatefile(
      join("/", [path.module, "../cloud-init/userdata_rancher_server.template"]),
      {
        docker_version = var.docker_version
        username       = local.node_username
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}
# Route 53 module to handle domain record for rancher cluster.
module "route53" {

  source  = "../route53"
  address = google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip
  domain  = var.domain

  #aws configs
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
  aws_zone       = var.aws_zone

}
# Rancher resources
module "rancher" {
  source = "../rancher"

  node_public_ip         = google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip
  node_internal_ip       = google_compute_instance.rancher_server.network_interface.0.network_ip
  node_username          = local.node_username
  ssh_private_key_pem    = tls_private_key.global_key.private_key_pem
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version
  letsencrypt_email    = var.letsencrypt_email
  rancher_server_dns   = var.domain
  admin_password       = var.rancher_server_admin_password

}

module "external_dns" {
  source       = "../external-dns"

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
  api_server_url = module.rancher.api_server_url
  client_cert  = module.rancher.client_cert
  client_key   = module.rancher.client_key
  ca_crt       = module.rancher.ca_crt
  rancher_token= module.rancher.rancher_token
}

module "harvester" {
  source       = "../harvester"
  api_server_url = module.rancher.api_server_url
  client_cert  = module.rancher.client_cert
  client_key   = module.rancher.client_key
  ca_crt       = module.rancher.ca_crt
  rancher_token= module.rancher.rancher_token
  harvester_archive_url = var.harvester_archive_url
  harvester_version = var.harvester_version
}