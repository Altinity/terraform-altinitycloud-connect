# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.61.0...HEAD)

## [0.61.0](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.22.0...v0.61.0)

### Added
- `ClickHouseKeeperInstallation` to the list of accessible CRDs (clickhouse-operator@0.23.0+).

## [0.22.0](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.21.0...v0.22.0)

### Added
- `use_external_secret` variable to control whether `altinity-cloud-system/cloud-connect` secret is created 
by the module or supplied externally.

### Changed 
- `altinitycloud_cloud_connect` deployment resource to be created after the secret (if provided).  

## [0.21.0](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.20.0...v0.21.0)

### Added
- `namespace_labels` to allow support for disabling namespace wide configuration like `istio`

## [0.20.0](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.9.3...v0.20.0)

### Added
- TLS cert auto-renewal/hot-reload.
- Support for disconnecting Kubernetes clusters from Altinity.Cloud via
`altinitycloud-connect kubernetes-disconnnect | kubectl delete -f -`.
- `/debug/vars` introspection endpoint.
- AWS/GCP provisioning capabilities.

## [0.9.3](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.9.0...v0.9.3)

### Fixed
- `wait_connected` taking precedence over `wait_ready` when both are set.

## [0.9.0](https://github.com/Altinity/terraform-altinitycloud-connect/compare/v0.6.0...v0.9.0)

### Added
- `wait_connected` & `wait_ready` variables that can be used to wait for the 
environment to be connected/ready (both false by default).
- `namespace_annotations` variable for attaching extra annotations to 
`altinity-cloud-*` namespaces (empty by default).
- `clickhouse_namespace` output.

### Fixed
- `altinity-cloud:node-metrics-view`, `altinity-cloud:storage-class-view` & 
`altinity-cloud:persistent-volume-view` role bindings.
