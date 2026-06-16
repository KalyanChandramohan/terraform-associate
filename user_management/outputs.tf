output "access_key" {
  value       = aws_iam_access_key.user_key.id
  description = "The access key ID for the IAM user."

}

output "secret_key" {
  value       = aws_iam_access_key.user_key.secret
  description = "The secret access key for the IAM user."
  sensitive   = true

}