//  Setup the backend "s3".
terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "terraform-state-bespin-sbl-seoul"
    key    = "openshift.tfstate"
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
  master_type  = "m4.xlarge"
  worker_type  = "m4.xlarge"

  //vpc_id          = "vpc-0099424d46e49c8c1"
  vpc_cidr        = "10.0.0.0/16"
  key_name        = "openshift"
  public_key_path = "~/.ssh/id_rsa.pub"
  base_domain     = "opspresso.com"
}

//  Output some useful variables for quick SSH access etc.
output "admin-url" {
  value = "https://${module.openshift.console-public}:8443"
}

output "master1-public_dns" {
  value = "${module.openshift.master1-public_dns}"
}

output "master1-public_ip" {
  value = "${module.openshift.master1-public_ip}"
}

output "master2-public_dns" {
  value = "${module.openshift.master2-public_dns}"
}

output "master2-public_ip" {
  value = "${module.openshift.master2-public_ip}"
}

output "master3-public_dns" {
  value = "${module.openshift.master3-public_dns}"
}

output "master3-public_ip" {
  value = "${module.openshift.master3-public_ip}"
}

output "node1-public_dns" {
  value = "${module.openshift.node1-public_dns}"
}

output "node1-public_ip" {
  value = "${module.openshift.node1-public_ip}"
}

output "node2-public_dns" {
  value = "${module.openshift.node2-public_dns}"
}

output "node2-public_ip" {
  value = "${module.openshift.node2-public_ip}"
}

output "infra1-public_dns" {
  value = "${module.openshift.infra1-public_dns}"
}

output "infra1-public_ip" {
  value = "${module.openshift.infra1-public_ip}"
}

output "infra2-public_dns" {
  value = "${module.openshift.infra2-public_dns}"
}

output "infra2-public_ip" {
  value = "${module.openshift.infra2-public_ip}"
}

output "bastion-public_dns" {
  value = "${module.openshift.bastion-public_dns}"
}

output "bastion-public_ip" {
  value = "${module.openshift.bastion-public_ip}"
}

output "efs-id" {
  value = "${module.openshift.efs-id}"
}

output "efs-dns_name" {
  value = "${module.openshift.efs-dns_name}"
}
