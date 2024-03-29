resource "kubernetes_cluster_role_v1" "altinitycloud_node_view" {
  metadata {
    name = "altinity-cloud:node-view"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["watch", "list", "get"]
  }
}

resource "kubernetes_cluster_role_v1" "altinitycloud_node_metrics_view" {
  metadata {
    name = "altinity-cloud:node-metrics-view"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes/metrics"]
    verbs      = ["watch", "list", "get"]
  }
}

resource "kubernetes_cluster_role_v1" "altinitycloud_storage_class_view" {
  metadata {
    name = "altinity-cloud:storage-class-view"
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["watch", "list", "get"]
  }
}

resource "kubernetes_cluster_role_v1" "altinitycloud_persistent_volume_view" {
  metadata {
    name = "altinity-cloud:persistent-volume-view"
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["watch", "list", "get"]
  }
}

resource "kubernetes_cluster_role_v1" "altinitycloud_cloud_connect" {
  metadata {
    name = "altinity-cloud:cloud-connect"
  }
  # temporary (for node resource usage tracking)
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["list"]
  }
  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    resource_names = [
      "clickhouseinstallations.clickhouse.altinity.com",
      "clickhouseinstallationtemplates.clickhouse.altinity.com",
      "clickhouseoperatorconfigurations.clickhouse.altinity.com",
      "clickhousekeeperinstallations.clickhouse-keeper.altinity.com",
    ]
    verbs = ["*"]
  }
}

resource "kubernetes_service_account_v1" "altinitycloud_cloud_connect" {
  metadata {
    name      = "cloud-connect"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "altinitycloud_cloud_connect" {
  metadata {
    name = "altinity-cloud:cloud-connect"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.altinitycloud_cloud_connect.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].name
    namespace = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "altinitycloud_node_view" {
  metadata {
    name = "altinity-cloud:node-view"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.altinitycloud_node_view.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].name
    namespace = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].namespace
  }
  subject {
    kind      = "ServiceAccount"
    name      = "edge-proxy"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "prometheus"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "altinitycloud_node_metrics_view" {
  metadata {
    name = "altinity-cloud:node-metrics-view"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.altinitycloud_node_metrics_view.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "prometheus"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "altinitycloud_storage_class_view" {
  metadata {
    name = "altinity-cloud:storage-class-view"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.altinitycloud_storage_class_view.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].name
    namespace = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "altinitycloud_persistent_volume_view" {
  metadata {
    name = "altinity-cloud:persistent-volume-view"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.altinitycloud_persistent_volume_view.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].name
    namespace = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].namespace
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
}

resource "kubernetes_role_binding_v1" "altinitycloud_cloud_connect_system" {
  metadata {
    name      = "altinity-cloud:cloud-connect"
    namespace = kubernetes_namespace_v1.altinitycloud_system.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].name
    namespace = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].namespace
  }
}

resource "kubernetes_role_binding_v1" "altinitycloud_cloud_connect_managed_clickhouse" {
  metadata {
    name      = "altinity-cloud:cloud-connect"
    namespace = kubernetes_namespace_v1.altinitycloud_managed_clickhouse.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].name
    namespace = kubernetes_service_account_v1.altinitycloud_cloud_connect.metadata[0].namespace
  }
}
