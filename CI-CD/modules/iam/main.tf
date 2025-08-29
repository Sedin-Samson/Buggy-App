# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "Buggyapp-ECSTaskExecutionRole-Samson"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_cloudwatch" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }

resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_role_name

  assume_role_policy = templatefile(
    "${path.module}/templates/base_role.json.tpl",
    {
      service = var.ecs_trusted_service
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_readonly_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role" "ec2_role" {
  name = var.ec2_role_name

  assume_role_policy = templatefile(
    "${path.module}/templates/base_role.json.tpl",
    {
      service = var.ec2_trusted_service
    }
  )
}

resource "aws_iam_role_policy_attachment" "ec2_ecs_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_container_service" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "Buggyapp-EC2-InstanceProfile-Samson"
  role = aws_iam_role.ec2_role.name
}



