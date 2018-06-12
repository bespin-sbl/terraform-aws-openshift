variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
}

variable "cluster_name" {
  description = "Name of the cluster, e.g: 'openshift'. Useful when running multiple clusters in the same AWS account."
}

variable "cluster_id" {
  description = "ID of the cluster, e.g: 'openshift-us-east-1'. Useful when running multiple clusters in the same AWS account."
}

variable "master_type" {
  description = "The size of the cluster master nodes, e.g: m4.large. Note that OpenShift will not run on anything smaller than m4.large"
  default = "m4.large"
}

variable "worker_type" {
  description = "The size of the cluster worker nodes, e.g: m4.large. Note that OpenShift will not run on anything smaller than m4.large"
  default = "m4.large"
}

variable "vpc_id" {
  description = "The VPC ID."
  default = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
  default = "10.0.0.0/16"
}

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: openshift"
  default = "openshift"
}

variable "public_key_path" {
  description = "The local public key path, e.g. ~/.ssh/id_rsa.pub"
  default = ""
}

variable "base_domain" {
  description = "Base domain of the cluster, e.g: openshift.com"
  default = ""
}

data "aws_availability_zones" "azs" {}
