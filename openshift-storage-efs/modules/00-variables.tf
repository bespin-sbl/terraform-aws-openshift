variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
}

variable "cluster_name" {
  description = "Name of the cluster, e.g: 'openshift'. Useful when running multiple clusters in the same AWS account."
}

variable "cluster_id" {
  description = "ID of the cluster, e.g: 'openshift-us-east-1'. Useful when running multiple clusters in the same AWS account."
}

variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "access_key" {
  description = "Access key"
  default     = ""
}

variable "secret_key" {
  description = "Secret key"
  default     = ""
}

data "aws_availability_zones" "azs" {}
