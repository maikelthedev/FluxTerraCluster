terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.42.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.4.0-alpha.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.1.1"
    }
    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 1.22.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}


provider "hcloud" {
  token = var.hcloud_token
}


provider "talos" {
  # Configuration options
}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {

  host                   = data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.host
  client_certificate     = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.mykubeconfig.kubernetes_client_configuration.ca_certificate)
}

