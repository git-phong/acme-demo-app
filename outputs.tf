output "instance_private_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.app_server.private_dns
}

output "instance_public_IP_address" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.app_server.public_ip
}

output "instance_security_group_ids" {
  value = aws_instance.app_server.vpc_security_group_ids
}

output "instance_subnet" {
  value = aws_instance.app_server.subnet_id
}