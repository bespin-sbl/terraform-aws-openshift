//  Setup the backend "s3".
terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "terraform-state-bespin-sbl-seoul"
    //bucket = "terraform-state-bespin-poc-seoul"
    //bucket = "terraform-nalbam-seoul"
    key = "openshift.tfstate"
  }
}

//  Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
}

//  Create the OpenShift cluster using our module.
module "openshift" {
  source          = "./modules/openshift"
  region          = "${var.region}"
  cluster_name    = "openshift"
  cluster_id      = "openshift-${var.region}"
  master_type     = "m4.xlarge"
  node_type       = "m4.xlarge"
  //vpc_id          = "vpc-0099424d46e49c8c1"
  vpc_cidr        = "10.0.0.0/16"
  key_name        = "openshift"
  public_key_path = "~/.ssh/id_rsa.pub"
  base_domain     = "opspresso.com"
}

//  Output some useful variables for quick SSH access etc.
output "a-console-url" {
  value = "https://${module.openshift.public_console}:8443"
}

output "master-public_dns" {
  value = "${module.openshift.master-public_dns}"
}
output "master-public_ip" {
  value = "${module.openshift.master-public_ip}"
}

output "master-node1_dns" {
  value = "${module.openshift.node1-public_dns}"
}
output "master-node1_ip" {
  value = "${module.openshift.node1-public_ip}"
}

output "master-node2_dns" {
  value = "${module.openshift.node2-public_dns}"
}
output "master-node2_ip" {
  value = "${module.openshift.node2-public_ip}"
}

output "bastion-public_dns" {
  value = "${module.openshift.bastion-public_dns}"
}
output "bastion-public_ip" {
  value = "${module.openshift.bastion-public_ip}"
}
