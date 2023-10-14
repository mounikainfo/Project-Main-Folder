resource "kubernetes_service" "service2" {
  metadata {
    name = "webappsvc2"
  }
  spec {
    type = "ClusterIP"
    selector = {
      test = "webapp1"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}
