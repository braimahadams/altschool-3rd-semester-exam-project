#create a VPC
resource "aws_vpc" "myapp_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.enviroment_name}-vpc"
  }
}



# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


#create 1st public subnet
resource "aws_subnet" "myapp_subnet_1" {
  vpc_id                  = aws_vpc.myapp_vpc.id
  cidr_block              = var.vpc_cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.enviroment_name}-subnet-1"
  }
}


#create 2nd public subnet
resource "aws_subnet" "myapp_subnet_2" {
  vpc_id                  = aws_vpc.myapp_vpc.id
  cidr_block              = var.vpc_cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.enviroment_name}-subnet-2"
  }
}



#create internet gateway
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp_vpc.id
  tags = {
    Name = "${var.enviroment_name}-igw"
  }
}



#create route-table to route the IGW to the VPC
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.enviroment_name}-public-route-table"
  }
}



# associate public subnet 1 to "public route table" above
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.myapp_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}



# associate public subnet 2 to "public route table" above
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.myapp_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}



