provider "aws" {
  region = var.vpc_region
}

# terraform {
#   backend "s3" {
#     bucket         = var.bucket_name   # Replace with your bucket name
#     key            = var.s3_path # Path inside the bucket
#     region         = var.vpc_region                # Region of your S3 bucket
#     encrypt        = true                          # Encrypt state file at rest
#   }
# }

terraform {
  backend "s3" {}
}
