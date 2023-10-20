provider "hcloud" {
  token = var.hcloud_token
}


provider "talos" {}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  host                   = data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.host
  client_certificate     = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.ca_certificate)
}

provider "flux" {
  kubernetes = {
    host = data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.host
    client_certificate     = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.ca_certificate)
  }

  git = {
    url = "ssh://git@github.com/${var.github.org}/${var.github.repo}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}


provider "github" {
  owner = var.github.org
  token = var.github.token
}