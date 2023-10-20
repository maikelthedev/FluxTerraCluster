# This bits creates the keys for the cluster machines to join each other, it is in purpose in blank
# You can see what it ends up being by terraform output talos_talosconfig
resource "talos_machine_secrets" "machine_secrets" {
}

# These two the equivalent to "talosctl gen config talos-k8s-hcloud-tutorial https://<load balancer IP or DNS>:6443" it creates data that contains equivalents to workers.yaml and controlplane.yaml to be used as user_data on servers.tf
data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${hcloud_load_balancer.load_balancer.ipv4}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${hcloud_load_balancer.load_balancer.ipv4}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets

}

# This creates talosconfig itself, it is the equivalent to talosctl config endpoints blablabla...
data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  nodes                 = [hcloud_server.controlplane[1].ipv4_address]
  endpoints = [hcloud_server.controlplane[1].ipv4_address] #Notice that in both cases and below worker included, needs the IP of the first (or any) of the controlplane nodes and it cannot be an internal one because this is for YOU to connect using Talosctl
}

# This is part of the bootstrapping process. 
resource "talos_machine_configuration_apply" "this" {
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = hcloud_server.controlplane[1].ipv4_address
}

# Finally bootstraps talos, equivalent to talosctl bootstrap on BASH
resource "talos_machine_bootstrap" "this" {
  depends_on = [
    talos_machine_configuration_apply.this
  ]
  node                 = hcloud_server.controlplane[1].ipv4_address
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
}


data "talos_cluster_kubeconfig" "mykubeconfig" {
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = hcloud_server.controlplane[1].ipv4_address
}

data "talos_cluster_health" "health" {
  depends_on = [
    data.talos_cluster_kubeconfig.mykubeconfig,
    hcloud_load_balancer_target.load_balancer_target_cp
    ]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  #control_plane_nodes = [for node in hcloud_server.controlplane: node.ipv4_address]
  control_plane_nodes = [for node in hcloud_server.controlplane: element([for network in node.network: network.ip],0)]
  endpoints = [for node in hcloud_server.controlplane: node.ipv4_address]
  #endpoints = [for node in hcloud_server.controlplane: element([for network in node.network: network.ip],0)]
  #worker_nodes = [for node in hcloud_server.workers: node.ipv4_address]
  worker_nodes = [for node in hcloud_server.workers: element([for network in node.network: network.ip],0)]
  timeouts = {
    read = "10m" # It can take ten minutes for Talos to be up max
  }

}