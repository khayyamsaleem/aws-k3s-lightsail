terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_lightsail_instance" "k3s-node" {
  name = "k3s-node-${var.node_suffix}"

  availability_zone = var.aws_availability_zone
  key_pair_name     = var.key_pair_name

  tags = var.tags

  blueprint_id = "ubuntu_20_04"
  bundle_id    = var.node_bundle_id

}

resource "aws_lightsail_static_ip" "static-ip" {
  name = "k3s-node-${var.node_suffix}-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "k3s-server-ip-bind" {
  static_ip_name = aws_lightsail_static_ip.static-ip.name
  instance_name  = aws_lightsail_instance.k3s-node.name
}

resource "aws_lightsail_instance_public_ports" "k3s-node-ssh-firewall-rule" {
  instance_name = aws_lightsail_instance.k3s-node.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["${var.host_ip}/32"]
  }

}
