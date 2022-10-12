resource "kubernetes_namespace_v1" "altinitycloud_system" {
  metadata {
    name        = "altinity-cloud-system"
    annotations = var.namespace_annotations
  }
}

resource "kubernetes_namespace_v1" "altinitycloud_managed_clickhouse" {
  metadata {
    name        = "altinity-cloud-managed-clickhouse"
    annotations = var.namespace_annotations
  }
}
