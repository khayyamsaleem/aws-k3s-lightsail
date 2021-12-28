output "ip_address" {
  description = "Static IP Address of the provisioned k3s node."
  value       = aws_lightsail_static_ip.static-ip.ip_address
}

output "private_ip_address" {
  description = "Private, internal IP Address of the provisioned k3s node, accessible from within same AZ and account."
  value       = aws_lightsail_instance.k3s-node.private_ip_address
}

output "instance_name" {
  description = "Name of the provisioned Lightsail instance."
  value       = aws_lightsail_instance.k3s-node.name
}