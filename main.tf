data "ibm_resource_group" "resource_group" {
  name = "${var.resource_group}"
}

data "ibm_container_cluster" "cluster" {
    cluster_name_id     = "${var.cluster_name}"
    region              = "${var.region}"
    resource_group_id   = "${data.ibm_resource_group.resource_group.id}"
}


data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = "${data.ibm_container_cluster.cluster.id}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  region            = "${var.region}"
  config_dir        = "/tmp"
}

data "helm_repository" "istio" {
  name            = "istio.io"
  url             = "https://storage.googleapis.com/istio-release/releases/${var.istio_version}/charts/"
}

resource "helm_release" "istio_init" {
  name       = "istio-init"
  namespace  = "istio-system"
  repository = "${data.helm_repository.istio.metadata.0.name}"
  chart      =  "istio.io/istio-init"
}


resource "helm_release" "istio_release" {
  name       = "istio"
  namespace  = "istio-system"
  repository = "${data.helm_repository.istio.metadata.0.name}"
  chart      = "istio.io/istio"
  depends_on = ["helm_release.istio_init"]
}

