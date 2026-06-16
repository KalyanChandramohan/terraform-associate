variable "user_name" {
  description = "The name of the IAM user to create."
  type        = string
  default     = "terraform_admin"

}

variable "github_repository" {
  description = "GitHub repo allowed to assume the OIDC role, as \"owner/repo\"."
  type        = string
}