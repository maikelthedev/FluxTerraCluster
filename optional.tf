# This exists just to simplify my part as I use Digital Ocean as DNS

resource "digitalocean_record" "subdomains" {
  for_each = { for name in var.domain.string_list : name => name }

  domain = var.domain.name
  type   = "A"
  name   = each.value
  value  = hcloud_load_balancer.load_balancer.ipv4
  depends_on = [
    hcloud_load_balancer.load_balancer
  ]
}