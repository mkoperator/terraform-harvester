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