resource "kubernetes_service" "service1" {
  metadata {
    name = "webappsvc1"
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
