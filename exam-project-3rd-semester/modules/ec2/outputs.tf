output "instance-ids" {
  value = aws_instance.myapp-instance[*].id
}


