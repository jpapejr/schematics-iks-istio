data "ibm_resource_group" "resource_group" {
  name = "${var.resource_group}"
}

resource "ibm_container_cluster" "cluster" {
  name              = "${var.cluster_name}-${random_id.name.hex}"
  region            = "${var.region}"
  datacenter        = "${var.datacenter}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  public_vlan_id    = "${var.public_vlan}"
  private_vlan_id   = "${var.private_vlan}"
  hardware          = "shared"
  machine_type      = "b3c.4x16"
  default_pool_size = 3
  
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = "${ibm_container_cluster.cluster.name}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  region            = "${var.region}"
  config_dir        = "/tmp"
}

provider "kubernetes" {
    config_context_auth_info = "jtpape@us.ibm.com"
    config_context_cluster   = "${ibm_container_cluster.cluster.name}"
    config_path              = "${data.ibm_container_cluster_config.cluster_config.config_file_path}"
}

resource "kubernetes_service_account" "tiller_service_account" {
  metadata {
    name       = "tiller"
    namespace  = "kube-system"
  }  
}

resource "kubernetes_cluster_role_binding" "tiller-cluster-admin" {
  metadata {
    name = "tiller-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"

  }
}

provider "helm" {
  kubernetes {
    config_path     = "${data.ibm_container_cluster_config.cluster_config.config_file_path}"
  }
  install_tiller  = true
  service_account = "tiller"
  namespace       = "kube-system"
}

data "helm_repository" "istio" {
  name = "istio.io"
  url  = "https://storage.googleapis.com/istio-release/releases/${var.istio_version}/charts/"
}

resource "helm_release" "istio_release" {
  name       = "istio"
  repository = "${data.helm_repository.istio.metadata.0.name}"
  chart      = "istio.io/istio"
}

resource "random_id" "name" {
  byte_length = 4
}