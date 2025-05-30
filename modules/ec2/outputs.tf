output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}

output "instance_type" {
  value = aws_instance.instance.instance_type
}
