resource "hcloud_load_balancer" "load_balancer" {
  name               = var.load_balancer_config.name
  load_balancer_type = var.load_balancer_config.type
  location           = var.load_balancer_config.location
  labels = {
    type = "controlplane"
  }
}

resource "hcloud_load_balancer_network" "srvnetwork" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  network_id       = hcloud_network.mynetwork.id
  ip               = var.load_balancer_config.ip
}


resource "hcloud_load_balancer_target" "load_balancer_target_cp" {
  depends_on = [ hcloud_load_balancer_network.srvnetwork ]
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  label_selector = "type=controlplane"
  use_private_ip = true
}
