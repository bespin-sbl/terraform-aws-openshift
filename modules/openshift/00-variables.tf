variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
}

variable "master_type" {
  description = "The size of the cluster nodes, e.g: m4.large. Note that OpenShift will not run on anything smaller than m4.large"
}

variable "node_type" {
  description = "The size of the cluster nodes, e.g: m4.large. Note that OpenShift will not run on anything smaller than m4.large"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
}

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: openshift"
}

variable "cluster_name" {
  description = "Name of the cluster, e.g: 'openshift'. Useful when running multiple clusters in the same AWS account."
}

variable "cluster_id" {
  description = "ID of the cluster, e.g: 'openshift-us-east-1'. Useful when running multiple clusters in the same AWS account."
}

variable "base_domain" {
  description = "Base domain of the cluster, e.g: openshift.com"
}

data "aws_availability_zones" "azs" {}
