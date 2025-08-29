variable "vpc_cidr_block" {}
variable "vpc_region" {}
# variable "private1_cidr" {}
# variable "private2_cidr" {}
# variable "public1_cidr" {}
# variable "public2_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
