resource "null_resource" "harvester_download" {
  triggers = {
    on_version_change = "v${var.harvester_version}"
  }

  provisioner "local-exec" {
    command = "curl -o files/harvester-${var.harvester_version}.tar.gz -L ${var.harvester_archive_url}/v${var.harvester_version}; tar -xzf files/harvester-${var.harvester_version}.tar.gz"
  }


}

# Helm resources

# Install Harvester helm chart
resource "helm_release" "harvester" {

  name             = "harvester"
  chart            = "./harvester-${var.harvester_version}/deploy/charts/harvester"
  namespace        = "harvester-system"
  create_namespace = true

  set {
    name  = "longhorn.enabled"
    value = true
  }

  set {
    name  = "minio.persistence.storageClass"
    value = "longhorn"
  }

  set {
    name  = "service.harvester.type"
    value = "NodePort"
  }

  set {
    name  = "multus.enabled"
    value = true
  }

  depends_on = [
    null_resource.harvester_download,
  ]
}
