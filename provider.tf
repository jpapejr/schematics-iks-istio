provider "ibm" {
  ibmcloud_api_key = "${var.ibm_cloud_api_key}"
  softlayer_username = "${var.sl_username}"
  softlayer_api_key = "${var.sl_api_key}"
}

provider "kubernetes" {
    config_context_auth_info = "jtpape@us.ibm.com"
    config_context_cluster   = "${var.cluster_name}"
    config_path              = "${data.ibm_container_cluster_config.cluster_config.config_file_path}"
}

provider "helm" {
  kubernetes {
    config_path     = "${data.ibm_container_cluster_config.cluster_config.config_file_path}"
  }
  install_tiller  = true
  service_account = "tiller"
  namespace       = "kube-system"
}