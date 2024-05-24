terraform {
  # Take defualt as backend as "local"
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

variable "database_password_1" {
  description = "Password for WebApp Conf 01"
  type        = string
  sensitive   = true
}

variable "database_password_2" {
  description = "Password for WebApp Conf 01"
  type        = string
  sensitive   = true
}

module "web_app_1" {
  source = "../web-app-module"

  # Variable for Module
  bucket_prefix    = "researchdev-dev"
  domain           = "researchdev-dev.dev"
  app_name         = "researchdev-dev"
  environment_name = "dev"
  instance_type    = "t3.nano"
  create_dns_zone  = true
  db_name          = "researchdev-dev"
  db_username      = "app_user"
  db_password      = var.database_password_1
}

module "web_app_2" {
  source = "../web-app-module"

  # Variable for Module
  bucket_prefix    = "researchdev-staging"
  domain           = "researchdev-staging.dev"
  app_name         = "researchdev-staging"
  environment_name = "staging"
  instance_type    = "t3.nano"
  create_dns_zone  = true
  db_name          = "researchdev-staging"
  db_username      = "app_user"
  db_password      = var.database_password_1
}
