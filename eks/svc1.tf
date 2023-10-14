resource "kubernetes_service" "service1" {
  metadata {
    name = "webappsvc1"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      test = "webapp1"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}
