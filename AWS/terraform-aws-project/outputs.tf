// filepath: terraform-aws-project/outputs.tf
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.Ubuntu_web_server.id # Utilise le nom correct de la ressource
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.Ubuntu_web_server.public_ip # Utilise le nom correct de la ressource
}

