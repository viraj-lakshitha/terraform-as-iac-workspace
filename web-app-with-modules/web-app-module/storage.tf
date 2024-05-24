resource "aws_s3_bucket" "bucket_storage" {
  bucket_prefix = var.bucket_prefix
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_storage_ver" {
  bucket = aws_s3_bucket.bucket_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_storage_sse_conf" {
  bucket = aws_s3_bucket.bucket_storage.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}