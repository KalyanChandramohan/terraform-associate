output "state_bucket_name" {
  value       = aws_s3_bucket.state.id
  description = "S3 bucket name to put in each backend.tf."
}

output "lock_table_name" {
  value       = aws_dynamodb_table.locks.name
  description = "DynamoDB table name to put in each backend.tf (dynamodb_table)."
}
