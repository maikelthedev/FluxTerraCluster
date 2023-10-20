resource "hcloud_load_balancer_service" "load_balancer_service_talos" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol         = "tcp"
    listen_port = 6443
    destination_port = 6443
}

resource "hcloud_load_balancer_service" "load_balancer_service_http" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol         = "tcp"
    listen_port = 80
    destination_port = 32080
}

resource "hcloud_load_balancer_service" "load_balancer_service_https" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol         = "tcp"
    listen_port = 443
    destination_port = 32443
}