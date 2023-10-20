output "talos_talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "talos_worker" {
  value     = data.talos_machine_configuration.worker.machine_configuration
  sensitive = true
}

output "talos_controplane" {
  value     = data.talos_machine_configuration.controlplane.machine_configuration
  sensitive = true
}

output "load_balancer" {
  value =  hcloud_load_balancer.load_balancer.ipv4
}

output "ip_first_controlplane" {
    value = hcloud_server.controlplane[1].ipv4_address
}

output "kubeconfig" {
    value = data.talos_cluster_kubeconfig.mykubeconfig
    sensitive = true
}

output "testserver" {
    value = element([for network in hcloud_server.controlplane[1].network : network.ip], 0)
    sensitive = true
}