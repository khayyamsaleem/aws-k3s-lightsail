variable "aws_profile" {
  type        = string
  description = "AWS profile name to use for provisioning."
}

variable "aws_region" {
  type        = string
  description = "AWS region to provision resources in."
  default     = "us-east-1"
}

variable "aws_availability_zone" {
  type        = string
  description = "AWS AZ to provision resources in."
  default     = "us-east-1a"
}

variable "num_agents" {
  type        = number
  description = "Number of k3s agents to provision for the cluster."
  default     = 2
}

variable "lightsail_key_pair_pgp_key" {
  type        = string
  description = "Keybase PGP key to use to create Lightsail key pair."
  validation {
    condition     = can(regex("^keybase:[0-9A-Za-z]+$", var.lightsail_key_pair_pgp_key))
    error_message = "PGP key for Lightsail keypair must be of the form \"keybase:keybaseUsername\"."
  }
}

variable "cluster_name" {
  type        = string
  description = "Name to give to the cluster. Will be added as a tag to each applicable resource."
  validation {
    condition     = can(regex("^[0-9A-Za-z]+$", var.cluster_name))
    error_message = "Cluster name must be alphanumeric."
  }
}