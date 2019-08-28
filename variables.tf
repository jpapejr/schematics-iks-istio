variable "resource_group" {
    default = "default"
}
variable "cluster_name" {}

variable "region" {
    default = "us-east"
}

variable "istio_version" {
  default = "1.2.5"
  description = "the Istio version to apply to the cluser"
}

variable "ibm_cloud_api_key" {}
variable "sl_username" {}
variable "sl_api_key" {}
