resource "hcloud_network_subnet" "funkysubnet" {
  network_id   = hcloud_network.mynetwork.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}


