variable "region" {
  description = "AWS region for the state bucket and lock table."
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform state."
  type        = string
  default     = "terraform-associate-tfstate-kalyanchandramohan"
}

variable "lock_table_name" {
  description = "DynamoDB table name for state locking."
  type        = string
  default     = "terraform-locks"
}
