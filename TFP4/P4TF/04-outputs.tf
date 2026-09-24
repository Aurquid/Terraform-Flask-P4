output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.p4_ec2.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.p4_ec2.public_ip
}

output "ssm_connection_command" {
  description = "Command to connect via SSM Session Manager"
  value       = "aws ssm start-session --target ${aws_instance.p4_ec2.id}"
}
