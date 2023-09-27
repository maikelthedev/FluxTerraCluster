terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.42.1"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.4.0-alpha.0"
    }
    flux = {
      source = "fluxcd/flux"
      version = "1.1.1"
    }
      github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
  }
}


provider "hcloud" {
  token = var.hcloud_token
}


provider "talos" {
  # Configuration options
}
