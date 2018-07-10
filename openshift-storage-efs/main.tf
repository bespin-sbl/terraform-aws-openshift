//  Setup the backend "s3".
terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "terraform-state-bespin-sbl-seoul"
    key    = "openshift-storage.tfstate"
  }
}

//  Setup the core provider information.
provider "aws" {
  region = "${var.region}"
}

//  Create the OpenShift cluster using our module.
module "openshift" {
  source       = "./modules"
  region       = "${var.region}"
  cluster_name = "openshift"
  cluster_id   = "openshift-${var.region}"
  vpc_id       = "${var.vpc_id}"
  vpc_cidr     = "10.0.0.0/16"
  access_key   = "${var.access_key}"
  secret_key   = "${var.secret_key}"
}

output "efs-id" {
  value = "${module.openshift.efs-id}"
}

output "efs-dns_name" {
  value = "${module.openshift.efs-dns_name}"
}
