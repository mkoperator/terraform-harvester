# Variables for GCP infrastructure module

variable "gcp_account_json" {
  type        = string
  description = "File path and name of service account access token file."
}

variable "gcp_project" {
  type        = string
  description = "GCP project in which the quickstart will be deployed."
}

variable "gcp_region" {
  type        = string
  description = "GCP region used for all resources."
  default     = "us-east4"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone used for all resources."
  default     = "us-east4-a"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rancher"
}

variable "machine_type" {
  type        = string
  description = "Machine type used for all compute instances"
  default     = "n1-standard-8"
}
variable "machine_disksize" {
  type        = string
  description = "Size of VM disk"
  default     = 200
}
variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.19.4-rancher1-1"
}


variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.0.4"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "v2.5.3"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}


# Local variables used to reduce repetition
locals {
  node_username = "ubuntu"
}


## route 53 stuff
# Variables for AWS infrastructure module

// TODO - use null defaults

# Required
variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

# Required
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "aws_zone" {
  type        = string
  description = "Zone to be updated or created"
  default     = "us-east-1"
}

variable "domain" {
  type        = string
  description = "Domain of the record."
  default     = "test.test.com"
}

variable "address" {
  type        = string
  description = "Address."
  default     = "0.0.0.0"
}

variable "letsencrypt_email" {
  default = "mikhail.kozorovitskiy@suse.com"
  type    = string
}

variable "gitlab_url" {
  type    = string
  default = "gitlab url"
}

variable "gitlab_token" {
  type    = string
  default = "token from the project"
}

variable "app_url" {
  type        = string
  default     = ""
}

variable "harvester_archive_url" {
  type        = string
  default     = "https://codeload.github.com/rancher/harvester/tar.gz"
}
variable "harvester_version" {
  type        = string
  default     = "0.1.0"
}