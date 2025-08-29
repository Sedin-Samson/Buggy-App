variable "public_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {
  type = string
}
variable "rds_identifier" {}
variable "rds_db_name" {}
variable "rds_engine" {}
variable "rds_engine_version" {}
variable "rds_instance_class" {}
variable "rds_username" {}
variable "rds_password" {}
variable "rds_allocated_storage" {
    type = number
}
variable "rds_port" {
    type = number
}
