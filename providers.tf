variable "hcloud_token" {}

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
  }
}


provider "hcloud" {
  token = var.hcloud_token
}


provider "talos" {
  # Configuration options
}