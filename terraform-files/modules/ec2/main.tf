#calls the VPC module, so we can use the VPC details *output* as an *input* in this EC2 module
module "vpc" {
  source              = "../vpc"
  environment_name    = var.environment_name
  vpc_cidr_block      = var.vpc_cidr_block
  subnet_1_cidr_block = var.subnet_1_cidr_block
  subnet_2_cidr_block = var.subnet_2_cidr_block
}

#configure the security group
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



#this is to filter the AMI to use
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID for official Ubuntu AMIs

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#create an ec2 instance
resource "aws_instance" "myapp-instance" {
  count         = var.number_of_instances
  instance_type = var.instance_type
  ami           = data.aws_ami.latest_ubuntu.id

  subnet_id              = module.vpc.subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.new-security-group.id]
  availability_zone      = module.vpc.availability_zones[count.index]

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name
  user_data                   = file("ansible-docker.sh")

  tags = {
    Name = "instance-${count.index + 1}-${module.vpc.subnet_ids[count.index]}"
  }
}


