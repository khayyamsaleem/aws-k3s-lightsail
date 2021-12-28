# AWS Lightsail k3s Cluster

Terraform configuration for creating an k3s cluster with cheap nodes from AWS Lightsail.

> Note: This terraform will only provision the nodes in the cluster with static IPs and appropriate firewall rules, not actually install k3s. Working on that, gotta learn about `remote-exec`