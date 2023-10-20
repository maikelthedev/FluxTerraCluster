variable "github" {
  type = object({
    repo = string
    bot_name = string
    org  = string
    token = string
  })
}


variable "flux_cluster_path" { }
variable "do_token" { }
variable "aws_token" { 
  // To get this one run in BASH 'cat /whateverfilewithAWscredentials | base64'
}
variable "hcloud_token" {}

variable "load_balancer_config" {
  type = object({
    ip = string
    name = string
    location = string
    type = string
  })
}

variable "domain" {
  description = "Domain to use as example and list of strings"
  type = object({
    name = string
    string_list = list(string)
  })
  default = {
    name = "mkl.lol"
    string_list = ["podinfo", "nginx" ]
  }
}


variable "instances_config" {
  type = object({
    cplane_nodes = number
    worker_nodes = number
    cplanes_start_ip = number
    workers_start_ip = number
    prefix_ip = string
    cplane_type = string
    worker_type = string
  })
  default =  {
    cplane_nodes = 3
    worker_nodes = 2
    cplanes_start_ip = 10
    workers_start_ip = 20
    prefix_ip = "10.0.1."
    worker_type =  "cax31"
    cplane_type = "cax11"
  }
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "funky-cluster"
}