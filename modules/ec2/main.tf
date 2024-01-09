#reconfigure the defualt firewall
resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

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
    Name = "${var.enviroment_name}-default-sg"
  }
}



#location of your key_pair
resource "aws_key_pair" "ssh-key" {
    key_name = "practice-keypair"
    public_key = file(var.public_key_location)
}


#create 2 ec2 instance
resource "aws_instance" "myapp-server" {


    count = var.count
    ami = var.ami
    instance_type = var.type


    subnet_id = subnet_id = count.index == 0 ? aws_subnet.public_subnet_az1 : aws_subnet.public_subnet_az2.id
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]
    availability_zone = count.index == 0 ? data.aws_availability_zones.available_zones.names[0] : data.aws_availability_zones.available_zones.names[1]


    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name


    user_data = file("ansible-docker.sh")

    tags = {
        Name = "${var.enviroment_name}-server"
    }
}


