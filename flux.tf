resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = var.github.bot_name
  repository = var.github.repo
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
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