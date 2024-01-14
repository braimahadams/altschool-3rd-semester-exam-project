#calls the VPC module, so we can use the VPC details *output* as an *input* in this EC2 module
module "vpc" {
  source              = "/home/braimahadams/Desktop/CONTINUE-PROJECT-ALT/terraform/modules/vpc"
  vpc_cidr_block      = "10.0.0.0/16"
  environment_name    = "development"
  subnet_1_cidr_block = "10.0.1.0/24"
  subnet_2_cidr_block = "10.0.2.0/24"
}



#reconfigure the defualt firewall
resource "aws_security_group" "new-security-group" {

  vpc_id = module.vpc.vpc_id 
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.environment_name}-new-security group"
  }
}




#location of your key_pair
resource "aws_key_pair" "ssh-key" {
  key_name   = "MyKeyPair"
  public_key = file("~/.ssh/id_rsa.pub")
}



#create 2 ec2 instance
resource "aws_instance" "myapp-instance" {
  count                       = length(var.availability_zone)
  instance_type               = var.instance_type
  ami           = var.ami_id

  subnet_id                   = module.vpc.subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.new-security-group.id]
  availability_zone           = var.availability_zone[count.index]
  
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name
  user_data                   = file("ansible-docker.sh")

  tags = {
    Name = "instance-${count.index + 1}-${var.availability_zone[count.index]}"
  }
}


