# Terraform Altinity.Cloud Kubernetes Connect Module

<div align="right">
  <img src="https://altinity.com/wp-content/uploads/2022/05/logo_horizontal_blue_white.svg" alt="Altinity" width="120">
</div>

[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/altinity/connect/altinitycloud/latest)
[![Latest Version](https://img.shields.io/badge/dynamic/json?label=version&query=$.version&url=https%3A//registry.terraform.io/v1/modules/altinity/connect/altinitycloud)](https://registry.terraform.io/modules/altinity/connect/altinitycloud/latest)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Terraform module that sets up the necessary Kubernetes infrastructure to connect your Kubernetes clusters to [Altinity.Cloud](https://altinity.cloud/anywhere). This module deploys the cloud-connect service as a Kubernetes deployment, along with the required namespaces, secrets, and RBAC configurations.

If you're looking for a way to manage ClickHouse clusters via Terraform, see [terraform-provider-altinitycloud](https://github.com/altinity/terraform-provider-altinitycloud).

## Prerequisites

Before using this module, ensure you have:

1. **Kubernetes cluster** with kubectl access configured
2. **Terraform** >= 0.13
3. **Altinity.Cloud account** and access to the cloud-connect certificate
4. **Kubernetes provider** >= 2.0

## Usage

### Basic Setup

```terraform
provider "kubernetes" {
  # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
}

module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "~> 0.133.0"

  # Certificate from `altinitycloud-connect login`
  # See https://github.com/altinity/altinitycloud-connect for details
  pem = file("cloud-connect.pem")
}
```

## Examples

### Node Affinity and Tolerations

```terraform
module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "~> 0.133.0"

  pem = file("cloud-connect.pem")

  # Schedule on specific nodes
  node_selector = {
    "kubernetes.io/os" = "linux"
    "node-role"        = "altinity"
  }

  # Custom tolerations
  tolerations = [
    {
      key      = "dedicated"
      operator = "Equal"
      value    = "altinity"
      effect   = "NoSchedule"
    }
  ]
}
```

## Configuration

### Required Variables

| Name | Description | Type |
|------|-------------|------|
| `pem` | Contents of cloud-connect.pem certificate (if not using external secret) | `string` |

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `use_external_secret` | Use externally managed secret instead of creating one | `bool` | `false` |
| `url` | Altinity.Cloud connection URL | `string` | `"https://anywhere.altinity.cloud"` |
| `image` | Custom Docker image | `string` | `"altinity/cloud-connect:latest-master"` |
| `image_pull_policy` | Kubernetes image pull policy | `string` | `"IfNotPresent"` |
| `wait_connected` | Wait for environment to be connected | `bool` | `false` |
| `wait_ready` | Wait for environment to be ready for ClickHouse clusters | `bool` | `false` |
| `wait_timeout_in_seconds` | Maximum wait time in seconds | `number` | `2700` |
| `namespace_annotations` | Annotations for altinity-cloud-* namespaces | `map(string)` | `{}` |
| `namespace_labels` | Labels for altinity-cloud-* namespaces | `map(string)` | `{}` |
| `tolerations` | Additional tolerations for cloud-connect deployment | `list(object)` | `[]` |
| `node_selector` | Node selector for cloud-connect deployment | `map(string)` | `null` |

For a complete list of variables, see [variables.tf](variables.tf).

## Outputs

| Name | Description |
|------|-------------|
| `system_namespace` | Name of the altinity-cloud-system namespace |
| `clickhouse_namespace` | Name of the altinity-cloud-managed-clickhouse namespace |

## Troubleshooting

- **Deployment fails to start:** Check certificate validity and network connectivity to Altinity.Cloud. Review pod logs with `kubectl logs -n altinity-cloud-system deployment/cloud-connect`.
- **Connection timeouts:** Verify firewall rules allow outbound HTTPS traffic to `anywhere.altinity.cloud`. Check if corporate proxy settings are required.
- **Permission errors:** Ensure the Kubernetes provider has sufficient RBAC permissions to create namespaces, deployments, secrets, and service accounts.
- **Certificate issues:** Regenerate the certificate using `altinitycloud-connect login` and ensure the PEM content is correctly formatted.

### Need Help?

If you encounter issues not covered above, please [create an issue](https://github.com/altinity/terraform-altinitycloud-connect-aws/issues/new) with detailed information about your problem.

## Contributing

Contributions are welcome! Please submit a Pull Request or open an issue for major changes. See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and advanced configuration examples.

## License

All code, unless specified otherwise, is licensed under the [Apache-2.0](LICENSE) license.
Copyright (c) 2022 Altinity, Inc.
