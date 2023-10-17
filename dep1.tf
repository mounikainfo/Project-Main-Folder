resource "kubernetes_deployment" "deployment1" {
  metadata {
    name = "webappdeployment1"
    /* labels = {
      test = "my-app"
    } */
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "webapp1"
      }
    }

    template {
      metadata {
        # name = mypod
        labels = {
          test = "webapp1"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx-container"
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

