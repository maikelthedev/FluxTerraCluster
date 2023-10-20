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