resource "hcloud_network" "mynetwork" {
  name     = "funky-network"
  ip_range = "10.0.1.0/24"
}
