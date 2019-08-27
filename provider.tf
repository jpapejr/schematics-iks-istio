provider "ibm" {
  ibmcloud_api_key = "${var.ibm_cloud_api_key}"
  softlayer_username = "${var.sl_username}"
  softlayer_api_key = "${var.sl_api_key}"
}