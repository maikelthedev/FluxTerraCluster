# This exists just to simplify my part as I use Digital Ocean as DNS

resource "digitalocean_record" "funky" {
  domain = "mkl.lol" 
  type   = "A"
  name   = "funky"
  value  = hcloud_load_balancer.load_balancer.ipv4
  depends_on = [
    hcloud_load_balancer.load_balancer
  ]
}

resource "digitalocean_record" "lb" {
  domain = "mkl.lol" 
  type   = "A"
  name   = "lb"
  value  = hcloud_load_balancer.load_balancer.ipv4
  depends_on = [
    hcloud_load_balancer.load_balancer
  ]
}