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
  vpc_id       = "vpc-74755b1c"
  vpc_cidr     = "10.0.0.0/16"
  access_key   = "${aws.access_key.value}"
  secret_key   = "${aws.secret_key.value}"
}

output "efs-id" {
  value = "${module.openshift.efs-id}"
}

output "efs-dns_name" {
  value = "${module.openshift.efs-dns_name}"
}
