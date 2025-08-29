resource "aws_ecs_cluster" "buggyapp_ecs_cluster" {
    name     = var.cluster_name
}

resource "aws_ecs_capacity_provider" "buggyapp_capacity_provider" {
    name     = var.cluster_cp_name
    auto_scaling_group_provider {
        auto_scaling_group_arn         = var.asg_arn
        managed_draining               = "ENABLED"
        managed_termination_protection = "DISABLED"

        managed_scaling {
            instance_warmup_period    = 300
            maximum_scaling_step_size = 10000
            minimum_scaling_step_size = 1
            status                    = "ENABLED"
            target_capacity           = 100
        }
    }
}


resource "aws_ecs_cluster_capacity_providers" "buggyapp_attachment" {
    cluster_name       = aws_ecs_cluster.buggyapp_ecs_cluster.name
    default_capacity_provider_strategy {
        base              = 0
        capacity_provider = aws_ecs_capacity_provider.buggyapp_capacity_provider.name
        weight            = 1
    }
    capacity_providers = [aws_ecs_capacity_provider.buggyapp_capacity_provider.name]
}