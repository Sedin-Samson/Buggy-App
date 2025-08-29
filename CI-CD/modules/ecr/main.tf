resource "aws_ecr_repository" "base-repo-buggy-app-" {
  name                 = var.ecr_base_name 
  image_tag_mutability = "MUTABLE"
}
resource "aws_ecr_repository" "app-repo-buggy-app-" {
  name                 = var.ecr_app_name 
  image_tag_mutability = "MUTABLE"
}