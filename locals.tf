locals {
  release = trimspace(file("${path.module}/version"))
}
