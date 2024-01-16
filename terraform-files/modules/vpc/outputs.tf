#this is the VPC IDs output to use in EC2 module
output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}


#this is the subnet IDs output to use in EC2 module
output "subnet_ids" {
  value = [aws_subnet.myapp-subnet-1.id, aws_subnet.myapp-subnet-2.id]
}


#this is the availability zones output to use in EC2 module
output "availability_zones" { 
  value = [data.aws_availability_zones.region-availability-zones.names[0], data.aws_availability_zones.region-availability-zones.names[1]]  
}