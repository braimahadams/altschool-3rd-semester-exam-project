variable "vpc_cidr_block" {}
variable "environment_name" {}
variable "subnet_1_cidr_block" {}
variable "subnet_2_cidr_block" {}
variable "my_ip" {}
variable "public_key_location" {}
variable "instance_type" {}
variable "availability_zone" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}



variable "region" {
  description = "AWS region to create resource"
  default     = "eu-west-2"
}



variable "ami_id" {}

# Add other variables as needed


