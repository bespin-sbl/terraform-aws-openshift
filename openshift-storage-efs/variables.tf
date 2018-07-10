//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the cluster into"
  default     = "ap-northeast-2"
}

variable "vpc_id" {
  description = "VPC to deploy the cluster into"
  default     = ""
}

variable "access_key" {
  description = "Access key to deploy the cluster into"
  default     = ""
}

variable "secret_key" {
  description = "Secret key to deploy the cluster into"
  default     = ""
}
