variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
  default = "ami-0e38835daf6b8a2b9"
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
  default     = "t2.micro"
  
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance."
  type        = string
  default = "ec2"
}

variable "subnet_id" {
  description = "The ID of the subnet in which to launch the EC2 instance."
  type        = string
  default = "subnet-0c2202ea3c3532a98"
}

variable "instance_name" {
  description = "The name to assign to the EC2 instance."
  type        = string
  default = "test"
}