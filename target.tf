# provider "k8s" {
#   config_path = "~/.kube/config"  # Path to your kubeconfig file
# }

resource "k8s_elbv2_target_group_binding" "nginx" {
  metadata {
    name = "nginx"
  }

  spec {
    service_ref {
      name              = "nginx"
      port              = 8080
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-2:231299874646:targetgroup/lbc-target-group/5dd10cc229a9f93d"
    }
  }
}
