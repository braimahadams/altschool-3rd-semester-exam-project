variable "vpc_cidr_block" {}

variable "environment_name" {}

variable "subnet_1_cidr_block" {}

variable "subnet_2_cidr_block" {}

variable "availability_zone" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}



