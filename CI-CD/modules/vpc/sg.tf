resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH, HTTP, HTTPS for EC2"
  vpc_id      = aws_vpc.buggy-app-vpc.id

  tags = {
    Name = "Samson-EC2-SG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "ec2_https" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "rds_port" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "ec2_all" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
#====================================================================
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow ALB to access ECS tasks"
  vpc_id      = aws_vpc.buggy-app-vpc.id

  tags = {
    Name = "Samson-ECS-SG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "buggy_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_all" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
# ======================================================================

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow DB access only from ECS and EC2"
  vpc_id      = aws_vpc.buggy-app-vpc.id

  tags = {
    Name = "Samson-RDS-SG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "rds_from_ec2" {
  security_group_id            = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "rds_all" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
# =====================================================================

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow internet access to ALB"
  vpc_id      = aws_vpc.buggy-app-vpc.id

  tags = {
    Name = "Samson-ALB-SG"
  }
}

# Inbound: Allow HTTP (80) from anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Inbound: Allow HTTPS (443) from anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# Outbound: Allow ALB to connect to ECS tasks
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
