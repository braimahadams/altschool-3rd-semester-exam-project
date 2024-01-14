#create a VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.environment_name}-vpc"
    vpc_env = var.environment_name
  }
}



#create 1st public subnet
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id                  = aws_vpc.myapp-vpc.id
  cidr_block              = var.subnet_1_cidr_block
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment_name}-subnet-1"
  }
}



#create 2nd public subnet
resource "aws_subnet" "myapp-subnet-2" {
  vpc_id                  = aws_vpc.myapp-vpc.id
  cidr_block              = var.subnet_2_cidr_block
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment_name}-subnet-2"
  }
}



#create internet gateway
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.environment_name}-igw"
  }
}



#create route-table to route the IGW to the VPC
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.environment_name}-public-route-table"
  }
}



# associate public subnet 1 to "public route table" above
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}



# associate public subnet 2 to "public route table" above
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.myapp-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}
