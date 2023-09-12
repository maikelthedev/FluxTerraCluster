# TODO: Divide this in multiple files you lazy F. 
# TODO: Make every name and every server a variable

resource "hcloud_server" "controlplane" {
  count       = 3 
  name        = "cplane${count.index + 1}"  
  server_type = "cax11"
  image       = "ubuntu-22.04" # Placeholder OS. This will change to Talos OS
}

resource "hcloud_server" "workers" {
  count       = 2 
  name        = "worker${count.index + 1}"  
  server_type = "cax31"
  image       = "ubuntu-22.04" # Placeholder OS. This will change to Talos OS
}

# TODO: Point it to somewhere
resource "hcloud_load_balancer" "load_balancer" {
  name               = "funky-load-balancer"
  load_balancer_type = "lb11"
  location           = "nbg1"
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  count            = length(hcloud_server.controlplane)
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.controlplane[count.index].id
}