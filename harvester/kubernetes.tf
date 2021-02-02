# Kubernetes resources

locals {
  windows10_image  = file(join("/", [path.module, "files/windows-10-install-disk.yaml"]))
}

resource "k8s_manifest" "windows10_image" {
  content = local.windows10_image
  depends_on = [
    helm_release.harvester,
  ]
}
locals {
  windows10_vm  = file(join("/", [path.module, "files/windows-10-vm.yaml"]))
}

resource "k8s_manifest" "windows10_vm" {
  content = local.windows10_vm
  depends_on = [
    helm_release.harvester,
  ]
}


locals {
  linuxjeos_image  = file(join("/", [path.module, "files/opensuse-leap-jeos-15sp2-image.yaml"]))
}

resource "k8s_manifest" "linuxjeos_image" {
  content = local.linuxjeos_image
  depends_on = [
    helm_release.harvester,
  ]
}