terraform {
  backend "s3" {
    bucket         = "terraform-associate-tfstate-kalyanchandramohan"
    key            = "user_management/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
