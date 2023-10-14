/* resource "k8s_elbv2_target_group_binding" "nginx" {
  metadata {
    name = "nginx"
  }

  spec {
    service_ref {
      name              = "nginx"
      port              = 8080
      target_group_arn = "arn:aws:elasticloadbalancing:ap-south-1:140382828045:targetgroup/lbc-target-group/ccfb7df6c3bea597"
    }
  }
}
 */