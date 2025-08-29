# ===============================================================================
# ========================= Launch template =======================================
# ===============================================================================
resource "aws_launch_template" "buggyapp_lt" {
  name           = var.lt_name
  image_id       = var.ami_image_id
  instance_type  = var.instance_type
  key_name       = var.key_name

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
  EOT
  )

  iam_instance_profile {
    arn = var.ec2_instance_profile_arn
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [var.ec2_sg_id]
  }
}

# ===============================================================================
# ========================= Auto Scaling =======================================
# ===============================================================================

resource "aws_autoscaling_group" "buggyapp-asg" {
    name                         = var.asg_name
    health_check_grace_period  = 30
    desired_capacity           = var.desired_capacity
    max_size                   = var.max_size
    min_size                   = var.min_size
    vpc_zone_identifier        = var.vpc_zone_identifier
    launch_template {
    id      = aws_launch_template.buggyapp_lt.id
    version = aws_launch_template.buggyapp_lt.latest_version
  }
    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = "ECS Instance - Buggy-App-Samson-Cluster"
    }
}

# ===============================================================================
# ========================= Load Balancer =======================================
# ===============================================================================
resource "aws_lb" "buggy_alb" {
    idle_timeout                                                 = 60
    internal                                                     = false
    enable_cross_zone_load_balancing                             = true
    enable_http2                                                 = true
    ip_address_type                                              = "ipv4"
    load_balancer_type                                           = var.load_balancer_type
    name                                                         = var.lb_name 
    name_prefix                                                  = null
    preserve_host_header                                         = false
    region                                                       = var.lb_region
    security_groups                                              = [var.lb_security_groups]
    subnets                                                      = var.lb_subnets
}

# ===============================================================================
# ========================= Target Group =======================================
# =============================================================================== 

resource "aws_lb_target_group" "buggy_tg" {
    name                              = var.tg_name
    port                              = var.tg_port
    vpc_id                            = var.vpc_id
    protocol                          = var.tg_protocol
    target_type                       = var.tg_target_type
    health_check {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "buggy_listener" {
  load_balancer_arn = aws_lb.buggy_alb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.buggy_tg.arn
    forward {
            target_group {
                arn    = aws_lb_target_group.buggy_tg.arn
                weight = 1
            }
        }
  }
}