terraform {
  cloud {
    organization = "vitiya99-personal"

    workspaces {
      name = "poc-on-tf"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "personal-tf"
}

resource "aws_sesv2_email_identity" "dev-sender" {
  email_identity = "virajlakshithabandara+ses@gmail.com"
}