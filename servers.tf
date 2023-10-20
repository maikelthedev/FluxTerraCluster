resource "hcloud_server" "workers" {
  count       = var.instances_config.worker_nodes
  depends_on = [ hcloud_network_subnet.funkysubnet ]
  name        = "worker${count.index + 1}" 
  user_data = data.talos_machine_configuration.worker.machine_configuration
  server_type = var.instances_config.worker_type
  labels = {
    type = "worker"
  }
  network {
    network_id = hcloud_network.mynetwork.id
    ip         = "${var.instances_config.prefix_ip}${count.index + var.instances_config.workers_start_ip}"
  }
  image = "124785373" # Instructions on how to create an image in hetzner here https://www.talos.dev/v1.5/talos-guides/install/cloud-platforms/hetzner/
}

resource "hcloud_server" "controlplane" {
  count       = var.instances_config.cplane_nodes
  depends_on = [ hcloud_network_subnet.funkysubnet ]
  name        = "cplane${count.index + 1}"  
  user_data = data.talos_machine_configuration.controlplane.machine_configuration
  labels = {
    type = "controlplane"
  }
  server_type = var.instances_config.cplane_type
  image = "124785373"
  network {
    network_id = hcloud_network.mynetwork.id
    ip         = "${var.instances_config.prefix_ip}${count.index + var.instances_config.cplanes_start_ip}"
  }
}