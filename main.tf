resource "kubernetes_secret_v1" "altinitycloud_cloud_connect" {
  metadata {
    name      = "cloud-connect"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
    labels = {
      app = "cloud-connect"
    }
  }

  data = var.pem != "" ? {
    "cloud-connect.pem" = var.pem
    "ca.crt" = var.ca_crt
  } : {}
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
        dynamic "host_aliases" {
          for_each = var.host_alias_ip != "" ? [1] : []
          content {
            ip = var.host_alias_ip
            hostnames = [host_alias_name]
          }
        }

        volume {
          name = "secret"
          secret {
            secret_name = "cloud-connect"
          }
        }
        container {
          name              = "cloud-connect"
          image             = var.image != "" ? var.image : "altinity/cloud-connect:${local.version}"
          image_pull_policy = var.image_pull_policy != "" ? var.image_pull_policy : local.version == "latest-master" ? "Always" : "IfNotPresent"

          args = concat(
            [
              "-u",
              var.url,
              "-i",
              "/etc/cloud-connect/cloud-connect.pem",
              "--debug-addr",
              ":7777",
              "--dual-tcp-udp",
              var.dual_tcp_udp,
            ],
            var.ca_crt != "" ? ["--ca-crt", "/etc/cloud-connect/ca.crt"] : []
          )
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

resource "null_resource" "wait" {
  count = var.wait_connected || var.wait_ready ? 1 : 0
  triggers = {
    hash = sha256(join("\n", [var.url, var.pem])),
  }
  provisioner "local-exec" {
    command     = "${path.module}/statuscheck --url=${var.url} --cert=<(echo $STATUSCHECK_CERT_BASE64 | base64 -d) --wait=${var.wait_timeout_in_seconds} ${!var.wait_ready ? "--connected" : ""}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    environment = {
      STATUSCHECK_CERT_BASE64 = base64encode(var.pem)
    }
  }
  depends_on = [
    kubernetes_deployment_v1.altinitycloud_cloud_connect
  ]
}
