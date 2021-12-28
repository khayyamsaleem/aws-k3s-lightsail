terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }

  required_version = ">= 0.14.9"
}

data "http" "host_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  host_ip = chomp(data.http.host_ip.body)
}

resource "aws_lightsail_key_pair" "k3s-key-pair" {
  name    = "k3s-key-pair"
  pgp_key = var.lightsail_key_pair_pgp_key
}

module "k3s-server" {
  source = "./modules/k3s-node"

  aws_availability_zone = var.aws_availability_zone
  node_suffix           = "server"
  key_pair_name         = aws_lightsail_key_pair.k3s-key-pair.name
  host_ip               = local.host_ip

  tags = {
    cluster   = var.cluster_name
    node_type = "server"
  }
}

resource "aws_lightsail_instance_public_ports" "k3s_control_plane_firewall_rule" {
  instance_name = module.k3s-server.instance_name

  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
    cidrs     = ["${local.host_ip}/32"]
  }
}

module "k3s-agents" {
  source = "./modules/k3s-node"
  count  = var.num_agents

  aws_availability_zone = var.aws_availability_zone
  node_suffix           = "agent-${count.index + 1}"
  key_pair_name         = aws_lightsail_key_pair.k3s-key-pair.name
  host_ip               = local.host_ip

  tags = {
    cluster   = var.cluster_name
    node_type = "agent"
  }

}

locals {
  k3s_nodes = concat(module.k3s-agents, [module.k3s-server])
}

resource "aws_lightsail_instance_public_ports" "k3s-node-firewall-rules" {
  count         = length(local.k3s_nodes)
  instance_name = local.k3s_nodes[count.index].instance_name

  port_info {
    protocol  = "all"
    from_port = 0
    to_port   = 65535
    cidrs = compact(
      [for node in local.k3s_nodes : node.private_ip_address == local.k3s_nodes[count.index].private_ip_address ? "" : "${node.private_ip_address}/32"]
    )
  }

}