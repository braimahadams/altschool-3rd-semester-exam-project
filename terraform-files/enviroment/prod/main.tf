module "vpc" {
  source              = "../../modules//vpc"
  vpc_cidr_block      = var.vpc_cidr_block      #"10.0.0.0/16"
  environment_name    = var.environment_name    #"development"
  subnet_1_cidr_block = var.subnet_1_cidr_block #"10.0.1.0/24"
  subnet_2_cidr_block = var.subnet_2_cidr_block #"10.0.2.0/24"
}