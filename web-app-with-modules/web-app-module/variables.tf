variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "ap-south-1"
}

variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "web-app"
}

variable "environment_name" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "ami" {
  description = "Amazon machine image for EC2 instance"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t3.nano"
}

variable "bucket_prefix" {
  description = "Prefix for AWS S3 bucket"
  type        = string
}

variable "create_dns_zone" {
  description = "Create DNS Zone? (if true, create new zone, else use existing)"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Web App domain address"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}
