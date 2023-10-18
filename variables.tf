# Needed for Flux
variable "github_token" {
  sensitive = true
  type      = string
}

variable "github_org" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "flux_cluster_path" {
    
}

variable "do_token" {
  
}
# Needed for hcloud
variable "hcloud_token" {}
