//  Setup the backend "s3".
terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "terraform-state-bespin-sbl-seoul"
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
  ami_type        = "m4.large"    //  Smallest that meets the min specs for OS
  vpc_cidr        = "10.0.0.0/16"
  subnet_cidr     = "10.0.1.0/24"
  key_name        = "bespin-sbl"
  cluster_name    = "openshift"
  cluster_id      = "openshift-${var.region}"
  base_domain     = "opspresso.com"
}

//  Output some useful variables for quick SSH access etc.
output "console-url" {
  value = "https://${module.openshift.public_console}:8443"
}

//output "master-url" {
//  value = "https://${module.openshift.master-public_ip}.xip.io:8443"
//}
output "master-public_dns" {
  value = "${module.openshift.master-public_dns}"
}
output "master-public_ip" {
  value = "${module.openshift.master-public_ip}"
}

output "bastion-public_dns" {
  value = "${module.openshift.bastion-public_dns}"
}
output "bastion-public_ip" {
  value = "${module.openshift.bastion-public_ip}"
}
