resource "kubernetes_secret_v1" "altinitycloud_cloud_connect" {
  # https://www.terraform.io/language/state/sensitive-data
  count = var.pem != "" ? 1 : 0
  metadata {
    name      = "cloud-connect"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
    labels = {
      app = "cloud-connect"
    }
  }
  data = {
    "cloud-connect.pem" = var.pem
  }
}

resource "kubernetes_deployment_v1" "altinitycloud_cloud_connect" {
  metadata {
    name      = "cloud-connect"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
    labels = {
      app = "cloud-connect"
    }
  }
  spec {
    replicas               = 1
    revision_history_limit = 3
    selector {
      match_labels = {
        app = "cloud-connect"
      }
    }
    template {
      metadata {
        labels = {
          app = "cloud-connect"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "7777"
        }
      }
      spec {
        service_account_name = "cloud-connect"
        volume {
          name = "secret"
          secret {
            secret_name = "cloud-connect"
          }
        }
        container {
          name  = "cloud-connect"
          image = "${var.docker_registry != "" ? "${var.docker_registry}/" : ""}altinity/cloud-connect:${local.release}"
          args = [
            "-i",
            "/etc/cloud-connect/cloud-connect.pem",
            "--debug-addr",
            ":7777"
          ]
          volume_mount {
            name       = "secret"
            mount_path = "/etc/cloud-connect"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 7777
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  app = "cloud-connect"
                }
              }
              topology_key = "topology.kubernetes.io/zone"
            }
          }
        }
      }
    }
  }
}
