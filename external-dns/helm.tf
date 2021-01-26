# Helm resources

# Install Gitlab Runner helm chart
resource "helm_release" "external_dns" {

  repository       = "https://charts.bitnami.com/bitnami"
  name             = "bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "aws.credentials.accessKey"
    value = var.aws_access_key
  }
  set {
    name  = "aws.credentials.secretKey"
    value = var.aws_secret_key
  }
  set {
    name  = "aws.region"
    value = var.aws_region
  }
}