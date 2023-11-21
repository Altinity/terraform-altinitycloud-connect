variable "pem" {
  type        = string
  description = "The contents of cloud-connect.pem generated by https://github.com/altinity/altinitycloud-connect login"
}

variable "url" {
  type    = string
  default = "https://anywhere.altinity.cloud"
}

variable "image" {
  type        = string
  description = "Custom Docker image (defaults to altinity/cloud-connect:$version)"
  default     = ""
}

variable "image_pull_policy" {
  type        = string
  description = "Image pull policy as described in https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy (defaults to \"IfNotPresent\" except when referred to latest master (in which case it's \"Always\"))"
  default     = ""
}

variable "wait_connected" {
  type        = bool
  description = "Wait for environment to be connected"
  default     = false
}

variable "wait_ready" {
  type        = bool
  description = "Wait for environment to be ready (to launch ClickHouse clusters & accept traffic) (implies connected)"
  default     = false
}

variable "wait_timeout_in_seconds" {
  type        = number
  description = "Max time to wait in seconds (45min by default)"
  default     = 2700
}

variable "namespace_annotations" {
  type        = map(string)
  description = "Map of annotations for `altinity-cloud-*` namespaces"
  default     = {}
}

variable "namespace_labels" {
  type        = map(string)
  description = "Map of labels for `altinity-cloud-*` namespaces"
  default     = {}
}
