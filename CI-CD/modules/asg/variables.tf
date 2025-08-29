variable "cluster_name" {}
variable "ec2_sg_id" {}
variable "lt_name" {}
variable "ami_image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "ec2_instance_profile_arn" {}
variable "max_size" {
    type = number
}
variable "min_size" {
    type = number
}
variable "desired_capacity" {
    type = number
}
variable "vpc_zone_identifier" {}
variable "load_balancer_type" {}
variable "lb_name" {} 
variable "lb_region" {} 
variable "lb_security_groups" {} 
variable "lb_subnets" {} 


variable "tg_name" {} 
variable "tg_port" {} 
variable "tg_protocol" {} 
variable "tg_target_type" {} 
variable "vpc_id" {}

variable "lb_listener_port" {}
variable "lb_listener_protocol" {}

variable "asg_name" {}