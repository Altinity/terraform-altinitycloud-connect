# terraform-altinitycloud-connect

Terraform module for connecting your Kubernetes clusters to [Altinity.Cloud](https://altinity.cloud/anywhere).  
If you're looking for way to manage ClickHouse clusters via Terraform,
see [terraform-provider-altinitycloud](https://github.com/altinity/terraform-provider-altinitycloud).

## Usage

```terraform
provider "kubernetes" {
  # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs 
}

module "altinitycloud_connect" {
  source  = "altinity/connect/altinitycloud"
  version = "0.9.3"
  # cloud-connect.pem is produced by `altinitycloud-connect login`.
  # See https://github.com/altinity/altinitycloud-connect for details.
  pem = file("cloud-connect.pem")
}
```

## Legal

All code, unless specified otherwise, is licensed under the [Apache-2.0](LICENSE) license.  
Copyright (c) 2022 Altinity, Inc.
