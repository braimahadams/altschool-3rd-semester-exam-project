module "vpc" {
  source              = "/home/braimahadams/Desktop/CONTINUE-PROJECT-ALT/terraform/modules/vpc"
  vpc_cidr_block      = "10.0.0.0/16"
  environment_name    = "development"
  subnet_1_cidr_block = "10.0.1.0/24"
  subnet_2_cidr_block = "10.0.2.0/24"
  availability_zone   = var.availability_zone
}


module "ec2-eu-west-2" {
  source              = "/home/braimahadams/Desktop/CONTINUE-PROJECT-ALT/terraform/modules/ec2"
  region              = "eu-west-2"
  ami_id              = "ami-0e5f882be1900e43b"
  vpc_id              = module.vpc.vpc_id
  environment_name    = "development"
  my_ip               = "84.236.123.54/32"
  public_key_location = "~/.ssh/id_rsa.pub"
  instance_type       = "t2.micro"
}
