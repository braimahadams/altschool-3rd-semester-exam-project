variable "region" {
  description = "AWS region to create resource"
  default     = "eu-west-2"
}


variable "instance_type" {
  description = "The type of EC2 instance"
  default     = "t2.micro"
}

variable "regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2"]
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

