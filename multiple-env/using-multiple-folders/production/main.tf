terraform {
  # set backend to default as 'local'
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "personal-tf"
}

locals {
  environment_name = "production"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket_prefix = "researchanddev-${local.environment_name}"
  force_destroy = true

  tags = {
    ProvisionedEnvironment = "${local.environment_name}"
  }
}

resource "aws_s3_bucket_versioning" "storage_bucket_ver" {
  bucket = aws_s3_bucket.storage_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "storage_bucket_sse" {
  bucket = aws_s3_bucket.storage_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
