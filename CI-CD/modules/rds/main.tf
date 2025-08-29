resource "aws_db_subnet_group" "db_subnet" {
  name       = "buggyappsubnetsamson"
  subnet_ids = var.public_subnet_ids
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "db" {
    identifier              = var.rds_identifier
    db_name = var.rds_db_name
    engine = var.rds_engine
    engine_version = var.rds_engine_version
    instance_class = var.rds_instance_class
    username = var.rds_username
    password = var.rds_password
    port = var.rds_port
    skip_final_snapshot  = true
    allocated_storage    = var.rds_allocated_storage
    publicly_accessible = true
    vpc_security_group_ids = [var.rds_sg_id]
    db_subnet_group_name   = aws_db_subnet_group.db_subnet.name

}

# resource "random_password" "db" {
#   length  = 16
#   special = true
# }

# resource "aws_secretsmanager_secret" "db_password" {
#   name = "buggyapp-db-password"
# }

# resource "aws_secretsmanager_secret_version" "db_password_version" {
#   secret_id     = aws_secretsmanager_secret.db_password.id
#   secret_string = random_password.db.result
# }