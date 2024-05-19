terraform {
  cloud {
    organization = "vitiya99-personal"
    workspaces {
      name = "value"
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
  profile = "personal-tf"
  region = "ap-south-1"
}

# Define replica instances
resource "aws_instance" "web_app_replica_1" {
  ami = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.nano"
  security_groups = [aws_security_group.instances.name]
  user_data = <<-EOF
          #!/bin/bash
          echo "Hello World 1" > index.html
          python3 -m http.server 8080 &
          EOF
}

resource "aws_instance" "web_app_replica_2" {
  ami = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.nano"
  security_groups = [aws_security_group.instances.name]
  user_data = <<-EOF
          #!/bin/bash
          echo "Hello World 2" > index.html
          python3 -m http.server 8080 &
          EOF
}

# Provision S3 storage bucket, versioning and encryption
resource "aws_s3_bucket" "web_app_storage" {
  bucket = "viraj_web_app_storage"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "web_app_storage_versioning" {
  bucket = aws_s3_bucket.web_app_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web_app_storage_sse" {
  bucket = aws_s3_bucket.web_app_storage.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Provision VPC and Security Group (use existing)
data "aws_vpc" "web_app_vpc" {
  default = true
}

data "aws_subnet_ids" "web_app_subnet_ids" {
  vpc_id = data.aws_vpc.web_app_vpc.id
}

# Instance security group
resource "aws_security_group" "web_app_instance_security_group" {
  name = "web_app_instance_security_group"
}

# Inbound rule
resource "aws_security_group_rule" "web_app_sg_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.web_app_instance_security_group.id
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Outbound rule
resource "aws_security_group_rule" "web_app_sg_outbound" {
  type = "engress"
  security_group_id = aws_security_group.web_app_instance_security_group.id
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# Load balancer security group
resource "aws_security_group" "web_app_loadbal_security_group" {
  name = "web_app_loadbal_security_group"
}

resource "aws_security_group_rule" "web_app_loadbal_inbound_rule" {
  type = "ingress"
  security_group_id = aws_security_group.web_app_loadbal_security_group.id

  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_app_loadbal_outbound_rule" {
  type = "egress"
  security_group_id = aws_security_group.web_app_loadbal_security_group.id

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# Load balancer
resource "aws_lb" "web_app_loadbalancer" {
  name = "web_app_load_balancer"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.web_app_subnet_ids.ids
  security_groups = [aws_security_group.web_app_loadbal_security_group.id]
}

resource "aws_lb_listener" "web_app_lb_listener" {
  load_balancer_arn = aws_lb.web_app_loadbalancer.arn
  protocol = "HTTP"
  port = 80

  # By default, return to 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page Not Found"
      status_code = 404
    }
  }
}

resource "aws_lb_target_group" "web_app_lb_tg" {
  name = "web_app_lb_group"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.aws_vpc.web_app_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "web_app_replica_1" {
  target_group_arn = aws_lb_target_group.web_app_lb_tg.arn
  target_id = aws_instance.web_app_replica_1.id
  port = 8080
}

resource "aws_lb_target_group_attachment" "web_app_replica_2" {
  target_group_arn = aws_lb_target_group.web_app_lb_tg.arn
  target_id = aws_instance.web_app_replica_2.id
  port = 8080
}

resource "aws_lb_listener_rule" "web_app_lb_listener_rule" {
  listener_arn = aws_lb_listener.web_app_lb_listener.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_app_lb_tg.arn
  }
}

resource "aws_route53_zone" "web_app_public_route" {
  name = "drpawspaw.com"
}

resource "aws_route53_record" "web_app_dns_record" {
  zone_id = aws_route53_zone.web_app_public_route.zone_id
  name = "webapp-terraform.drpawspaw.com"
  type = "A"

  alias {
    name = aws_lb.web_app_loadbalancer.dns_name
    zone_id = aws_lb.web_app_loadbalancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_db_instance" "web_app_rds_db" {
  allocated_storage = 20
  auto_minor_version_upgrade = true
  storage_encrypted = "standard"
  engine = "postgres"
  engine_version = "12"
  instance_class = "db.t2.micro"
  name = "web_app_db"
  username = "app_user"
  password = "dev$db2024$webapp"
  skip_final_snapshot = true
}