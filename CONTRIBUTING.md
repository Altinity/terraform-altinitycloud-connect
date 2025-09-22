# Contributing to Terraform Altinity.Cloud Kubernetes Connect Module

We welcome contributions to this Terraform module! This document provides guidelines for contributing and includes advanced configuration examples for development purposes.

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests if applicable
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Guidelines

- Follow Terraform best practices and conventions
- Update documentation when adding new features
- Ensure all examples are working and tested
- Keep the main README user-focused and move complex examples here

## Advanced Configuration Examples

The following examples are primarily intended for development and testing purposes.

### Custom Docker Image and Pull Policy

For development and testing with custom builds:

```terraform
module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "~> 0.133.0"

  pem               = file("cloud-connect.pem")
  image             = "altinity/cloud-connect:custom-tag"
  image_pull_policy = "Always"
}
```

### Custom Connection URL

For development environments that need to connect to a different endpoint:

```terraform
module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "~> 0.133.0"

  pem = file("cloud-connect.pem")
  url = "https://dev.altinity.cloud"
}
```

### Development with External Secret Management

For development workflows where secrets are managed externally:

```terraform
# Create secret externally
resource "kubernetes_secret_v1" "cloud_connect" {
  metadata {
    name      = "cloud-connect"
    namespace = "altinity-cloud-system"
  }
  data = {
    "cloud-connect.pem" = file("cloud-connect.pem")
  }
}

module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "~> 0.133.0"

  use_external_secret = true
  depends_on = [kubernetes_secret_v1.cloud_connect]
}
```

### Advanced Scheduling and Resource Configuration

For development environments with specific node requirements:

```terraform
module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "~> 0.133.0"

  pem = file("cloud-connect.pem")

  # Development node scheduling
  node_selector = {
    "kubernetes.io/os" = "linux"
    "node-type"        = "development"
  }

  tolerations = [
    {
      key      = "development"
      operator = "Equal"
      value    = "true"
      effect   = "NoSchedule"
    }
  ]

  # Development namespace configuration
  namespace_labels = {
    Environment = "development"
    Team        = "platform-dev"
  }
  namespace_annotations = {
    "dev.altinity.com/purpose" = "testing"
  }
}
```

## Testing

When contributing changes, please ensure:

- All Terraform configurations are valid (`terraform validate`)
- Examples work as expected with a valid Kubernetes cluster
- Test with different Kubernetes providers (EKS, GKE, AKS, etc.)
- Verify RBAC permissions work correctly
- Documentation is updated accordingly
- Follow the existing code style and conventions

## Questions?

If you have questions about contributing or need help with advanced configurations, please open an issue or reach out at [nacho@altinity.com](mailto:nacho@altinity.com)
