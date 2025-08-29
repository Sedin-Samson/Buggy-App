resource "aws_vpc" "buggy-app-vpc" {
    enable_dns_support   = true
    enable_dns_hostnames = true
    cidr_block = var.vpc_cidr_block
    region     = var.vpc_region
    tags = {
    Name = "samson-vpc-buggyapp"
  }
}

