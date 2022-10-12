output "clickhouse_namespace" {
  value = kubernetes_namespace_v1.altinitycloud_managed_clickhouse.metadata[0].name
  depends_on = [
    null_resource.wait
  ]
}
