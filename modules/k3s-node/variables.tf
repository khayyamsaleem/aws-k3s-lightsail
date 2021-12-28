variable "aws_availability_zone" {
  type        = string
  description = "AWS AZ to provision resources in."
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to the node."
  default     = {}
}

variable "node_suffix" {
  type        = string
  description = "Suffix to append to k3s node name."

  validation {
    condition     = can(regex("^[0-9A-Za-z-_]+$", var.node_suffix))
    error_message = "Node suffix must be alphanumeric, with dashes and underscores allowed."
  }
}

variable "node_bundle_id" {
  type        = string
  description = "Lightsail bundle id used for the node."
  default     = "micro_2_0"
}

variable "key_pair_name" {
  type        = string
  description = "Key pair name to be used for the node."
}

variable "host_ip" {
  type        = string
  description = "Host IP for provisioning machine, required for subsequent K3S steps."
}