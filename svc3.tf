resource "kubernetes_service" "service3" {
  metadata {
    name = "webappsvc3"
  }
  spec {
    type = "ClusterIP"
    selector = {
      test = "webapp3"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}
