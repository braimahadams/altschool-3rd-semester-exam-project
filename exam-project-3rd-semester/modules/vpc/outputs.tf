#this is the VPC IDs output to use in EC2 module
output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}



#this is the subnet IDs output to use in EC2 module
output "subnet_ids" {
  value = [aws_subnet.myapp-subnet-1.id, aws_subnet.myapp-subnet-2.id]
}


