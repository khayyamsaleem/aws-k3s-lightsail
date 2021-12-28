output "k3s_server_ip_address" {
  description = "Static IP address of k3s server node."
  value       = module.k3s-server.ip_address
}

output "k3s_agent_ip_addresses" {
  description = "Static IP address of k3s server node."
  value       = [for agent in module.k3s-agents : agent.ip_address]
}

output "k3s_key_pair" {
  description = "Key pair for admin actions on Lightsail nodes."
  value = {
    public_key            = aws_lightsail_key_pair.k3s-key-pair.public_key
    encrypted_private_key = aws_lightsail_key_pair.k3s-key-pair.encrypted_private_key
  }
}