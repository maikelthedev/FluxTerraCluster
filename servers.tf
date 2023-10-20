resource "hcloud_server" "workers" {
  count       = 2 
  name        = "worker${count.index + 1}" 
  user_data = data.talos_machine_configuration.worker.machine_configuration
  server_type = "cax31"
  labels = {
    type = "worker"
  }
  network {
    network_id = hcloud_network.mynetwork.id
    ip         = "10.0.1.${count.index + 13}"
  }
  image = "124785373" # Instructions on how to create an image in hetzner here https://www.talos.dev/v1.5/talos-guides/install/cloud-platforms/hetzner/
}

resource "hcloud_server" "controlplane" {
  count       = 3 
  name        = "cplane${count.index + 1}"  
  user_data = data.talos_machine_configuration.controlplane.machine_configuration
  labels = {
    type = "controlplane"
  }
  server_type = "cax11"
  image = "124785373"
  network {
    network_id = hcloud_network.mynetwork.id
    ip         = "10.0.1.${count.index + 10}"
  }
}