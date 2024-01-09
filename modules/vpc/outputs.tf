output "vpc_id" {
  value = aws_vpc.myapp_vpc.id
}

output "1st_subnet_id" {
  value = aws_subnet.myapp_subnet_1.id
}

output "2nd_subnet_id" {
  value = aws_subnet.myapp_subnet_2.id
}

