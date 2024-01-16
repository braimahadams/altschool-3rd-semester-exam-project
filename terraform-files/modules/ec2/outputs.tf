# This file is used to output the values of the instances created by the EC2 module.
output "instance-ids" {
  value = aws_instance.myapp-instance[*].id
}


