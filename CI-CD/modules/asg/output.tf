output "asg_arn" {
  value = aws_autoscaling_group.buggyapp-asg.arn
}

output "target_group_arn" {
  value       = aws_lb_target_group.buggy_tg.arn
}
