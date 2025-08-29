resource "aws_s3_bucket" "buggyapp_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.buggyapp_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}