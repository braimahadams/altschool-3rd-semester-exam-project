#this module is used to create the VPC in eu-west-2 region
module "vpc" {
  source              = "../../modules//vpc"
  vpc_cidr_block      = var.vpc_cidr_block      #"10.0.0.0/16"
  environment_name    = var.environment_name    #"development"
  subnet_1_cidr_block = var.subnet_1_cidr_block #"10.0.1.0/24"
  subnet_2_cidr_block = var.subnet_2_cidr_block #"10.0.2.0/24"
}

#this module is used to create the EC2 instances in the regoin specified in the provider.tf file
module "ec2" {
  source              = "/home/braimahadams/Desktop/altschool-3rd-semester-exam-project/terraform-files/modules//ec2"
  environment_name    = var.environment_name
  image_name          = var.image_name
  my_ip               = var.my_ip
  instance_type       = var.instance_type
  number_of_instances = var.number_of_instances
  vpc_cidr_block      = var.vpc_cidr_block
  subnet_1_cidr_block = var.subnet_1_cidr_block #"10.0.1.0/24"
  subnet_2_cidr_block = var.subnet_2_cidr_block
}
