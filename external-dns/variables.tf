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

variable "api_server_url" {
  type        = string
  default     = ""
}

variable "client_cert" {
  type        = string
  default     = ""
}

variable "client_key" {
  type        = string
  default     = ""
}

variable "ca_crt" {
  type        = string
  default     = ""
}
variable "rancher_token" {
  type        = string
  default     = ""
}
