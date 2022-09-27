resource "kubernetes_namespace_v1" "altinitycloud_system" {
  metadata {
    name = "altinity-cloud-system"
  }
  count = var.create_namespaces == true ? 1 : 0
}

resource "kubernetes_namespace_v1" "altinitycloud_managed_clickhouse" {
  metadata {
    name = "altinity-cloud-managed-clickhouse"
  }
  count = var.create_namespaces == true ? 1 : 0
}

data "kubernetes_namespace_v1" "altinitycloud_system" {
  metadata {
    name = "altinity-cloud-system"
  }
  count = var.create_namespaces == false ? 1 : 0
}

data "kubernetes_namespace_v1" "altinitycloud_managed_clickhouse" {
  metadata {
    name = "altinity-cloud-managed-clickhouse"
  }
  count = var.create_namespaces == false ? 1 : 0
}

locals {
  altinitycloud_system_namespace_id = (
    length(kubernetes_namespace_v1.altinitycloud_system) > 0
    ? kubernetes_namespace_v1.altinitycloud_system[0].metadata[0].name
    : data.kubernetes_namespace_v1.altinitycloud_system[0].metadata[0].name
  )
  altinitycloud_managed_clickhouse_namespace_id = (
    length(kubernetes_namespace_v1.altinitycloud_managed_clickhouse) > 0
    ? kubernetes_namespace_v1.altinitycloud_managed_clickhouse[0].metadata[0].name
    : data.kubernetes_namespace_v1.altinitycloud_managed_clickhouse[0].metadata[0].name
  )
}
