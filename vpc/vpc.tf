//vpc configs

resource "aws_vpc" "dev_vpc" {
  cidr_block       = var.ipv4_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
  }

}