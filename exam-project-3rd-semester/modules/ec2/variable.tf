variable "my_ip" {}
variable "environment_name" {}
variable "public_key_location" {}

variable "availability_zone" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "region" {}
variable "ami_id" {}
variable "instance_type" {}
# Add other variables as needed
