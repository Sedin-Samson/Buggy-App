resource "aws_ecs_task_definition" "buggyapp_task_definition" {
  family                   = var.task_family
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn

  container_definitions = templatefile(
  "${path.module}/templates/task_definition.json.tpl",
  {
    image           = var.image
    container_port  = var.container_port
    host_port       = var.host_port
    log_group       = "/ecs/${var.task_family}"
    region          = var.region
    container_name  = var.container_name

    # environment variables
    db_host     = var.db_host
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
  }
)


  runtime_platform {
    cpu_architecture        = var.cpu_architecture 
    operating_system_family = var.operating_system_family
  }
}
