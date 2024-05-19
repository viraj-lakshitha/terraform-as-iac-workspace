variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS Profile configured in your machine"
  type        = string
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "instance_ami" {
  description = "Amazon machine image to use for EC2 instance"
  type        = string
}

variable "rds_db_name" {
  description = "AWS RDS Database Name"
  type        = string
}

variable "rds_db_user" {
  description = "AWS RDS Username"
  type        = string
}

variable "rds_db_password" {
  description = "AWS RDS Password"
  type        = string
  sensitive   = true
}
