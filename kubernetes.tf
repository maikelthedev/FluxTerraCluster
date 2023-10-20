# We need the velero namespaces to assign its secret (AWS config) 
resource "kubernetes_namespace" "velero" {
  depends_on = [
    hcloud_load_balancer_target.load_balancer_target_cp,
    hcloud_load_balancer_service.load_balancer_service_talos,
    data.talos_cluster_health.health
  ]
  metadata {
    name = "velero"
    labels = {
      component = "velero",
      "pod-security.kubernetes.io/audit" = "privileged",
      "pod-security.kubernetes.io/audit-version" = "latest",
      "pod-security.kubernetes.io/enforce" = "privileged",
      "pod-security.kubernetes.io/enforce-version" = "latest",
      "pod-security.kubernetes.io/warn" = "privileged",
      "pod-security.kubernetes.io/warn-version" = "latest"
    }
  }
}

resource "kubernetes_secret" "hcloud" {
  depends_on = [
    data.talos_cluster_health.health
  ]
  
  metadata {
    name = "hcloud"
    namespace = "kube-system"
  }

  data = {
    token = var.hcloud_token
  }

}

resource "kubernetes_secret" "aws_token" {
  depends_on = [
    data.talos_cluster_health.health
  ]
  
  metadata {
    name = "cloud-credentials"
    namespace = "velero"
    labels = {
      component = "velero"
    }

  }

  data = {
    cloud = base64decode(var.aws_token)
  }

}

