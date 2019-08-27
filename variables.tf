variable "public_vlan" {}
variable "private_vlan" {}
variable "resource_group" {
    default = "default"
}
variable "cluster_name" {}
variable "datacenter" {}
variable "region" {
    default = "us-east"
}
variable "private_service_endpoint" {
  default = "false"
}

variable "trigger_token" {
  default = "1"
  description = "token to force running the provisioner. Change value to force running against cluster"
}

variable "istio_version" {
  default = "1.2.5"
  description = "the Istio version to apply to the cluser"
}

variable "ibm_cloud_api_key" {}
variable "sl_username" {}
variable "sl_api_key" {}
