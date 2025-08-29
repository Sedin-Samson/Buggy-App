# Task Definition Attributes
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "task_memory" {}
variable "network_mode" {}
variable "requires_compatibilities" {}
variable "task_family" {}
variable "task_cpu" {}
variable "cpu_architecture" {}
variable "operating_system_family" {}

# Task definition container attributes 
variable "image" {}
variable "container_port" {}
variable "host_port" {}
variable "region" {}
variable "container_name" {} 

# Environment variables for container buggy app
variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}

# Cluster Related Attributes
variable "asg_arn" {}
variable "cluster_cp_name" {}
variable "cluster_name" {}


variable "target_group_arn" {}
variable "vpc_region" {}

variable "ecs_service_security_groups" {}
variable "ecs_service_subnet" {}
variable "service_name" {}