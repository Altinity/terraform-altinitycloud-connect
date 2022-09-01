resource "kubernetes_namespace_v1" "altinitycloud_system" {
  metadata {
    name = "altinity-cloud-system"
  }
}

resource "kubernetes_namespace_v1" "altinitycloud_managed_clickhouse" {
  metadata {
    name = "altinity-cloud-managed-clickhouse"
  }
}
