resource "aws_ecs_service" "buggyapp-service" {
    availability_zone_rebalancing      = "ENABLED"
    cluster                            = aws_ecs_cluster.buggyapp_ecs_cluster.arn
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100
    desired_count                      = 1
    enable_ecs_managed_tags            = true
    enable_execute_command             = false
    health_check_grace_period_seconds  = 0
    #iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
    launch_type                        = "EC2"
    name                               = var.service_name
    platform_version                   = null
    propagate_tags                     = "NONE"
    region                             = var.vpc_region
    scheduling_strategy                = "REPLICA"
    tags                               = {}
    tags_all                           = {}
    task_definition                    = aws_ecs_task_definition.buggyapp_task_definition.arn #"Buggy-Task-Defenition-Samson:42"
    triggers                           = {}

    deployment_circuit_breaker {
        enable   = true
        rollback = true
    }

    deployment_controller {
        type = "ECS"
    }

    load_balancer {
        container_name   = var.container_name
        container_port   = 3000
        elb_name         = null
        target_group_arn = var.target_group_arn
    }

    network_configuration {
        assign_public_ip = false
        security_groups  = [var.ecs_service_security_groups,]
        subnets = var.ecs_service_subnet
    }

    ordered_placement_strategy {
        field = "attribute:ecs.availability-zone"
        type  = "spread"
    }
    ordered_placement_strategy {
        field = "instanceId"
        type  = "spread"
    }
}