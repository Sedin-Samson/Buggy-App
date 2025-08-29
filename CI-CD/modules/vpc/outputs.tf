output "vpc_id" {
  value = aws_vpc.buggy-app-vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
