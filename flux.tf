provider "flux" {
  kubernetes = {
    host = data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.host
    client_certificate     = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.ca_certificate)
  }

  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}


provider "github" {
  owner = var.github_org
  token = var.github_token
}

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}


data "talos_cluster_health" "health" {
  depends_on = [data.talos_cluster_kubeconfig.mykubeconfig]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  control_plane_nodes = [for node in hcloud_server.controlplane: node.ipv4_address]
  endpoints = [for node in hcloud_server.controlplane: node.ipv4_address]
  worker_nodes = [for node in hcloud_server.workers: node.ipv4_address]
  timeouts = {
    read = "10m" # It can take ten minutes for Talos to be up max
  }

}

#Interestingly enough destructing this, destroys the Flux folder on the repository
resource "flux_bootstrap_git" "this" {
  depends_on = [
    github_repository_deploy_key.this,  
    talos_machine_bootstrap.this,
    data.talos_cluster_health.health
  ]  
  path = var.flux_cluster_path
}