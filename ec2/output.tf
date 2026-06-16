output "ec2" {
  value       = aws_instance.ec2_instance.id
  description = "The ID of the EC2 instance."

}