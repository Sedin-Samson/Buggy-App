module "vpc" {
    source = "./modules/vpc"
    vpc_cidr_block = var.vpc_cidr_block
    vpc_region = var.vpc_region

    availability_zones   = var.availability_zones
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs

}
module "rds" {
    source = "./modules/rds"
    public_subnet_ids = module.vpc.public_subnet_ids
    rds_sg_id          = module.vpc.rds_sg_id
    rds_identifier = var.rds_identifier
    rds_db_name = var.rds_db_name
    # rds_db_name = var.rds_password
    rds_engine = var.rds_engine
    rds_engine_version = var.rds_engine_version
    rds_instance_class = var.rds_instance_class
    rds_username = var.rds_username
    rds_password = var.rds_password
    rds_allocated_storage = var.rds_allocated_storage
    rds_port = var.rds_port
}
module "iam" {
    source = "./modules/iam"
    ecs_role_name = var.ecs_role_name
    ecs_trusted_service = var.ecs_trusted_service 
    ec2_role_name = var.ec2_role_name
    ec2_trusted_service = var.ec2_trusted_service
}
module "ecr" {
    source = "./modules/ecr"
    ecr_base_name = var.ecr_base_name
    ecr_app_name = var.ecr_app_name
}
module "ecs" {
    source = "./modules/ecs"
    asg_arn = module.asg.asg_arn
    cluster_cp_name = var.cluster_cp_name
    cluster_name = var.cluster_name
    # log_group = var.log_group Not needed we specify a task family name 

    # Task Definition Container attributes
    region = var.vpc_region
    host_port = var.host_port
    container_port = var.container_port
    image = var.image # Need to Pass a value while building a image
    container_name = var.container_name

    # Environment variable for task definition 
    db_host = module.rds.db_endpoint # module.rds.db_endpoint # < For testing purpose 
    db_name = var.rds_db_name
    db_user = var.rds_username
    db_password = var.rds_password

    # Task definition variable 
    task_family = var.task_family
    requires_compatibilities = var.requires_compatibilities
    network_mode = var.network_mode
    task_memory = var.task_memory
    task_cpu = var.task_cpu
    execution_role_arn = module.iam.ecs_role_arn
    task_role_arn = module.iam.ecs_role_arn
    cpu_architecture        = var.cpu_architecture 
    operating_system_family = var.operating_system_family

    vpc_region = var.vpc_region
    target_group_arn = module.asg.target_group_arn
    ecs_service_security_groups = module.vpc.ecs_sg_id
    ecs_service_subnet = module.vpc.public_subnet_ids
    service_name = var.service_name
}

module "asg" {
  source = "./modules/asg"

  cluster_name             = var.cluster_name
  ec2_sg_id                = module.vpc.ec2_sg_id
  instance_type            = var.instance_type 
  key_name                 = var.key_name
  lt_name                  = var.lt_name
  ami_image_id                 = var.ami_image_id
  ec2_instance_profile_arn = module.iam.ec2_instance_profile_arn

  vpc_zone_identifier = module.vpc.public_subnet_ids
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity

  lb_subnets = module.vpc.public_subnet_ids
  lb_security_groups  = module.vpc.alb_sg_id
  lb_region = var.vpc_region
  load_balancer_type = var.load_balancer_type
  lb_name = var.lb_name

  tg_target_type = var.tg_target_type
  tg_protocol = var.tg_protocol
  tg_port = var.tg_port
  tg_name = var.tg_name

  vpc_id = module.vpc.vpc_id

  lb_listener_port = var.lb_listener_port
  lb_listener_protocol = var.lb_listener_protocol

  asg_name = var.asg_name 
}

# module "s3" {
#     source = "./modules/s3"
#     bucket_name = var.bucket_name
# }

