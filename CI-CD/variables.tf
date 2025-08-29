# ================================================
# ===================== VPC ======================
# ================================================ 
variable "vpc_cidr_block" {}
variable "vpc_region" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
# ================================================
# ===================== RDS ======================
# ================================================ 

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

# ================================================
# ===================== IAM ======================
# ================================================ 

variable "ecs_role_name" {}
variable "ecs_trusted_service" {}
variable "ec2_trusted_service" {}
variable "ec2_role_name" {}

# ================================================
# ===================== ECR ======================
# ================================================ 

variable "ecr_app_name" {}
variable "ecr_base_name" {}

# ================================================
# ===================== ECS ======================
# ================================================ 

# Task Definition Attributes
# variable "execution_role_arn" {}
# variable "task_role_arn" {}
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
# variable "region" {}

# Environment variables for container buggy app
# variable "db_host" {} # < -- Not Needed becasue we will assign in runtime 
variable "container_name" {}  
# variable "db_user" {}
# variable "db_password" {}

# Cluster Capacity Provider 

variable "cluster_cp_name" {}
variable "bucket_name" {}
variable "service_name" {}


# ================================================
# ===================== ASG ======================
# ================================================ 

# Launch Template 
variable "lt_name" {}
variable "ami_image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "cluster_name" {} # We can use this for asg and ecs 

# Auto scaling 
variable "asg_name" {}
variable "max_size" {
    type = number
}
variable "min_size" {
    type = number
}
variable "desired_capacity" {
    type = number
}

# Load Balancer 
variable "load_balancer_type" {}
variable "lb_name" {} 
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}

# Target Group 
variable "tg_name" {} 
variable "tg_port" {} 
variable "tg_protocol" {} 
variable "tg_target_type" {} 







